import debounce from './utils/debounce';
import regexes from './utils/regexes';

const updateAccountName = {
  elements: {
    updateAccountNameContainer: document.querySelector('.js-updateAccountNameContainer') as HTMLFormElement,
    accountListContainer: document.querySelector('.js-accountListContainer') as HTMLElement,
    accountSelectedContainer: document.querySelector('.js-accountSelectedContainer') as HTMLElement
  },
  formState: {
    accountSelected: 'UNTOUCHED',
    newAccountName: 'UNTOUCHED'
  },
  get formStatus() {
    return this.formState;
  },
  set formStatus(val) {
    this.formState = val;
    this.formStateListener(val);
  },
  // @ts-ignore
  formStateListener: function (val: any) {},
  registerListener: function (listenerFunction: any) {
    this.formStateListener = listenerFunction;
  },
  init(): void {
    // @ts-ignore
    this.registerListener(function (val: any) {
      updateAccountName.validationHandler();
    });
    this.accountSelectDropdown();
    this.selectAccountHandler();
    this.inputHandler();
    this.shouldSubmitForm();
  },
  accountSelectDropdown(): void {
    this.elements.accountSelectedContainer.addEventListener('click', () => {
      this.elements.accountListContainer.classList.toggle('hide');
      this.elements.accountSelectedContainer.classList.toggle('is-active');
    });
  },
  selectAccountHandler(): void {
    const accountSelectedName = this.elements.updateAccountNameContainer.querySelector('.js-accountSelectedName') as HTMLElement;
    const accountSelectedCode = this.elements.updateAccountNameContainer.querySelector('.js-accountSelectedCode') as HTMLElement;
    const inputSelectedAccountCode = this.elements.updateAccountNameContainer.querySelector('#selectedAccountCode') as HTMLInputElement;

    if (accountSelectedName.dataset['value'] === 'DEFAULT') {
      this.formStatus = { ...this.formState, accountSelected: 'FAIL' };
    } else {
      this.formStatus = { ...this.formState, accountSelected: 'PASS' };
      inputSelectedAccountCode.setAttribute('value', accountSelectedCode.innerText as string);
    }

    this.elements.accountListContainer.addEventListener('click', (event: Event) => {
      const targetElement = event.target as HTMLElement;

      accountSelectedName.innerText = targetElement.dataset['name'] as string;
      accountSelectedCode.innerText = targetElement.dataset['id'] as string;
      inputSelectedAccountCode.setAttribute('value', targetElement.dataset['id'] as string);

      this.elements.accountListContainer.classList.add('hide');
      this.elements.accountSelectedContainer.classList.remove('is-active');
      this.formStatus = { ...this.formState, accountSelected: 'PASS' };
    });
  },
  inputHandler(): void {
    const inputNewAccountName = this.elements.updateAccountNameContainer.querySelector('.js-newAccountName') as HTMLInputElement;
    const regex = new RegExp(regexes.printablecharacters);

    inputNewAccountName.addEventListener(
      'input',
      debounce(
        () =>
          (this.formStatus = {
            ...this.formState,
            newAccountName: regex.test(inputNewAccountName.value) && inputNewAccountName.value.length <= 35 ? 'PASS' : 'FAIL'
          }),
        1000
      )
    );
  },
  validationHandler(): void {
    const formCTA = this.elements.updateAccountNameContainer.querySelector('.js-updateAccountNameSubmitButton') as HTMLElement;
    const formGroup = this.elements.updateAccountNameContainer.querySelector('.js-formGroup') as HTMLElement;
    const errorMsg = this.elements.updateAccountNameContainer.querySelector('.js-errorMsg') as HTMLElement;
    const dataErrorMsg = this.elements.updateAccountNameContainer.querySelector('[for="accountName"]') as HTMLElement;

    if (['FAIL', 'UNTOUCHED'].some((el) => Object.values(this.formStatus).includes(el))) {
      formCTA?.classList.add('disabled');
    } else {
      formCTA?.classList.remove('disabled');
    }

    if (this.formStatus.newAccountName === 'FAIL') {
      formGroup?.classList.add('has-error');
      errorMsg!.innerText = dataErrorMsg.dataset['errorInvalid'] as string;
      errorMsg?.classList.remove('hide');
    } else {
      formGroup?.classList.remove('has-error');
      errorMsg?.classList.add('hide');
    }
  },
  shouldSubmitForm(): void {
    this.elements.updateAccountNameContainer.addEventListener('submit', (event) => {
      event.preventDefault();

      if (!['FAIL', 'UNTOUCHED'].some((el) => Object.values(this.formStatus).includes(el))) {
        this.elements.updateAccountNameContainer.submit();
      }
    });
  }
};

export default updateAccountName;
