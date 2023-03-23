<script>
import { createElement } from 'react';
import { createRoot } from 'react-dom/client';

export default {
  inheritAttrs: false,
  props: {
    component: {
      type: Function,
      required: true
    }
  },
  mounted() {
    const root = createRoot(this.$refs.container);
    root.render(createElement(this.component, this.$attrs));
  }
};
</script>

<template>
  <div ref="container" />
</template>
