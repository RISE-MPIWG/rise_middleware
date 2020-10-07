<template>
  <div id="app">
    <div class="metadata-tree">
      <json-view :data="metadata" rootKey="Metadata" :styles="treeStyles"></json-view>
    </div>
    <div class="row">

      <div class="col col-12 col-lg-4 col-md-4">

         <div class="col-header">
           <h4>{{ $t("browser.title") }} </h4>
           <input type="text" @keyup="inputKeyUp" v-model="searchText" :placeholder="$t('browser.placeholder')" class="form-control"/>
         </div>

         <div class="col-body tree">
           <v-jstree  v-if="this.sections.length > 0" :data="sections" show-checkbox multiple allow-batch ref="tree" @item-click="itemClick"></v-jstree>
           <div v-else class="spinner-wrapper">
             <spinner/>
           </div>
         </div>

      </div>


      <div class="col col-12 col-lg-4 col-md-4">
        <div class="col-header">
          <h4>{{ $t("selections.title") }}</h4>
          <div v-if="selected.length > 0">
            <p>Click on the selected sections to preview them.</p>
              <!-- <div v-if="research_tools.length > 0">
                <openWith :selected="selected" :research_tools="research_tools" :instance_url="instance_url" />
              </div>
              <div v-else>
                <p>Click on the selected sections to preview them.</p>
              </div> -->
          </div>
          <div v-else>
            <p>Selected sections will appear here.</p>
          </div>
        </div>

        <div class="col-body">
          <div>
            <p v-for="(item, index) in selected"
               class="selected-item"
               @click="toogle(item.id, index)"
               :class="{active: isActive === index}"
            >
              <card v-bind:item="item" :resource="resource" />
            </p>
            </div>
          </ul>
        </div>

      </div>

      <div class="col col-12 col-lg-4 col-md-4">

        <div class="col-header">
          <h4>{{ $t("preview.title") }}</h4>
          <div v-if="activeItem.contentUnits.length > 0">
            <input type="text" name="query" v-model="searchQuery" :placeholder="$t('preview.placeholder')" class="form-control" />
            <div v-if="searchResult !== undefined">
              {{ searchResult.length }}
             <button v-scroll-to="'highlight'">

              </button>
            </div>

          </div>
          <div v-else>
            <p>{{ $t("preview.undertitle") }}</p>
          </div>
        </div>

        <div class="col-body preview">
          <div v-if="errors.length > 0">
            {{ $t("permission.message") }}
          </div>

          <div v-if="loadingPreview" class="spinner-wrapper">
            <spinner/>
          </div>

          <v-infinite-scroll v-else :loading="loadingPreview" @bottom="nextPage" :offset='20' class="infinite-scroll">
            <div v-for="contentUnit in activeItem.contentUnits">
              <p v-html="$options.filters.highlight(contentUnit.content, searchQuery)">{{ contentUnit.content | highlight }}</p>
            </div>
          </v-infinite-scroll>

        </div>

      </div>

      <!-- <div v-if="activeItem.contentUnits.length > 0">
        <json-view :data="JSON.parse(activeItem.contentUnits[0].content)" rootKey="pr" :styles="treeStyles"></json-view>
      </div> -->

    </div>
  </div>
</template>

<script>
import VJstree from 'vue-jstree'
import axios from 'axios'
import card from './packs/components/card'
import spinner from './packs/components/spinner'
import openWith from './packs/components/openWith'
import lodash from 'lodash'
import MugenScroll from 'vue-mugen-scroll'


export default {
  props: ["resource", "metadata", "research_tools", "instance_url"],
  components: {
    VJstree,
    card,
    openWith,
    spinner,
    MugenScroll,

  },
  data() {
    return {
      selected: [],
      treeStyles: {
        arrowSize: '8px',
        key: '#002b36',
        valueKey: '#073642',
        string: '#666',
        number: '#2aa198',
        boolean: '#cb4b16',
        null: '#6c71c4'
      },
      searchText: '',
      sections: [],
      errors: [],
      editingItem: {},
      previewItemsCache: [],
      activeItem: {
        contentUnits: [],
      },
      searchQuery: '',
      isActive: null,
      loadingPreview: false,
      page: 1
    }
  },
  created() {
    this.fetchInitialData()
  },

  filters: {
    highlight: function(words, query){
      var iQuery = new RegExp(query, "ig");

      return words.toString().replace(iQuery, function(matchedTxt,a,b){
          return ('<span class=\'highlight\'>' + matchedTxt + '</span>');
      });
    }
  },

    computed: {
      searchResult: function() {
        if(this.searchQuery !== '') {
          results = this.activeItem.contentUnits.map(contentUnit => {
            if(contentUnit.content.includes(this.searchQuery)) {
              return { }
            }
          })
          return counter
        }
      }
    },
  methods: {
    itemClick(node, item, e) {
      if(item.selected){
        item.opened = true
      }else {
        item.opened = false
      }

      var flattened = this.flatten(this.sections)

      var selected = _.filter(flattened, (item) => {
        return item.selected && item.is_leaf
      })

      this.selected = selected
    },

    flattenNestedObjectsArray(sections){
      var that = this
      var flattened = []
      sections.forEach(function(section){
        if (Array.isArray(section.children) && section.children.length) {
          var children = section.children;
          that.flattenNestedObjectsArray(children);
        } else {
          flattened.push(section);
        }
      });
      return flattened;
    },

    flatten(xs) {
      var that = this
      return xs.reduce((acc, x) => {
        acc = acc.concat(x);
        if (x.children) {
          acc = acc.concat(that.flatten(x.children));
          x.openChildren = [];
        }
        return acc;
      }, []);
    },

    fetchInitialData() {
      axios.get(`/resources/${this.resource.id}/sections_for_tree_display`, {
        headers: {
          'Content-Type': 'application/json'
        }
      })
      .then(response => {
        this.sections = response.data
      })
      .catch(e => {
        this.errors.push(e)
      })
    },

    inputKeyUp: function () {
      var text = this.searchText
      const patt = new RegExp(text);
      this.$refs.tree.handleRecursionNodeChilds(this.$refs.tree, function (node) {
        if (text !== '' && node.model !== undefined) {
          const str = node.model.text
          if (patt.test(str)) {
              node.$el.querySelector('.tree-anchor').style.color = '#ff307a'
          } else {
              node.$el.querySelector('.tree-anchor').style.color = '#000'
          }
        } else {
          node.$el.querySelector('.tree-anchor').style.color = '#000'
        }
      })
    },

    fetchPreview(id) {
      axios.get(`/sections/${id}`, {
        headers: {
          'Content-Type': 'application/json',
        },
      })
      .then(response => {
        this.loadingPreview = false
        this.previewItemsCache.push({uuid: id, contentUnits: response.data});
        this.activeItem = { uuid: id, contentUnits: response.data }
      })
      .catch(e => {
        this.errors.push(e)
      })
    },

    toogle(uuid, index) {
      var oldPreviewItems = this.previewItemsCache.filter(item => item.uuid == uuid)
      this.isActive = index
      if(oldPreviewItems.length == 0){
        this.loadingPreview = true
        this.fetchPreview(uuid)
      } else {
        this.activeItem = this.previewItemsCache.find(item => item.uuid == uuid)
      }
    },
    // infinite scroll
    nextPage() {
      this.page += 1
      axios.get(`/sections/${this.activeItem.uuid}`, {
        params: {
          page: this.page
        },
      }).then(({ data }) => {
        if (data) {
          this.activeItem.contentUnits.push(...data);
        } else {

        }
      });
    }
  }
}
</script>

<style scoped>

</style>
