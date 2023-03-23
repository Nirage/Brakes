import template from '../../utils/template';
import LoginPopover from './Login.vue';

export default () => {
  const accountLogin = document.getElementById('v-login-popup') as HTMLElement;
  if (!accountLogin) return;

  const location = window.location;

  const {
    siteUid,
    hybrisIdpClient,
    userId,
    userIdValue,
    userName,
    signinTitle,
    headingValue,
    myDetailsValue,
    myFavouritesValue,
    myFavouritesUrl,
    notFoundValue,
    switchAccountValue,
    switchPlaceholderValue,
    switchBackValue,
    logoutValue
  } = accountLogin?.dataset;

  const ssoHandler = {
    receiveMessage(event) {
      let performAutologin = true;
      let checkIDPSessionPeriodically = false;
      let reloadLoginIframeTimeout = null;
      const authorizationServerHostOP = location.protocol + '//' + location.host; // is the same as hybrisServerHost. we are keeping seperate as it miht be useful when we will migrate to Okta.
      if (event.origin !== authorizationServerHostOP && event.origin !== authorizationServerHostOP) {
        // Origin did not come from the OP; this message must be rejected.
        return;
      }
      if (!event.data.type) {
        return;
      }
      switch (event.data.type) {
        // Messages coming from the Check Status Iframe
        case 'CHECK_STATUS_TYPE':
          switch (event.data.msg) {
            case 'unchanged':
              if (checkIDPSessionPeriodically) {
                const reCheckIDPSession = setTimeout(() => {
                  clearTimeout(reCheckIDPSession);
                  document.getElementById('sso-check-session').src = document.getElementById('sso-check-session').src;
                }, 5000); // get from a Backend Property
              }
              break;
            case 'changed':
              if (ssoHandler.loggedInPage) {
                // The IdP session has changed so we need to perform an Hybris Logout (only Hybris logout, no IdP loout).
                // TODO perform logout (need to decide if we perform the logout in asynchronously or just inform the user and perform a synchronous logout by reloading the page)
                // NIRAJ PAUL - Go to windows.location = /logout
              } else {
                /* There is a valid session in the IdP.
                   There might be different scenarios for this sub case:
                   1 - The user has performed a login using the iframe within the same page: in this case we should receive
                       a notification from the login iframe soon by the message 'hybrisLoginSuccess' or by the message
                       'hybrisLoginError' (please check the related handlers futher down in this code) => no actions here.
                   2 - The user has performed a login using another browser tab: in this case we should perform the
                       autologin by reloading the login iframe if the checkIDPSessionPeriodically flag is not set.
                       As we might be under the scenario 1, we will be waiting a bit in order to triger the login. */
                // Sub scenario 2
                if (performAutologin) {
                  console.info('[SSO] - Performing Login');
                  reloadLoginIframeTimeout = setTimeout(() => {
                    const body = document.body;
                    body.classList.add('overflow-hide');
                    body?.insertAdjacentHTML(
                      'beforeend',
                      `<div class="bg-item">
                        <div class="message-overlay">
                          <i class="icon icon-tick text-primary mr1" aria-hidden="true"></i>You are being logged into <span class="font-primary-bold">
                          ${siteUid === 'countryChoice' ? 'Country Choice' : 'Brakes'}
                          </span> automatically.
                        </div>
                      </div>`
                    );
                    const hybrisServerHost = location.protocol + '//' + location.host;
                    const authorizationServerHostOP = location.protocol + '//' + location.host;
                    const ssoLoginIframeURL = `${authorizationServerHostOP}/authorizationserver/oauth/authorize?client_id=${hybrisIdpClient}&response_type=code&redirect_uri=${hybrisServerHost}/ssoautologin&scope=openid`;
                    const iframe = document.createElement('iframe');
                    iframe.id = 'sso-login-iframe';
                    iframe.src = ssoLoginIframeURL;
                    iframe.classList.add('hide');
                    document.body.append(iframe);
                  }, 5000); // get from a Backend Property
                } else {
                  console.warn(
                    '[SSO] - There is a valid session in the IDP the autoloin has been not performed. It would be advisable to reload the page. If the problem will persist please contact the system administrator'
                  );
                }
              }
              break;
          }
          break;
        // Messages coming from the logn / Authorization Iframe
        case 'SSO_AUTHORIZATION_TYPE':
          switch (
            event.data.msg // TODO we need to amend the related oauth2 jsp pages that will trigger the following code: parent.postMessage('ssoIdp<specific error>' , '*') on page load;
          ) {
            case 'hybrisLoginSuccess': // TODO Please note, the event 'hybrisLoginSuccess' would need to be raised by custom javascript code within the iframe dedicated to the login. This means that once the loin will succeede and the /ssoautologin will be executed, we need to display a jsp page that will trigger the following code parent.postMessage('hybrisLoginSuccess', '*') on page load;
              console.info('[SSO] - Succesfully Login - Page reloading ...');
              const spinner = document.body.querySelector('.spinning-div');
              spinner?.classList.add('show');
              window.location.reload();
              break;
            case 'hybrisLoginError': // TODO Please note, the event 'hybrisLoginSuccess' would need to be raised by custom javascript code within the iframe dedicated to the login. This means that once the loin will succeede and the /ssoautologin will be executed, we need to display a jsp page that will trigger the following code parent.postMessage('hybrisLoginError', '*') on page load;
              // TODO we should check if it would be worth it to have a more invasive message here like 'Try to reload the page: if this issue is still there contact our service team'
              console.error('[SSO] - [hybrisLoginError] - error during autologin');
              break;
            case 'hybrisLoginPageLoaded': // TODO Please note, the event 'hybrisLoginPageLoaded' would need to be raised by custom javascript code within the iframe dedicated to the login. This means that once the loin will succeede and the /ssoautologin will be executed, we need to display a jsp page that will trigger the following code parent.postMessage('hybrisLoginPageLoaded', '*') on page load;
              if (!ssoHandler.loggedInPage) {
                // TODO we should check if it would be worth it to have a more invasive message here like 'Try to reload the page: if this issue is still there contact our service team'
                // console.info('[SSO] - [hybrisLoginPageLoaded] - Login Page Loaded');
                console.info('[SSO] - [hybrisLoginPageLoaded]');
                if (location.pathname.includes('sign-in')) {
                  ssoHandler.injectCheckSessionIframe();
                }
              } else {
                console.error('[SSO] - [hybrisLoginPageLoaded] - LogIn Page loaded within a logged in page.');
              }
              break;
            case 'ssoIdpError':
            case 'ssoIdp404Error':
            case 'ssoIdpExceptionError':
            case 'ssoIdpUknownError':
              // We are currently assuming that all the above errors should not be related to a temp issue of the IDP, but more to a wrong configuration so it would be not worth it to retry by creating additional overload.
              checkIDPSessionPeriodically = false;
              console.error('[SSO] - [SSO-IDP-Error] - error during autologin: ' + event.data);
              break;
          }
      }
      return;
    },
    injectCheckSessionIframe() {
      const authorizationServerHostOP = location.protocol + '//' + location.host;
      const ssoLoginSessionIframeURL = `${authorizationServerHostOP}/authorizationserver/oauth/check_session?user=${userIdValue}`;
      const iframe = document.createElement('iframe');
      iframe.id = 'sso-check-session';
      iframe.src = ssoLoginSessionIframeURL;
      iframe.classList.add('hide');
      document.body.append(iframe);
    }
  };

  window.addEventListener('message', ssoHandler.receiveMessage, false);

  // Check Session require onload all the time except sign-in.
  if (!location.pathname.includes('sign-in')) {
    ssoHandler.injectCheckSessionIframe();
  }

  const ssoLogin = () => {
    const blackListPages = window.location.href.includes('/ssoautologin');
    // Below the Message Listener that will be handling messages for both the 'sso-check-session' and the login related ones in case of anonymous users (containing the username and password)
    if (!blackListPages) {
      const obj: Object = {
        prop: 'login-data',
        id: accountLogin.id,
        hybrisIdpClient,
        userId,
        userName,
        signinTitle,
        headingValue,
        myDetailsValue,
        myDetailsUrl: siteUid === 'countryChoice' ? '/my-account/my-details' : '/Mybrakes-myaccount',
        myFavouritesValue,
        myFavouritesUrl,
        notFoundValue,
        switchAccountValue,
        switchPlaceholderValue,
        switchBackValue,
        logoutValue,
        authenticated: ACC.config.authenticated,
        isb2cSite: ACC.config.isb2cSite,
        CSRFToken: ACC.config.CSRFToken
      };
      template(obj, LoginPopover);
    }
  };

  const loginPopupTriggers = document.body.querySelectorAll('.js-loginPopupTrigger');
  if (loginPopupTriggers.length) {
    loginPopupTriggers.forEach((loginElement) => {
      loginElement.addEventListener('click', () => {
        const accountLogin = document.getElementById('v-login-popup') as HTMLElement;
        const popup = accountLogin?.querySelector('.nav-popup');
        if (popup) {
          popup.classList.remove('hide');
        } else {
          ssoLogin();
        }
      });
    });
  } else {
    ssoLogin();
  }
};
