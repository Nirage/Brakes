/**
 *
 */
package com.envoydigital.brakes.storefront.controllers.misc;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.commercefacades.user.data.CompanyData;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.envoydigital.brakes.facades.BrakesCompanyFacade;


/**
 * @author maheshroyal
 *
 */
@RestController
public class MiscController extends AbstractController
{

	@Resource(name = "brakesCompanyFacade")
	private BrakesCompanyFacade brakesCompanyFacade;

	@GetMapping(path = "/misc/subsectors")
	@ResponseBody
	public List<CompanyData> getSubSectors(@RequestParam("sector")
	final String sector)
	{
		return brakesCompanyFacade.getSubSectors(sector);

	}

	@GetMapping(path = "/misc/sfsubsectors")
	@ResponseBody
	public List<CompanyData> getSFSubSectors(@RequestParam("sector")
	final String sector)
	{
		return brakesCompanyFacade.getSFSubSectors(sector);

	}

}
