/**
 *
 */
package com.envoydigital.brakes.storefront.controllers.integration;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;

import javax.annotation.Resource;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.envoydigital.brakes.facades.BrakesSingleSignonFacade;
import com.envoydigital.brakes.facades.sso.data.SSOSessionData;


/**
 * @author Sathya.m
 *
 */
@RestController
@RequestMapping("/singleSignon")
public class SingleSignOnController extends BaseIntegrationController
{
	@Resource(name = "brakesSingleSignonFacade")
	private BrakesSingleSignonFacade brakesSingleSignonFacade;

	@RequireHardLogIn
	@GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
	public SSOSessionData getCustomerLoginDetails()
	{
		return brakesSingleSignonFacade.getCustomerSSOSession();

	}

}
