package com.envoydigital.brakes.storefront.security.impl;

import com.envoydigital.brakes.core.integration.sso.SSOClient;
import com.envoydigital.brakes.integration.json.SSOAuthTokenResponseData;
import com.envoydigital.brakes.integration.json.SSOJWTTokenPayloadData;
import com.envoydigital.brakes.storefront.security.SSOAutoAuthenticationStrategy;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetails;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Base64;

public class DefaultSSOAutoAuthenticationStrategy extends DefaultAutoLoginStrategy implements SSOAutoAuthenticationStrategy  {

    private static final Logger LOG = Logger.getLogger(DefaultSSOAutoAuthenticationStrategy.class);
    private SSOClient ssoClient;
    private AuthenticationProvider authenticationProvider;

    @Override
    public boolean ssoAutoLogin(String accessCode, String internalRedirectUri, HttpServletRequest request, HttpServletResponse response) {
        ResponseEntity<SSOAuthTokenResponseData> authTokenResponse = ssoClient.getAuthTokenByAccessCode(accessCode, internalRedirectUri);
        if(authTokenResponse.hasBody() && null != authTokenResponse.getBody()
            && StringUtils.isNotEmpty(authTokenResponse.getBody().getIdToken())) {
                String[] chunks = authTokenResponse.getBody().getIdToken().split("\\.");
                if(chunks.length > 1) {
                    try {
                        Base64.Decoder decoder = Base64.getUrlDecoder();
                        String payload = new String(decoder.decode(chunks[1]));
                        ObjectMapper mapper = new ObjectMapper();
                        SSOJWTTokenPayloadData jwtPayloadData = mapper.readValue(payload, SSOJWTTokenPayloadData.class);
                        if(StringUtils.isNotEmpty(jwtPayloadData.getSub())) {
                            final UsernamePasswordAuthenticationToken token = new UsernamePasswordAuthenticationToken(jwtPayloadData.getSub(), null);
                            token.setDetails(new WebAuthenticationDetails(request));
                            final Authentication authentication = getAuthenticationProvider().authenticate(token);
                            SecurityContextHolder.getContext().setAuthentication(authentication);
                            getCustomerFacade().loginSuccess();
                            getGuidCookieStrategy().setCookie(request, response);
                            getRememberMeServices().loginSuccess(request, response, token);
                            return true;
                        } else {
                            SecurityContextHolder.getContext().setAuthentication(null);
                            LOG.error("JWT token ::sub is empty ");
                            return false;
                        }
                    } catch (final AuthenticationException | JsonProcessingException ex) {
                        SecurityContextHolder.getContext().setAuthentication(null);
                        LOG.error("Failure during sso autoLogin", ex);
                        return false;
                    }
                }
        }
        SecurityContextHolder.getContext().setAuthentication(null);
        LOG.error("Failure during sso autoLogin :: authToken response is empty");
        return false;
    }

    @Override
    public void logout() {
        SecurityContextHolder.clearContext();
    }

    public SSOClient getSsoClient() {
        return ssoClient;
    }

    public void setSsoClient(SSOClient ssoClient) {
        this.ssoClient = ssoClient;
    }

    public AuthenticationProvider getAuthenticationProvider() {
        return authenticationProvider;
    }

    public void setAuthenticationProvider(AuthenticationProvider authenticationProvider) {
        this.authenticationProvider = authenticationProvider;
    }
}
