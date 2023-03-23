package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractCheckoutController;

import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.envoydigital.brakes.facades.payment.BrakesPaymentFacade;
import com.envoydigital.brakes.payment.callback.PayPageNotificationService;


/**
 * This controller handle the Paypage POST callback.
 *
 * @author himansu.durgapal
 *
 */
@Controller
@RequestMapping(value = "/paypage")
public class BrakesPaymentCallBackController extends AbstractCheckoutController
{
	private static final org.slf4j.Logger LOG = LoggerFactory.getLogger(BrakesPaymentCallBackController.class);

	@Resource(name = "payPageNotificationService")
	private PayPageNotificationService payPageNotificationService;

	@Resource(name = "brakesPaymentFacade")
	private BrakesPaymentFacade brakesPaymentFacade;

	@RequestMapping(value = "/merchant_callback", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity handleResponseURLPOST(final RedirectAttributes redirectModel, final Model model,
			final HttpServletRequest request) throws IOException
	{
		LOG.info("Request map -  {}", request.getParameterMap());
		payPageNotificationService.handlePostCallBack(request.getParameterMap());
		return new ResponseEntity(HttpStatus.OK);
	}


	@RequestMapping(value = "/addcard_merchant_callback", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity handleResponseAddCardURLPOST(final RedirectAttributes redirectModel, final Model model,
			final HttpServletRequest request) throws IOException
	{
		LOG.info("Callback Request map -  {}", request.getParameterMap());
		brakesPaymentFacade.createPaymentInfo(request.getParameterMap());
		return new ResponseEntity(HttpStatus.OK);
	}
}
