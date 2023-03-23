/*
 * Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
 */
package com.envoydigital.brakes.storefront.renderer;

import de.hybris.platform.acceleratorcms.component.renderer.CMSComponentRenderer;
import de.hybris.platform.cms2.model.contents.components.CMSParagraphComponentModel;
import de.hybris.platform.util.Config;
import org.apache.commons.lang.StringUtils;

import javax.servlet.ServletException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import java.io.IOException;


public class CMSParagraphComponentRenderer extends de.hybris.platform.acceleratorcms.component.renderer.impl.CMSParagraphComponentRenderer implements CMSComponentRenderer<CMSParagraphComponentModel>
{

	private static final String CUSTOM_UNSAFE_JAVASCRIPT_OWSPA_ALLOWED = "cms.components.allowUnsafeJavaScriptOWSPA";

	private BrakesHtmlSanitizerPolicyProvider brakesHtmlSanitizerPolicyProvider;

	@Override
	public void renderComponent(final PageContext pageContext, final CMSParagraphComponentModel component)
			throws ServletException, IOException
	{
		// <div class="content">${content}</div>
		final JspWriter out = pageContext.getOut();

		out.write("<div class=\"content\">");
		
		final String content = component.getContent() == null ? StringUtils.EMPTY : component.getContent();
		
		if(isUnsafeJavaScriptAllowed())
		{
				out.write(content);
		}
		else
		{
				out.write(brakesHtmlSanitizerPolicyProvider.defaultPolicy().sanitize(content));
		}
		out.write("</div>");
	}

	@Override
	protected boolean isUnsafeJavaScriptAllowed() {
		return super.isUnsafeJavaScriptAllowed() || Config.getBoolean(CUSTOM_UNSAFE_JAVASCRIPT_OWSPA_ALLOWED, false);
	}

	public void setBrakesHtmlSanitizerPolicyProvider(BrakesHtmlSanitizerPolicyProvider brakesHtmlSanitizerPolicyProvider) {
		this.brakesHtmlSanitizerPolicyProvider = brakesHtmlSanitizerPolicyProvider;
	}
}