<script setup lang="ts">
import ReactWrapper from '../../utils/reactWrapper.vue';
import HelloComponent from '.';

interface Props {
  helloData: {
    id: string;
    msg: string;
  };
}

const obj = defineProps<Props>();
const data = obj.helloData;
</script>

<template>
  <ReactWrapper :component="HelloComponent" :msg="data.msg" />
</template>
