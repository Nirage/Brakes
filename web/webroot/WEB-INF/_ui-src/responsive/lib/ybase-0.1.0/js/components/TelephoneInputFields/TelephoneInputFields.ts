import template from '../../utils/template';
import TelephoneInputFields from './index.vue';

export default () => {
  const d = document;
  const component = d.getElementById('v-telephone-number') as HTMLElement;
  const obj = {} as Object;
  obj['id'] = component?.id as string;
  obj['prop'] = 'telephone-input-data' as string;
  obj['telephoneTooltipText'] = component?.dataset['telephoneTooltipText'] as string;
  obj['errorEmpty'] = component?.dataset['errorEmpty'] as string;
  obj['twoEmptyInputs'] = false;

  const focusHandler = (e: FocusEvent): void => {
    e.preventDefault();
    const target = e.currentTarget as HTMLInputElement;
    obj['isFocused'] = target.id as string;

    template(obj, TelephoneInputFields);
  };

  const telephoneInputs = d.body.querySelectorAll('.v-telephone-input') as NodeListOf<HTMLInputElement>;
  telephoneInputs.forEach((input: HTMLInputElement): void => {
    const { id, value, pattern } = input as HTMLInputElement;
    const label = input.closest('.form-group')?.querySelector('label');
    const hiddenId = input.previousElementSibling?.id;
    const errorStatus = !new RegExp(pattern).test(value.replace(/\D/g, ''));

    obj[id] = {
      errorStatus: value !== '' ? errorStatus : null,
      id,
      hiddenId,
      value,
      pattern,
      errorInvalid: label?.dataset['errorInvalid'] as string
    } as Object;

    if (value !== '') {
      const statusIcon = input.nextElementSibling as HTMLElement;
      const iconClasses = statusIcon.classList;
      iconClasses.add('show');
      errorStatus ? iconClasses.add('icon-error', 'site-form__errorsideicon') : iconClasses.add('icon-tick', 'site-form__validsideicon');
    }

    input.addEventListener('focus', focusHandler);
  });

  $(document).on('submit', '.js-formValidation', function () {
    var formId = this.getAttribute('id');
    var noValidation = this.getAttribute('data-noValidation');
    var $form = $('#' + formId);
    var isFormValid = false;
    if (noValidation && noValidation === 'true') {
      var listOfErrorField = $form.find('.' + ACC.validation.HAS_ERROR);
      $(listOfErrorField).each(function () {
        $(this).find('.js-formField').val();
      });
    } else {
      ACC.validation.validateAllRequired(formId);
      isFormValid = ACC.validation.isFormValid($form);
      ACC.validation.toggleLoadingState($form, isFormValid);
      // If form is invalid
      if (!isFormValid) {
        // On mobile open all sections to present error messages
        $('.js-formSection').addClass('is-active').removeClass('pristine');
        // scroll to first errror
        // If form is invalid scroll to first errror.
        ACC.global.scrollToElement('.js-formGroup.has-error');
      } else {
        $('.js_spinner').show();
      }
      if (window.hasAccountsList) {
        ACC.register.collectAccountsList('.js-accountNumbers', '.js-accountNumber');
      }
      return isFormValid;
    }

    const registerForm = document.getElementById('registerForm') as HTMLFormElement;
    if (!registerForm) return;

    let twoEmptyInputs = true;
    const telephoneInputs = registerForm.querySelectorAll('.v-telephone-input') as NodeListOf<HTMLInputElement>;
    telephoneInputs.forEach((input: HTMLInputElement): void => {
      const { name, id, value, pattern } = input as HTMLInputElement;
      const label = input.closest('.form-group')?.querySelector('label');
      const errorStatus = !new RegExp(pattern).test(value);

      if (value !== '') twoEmptyInputs = false;
      obj['twoEmptyInputs'] = twoEmptyInputs;

      obj[name] = {
        errorStatus: value !== '' ? errorStatus : null,
        id,
        value,
        pattern,
        errorInvalid: label?.dataset['errorInvalid'] as string
      } as Object;
    });

    template(obj, TelephoneInputFields);
  });
};
