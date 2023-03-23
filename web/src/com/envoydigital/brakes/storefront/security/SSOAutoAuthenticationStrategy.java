package com.envoydigital.brakes.storefront.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface SSOAutoAuthenticationStrategy {

    /**
     * Authenticates a user into the system.
     *
     * @param accessCode
     *           the access code from IDP
     * @param request
     *           the HTTP request
     * @param response
     *           the HTTP response
     */
    boolean ssoAutoLogin(String accessCode, String internalRedirectUri, HttpServletRequest request, HttpServletResponse response);

    /**
     * Logs out a user from the system.
     */
    void logout();
}
