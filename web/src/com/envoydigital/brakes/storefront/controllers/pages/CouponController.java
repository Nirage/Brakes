package com.envoydigital.brakes.storefront.controllers.pages;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.acceleratorstorefrontcommons.forms.VoucherForm;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.envoydigital.brakes.facades.coupons.BrakesCouponFacade;
import com.envoydigital.brakes.facades.data.AddCouponResponseData;


/**
 * Controller for coupon related operations
 */
@Controller
@RequestMapping(value = "/coupon")
public class CouponController extends AbstractPageController
{

	@Resource(name = "voucherFacade")
	private BrakesCouponFacade brakesCouponFacade;

	@ResponseBody
	@RequestMapping(value = "/enable-coupon-account", method = RequestMethod.POST)
	@RequireHardLogIn
	public AddCouponResponseData addVoucherToAccount(@ModelAttribute("voucherForm")
	final VoucherForm voucherForm, final Model model)
	{
		return brakesCouponFacade.enableCouponForAccount(voucherForm.getVoucherCode());
	}
}
