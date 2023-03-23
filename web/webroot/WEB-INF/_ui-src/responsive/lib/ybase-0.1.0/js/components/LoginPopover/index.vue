<script setup lang="ts">
import { ref, Ref, onMounted } from 'vue';
import axios from 'axios';

interface Props {
  loginPopoverData: {
    id: string;
    userId: string;
    userName: string;
    headingValue: string;
    myDetailsValue: string;
    myDetailsUrl: string;
    myFavouritesValue: string;
    myFavouritesUrl: string;
    notFoundValue: string;
    switchAccountValue: string;
    switchPlaceholderValue: string;
    switchBackValue: string;
    logoutValue: string;
    CSRFToken: string;
  };
}

const props = defineProps<Props>();
const data = props.loginPopoverData;
const showPopover: Ref<boolean> = ref(true);
const switchAccount: Ref<boolean> = ref(false);
const currentUnit: Ref<{}> = ref<{}>({});
const listOfUnits: Ref<[]> = ref<[]>([]);
const filteredUnits: Ref<[]> = ref<[]>([]);
const maxHeight: Ref<number> = ref<number>(0);
const accountID: Ref<string> = ref<string>('');
const unitlist: Ref<any> = ref(null);

const switchAccountHandler = (e) => {
  e.preventDefault();
  switchAccount.value = !switchAccount.value;
  maxHeight.value = window.innerHeight - unitlist.value.getBoundingClientRect().top - 250;
};

const filterUnitsHandler = (e: Event): void => {
  const target = e.target as HTMLInputElement;
  filteredUnits.value = listOfUnits.value.filter((obj) => {
    const unitNameString = `${obj.uid} ${obj.name}`;
    return unitNameString.toLowerCase().includes(target.value.toLowerCase());
  });
};

const buttonHandler = (e: Event): void => {
  showPopover.value = !showPopover.value;
};

const changeHandler = (e: Event): void => {
  const target = e.target as HTMLInputElement;
  if (target.value !== currentUnit.value) {
    const form = target.closest('.js-accountsListWrapper')?.querySelector('form');
    const accountId = form?.querySelector('#accountID');
    accountId.value = target.value;
    form?.submit();
  }
};

(async () => {
  try {
    const response = await axios.get('/my-account/units');
    const { currentB2Bunit, listOfB2BUnits } = response.data;
    currentUnit.value = currentB2Bunit;
    listOfUnits.value = listOfB2BUnits;
    filteredUnits.value = listOfUnits.value;
  } catch (error) {
    console.warn(error);
  }
})();

onMounted(() => {
  document.addEventListener('click', (e: Event): void => {
    const target = e.target as HTMLElement;
    if (!target.closest('#v-login-popup') && !target.classList.contains('btn-switch')) {
      showPopover.value = false;
    }
  });
});
</script>

<template>
  <div :id="data.id" class="nav__item js-mobile-nav__item user" :class="showPopover ? 'nav__item--open' : ''" @click="show = false">
    <button class="btn btn-link nav__links-item__link" :aria-label="data.headingValue" @click="buttonHandler">
      <i class="icon icon-user" />
    </button>
    <div class="nav-popup" :class="showPopover ? '' : 'hide'">
      <h1 class="nav-popup__main-heading">{{ data.headingValue }}</h1>
      <hr />
      <div class="account-dropdown__views" ref="unitlist">
        <h2 v-if="!switchAccount" class="nav-popup__sub-heading">
          <a :href="data.myDetailsUrl">{{ data.myDetailsValue }}</a>
        </h2>
        <span class="account-dropdown__account-id">{{ data.userId }}</span>
        <span class="account-dropdown__businessname p0">{{ data.userName }}</span>

        <div v-if="!switchAccount">
          <button v-if="listOfUnits.length > 1" class="btn p0 mt1 bg-white flex font-size-1 btn-switch" @click="switchAccountHandler">
            <i class="icon icon-switch-basket mr1-4" />
            {{ data.switchAccountValue }}
          </button>
          <hr />
          <h2 class="nav-popup__sub-heading">
            <a :href="data.myFavouritesUrl">{{ data.myFavouritesValue }}</a>
          </h2>
          <hr />
          <a href="/logout" class="flex"><i class="icon icon-logout mr1-4" />{{ data.logoutValue }}</a>
        </div>

        <div v-if="switchAccount" class="switch-account mt1">
          <button
            tabindex="0"
            class="btn btn-back-normal flex align-items-center p1-4 font-size-1 btn-switch"
            @click="() => (switchAccount = !switchAccount)"
          >
            <i class="icon icon--sm icon-chevron-left" />{{ data.switchBackValue }}
          </button>
          <div class="site-form switch-account__search">
            <label class="site-form__label site-form__label--no-margin-top">{{ data.switchAccountValue }}</label>
            <input
              tabindex="0"
              type="text"
              maxlength="35"
              class="form-control site-form__input"
              :placeholder="data.switchPlaceholderValue"
              @input="filterUnitsHandler"
            />
          </div>
          <div class="switch-account__list-wrapper js-accountsListWrapper" :style="{ maxHeight: maxHeight + 'px' }">
            <form id="switchAccountForm" class="js-switchAccountForm" action="/my-account/select" method="post">
              <input id="accountID" type="hidden" :value="accountID" name="accountID" />
              <input type="hidden" name="CSRFToken" :value="data.CSRFToken" />
            </form>
            <input type="hidden" class="js-currentAccountId" :value="currentUnit.uid" />
            <ul v-if="filteredUnits.length" class="switch-account__list list-unstyled">
              <li v-for="unit in filteredUnits" :key="unit.uid" class="js-accountUnit h-width-100">
                <div class="radio site-radio">
                  <input
                    tabindex="0"
                    type="radio"
                    :id="`b2bunit-${unit.uid}`"
                    :value="unit.uid"
                    name="uid"
                    class="js-switchAccountRadio"
                    :checked="unit.uid === currentUnit.uid"
                    @change="changeHandler"
                  />
                  <label :for="`b2bunit-${unit.uid}`" class="site-radio__label site-radio__label--has-subtext">
                    <span class="site-radio__maintext">{{ unit.uid }}</span>
                    <span class="site-radio__subtext">{{ unit.name }}</span>
                  </label>
                </div>
              </li>
            </ul>
            <span v-else>{{ data.notFoundValue }}</span>
          </div>
        </div>
      </div>
    </div>
    <span v-if="showPopover" class="nav-popup--bg" @click="showPopover = false" />
  </div>
</template>
