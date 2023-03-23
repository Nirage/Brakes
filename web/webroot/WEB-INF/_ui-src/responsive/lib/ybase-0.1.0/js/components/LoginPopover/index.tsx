import React, { useEffect, useState, useRef } from 'react';
import axios from 'axios';

type Props = {
  id: string;
  hybrisIdpClient: string;
  userId: string;
  userName: string;
  signinTitle: string;
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
  authenticated: boolean;
  isb2cSite: boolean;
  CSRFToken: string;
};

interface B2BUnit {
  uid: string;
  name: string;
}

export default ({
  id,
  userId,
  hybrisIdpClient,
  userName,
  signinTitle,
  headingValue,
  myDetailsValue,
  myDetailsUrl,
  myFavouritesValue,
  myFavouritesUrl,
  notFoundValue,
  switchAccountValue,
  switchPlaceholderValue,
  switchBackValue,
  logoutValue,
  authenticated,
  isb2cSite,
  CSRFToken
}: Props) => {
  const [showPopover, setShowPopover] = useState<boolean>(true);
  const [switchAccount, setSwitchAccount] = useState<boolean>(false);
  const [currentUnit, setCurrentUnit] = useState<B2BUnit | {}>({});
  const [listOfUnits, setListOfUnits] = useState<Array<B2BUnit>>([]);
  const [filteredUnits, setFilteredUnits] = useState<Array<B2BUnit>>([]);
  const [maxHeight, setMaxHeight] = useState<number>(0);
  const [accountID, setAccountID] = useState<string>('');
  const unitlist = useRef<HTMLDivElement>(null);
  const switchAccountForm = useRef<HTMLFormElement>(null);
  const hybrisServerHost = window.location.protocol + '//' + window.location.host;
  const authorizationServerHostOP = window.location.protocol + '//' + window.location.host;
  const ssoLoginIframeURL = `${authorizationServerHostOP}/authorizationserver/oauth/authorize?client_id=${hybrisIdpClient}&response_type=code&redirect_uri=${hybrisServerHost}/ssoautologin&scope=openid`;
  const isPopover = !!document.body.querySelectorAll('.js-loginPopupTrigger').length;

  const switchAccountHandler = (e: Event): void => {
    e.preventDefault();
    setSwitchAccount(!switchAccount);
    setMaxHeight(window.innerHeight - unitlist.current?.getBoundingClientRect().top - 250);
  };

  const filterUnitsHandler = (e: Event): void => {
    const target = e.target as HTMLInputElement;
    const updateList: string[] = listOfUnits.filter((obj) => {
      const unitNameString = `${obj.uid} ${obj.name}`;
      return unitNameString.toLowerCase().includes(target.value.toLowerCase());
    }) as any;
    setFilteredUnits(updateList);
  };

  const changeHandler = (e: Event): void => {
    const target = e.target as HTMLInputElement;
    if (target.value !== currentUnit) {
      setAccountID(target.value);
      setTimeout(() => switchAccountForm.current?.submit(), 0);
    }
  };

  const clickHandler = (e: Event) => {
    const button = e.currentTarget as HTMLButtonElement;
    const popover = button.nextElementSibling;
    popover?.classList.toggle('hide');
    setShowPopover(!showPopover);
  };

  const renderUnits = filteredUnits?.map((unit) => (
    <li key={unit.uid} className="full-width">
      <div className="radio site-radio">
        <input
          tabIndex={0}
          type="radio"
          id={`b2bunit-${unit.uid}`}
          value={unit.uid}
          name="uid"
          defaultChecked={unit.uid === currentUnit.uid}
          onChange={changeHandler}
        />
        <label htmlFor={`b2bunit-${unit.uid}`} className="site-radio__label site-radio__label--has-subtext">
          <span className="site-radio__maintext">{unit.uid}</span>
          <span className="site-radio__subtext">{unit.name}</span>
        </label>
      </div>
    </li>
  ));

  useEffect(() => {
    document.addEventListener('click', (e: Event): void => {
      const target = e.target as HTMLElement;
      if (!target.closest('#v-login-popup') && !target.classList.contains('btn-switch') && !target.closest('.js-loginPopupTrigger')) {
        document.getElementById('v-login-popup')?.querySelector('.nav-popup')?.classList.add('hide');
        setShowPopover(false);
      }
    });

    (async () => {
      try {
        const response = await axios.get('/my-account/units');
        const { currentB2Bunit, listOfB2BUnits } = response.data;
        setCurrentUnit(currentB2Bunit);
        setListOfUnits(listOfB2BUnits);
        setFilteredUnits(listOfB2BUnits);
      } catch (error) {
        console.warn(error);
      }
    })();

    const iframe = document.getElementById('sso-iframe') as HTMLIFrameElement;
    if (iframe) {
      const resizeIFrame = () => {
        const iframeHeight = iframe.contentWindow?.document.body?.scrollHeight;
        iframe.style.height = iframeHeight + 'px';
      };
      iframe.addEventListener('load', resizeIFrame);
      const resizeObserver = new ResizeObserver(resizeIFrame);
      resizeObserver.observe(iframe);
    }
  }, []);

  return (
    <>
      {isPopover || authenticated ? (
        <div id={id} className={`nav__item js-mobile-nav__item user ${showPopover ? 'nav__item--open' : ''}`}>
          <button className="btn btn-link nav__links-item__link" aria-label="login" onClick={clickHandler}>
            <i className="icon icon-user" aria-hidden="true" />
          </button>
          {authenticated && !isb2cSite ? (
            <div className="nav-popup">
              <h2 className="nav-popup__main-heading">{headingValue}</h2>
              <hr />
              <div className="account-dropdown__views" ref={unitlist}>
                {!switchAccount && (
                  <h2 className="nav-popup__sub-heading">
                    <a href={myDetailsUrl}>{myDetailsValue}</a>
                  </h2>
                )}
              </div>
              <span className="account-dropdown__account-id">{userId}</span>
              <span className="account-dropdown__businessname p0">{userName}</span>
              {!switchAccount && (
                <>
                  {!!listOfUnits.length && (
                    <button className="btn p0 mt1 bg-white flex font-size-1 btn-switch" onClick={switchAccountHandler}>
                      <i className="icon icon-switch-basket mr1-4" aria-hidden="true" />
                      {switchAccountValue}
                    </button>
                  )}
                  <hr />
                  <h2 className="nav-popup__sub-heading">
                    <a href={myFavouritesUrl}>{myFavouritesValue}</a>
                  </h2>
                  <hr />
                  <a href="/logout" className="flex">
                    <i className="icon icon-logout mr1-4" aria-hidden="true" />
                    {logoutValue}
                  </a>
                </>
              )}
              {switchAccount && (
                <div className="switch-account mt1">
                  <button
                    tabIndex={0}
                    className="btn btn-back-normal flex align-items-center p1-4 font-size-1 btn-switch"
                    onClick={() => setSwitchAccount(!switchAccount)}
                  >
                    <i className="icon icon--sm icon-chevron-left" />
                    {switchBackValue}
                  </button>
                  <div className="site-form switch-account__search">
                    <label className="site-form__label site-form__label--no-margin-top">{switchAccountValue}</label>
                    <input
                      tabIndex={0}
                      type="text"
                      maxLength={35}
                      className="form-control site-form__input"
                      placeholder={switchPlaceholderValue}
                      onInput={filterUnitsHandler}
                    />
                  </div>
                  <div className="switch-account__list-wrapper js-accountsListWrapper" style={{ maxHeight: maxHeight + 'px' }}>
                    <form id="switchAccountForm" action="/my-account/select" method="post" ref={switchAccountForm}>
                      <input id="accountID" type="hidden" value={accountID} name="accountID" />
                      <input type="hidden" name="CSRFToken" value={CSRFToken} />
                      {filteredUnits.length ? (
                        <ul className="switch-account__list list-unstyled">{renderUnits}</ul>
                      ) : (
                        <div className="mt1-2">{notFoundValue}</div>
                      )}
                    </form>
                  </div>
                </div>
              )}
            </div>
          ) : (
            <div className={`nav-popup ${showPopover ? '' : 'hide'}`}>
              <h2 className="login-popup__sub-heading">{signinTitle}</h2>
              <iframe id="sso-iframe" className="b0" src={ssoLoginIframeURL} width="100%"></iframe>
              <div className="text-center mt1-2">
                Forgot&nbsp;
                <a href="/forgot-username" className="text-primary underline">
                  username
                </a>
                &nbsp;or&nbsp;
                <a href="/forgot-password" className="text-primary underline">
                  password
                </a>
                ?
              </div>
              <hr />
              <a href="/sign-in" className="btn btn-secondary btn--full-width" title="Register">
                Register
              </a>
            </div>
          )}
          {showPopover && <span className="nav__item--bg" onClick={() => setShowPopover(false)} />}
        </div>
      ) : (
        <iframe id="sso-iframe" className="b0" src={ssoLoginIframeURL} width="100%"></iframe>
      )}
    </>
  );
};
