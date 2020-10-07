import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm.js';
import App from '../app.vue'
import VueI18n from 'vue-i18n'
import toastr from 'toastr'
import InfiniteScroll from 'v-infinite-scroll'
import JSONView from "vue-json-component";

Vue.use(InfiniteScroll)
Vue.use(VueI18n)
Vue.use(TurbolinksAdapter)
Vue.use(JSONView)


// listen to event 'DOMContentLoaded' and then mount vue component in div with id app
document.addEventListener('DOMContentLoaded', function() {
    const element = document.querySelector('#vue-behaviour');
    if(element){
      const el2 =  document.querySelector('#app')
      const locales = JSON.parse(el2.dataset.locales);
      const locale = Object.keys(locales)[0];
      const translations = JSON.parse(locales[locale]);
      const messages = {
        [locale]: translations
      }

      const i18n = new VueI18n({
        locale,
        messages
      })

      const app = new Vue({
          i18n,
          el: element,
          components: {
            App
          },
          data: {
            resource: JSON.parse(el2.dataset.resource),
            research_tools: JSON.parse(el2.dataset.researchTools),
            instance_url: JSON.parse(el2.dataset.instanceUrl),
            metadata: JSON.parse(el2.dataset.metadata)
          },
          template: "<App :resource='resource' :research_tools='research_tools' :instance_url='instance_url' :metadata='metadata'/>"
      }).$mount('#app');
    }
})
