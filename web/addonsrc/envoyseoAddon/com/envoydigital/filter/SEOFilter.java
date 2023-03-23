/**
 *
 */
package com.envoydigital.filter;

import de.hybris.platform.commercefacades.user.UserFacade;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.filter.OncePerRequestFilter;

import com.envoydigital.enums.ForwardType;
import com.envoydigital.facades.seo.data.SEOData;
import com.envoydigital.seo.facades.SEOFacade;
import com.envoydigital.seo.util.SeoCoreUtils;


/**
 * @author maheshroyal
 *
 *         SEOFilter. Used for forwarding or Redirecting each request if there is matching SEO URl config.
 */
public class SEOFilter extends OncePerRequestFilter
{


	private static final String HTTP_GET = "GET";
	private static final String ROOT_URL = "/";

	@Autowired
	private SEOFacade seoFacade;

	@Autowired
	private UserFacade userFacade;

	private boolean activated;
	private List<String> excludeUrlList = new ArrayList<String>();

	@Override
	protected void doFilterInternal(final HttpServletRequest request, final HttpServletResponse response,
			final FilterChain filterChain) throws ServletException, IOException
	{
		if (request.getMethod().equalsIgnoreCase(HTTP_GET) && activated)
		{
			final String url = request.getRequestURI().substring(request.getContextPath().length());
			//Ignore some urls - styles, js etc - iterator to avoid concurrency issues and having to use synchronization
			boolean excluded = false;
			final Iterator<String> listIterator = excludeUrlList.iterator();
			while (listIterator.hasNext())
			{
				final String excludeUrl = listIterator.next();
				if (url.startsWith(excludeUrl))
				{
					excluded = true;
					break;
				}
			}

			if (!excluded)
			{
				String filteredUrl = null;
				final boolean isAnonymousUser = userFacade.isAnonymousUser();
				if (ROOT_URL.equals(url) && isAnonymousUser)
				{
					filterChain.doFilter(request, response);
					return;
				}
				else if (ROOT_URL.equals(url) && !isAnonymousUser)
				{
					filteredUrl = url;
				}
				else
				{
					filteredUrl = SeoCoreUtils.removeTrailingSlash(url);
				}
				final SEOData internalUrlConfig = seoFacade.getSEOURL(filteredUrl);
				if (internalUrlConfig != null)
				{
					final String targetUrl = internalUrlConfig.getTargetUrl();
					if (internalUrlConfig.getForwardType().equals(ForwardType.FORWARD))
					{
						if (Boolean.TRUE.equals(internalUrlConfig.getCachingDisabled()))
						{
							response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
							response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
							response.setDateHeader("Expires", 0); // Proxies.
						}
						request.getRequestDispatcher(targetUrl).forward(request, response);
					}
					else
					{
						//We assume all moves are permanent
						response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
						response.setHeader("Location", targetUrl);
					}

					// By this point have either forwarded or redirected
					// Just return so that filter chain is not processed
					return;
				}else if(internalUrlConfig == null && url.endsWith("/") && url.length() > 1) {
					// Removing ending slash in all cases
					response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
					response.setHeader("Location",  SeoCoreUtils.removeTrailingSlash(url));

					return;
				}
			}
		}
		filterChain.doFilter(request, response);
	}

	public void setActivated(final boolean activated)
	{
		this.activated = activated;
	}

	public void setExcludeUrl(final List<String> excludeUrl)
	{
		this.excludeUrlList = excludeUrl;
	}

}
