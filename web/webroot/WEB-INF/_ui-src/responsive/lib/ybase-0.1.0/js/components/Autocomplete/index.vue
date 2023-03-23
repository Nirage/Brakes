<script setup lang="ts">
import { ref, onMounted, Ref } from 'vue';
import axios from 'axios';

import debounce from '../../utils/debounce';

import './Autocomplete.vue.less';
import breakpoints from '../../acc.breakpoints';

interface Props {
  autocompleteData: {
    value: string;
    displayProductImages: string;
    minCharactersBeforeRequest: string;
    waitTimeBeforeRequest: string;
    autocompleteUrl: string;
  };
}

const { body } = document;
const a = 'v-autocomplete';
let currentFocus: number = -1;
const searchInput = ref(null);
const recent = localStorage.getItem('recent') as string;
const recentSearches: [] = recent ? JSON.parse(recent) : [];
const ac = defineProps<Props>();
const data = ac.autocompleteData;
const searchString: Ref<string> = ref<string>(data.value.toLowerCase());
const show: Ref<boolean> = ref<boolean>(true);
const inputFocused: Ref<boolean> = ref<boolean>(false);
const recentSearchesRef: Ref<[]> = ref<[]>(recentSearches);
const categorySuggestionsRef: Ref<[]> = ref<[]>([]);
const productsRef: Ref<[]> = ref<[]>([]);
const suggestionsRef: Ref<[]> = ref<[]>([]);
const setLimit: number = window.matchMedia(`(max-width: ${breakpoints.screenXsMax}`) ? 20 : 10;

const inputHandler = (e: Event) => {
  e.preventDefault();
  const element = e.target as HTMLInputElement;
  const searchButton = element.nextElementSibling as HTMLButtonElement;
  searchString.value = element.value.toLowerCase();

  const fetchData = async (searchString: string) => {
    try {
      const response = await axios.get(`${data.autocompleteUrl}?term=${searchString}`);
      const { categorySuggestions, products, suggestions } = response.data;
      categorySuggestionsRef.value = categorySuggestions;
      productsRef.value = products;
      suggestionsRef.value = suggestions;
      recentSearchesRef.value = [];
      show.value = true;
    } catch (error) {
      console.warn(error);
    }
  };

  currentFocus = -1;

  if (searchString.value.length >= parseInt(data.minCharactersBeforeRequest)) {
    fetchData(searchString.value);
  } else {
    const recent = localStorage.getItem('recent') as string;
    recentSearchesRef.value = recent ? JSON.parse(recent) : [];
    categorySuggestionsRef.value = [];
    productsRef.value = [];
    suggestionsRef.value = [];
    show.value = true;
  }

  searchButton.disabled = !searchString.value.length;
};
const debounceInput = debounce(inputHandler, parseInt(data.waitTimeBeforeRequest));
const removeSearchValueHandler = () => {
  searchString.value = '';
  show.value = false;
};
const clearHandler = () => {
  recentSearchesRef.value = [];
  localStorage.removeItem('recent');
};
const removeRecentHandler = (e: any) => {
  const recent = localStorage.getItem('recent') as string;
  recentSearchesRef.value = JSON.parse(recent).filter((item: string) => item !== e.target.dataset.removeRecent);
  localStorage.setItem('recent', JSON.stringify([...recentSearchesRef.value]));
};
const searchButtonClickHandler = (e: any) => {
  e.preventDefault();
  const { currentTarget } = e;
  addRecentSearch(searchString.value);
  currentTarget.form?.submit();
};
const outsideHandler = (e: Event) => {
  const { target }: any = e;
  const autocomplete = body.querySelector(`.${a}__list`) as HTMLDivElement;

  if (autocomplete && !(autocomplete === target || autocomplete.contains(target) || target.classList.contains('icon-close'))) {
    show.value = false;
    target.blur();
  }
};
const keyDownHandler = (e: KeyboardEvent) => {
  const autocomplete = body.querySelector(`.${a}__list`) as HTMLDivElement;
  const list = autocomplete?.querySelectorAll(`.${a}__suggestion`) as NodeListOf<HTMLAnchorElement>;

  if (e.key === 'Escape') {
    show.value = false;
  } else if (e.key === 'ArrowDown') {
    currentFocus++;
    addActive(list);
  } else if (e.key === 'ArrowUp') {
    currentFocus--;
    addActive(list);
  } else if (e.key === 'Enter') {
    e.preventDefault();
    if (currentFocus > -1) {
      const activeAutocomplete = autocomplete?.querySelector('.v-autocomplete--active') as HTMLAnchorElement;
      activeAutocomplete?.click();
    } else {
      const { target }: any = e as Event;
      addRecentSearch(searchString.value);
      target?.form?.submit();
    }
  }
};
const addActive = (list: NodeListOf<HTMLAnchorElement>) => {
  if (!list?.length) return false;

  list.forEach((item: HTMLAnchorElement) => item.classList.remove(`${a}--active`));

  if (currentFocus >= list.length) currentFocus = 0;
  if (currentFocus < 0) currentFocus = list.length - 1;

  return list[currentFocus]?.classList?.add(`${a}--active`);
};
const addRecentSearch = (value: string) => {
  const recent: string = localStorage.getItem('recent') as string;
  recentSearchesRef.value = recent ? JSON.parse(recent) : [];
  const updateRecentSearches: string[] = Array.from(new Set([value, ...recentSearchesRef.value]));
  const formatRecent: string[] = updateRecentSearches.splice(0, 20);
  localStorage.setItem('recent', JSON.stringify(formatRecent));
};
const boldSubSuggestion = (term: string) => {
  const words: string = searchString.value.trim().split(' ').join('|') as string;
  const re = new RegExp(`(${words})`, 'gi') as RegExp;
  const strong: string = '<strong class="font-primary-bold text-black">$1</strong>' as string;
  return term.replace(re, strong);
};
const boldSubCategory = (name: string, count: number) => {
  return `<strong class="font-primary-bold text-black">${searchString.value}</strong> in ${name} (${count})`;
};
const containImage = (image: any) => {
  const noImagePlaceholder = 'https://i1.adis.ws/i/Brakes/image-not-available?$plp-mobile$';
  return image && JSON.parse(data.displayProductImages) ? image[0].url : noImagePlaceholder;
};
const calcHeight = (rows: number): number => {
  // Height of one row is 40px
  return 40 * rows;
};
const setHeight = (): number => {
  if (window.matchMedia(`(max-width: ${breakpoints.screenXsMax}`)) {
    return calcHeight(inputFocused ? 6 : 12);
  }
  return calcHeight(10);
};

onMounted(() => {
  const navigation = document.querySelector('.js-mainNavigation') as HTMLDivElement;
  navigation?.addEventListener('mouseover', outsideHandler);
  searchInput.value?.focus();
});
</script>

<template>
  <div class="site-search">
    <form name="search_form_SearchBox" method="get" action="/search">
      <div class="input-group site-search__input-group flex js-site-search__input-group">
        <input
          type="text"
          ref="searchInput"
          id="js-site-search-input"
          class="form-control js-site-search-input site-search__input ga-nav-bar-2"
          name="text"
          maxlength="100"
          autocomplete="off"
          placeholder="Search products..."
          data-autocomplete-url="/search/autocomplete/SearchBox"
          data-min-characters-before-request="3"
          data-wait-time-before-request="500"
          data-display-product-images="true"
          :value="searchString"
          @input="debounceInput"
          @focus="inputHandler"
          @focusout="outsideHandler"
          @keydown.down="keyDownHandler"
          @keydown.up="keyDownHandler"
          @keydown.esc="keyDownHandler"
          @keydown.enter="keyDownHandler"
        />
        <button v-if="searchString.length" :class="`${a}__remove icon icon-close`" type="button" @click="removeSearchValueHandler" />
        <button
          class="btn js_search_button site-search__submit-btn input-group-btn"
          type="submit"
          :disabled="!searchString.length"
          @click="searchButtonClickHandler"
        >
          <i class="glyphicon glyphicon-search nav-bar-3"></i>
        </button>
      </div>
    </form>
    <div v-if="show" :id="a" :class="a">
      <div :class="`${a}__list position-absolute`">
        <!-- Recent Searches -->
        <div v-if="recentSearchesRef.length && searchString.length <= parseInt(data.minCharactersBeforeRequest)">
          <div :class="`${a}__recent-search flex justify-content-between`">
            Your recent searches
            <button :class="`${a}__clear-all`" type="button" @click="clearHandler">Clear all</button>
          </div>
          <div class="flex flex-direction-column bg-white p1-4 overflow-hide" :style="`max-height: ${setHeight}px`">
            <div v-for="search in recentSearchesRef.slice(0, setLimit)" :key="search" class="flex justify-content-between position-relative">
              <a :class="`${a}__suggestion ${a}__search`" :href="`/search?text=${search}`" @click="addRecentSearch(search)">
                {{ search }}
              </a>
              <button type="button" class="icon icon-close" :data-remove-recent="search" @click="removeRecentHandler" />
            </div>
          </div>
        </div>
        <!-- Suggestions -->
        <div v-if="suggestionsRef.length" class="flex flex-direction-column bg-white p1-4">
          <a
            v-for="suggestion in suggestionsRef"
            :key="suggestion.term"
            :class="`${a}__suggestion`"
            :href="`/search?text=${suggestion.term}`"
            v-html="boldSubSuggestion(suggestion.term)"
            @click="addRecentSearch(suggestion.term)"
          />
        </div>
        <legend v-if="suggestionsRef.length" class="m0" />
        <!-- Categories -->
        <div v-if="categorySuggestionsRef.length" class="flex flex-direction-column bg-white p1-4">
          <a
            v-for="category in categorySuggestionsRef"
            :key="category.term"
            :class="`${a}__suggestion flex justify-content-between align-items-center`"
            :href="category.url"
          >
            <span :class="`${a}--one-line`" v-html="boldSubCategory(category.name, category.count)" />
            <i class="icon icon-chevron-right" />
          </a>
        </div>
        <legend v-if="categorySuggestionsRef.length" class="m0" />
        <!-- Products -->
        <div v-if="productsRef.length" class="flex flex-direction-column bg-white p1-4">
          <a
            v-for="product in productsRef"
            :key="product.code"
            :class="`${a}__suggestion ${a}--product flex justify-content-between`"
            :href="product.url"
          >
            <img :class="`${a}__image`" :src="containImage(product.images)" :alt="product.name" :title="product.name" width="80px" />
            <div :class="`${a}__summary`">{{ product.name }}</div>
            <div :class="`${a}__price flex flex-direction-column justify-content-center`">
              <strong class="font-primary-bold">{{ product.price && product.price.formattedValue }}</strong>
              <span :class="`${a}--ea`">{{ product.unitPriceStr ? product.unitPriceStr : '' }}</span>
            </div>
          </a>
        </div>
      </div>
    </div>
  </div>
</template>
