/**
 *
 */
package com.envoydigital.brakes.storefront.renderer;

import de.hybris.platform.util.Config;
import org.owasp.html.HtmlPolicyBuilder;
import org.owasp.html.PolicyFactory;
import org.owasp.html.Sanitizers;

import javax.annotation.PostConstruct;

/**
 * It has been reimplemented just for accommodate the possibility of using css attribute within div tag in the content.
 * The implementation, however, is perfectly reflecting the OOB one (please see the original one in the cmsaccellerator).
 *
 * The risk of relaxing the original CSS constraint would be the following:
 *
 * - The ability to reuse trusted classes. If user-controlled CLASS="..." attributes are permitted in HTML syntax, the
 *   attacker may have luck "borrowing" a class used to render elements of the trusted UI and impersonate them.
 *
 * Please note The original HtmlSanitizerPolicyProvider (was acting with static methods) has been transformed in a bean.
 */
public class BrakesHtmlSanitizerPolicyProvider
{
	private static final String KPS_TAG_EXCEPTION_LIST = "cms.components.kpsTagExceptionList";

	// Custom Policy that has been created in order keep the current Brakes CMS content
	protected PolicyFactory DEFAULT_POLICY;

	@PostConstruct
	public void init() {
		final String[] tagListArrayParam = Config.getString(KPS_TAG_EXCEPTION_LIST, "div").split(",");
		DEFAULT_POLICY = new HtmlPolicyBuilder()
				.allowElements("pre", "address", "em", "hr", "a")
				.allowElements(tagListArrayParam) /* This this the new piece */
				.allowAttributes("class").onElements("em")
				.allowAttributes("class", "target").onElements("a")
				.allowAttributes("class").onElements(tagListArrayParam) /* This this the new piece */
				.toFactory()
				.and(Sanitizers.IMAGES) /* This this the new piece */
				.and(Sanitizers.BLOCKS)
				.and(Sanitizers.FORMATTING)
				.and(Sanitizers.LINKS)
				.and(Sanitizers.TABLES)
				.and(Sanitizers.STYLES);
	}

	public PolicyFactory defaultPolicy() {
		if (DEFAULT_POLICY == null) {
			throw new RuntimeException("Tenant not Ready: please contact the administrator.");
		}
		return DEFAULT_POLICY;
	}
}