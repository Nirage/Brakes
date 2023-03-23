import Autocomplete from './index.vue';

export default {
  title: 'Brakes/Autocomplete',
  component: Autocomplete
};

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { Autocomplete },
  template: '<Autocomplete v-bind="$props" />'
});

const obj = {
  id: 'v-autocomplete',
  prop: 'autocomplete-data',
  value: '',
  displayProductImages: 'true',
  minCharactersBeforeRequest: '3',
  waitTimeBeforeRequest: '300',
  autocompleteUrl: '/json/autocomplete.json'
};

export const Default = Template.bind({});
Default.args = {
  autocompleteData: obj
};

export const AddInput = Template.bind({});
AddInput.args = {
  autocompleteData: { ...obj, value: 'butter' }
};
