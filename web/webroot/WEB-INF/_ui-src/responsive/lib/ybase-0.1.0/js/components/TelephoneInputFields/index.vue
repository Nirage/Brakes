<script setup lang="ts">
import { onMounted, reactive, ref, Ref } from 'vue';

import InputField from '../Input/index.vue';

interface Props {
  telephoneInputData: {
    mobileNumber: Object;
    phoneNumber: Object;
    isFocused: string;
    telephoneTooltipText: string;
    errorEmpty: string;
    twoEmptyInputs?: boolean;
  };
}

const props = defineProps<Props>();
const data = props.telephoneInputData;
const mobileNumber: any = reactive(data.mobileNumber);
const phoneNumber: any = reactive(data.phoneNumber);
const mobileInput: Ref<any> = ref(null);
const landlineInput: Ref<any> = ref(null);
const twoEmptyInputs: Ref<any> = ref(data.twoEmptyInputs);

const getInput = (parentElement: HTMLDivElement) => parentElement?.$el.querySelector('input[type="tel"]');

const checkBothInputs = (): void => {
  if (mobileNumber.value !== '' || phoneNumber.value !== '') {
    twoEmptyInputs.value = false;
  }
};

onMounted(() => {
  data.isFocused === getInput(mobileInput.value).id && getInput(mobileInput.value).focus();
  data.isFocused === getInput(landlineInput.value).id && getInput(landlineInput.value).focus();
});
</script>

<template>
  <div class="col-xs-12" id="v-telephone-number">
    <InputField
      :obj="mobileNumber"
      :telephoneTooltipText="data.telephoneTooltipText"
      :twoEmptyInputs="twoEmptyInputs"
      name="mobileNumber"
      placeholder="Mobile number"
      minlength="11"
      maxlength="13"
      ref="mobileInput"
      @checkChange="checkBothInputs()"
    />
    <InputField
      :obj="phoneNumber"
      :twoEmptyInputs="twoEmptyInputs"
      name="phoneNumber"
      placeholder="Landline number"
      minlength="10"
      maxlength="13"
      ref="landlineInput"
      @checkChange="checkBothInputs()"
    />
    <span v-if="twoEmptyInputs" class="error-msg js-errorMsg site-form__errormessage">
      <i class="icon icon-caret-up font-size-base-sm" /> {{ data.errorEmpty }}
    </span>
  </div>
</template>
