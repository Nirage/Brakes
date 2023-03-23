/**
 *
 */
package com.envoydigital.brakes.storefront.util;

import de.hybris.platform.store.services.BaseStoreService;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


/**
 * @author Sridhar
 *
 */
public class BrakesOrderDeadLockUtils
{
	private static final String ORDER_IDS = "orderIds";
	private static final String STORE_ID = "storeId";

	@Resource(name = "baseStoreService")
	private BaseStoreService baseStoreService;

	public void addOrderIDToSession(final HttpServletRequest request, final String orderCode)
	{
		final HttpSession session = request.getSession();
		final List<String> orderIds = new ArrayList<>();
		if (null != session.getAttribute(ORDER_IDS))
		{
			orderIds.addAll((Collection<? extends String>) session.getAttribute(ORDER_IDS));
			if (!orderIds.contains(orderCode))
			{
				orderIds.add(orderCode);
			}
		}
		else
		{
			orderIds.add(orderCode);
		}
		session.setAttribute(ORDER_IDS, orderIds);
		session.setAttribute(STORE_ID, baseStoreService.getCurrentBaseStore().getUid());
	}
}
