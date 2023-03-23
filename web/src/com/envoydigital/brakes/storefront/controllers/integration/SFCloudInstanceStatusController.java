package com.envoydigital.brakes.storefront.controllers.integration;

import com.envoydigital.brakes.facades.integration.sfcloud.BrakesSFCloudFacade;
import com.envoydigital.brakes.facades.integration.sfcloud.json.SFCloudTransformedData;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
@RequestMapping("/sfCloudInstance/status")
public class SFCloudInstanceStatusController extends BaseIntegrationController {

    @Resource(name = "brakesSFCloudFacade")
    private BrakesSFCloudFacade brakesSFCloudFacade;

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public SFCloudTransformedData getSFCloudInstanceStatus()
    {
        return brakesSFCloudFacade.getSfCloudInstanceResponse();
    }
}
