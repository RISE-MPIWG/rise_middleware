<template>
  <div>
    <div class="btn-wrapper">
      <!-- <div>{{ $t("selections.open") }} {{ selected.length }} {{ $t("selections.selected_resources") }}</div> -->

      <select v-model="selectedTool" class="form-control auto-width">
        <option v-for="tool in research_tools" v-bind:value="tool">
          {{tool.name}}
        </option>
      </select>

      <a :href="href(selectedTool)" class="btn btn-sm btn-default" target="_blank">
        Open {{ selected.length }} {{ $t("selections.selected_resources") }}
      </a>
    </div>
  </div>
</template>

<script>
export default {
  props: ['selected', 'research_tools', 'instance_url'],
  data(){
    return{
      selectedTool: this.research_tools[0]
    }
  },
  methods: {
    href(research_tool) {
      var uuids = _.map(this.selected, 'uuid');
      var uuidsString = _.join(uuids, ',')
      return research_tool.url + '/?instance_url=' + this.instance_url.url + '&rise_section_uuid=' + uuidsString
    }
  }
}
</script>

<style>
.btn-wrapper {
  display: flex;
  align-items: center;
}
.btn-wrapper > * {
  margin-right: 10px;
}
.auto-width {
  width: auto;
}
</style>
