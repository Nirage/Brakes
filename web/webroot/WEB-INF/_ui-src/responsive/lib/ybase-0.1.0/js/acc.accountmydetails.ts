const accountmydetails = {
  init(): void {
    const mq = window.matchMedia('(min-width: 768px)') as MediaQueryList;
    const _this = ACC.accountmydetails as any;
    const comp = document.body.querySelector('#v-vertical-tabs') as HTMLDivElement;
    const updateEmailBox = comp.querySelector('.js-updateEmailBox') as HTMLElement;
    const updatePasswordSubmitBtn = comp.querySelector('.js-updatePasswordSubmitBtn') as HTMLButtonElement;

    const updateEmailInput = comp.querySelector('.js-updateEmailInput') as HTMLInputElement;
    updateEmailInput?.addEventListener('blur', (): void => {
      _this.checkPasswordFieldsNotEmpty(updatePasswordInput, updatePasswordSubmitBtn);
    });

    const updateEmailBtn = comp.querySelector('.js-updateEmailBtn') as HTMLButtonElement;
    updateEmailBtn?.addEventListener('click', (): void => {
      this.toggleEmailBox(updateEmailInput, updateEmailBox, updateEmailBtn);
    });

    const closeEmailBoxbtn = comp.querySelector('.js-closeEmailBoxbtn') as HTMLButtonElement;
    closeEmailBoxbtn?.addEventListener('click', (): void => {
      this.toggleEmailBox(updateEmailInput, updateEmailBox, updateEmailBtn);
    });

    const clickableItems: string = mq.matches ? 'tab' : 'heading';
    const tabs = comp.querySelectorAll(`.v-accordion__${clickableItems}`) as NodeListOf<HTMLElement>;
    tabs?.forEach((tab) => {
      tab.addEventListener('click', (): void => {
        const getClickedTab = tab.getAttribute('for') as string;
        sessionStorage.setItem('myaccount', getClickedTab);
        $('.js-triggerTooltip')?.popover('hide');
      });
    });

    const updatePasswordInput: NodeListOf<HTMLInputElement> = comp.querySelectorAll('.js-accountPasswordInput');
    updatePasswordInput?.forEach((input: HTMLInputElement): void => {
      input.addEventListener('input', (e: any): void => {
        const { target } = e;
        if (!_this.passwordEditable && target) target.value = '';
      });
      input.addEventListener('focus', (): void => {
        _this.passwordEditable = true;
        updatePasswordSubmitBtn.disabled = false;
        updatePasswordInput.forEach((item: HTMLInputElement): void => item.classList.add('js-activeSubformField'));
      });
      input.addEventListener('blur', (): void => {
        _this.passwordEditable = false;
        _this.checkPasswordFieldsNotEmpty(updatePasswordInput, updatePasswordSubmitBtn);
      });
    });

    // Look to remove this JQuery dependency in the future
    const form: NodeListOf<HTMLFormElement> = comp.querySelectorAll('.updateProfileForm');
    $(form).on('submit', function (e: JQuery.SubmitEvent): void {
      e.preventDefault();
      ACC.global.checkLoginStatus(_this.formSubmit.bind(this));
    });
  },
  formSubmit(): void {
    const form = $(this);
    form.find('.js-activeSubformField').each(function (): void {
      ACC.validation.onFieldChange($(this));
    });
    const ifFormValid: boolean = ACC.validation.isFormValid(form);
    ACC.validation.toggleDisableSubmit(form, ifFormValid);
    ifFormValid && form.unbind('submit').submit();
  },
  toggleEmailBox(
    updateEmailInput: HTMLInputElement,
    updateEmailBox: HTMLElement,
    updateEmailBtn: HTMLButtonElement
  ): void {
    updateEmailInput?.classList.toggle('js-activeSubformField');
    updateEmailInput.value = '';
    updateEmailBtn?.classList.toggle('hide');
    updateEmailBox?.classList.toggle('hide');
    updateEmailBox?.querySelector('.js-formGroup')?.classList.remove('is-valid', 'has-error');
    updateEmailBox?.querySelector('.js-errorMsg')?.classList.add('hide');
  },
  checkPasswordFieldsNotEmpty(
    updatePasswordInput: NodeListOf<HTMLInputElement>,
    updatePasswordSubmitBtn: HTMLButtonElement
  ): void {
    updatePasswordInput.forEach(
      (input: HTMLInputElement) => !input.value.length && updatePasswordSubmitBtn.classList.add('disabled')
    );
  }
};

export default accountmydetails;
