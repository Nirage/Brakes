/**
 *
 */
package com.envoydigital.brakes.storefront.interceptors.beforeview;

import com.envoydigital.brakes.facades.constants.BrakesFacadesConstants;
import de.hybris.platform.acceleratorstorefrontcommons.interceptors.BeforeViewHandler;
import de.hybris.platform.cms2.model.site.CMSSiteModel;
import de.hybris.platform.cms2.servicelayer.services.CMSSiteService;
import de.hybris.platform.commercefacades.order.data.OrderHistoryData;
import de.hybris.platform.servicelayer.config.ConfigurationService;
import de.hybris.platform.servicelayer.session.SessionService;
import de.hybris.platform.store.services.BaseStoreService;
import de.hybris.platform.util.Config;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;

import java.text.DateFormat;
import java.text.SimpleDateFormat;


/**
 * @author maheshroyal
 *
 */
public class BrakesConfigParametersBeforeViewHandler implements BeforeViewHandler
{

	@Resource(name = "cmsSiteService")
	private CMSSiteService cmsSiteService;

	@Resource(name = "configurationService")
	private ConfigurationService configurationService;

	@Resource(name = "baseStoreService")
	private BaseStoreService baseStoreService;


	@Resource
	private SessionService sessionService;

	@Override
	public void beforeView(final HttpServletRequest request, final HttpServletResponse response, final ModelAndView modelAndView)
			throws Exception
	{
		if(StringUtils.isNotEmpty(sessionService.getCurrentSession().getAttribute(BrakesFacadesConstants.AMENDING_ORDER_CODE))) {
			modelAndView.addObject(BrakesFacadesConstants.AMENDING_ORDER_CODE,sessionService.getCurrentSession().getAttribute(BrakesFacadesConstants.AMENDING_ORDER_CODE));
		}
		if(null != sessionService.getCurrentSession().getAttribute(BrakesFacadesConstants.AMENDING_ORDER_DEADLINE)) {
			final SimpleDateFormat orderDeadLineDateFormat = new SimpleDateFormat(BrakesFacadesConstants.ORDER_DEADLINE_DATE_FORMAT);
			modelAndView.addObject(BrakesFacadesConstants.AMENDING_ORDER_DEADLINE, orderDeadLineDateFormat.format(sessionService.getCurrentSession().getAttribute(BrakesFacadesConstants.AMENDING_ORDER_DEADLINE)));
		}
		modelAndView.addObject("pcaApiKey", Config.getString("pcalookup.apikey", "DK69-UW94-FA93-UW89"));
		modelAndView.addObject("pcaFindURL", Config.getString("pcalookup.api.findUrl",
				"https://services.postcodeanywhere.co.uk/PostcodeAnywhere/Interactive/Find/v1.10/json3.ws?Key="));
		modelAndView.addObject("pcaRetrieveURL", Config.getString("pcalookup.api.retrieveByIdUrl",
				"https://services.postcodeanywhere.co.uk/PostcodeAnywhere/Interactive/RetrieveById/v1.30/json3.ws?Key="));
		modelAndView.addObject("calendarDefaultWeekCount",
				Config.getInt(BrakesCoreConstants.DELIVERY_CALENDAR_DEFAULT_WEEK_COUNT, 8));
		modelAndView.addObject("promoSearchPageSize", Config.getInt("promo.search.pageSize", getSolrPageSize()));
		modelAndView.addObject("ccv2Environment", Config.getString("storefront.ccv2.env.id", ""));
		modelAndView.addObject("amplienceEnvironment", Config.getString("amplience.env.id", "PROD"));
		modelAndView.addObject("cookieToken", Config.getString("cookies." + cmsSiteService.getCurrentSite().getUid()+".token", ""));
		modelAndView.addObject("hybrisIDPClient", Config.getString(cmsSiteService.getCurrentSite().getUid()+".sso.api.token.client.id", ""));


		final CMSSiteModel currentSite = cmsSiteService.getCurrentSite();

		String monetatePlaceHolderPathVariable = "";
		String sfwebbeaconUrl = "";
		String linkPrefix = "d";
		Boolean enableSfwebBeaconTag = Boolean.FALSE;
		final String env = configurationService.getConfiguration().getString("modelt.environment.type", "development");
		switch (currentSite.getUid())
		{

			case "brakes":
				if (env.equals("production"))
				{
					linkPrefix = "p";
					monetatePlaceHolderPathVariable = "brake.co.uk";
				}
				else
				{
					monetatePlaceHolderPathVariable = "accstorefront.cmgii8vaud-brakebros1-s1-public.model-t.cc.commerc";
				}

				//Setting SF web beacon script
				enableSfwebBeaconTag = Config.getBoolean("brakes.enableSfwebBeacontag", Boolean.TRUE);
				sfwebbeaconUrl = Config.getString("brakes.sfwebbeaconUrl", "//cdn.evgnet.com/beacon/syscocorporation/brakesukdev/scripts/evergage.min.js");

				break;
			case "countryChoice":
				if (env.equals("production"))
				{
					linkPrefix = "p";
					monetatePlaceHolderPathVariable = "countrychoice.co.uk";
				}
				else
				{
					monetatePlaceHolderPathVariable = "countrychoice-staging.envoydigital.com";
				}

				//Setting SF web beacon script
				enableSfwebBeaconTag = Config.getBoolean("countrychoice.enableSfwebBeacontag", Boolean.TRUE);
				sfwebbeaconUrl = Config.getString("countrychoice.sfwebbeaconUrl", "//cdn.evgnet.com/beacon/syscocorporation/country_choice_qa/scripts/evergage.min.js");

				break;
			case "brakesfoodshop":
				if (env.equals("production"))
				{
					linkPrefix = "p";
					monetatePlaceHolderPathVariable = "brakesfoodshop.co.uk";
				}
				else
				{
					linkPrefix = "d";
					monetatePlaceHolderPathVariable = "brakesfoodshop-qa.envoydigital.com";
				}
				break;
		}

		//Setting monatate script url path
		modelAndView.addObject("monetateScriptUrl",
			"https://se.monetate.net/js/2/a-cded1213/" + linkPrefix + "/" + monetatePlaceHolderPathVariable + "/entry.js");
		//Setting SF web beacon script
		modelAndView.addObject("enableSfwebBeaconTag", enableSfwebBeaconTag);
		modelAndView.addObject("sfwebbeaconUrl", sfwebbeaconUrl);
		if(currentSite.getUid().equalsIgnoreCase("brakes")) 
		{
			modelAndView.addObject("singlesignon", Config.getBoolean("brakes.enable.single.signon", Boolean.FALSE));
		}
		else 
		{
			modelAndView.addObject("singlesignon", Boolean.FALSE);
		}

	}

	/**
	 * @return
	 */
	private int getSolrPageSize()
	{
		final int defaultpageSize = 60;
		if (baseStoreService.getCurrentBaseStore() != null
				&& baseStoreService.getCurrentBaseStore().getSolrFacetSearchConfiguration() != null)
		{
			return baseStoreService.getCurrentBaseStore().getSolrFacetSearchConfiguration().getSolrSearchConfig().getPageSize();
		}
		return defaultpageSize;
	}

}
