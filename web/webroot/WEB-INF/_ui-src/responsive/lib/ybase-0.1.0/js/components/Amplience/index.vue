<script setup lang="ts">
import { ref, onMounted } from 'vue';
import axios from 'axios';

interface Props {
  amplienceData: {
    prop: string;
    url: string;
  };
}

defineProps<Props>();
console.log('defineProps');
const getResults = async () => {
  console.log('getresults');
  try {
    const { data } = await axios.get('https://c1.adis.ws/v1/content/Brakes/content-item/73aab437-0691-49b7-9550-296d3d42b864?template=top_template');
    console.log(data);
  } catch (error) {
    console.log(error);
  }
};

onMounted(() => {
  console.log('esgf');
});
</script>

<template>
  <div>test ns</div>
</template>
