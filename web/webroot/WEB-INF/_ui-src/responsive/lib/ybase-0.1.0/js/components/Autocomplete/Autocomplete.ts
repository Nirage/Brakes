import template from '../../utils/template';
import Autocomplete from './index.vue';

export default () => {
  const searchInput = document.getElementById('js-site-search-input') as HTMLInputElement;
  const { autocompleteUrl, minCharactersBeforeRequest, displayProductImages, waitTimeBeforeRequest } = searchInput?.dataset || {};

  const focusHandler = (e: FocusEvent) => {
    e.preventDefault();
    const obj = {
      id: 'v-autocomplete',
      prop: 'autocomplete-data',
      value: searchInput.value,
      displayProductImages,
      minCharactersBeforeRequest,
      waitTimeBeforeRequest,
      autocompleteUrl
    } as Object;

    template(obj, Autocomplete);
  };

  searchInput?.addEventListener('focus', focusHandler);
};
