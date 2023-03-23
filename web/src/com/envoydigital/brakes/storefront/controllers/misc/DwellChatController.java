package com.envoydigital.brakes.storefront.controllers.misc;

import com.envoydigital.brakes.core.data.DwellAccessTokenResponseData;
import com.envoydigital.brakes.core.data.DwellChatQueueStatusData;
import com.envoydigital.brakes.core.integration.dwellchat.DwellChatClient;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.cms2.servicelayer.services.CMSSiteService;
import de.hybris.platform.servicelayer.config.ConfigurationService;
import de.hybris.platform.servicelayer.session.SessionService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

@Controller
public class DwellChatController extends AbstractController {

    @Resource(name = "dwellChatClient")
    private DwellChatClient dwellChatClient;

    @Resource(name = "cmsSiteService")
    private CMSSiteService cmsSiteService;

    @Resource(name = "configurationService")
    private ConfigurationService configurationService;

    @Resource(name = "sessionService")
    private SessionService sessionService;

    private static final String AUTH_TOKEN_SESSION_KEY = "dwellAuthToken";

    @RequestMapping(value = "/dwell-chat/auth/token", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public ResponseEntity<DwellAccessTokenResponseData> getAccessToken() {

        return dwellChatClient.getAuthToken();
    }

    @RequestMapping(value = "/dwell-chat/queue/status", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public DwellChatQueueStatusData getQueueStatus() {

        String authToken = "";
        if(null != sessionService.getAttribute(AUTH_TOKEN_SESSION_KEY)) {
            authToken = sessionService.getAttribute(AUTH_TOKEN_SESSION_KEY);
        }else if(null !=  dwellChatClient.getAuthToken() && null != dwellChatClient.getAuthToken().getBody()) {
            authToken =  dwellChatClient.getAuthToken().getBody().getAccessToken();
            sessionService.setAttribute(AUTH_TOKEN_SESSION_KEY, authToken);
        }

        DwellChatQueueStatusData responseData = dwellChatClient.getQueueStatus(cmsSiteService.getCurrentSite().getDwellChatQueueId(), authToken).getBody();

        return responseData;
    }

}
