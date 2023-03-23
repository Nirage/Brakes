<script setup lang="ts">
interface Props {
  obj: Object;
  telephoneTooltipText?: string;
  name: string;
  placeholder: string;
  minlength: string;
  maxlength: string;
  twoEmptyInputs?: boolean;
}

const props = defineProps<Props>();
const emit = defineEmits('checkChange');

const formatPhone = (value: string): string => {
  return value
    .replace(/\D/g, '')
    .replace(/^(\d{4})(\d{3})(\d{4})/g, '$1 $2 $3')
    .replace(/^(\d{4})(\d{3})(\d*)/g, '$1 $2 $3')
    .replace(/^(\d{4})(\d{1,3})/g, '$1 $2')
    .replace(/^(\d{1,4})/g, '$1')
    .substring(0, 13)
    .trim();
};

const inputHandler = (e: Event, obj: any): void => {
  const element = e.target as HTMLInputElement;
  const position = (element.selectionStart - element.value.length) as number;
  obj.value = formatPhone(element.value);
  element.value = obj.value;
  element.selectionStart = position + element.value.length;
  element.selectionEnd = position + element.value.length;
};

const focusOutHandler = (e: Event, obj: any): void => {
  emit('checkChange');

  if (!obj.value.length) {
    obj.errorStatus = null;
    return;
  }

  obj.errorStatus = !new RegExp(obj.pattern).test(obj.value.replace(/\D/g, ''));

  setTimeout(() => {
    const form = document.getElementById('registerForm') as HTMLFormElement;
    const hasFormError = !!form.querySelector('.has-error');
    const nextButtons = document.querySelectorAll('.js-submitRegistrationForm') as NodeListOf<HTMLButtonElement>;
    nextButtons.forEach((button: HTMLButtonElement) => {
      const buttonClasses = button.classList;
      hasFormError ? buttonClasses.add('disabled') : buttonClasses.remove('disabled');
    });
  }, 0);
};
</script>
<template>
  <div class="custom-txtbox">
    <div :class="`site-form__formgroup form-group mr0 ${obj.errorStatus || props.twoEmptyInputs ? 'has-error' : ''}`">
      <label v-if="telephoneTooltipText?.length" class="flex justify-content-between font-size-1 mt2">
        Telephone number&nbsp;*&nbsp;<span class="mrauto text-grey text-italic">(Please fill in at least one field)</span>
        <i class="icon icon-question font-size-1-25 custom-tooltip">
          <span class="custom-tooltip__text font-size-base-sm lh1 p1 br1 font-primary position-absolute bg-white">
            {{ telephoneTooltipText }}
          </span>
        </i>
      </label>
      <div class="position-relative">
        <input :id="obj.hiddenId" type="hidden" :name="name" :value="obj.value.replace(/\s+/g, '')" />
        <input
          :id="obj.id"
          type="tel"
          inputmode="numeric"
          class="site-form__input form-control font-size-1 v-telephone-input"
          autocomplete="noautocomplete"
          :value="obj.value"
          :placeholder="placeholder"
          :minlength="minlength"
          :maxlength="maxlength"
          @focusout="focusOutHandler($event, obj)"
          @input="inputHandler($event, obj)"
        />
        <i
          v-if="obj.errorStatus !== null"
          :class="`icon icon--position-right icon-${obj.errorStatus ? 'error text-warning' : 'tick text-success'}`"
        />
      </div>
      <span v-if="obj.errorStatus" class="error-msg js-errorMsg site-form__errormessage">
        <i class="icon icon-caret-up font-size-base-sm" /> {{ obj.errorInvalid }}
      </span>
    </div>
  </div>
</template>
