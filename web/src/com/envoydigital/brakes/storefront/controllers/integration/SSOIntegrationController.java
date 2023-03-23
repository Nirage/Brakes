package com.envoydigital.brakes.storefront.controllers.integration;

import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.security.SSOAutoAuthenticationStrategy;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class SSOIntegrationController {

    @Resource(name = "ssoAutoLoginStrategy")
    private SSOAutoAuthenticationStrategy ssoAutoLoginStrategy;

    @RequestMapping(value = "/ssoautologin", method = RequestMethod.GET)
    public String ssoAutoLogin(@RequestParam("code") String accessCode, @RequestParam(value = "internal_redirect_uri" , required = false) String internalRedirectUri, final HttpServletRequest request,
                               final HttpServletResponse response, Model model) {
        if (ssoAutoLoginStrategy.ssoAutoLogin(accessCode, internalRedirectUri, request, response)) {
            model.addAttribute("status", "hybrisLoginSuccess");
        }else {
            model.addAttribute("status", "hybrisLoginFailure");
        }
        return ControllerConstants.Views.Pages.Account.SSOLoginIframePage;
    }
}

