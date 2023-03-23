import template from '../../utils/template';
import Popover from './index.vue';

export default () => {
  interface Object {
    prop: string;
    id: string;
    type: boolean;
    ssoMessage?: string;
    helpMessage?: string;
    errorMessage?: string;
    url: string;
  }

  const { body } = document as Document;
  const convertToButton = (popover: HTMLAnchorElement): HTMLButtonElement => {
    const { className, textContent, id } = popover;
    const button = document.createElement('button') as HTMLButtonElement;
    button.id = id;
    button.type = 'button';
    button.textContent = textContent;
    button.className = className;
    button.classList.add('nav__button');
    button.classList.remove('disabled');
    return button;
  };

  const listOfPopovers = body.querySelectorAll('.js-popover-loading') as NodeListOf<HTMLAnchorElement>;
  listOfPopovers.forEach((popover: HTMLAnchorElement): void => {
    const href = popover.getAttribute('href') as string;
    const button = convertToButton(popover) as HTMLButtonElement;
    popover.parentNode?.replaceChild(button, popover);

    button.addEventListener('click', (e: Event): void => {
      e.preventDefault();
      const target = e.target as HTMLButtonElement;
      const popoverLoading = body.querySelector('#popover-loading') as HTMLDivElement;
      const { id, dataset } = popoverLoading;
      const { ssoMessage, helpMessage, errorMessage } = dataset;

      body.classList.add('overflow-hide');

      const obj: Object = {
        prop: 'popover-data',
        id,
        type: !!target.id.length,
        ssoMessage,
        helpMessage,
        errorMessage,
        url: ACC.config.contextPath + href
      };

      template(obj, Popover);
    });
  });
};
