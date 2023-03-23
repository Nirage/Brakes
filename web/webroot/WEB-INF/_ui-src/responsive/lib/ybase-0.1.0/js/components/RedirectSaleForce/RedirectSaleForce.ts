import template from '../../utils/template';
import RedirectSaleForce from './index.vue';

export default () => {
  interface Object {
    prop: string;
    id: string;
    bodyMessage?: string;
    errorMessage?: string;
    noNewTab?: string;
    backToHome?: string;
    url: string;
  }

  const { body } = document as Document;
  const externalLoader = body.querySelector('#onload-loading') as HTMLDivElement;
  if (!externalLoader) return;

  const { id, dataset } = externalLoader;
  const { bodyMessage, errorMessage, href, backToHome, noNewTab } = dataset;
  const obj: Object = {
    prop: 'loader-data',
    id,
    bodyMessage,
    errorMessage,
    noNewTab,
    backToHome,
    url: ACC.config.contextPath + href
  };

  template(obj, RedirectSaleForce);
};
