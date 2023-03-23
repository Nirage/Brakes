<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:url value="/my-account/favourites" var="myFavouritesUrl"/>
<c:url value="${siteUid eq 'countryChoice' ? '/my-account/my-details': '/Mybrakes-myaccount'}" var="myDetailsUrl"/>

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
        <div class="account-dropdown account-dropdown--user-details">

            <div class="account-dropdown__content account-dropdown__content--account hide js-accountDropdownContent text-left" data-id="user-details">
                <div class="account-dropdown__section account-dropdown__section--no-border-top">
                    <h1 class="account-dropdown__salutation">
                        <spring:theme code="account.salutation" arguments="${user.firstName}, ${user.lastName}"/>
                    </h1>
                    <span class="account-dropdown__account-id">${user.unit.uid}</span>
                    <span class="account-dropdown__businessname">${user.unit.name}</span>
                </div>
                <div class="account-dropdown__views">
                        <%--START: account-dropdown__view normal--%>
                    <div class="account-dropdown__view js-accountDropdownView account-dropdown__view--normal is-visible" data-account-view="normal">
                        <div class="account-dropdown__section account-dropdown__section--no-border-top  js-switchAccountSection hide">
						<span class="account-action js-changeAccountView js-switchAccountBtn" data-view="switch-account">
							<span class="icon icon-switch-basket account-action__icon"></span>
							<span class="account-action__text"><spring:theme code="account.switchaccount"/></span>
						</span>
                        </div>
                        <a href="${fn:escapeXml(myDetailsUrl)}" >
                            <spring:theme code="account.mydetails" />
                        </a>
                        <a href="${fn:escapeXml(myFavouritesUrl)}" >
                            <spring:theme code="text.account.favourites.my" />
                        </a>
                        <ycommerce:testId code="header_signOut">
                            <c:url value="/logout" var="logoutUrl"/>
                            <div class="account-dropdown__section">
                                <a href="${fn:escapeXml(logoutUrl)}" class="account-action">
                                    <span class="icon icon-logout account-action__icon"></span>
                                    <span class="account-action__text">
									<spring:theme code="header.link.logout" />
								</span>
                                </a>
                            </div>
                        </ycommerce:testId>
                    </div><%--account-dropdown__view normal--%>
                        <%--START: account-dropdown__view switch-account--%>
                    <div class="account-dropdown__view account-dropdown__view--switch-account js-accountDropdownView" data-account-view="switch-account">
                        <button tabindex="0" class="btn btn-back-normal js-changeAccountView" data-view="normal">
							<span class="btn-back-normal__inner">
								<span class="icon icon--sm icon-chevron-left"></span>
								<span><spring:theme code="account.back"/></span>
							</span>
                        </button>

                        <div class="site-form switch-account__search">
                            <label class="site-form__label site-form__label--no-margin-top">
                                <spring:theme code="account.switchaccount" /></label>
                            <input tabindex="0" type="text" class="form-control site-form__input js-filterAccounts" placeholder="<spring:theme code="account.switchaccount.search.placeholder" />" />
                        </div>
                        <div class="switch-account__list-divider"></div>
                        <div class="switch-account__list-wrapper js-accountsListWrapper">
                            <form:form action="/my-account/select" method="post" id="switchAccountForm" class="js-switchAccountForm">
                                <input id="accountID" type="hidden" value="" name="accountID" />
                            </form:form>
                            <div id= "switchAccountList">
                            </div>
                        </div>
                    </div>
                        <%--END: account-dropdown__view switch-account--%>
                </div><%--account-dropdown__views--%>
            </div><%--account-dropdown__content--%>
        </div><%--account-dropdown--%>
</sec:authorize>
