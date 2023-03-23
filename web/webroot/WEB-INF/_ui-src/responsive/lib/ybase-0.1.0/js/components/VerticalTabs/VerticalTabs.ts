import accountmydetails from '../../acc.accountmydetails';
import updateAccountName from '../../acc.updateAccountName';

const mq: MediaQueryList = window.matchMedia('(min-width: 768px)');
const verticalTabs = document.getElementById('v-vertical-tabs') as HTMLDivElement;
const { navigation } = performance;

const tab1MyDetails = 'tabs-1';
const tab4MyPaymentCard = 'tabs-4';
const tab6UpdateAccountName = 'tabs-6';

if (navigation.type !== navigation.TYPE_RELOAD) sessionStorage.removeItem('myaccount');

const _activeTabDetectionFn = function () {
  const _paymentErrorInput = document.getElementsByClassName('js-showPaymetErrorPopup');
  const _accountNameSuccess = document.getElementsByClassName('updateAccountName--success');
  if (_paymentErrorInput.length && (_paymentErrorInput[0] as HTMLInputElement).value) {
    return tab4MyPaymentCard;
  }
  if (_accountNameSuccess.length) {
    return tab6UpdateAccountName;
  }
  return sessionStorage['myaccount'] ? sessionStorage.getItem('myaccount') : tab1MyDetails;
};
const activeTab = _activeTabDetectionFn();
const selectedTab = (mq.matches || sessionStorage['myaccount']) && (verticalTabs?.querySelector(`#${activeTab}`) as HTMLInputElement);
if (selectedTab) selectedTab.checked = true;

const ACC = window.ACC;
Object.assign(ACC, { accountmydetails, updateAccountName });

ACC.accountmydetails.init();
ACC.updateAccountName.init();
