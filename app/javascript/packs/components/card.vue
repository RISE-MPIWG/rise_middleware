<template>
  <div>
    {{fulltitle}}
  </div>
</template>
<script>

import axios from 'axios'
export default {
  props: ["item"],
  data() {
    return {
      contentUnits: [],
      errors: [],
    }
  },
  computed: {
    fulltitle(){
      if(this.item.ancestors.length > 0) {
        var title = ''
        this.item.ancestors.forEach(el => title = title + el + ' > ')
        return title + this.item.text
      } else {
        return this.item.text
      }
    }
  }
}
</script>
