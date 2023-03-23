/**
 *
 */
package com.envoydigital.brakes.storefront.tags;

import de.hybris.platform.acceleratorcms.component.slot.CMSPageSlotComponentService;
import de.hybris.platform.acceleratorcms.data.CmsPageRequestContextData;
import de.hybris.platform.acceleratorcms.services.CMSPageContextService;
import de.hybris.platform.acceleratorcms.utils.SpringHelper;
import de.hybris.platform.acceleratorstorefrontcommons.tags.Functions;
import de.hybris.platform.cms2.model.contents.components.AbstractCMSComponentModel;
import de.hybris.platform.cms2.model.contents.components.CMSLinkComponentModel;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;


/**
 * @author Lakshmi
 *
 */
public class YFunctions
{

	public static boolean isComponentVisible(final String componentId)
	{
		if (StringUtils.isNotEmpty(componentId))
		{
			final AbstractCMSComponentModel currentCmsComponent = getCMSPageSlotComponentService().getComponentForId(componentId);

			if (currentCmsComponent != null)
			{
				final CmsPageRequestContextData currentCmsPageRequestContextData = getCmsPageContextService()
						.getCmsPageRequestContextData(getCurrentRequest());
				final List<AbstractCMSComponentModel> components = getCMSPageSlotComponentService()
						.getCMSComponentsForComponent(currentCmsPageRequestContextData, currentCmsComponent, true, -1);
				if (!components.isEmpty())
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		return false;
	}

	public static String renderCatHomePageLink(final CMSLinkComponentModel cmsLinkComponent)
	{
		if (cmsLinkComponent != null)
		{
			return Functions.getUrlForCMSLinkComponent(cmsLinkComponent);
		}
		return StringUtils.EMPTY;
	}


	protected static CMSPageContextService getCmsPageContextService()
	{
		return SpringHelper.getSpringBean(getCurrentRequest(), "cmsPageContextService", CMSPageContextService.class, true);
	}

	protected static CMSPageSlotComponentService getCMSPageSlotComponentService()
	{
		return SpringHelper.getSpringBean(getCurrentRequest(), "cmsPageSlotComponentService", CMSPageSlotComponentService.class,
				true);
	}

	protected static HttpServletRequest getCurrentRequest()
	{
		return ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
	}


}
