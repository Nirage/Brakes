/**
 *
 */
package com.envoydigital.brakes.storefront.listener;

import de.hybris.platform.core.Registry;

import java.util.List;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;

import org.springframework.web.util.HttpSessionMutexListener;
import org.springframework.web.util.WebUtils;

import com.envoydigital.brakes.core.services.BrakesOrderDeadLockService;


/**
 * @author Sridhar
 *
 */
public class BrakesHttpSessionMutexListener extends HttpSessionMutexListener
{
	private static final String ORDER_IDS = "orderIds";
	private static final String STORE_ID = "storeId";

	@Override
	public void sessionDestroyed(final HttpSessionEvent event)
	{

		final HttpSession session = event.getSession();
		if (session != null)
		{
			if (null != session.getAttribute(ORDER_IDS) && null != session.getAttribute(STORE_ID))
			{
				unlockTheOrder(session);
			}

		}

		event.getSession().removeAttribute(WebUtils.SESSION_MUTEX_ATTRIBUTE);
	}

	void unlockTheOrder(final HttpSession session)
	{
		final BrakesOrderDeadLockService service = (BrakesOrderDeadLockService) Registry.getApplicationContext()
				.getBean("brakesOrderDeadLockService");
		final List<String> orderIds = (List<String>) session.getAttribute(ORDER_IDS);
		service.releasingOrderDeadLock(orderIds, session.getAttribute(STORE_ID).toString());
	}

}
