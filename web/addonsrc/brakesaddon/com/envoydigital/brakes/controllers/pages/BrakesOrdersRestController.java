package com.envoydigital.brakes.controllers.pages;


import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.commercefacades.order.OrderFacade;
import de.hybris.platform.commercefacades.order.data.OrderData;

import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * @author roberto.lanuti
 *
 */
@RestController
@RequestMapping("/orders")
public class BrakesOrdersRestController extends AbstractPageController
{

	@Resource(name = "orderFacade")
	private OrderFacade orderFacade;

	@RequireHardLogIn
	@GetMapping(value = "/{orderCode}/status", produces = MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity getOrderStatus(@PathVariable final String orderCode)
	{
		try {
			final OrderData orderData = orderFacade.getOrderDetailsForCode(orderCode);
			return orderData != null && orderData.getStatus() != null ? ResponseEntity.ok(orderData.getStatus().getCode()) : new ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR);
		} catch (UnknownIdentifierException exception) {
			return new ResponseEntity(HttpStatus.NOT_FOUND);
		} catch (Exception exception) {
			return new ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

}