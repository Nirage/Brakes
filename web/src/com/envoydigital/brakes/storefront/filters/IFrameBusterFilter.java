package com.envoydigital.brakes.storefront.filters;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.slf4j.LoggerFactory;
import org.springframework.web.filter.OncePerRequestFilter;


/**
 * Filter to break out of iframe without going through Hybris filter chain.
 *
 * See SOFA-2952/BRAKESP2-705
 *
 * Browsers are stopping sending 3rd party cookies, i.e. when returning from a ITS payment to Hybris it doesn't send the
 * JSESSIONID cookie. This causes a new session to be created and a new cookie to be returned to the user's browser
 * effectively logging them out. This filter attempts to avoid that by just sending the page to break out of the iframe
 * without creating a new session and then when the page reloads it is in a 1st party cookie situation (site that asked
 * for the reload is the same domain as the session cookie) so the correct session cookie is sent in the request.
 */
public class IFrameBusterFilter extends OncePerRequestFilter
{
	private static final org.slf4j.Logger LOG = LoggerFactory.getLogger(IFrameBusterFilter.class);

	private Map<String, String> urlMap;

	private String iframeJsp;

	private final String DEFAULT_RETURN_URL = "/checkout/order-completion";

	@Override
	protected void doFilterInternal(final HttpServletRequest request, final HttpServletResponse response, final FilterChain chain)
			throws ServletException, IOException
	{
		if (urlMap.containsKey(request.getRequestURI()))
		{

			if (request.getParameterMap() != null && !request.getParameterMap().isEmpty())
			{
				request.setAttribute("url", getURL(request.getParameterMap(), request.getRequestURI()));
			}
			request.getRequestDispatcher(iframeJsp).forward(request, response);
		}
		else
		{
			chain.doFilter(request, response);
		}
	}

	/**
	 * @param parameterMap
	 * @return
	 */
	private String getURL(final Map<String, String[]> parameterMap, final String baseURL)
	{
		final List<NameValuePair> queryTokens = new ArrayList();
		for (final Entry<String, String[]> entry : parameterMap.entrySet())
		{
			if (entry.getValue() != null && entry.getValue().length > 0)
			{
				queryTokens.add(new BasicNameValuePair(entry.getKey(), entry.getValue()[0]));
			}
		}
		URI actualURL = null;
		try
		{
			actualURL = new URIBuilder(urlMap.get(baseURL)).setParameters(queryTokens).build();
		}
		catch (final URISyntaxException e)
		{
			LOG.error("Error converting url {}", e);
		}
		if (actualURL != null)
		{
			return actualURL.toString();
		}
		else
		{
			return DEFAULT_RETURN_URL;
		}
	}

	public void setUrlMap(final Map<String, String> urlMap)
	{
		this.urlMap = urlMap;
	}

	public void setIframeJsp(final String iframeJsp)
	{
		this.iframeJsp = iframeJsp;
    }
}
