package com.envoydigital.brakes.storefront.controllers.pages;

import com.envoydigital.brakes.facades.data.PaymentCardStatus;
import com.envoydigital.brakes.facades.order.data.CardStatusWrapperData;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commercefacades.order.data.CCPaymentInfoData;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.envoydigital.brakes.facades.BrakesB2BCheckoutFacade;
import com.envoydigital.brakes.facades.b2c.checkout.BrakesPayPageCheckoutFacade;
import com.envoydigital.brakes.facades.constants.BrakesFacadesConstants;
import com.envoydigital.brakes.facades.payment.BrakesPaymentFacade;
import com.envoydigital.brakes.payment.constants.BrakespaymentcoreConstants;
import com.envoydigital.brakes.payment.exception.PayPageClientException;
import com.envoydigital.brakes.storefront.forms.PaymentForm;


/**
 * Controller for payment page
 */
@Controller
@RequestMapping(value = "/payment")
public class BrakesPaymentController extends AbstractPageController
{
	private static final Logger LOG = LoggerFactory.getLogger(BrakesPaymentController.class);
	protected static final String MY_DETAILS_CC_URL = "/my-account/my-details";
	protected static final String MY_DETAILS_BRAKES_URL = "/Mybrakes-myaccount";
	protected static final String SELECTED_ACCOUNT = "selectedAccount";

	@Resource(name = "brakesPaymentFacade")
	private BrakesPaymentFacade brakesPaymentFacade;

	@Resource(name = "brakesPayPageCheckoutFacade")
	private BrakesPayPageCheckoutFacade brakesPayPageCheckoutFacade;

	@Resource(name = "b2bCheckoutFacade")
	private BrakesB2BCheckoutFacade brakesB2BCheckoutFacade;

	@RequestMapping(value = "/add-card-iframe", method = RequestMethod.POST)
	@RequireHardLogIn
	@ResponseBody
	public String getIFrameURLReal(@ModelAttribute("paymentForm")
	final PaymentForm paymentForm, final Model model) throws CMSItemNotFoundException
	{
		String token = null;
		try
		{
			token = brakesPaymentFacade.getPaymentToken(paymentForm.getSelectedAccount(), paymentForm.getAddToAllAccount());
		}
		catch (final PayPageClientException e)
		{
			LOG.error("Exception while generating token ", e.getMessage());
			return null;
		}
		return brakesPayPageCheckoutFacade.getPaymentURL(token);
	}

	@RequestMapping(value = "/add-card", method = RequestMethod.GET)
	@RequireHardLogIn
	public String paymentResponse(final RedirectAttributes redirectModel, final Model model, final HttpServletRequest request)
			throws CMSItemNotFoundException
	{
		final Map<String, String[]> requestMap = request.getParameterMap();
		LOG.info("Request map on add card response {}", requestMap);
		final String token = null;

		final String resultCode = brakesPaymentFacade.getResultCode(requestMap);
		if (StringUtils.isNotEmpty(resultCode) && resultCode.equals(BrakespaymentcoreConstants.PAYPAGE_SUCCESS_RESULT_CODE))
		{
			brakesB2BCheckoutFacade.removePaymentInfo();

			if (isAddToAllAccount(requestMap)) {
				redirectModel.addFlashAttribute("addToAllAccount", true);
			}
			redirectModel.addFlashAttribute("isCardAdded", true);
		}
		else
		{
			//Transaction failed show error message
			final String errorMessageCode = brakesPayPageCheckoutFacade.getErrorCode(requestMap);
			if (StringUtils.isNotEmpty(resultCode) && resultCode.equals(BrakespaymentcoreConstants.PAYPAGE_USER_CANCEL_RESULT_CODE))
			{
				LOG.error("Transaction aborted by user", errorMessageCode);
			}
			else
			{
				LOG.error("Transaction is not succesful:error message {}", errorMessageCode);
				redirectModel.addFlashAttribute("showIframeErrorMessage", true);
			}
		}
		if (requestMap != null && !requestMap.isEmpty())
		{
			redirectModel.addFlashAttribute("selectedAccount", requestMap.get(BrakespaymentcoreConstants.Reference)[0]);
		}
		if(getSiteUid().equalsIgnoreCase(BrakesFacadesConstants.SITE_BRAKES)) 
		{
			return REDIRECT_PREFIX + MY_DETAILS_BRAKES_URL;
		}
		return REDIRECT_PREFIX + MY_DETAILS_CC_URL;
	}

	private boolean isAddToAllAccount(Map<String, String[]> requestMap) {
		final String[] contextData = requestMap.get(BrakespaymentcoreConstants.ContextData);
		final String contextDataString = (contextData != null && contextData.length > 0) ? contextData[0] : StringUtils.EMPTY;
		final List<String> contextDataList = new ArrayList<>(
				Arrays.asList(contextDataString.split("\\" + BrakespaymentcoreConstants.DATA_SEPERATOR)));
		return contextDataList.size() == 2 && BrakespaymentcoreConstants.TRUE_STR.equals(contextDataList.get(1));
	}

	@ResponseBody
	@RequestMapping(value = "/get-payment-info", method = RequestMethod.GET)
	@RequireHardLogIn
	public CardStatusWrapperData getPaymentInfo(@RequestParam(value = "accountId", required = true)
	final String accountId)
	{
		CardStatusWrapperData cardStatusWrapperData = new CardStatusWrapperData();
		cardStatusWrapperData.setPaymentInfo(brakesPaymentFacade.getPaymentInfoForAccount(accountId));
		PaymentCardStatus paymentCardStatus = brakesPaymentFacade.getPaymentCardStatusForAccount(accountId);
		if(null != paymentCardStatus) {
			cardStatusWrapperData.setB2BCardStatus(paymentCardStatus.toString());
		}

		return cardStatusWrapperData;
	}

}
