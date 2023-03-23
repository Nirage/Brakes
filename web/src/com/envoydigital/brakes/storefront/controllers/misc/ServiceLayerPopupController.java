/**
 *
 */
package com.envoydigital.brakes.storefront.controllers.misc;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.acceleratorstorefrontcommons.forms.LoginForm;
import de.hybris.platform.commercefacades.user.UserFacade;
import de.hybris.platform.commercefacades.user.data.TitleData;

import java.util.Collection;

import javax.annotation.Resource;

import de.hybris.platform.servicelayer.user.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.envoydigital.brakes.facades.guestcheckout.RegisterCheckoutFacade;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.BrakesB2cRegisterForm;
import com.envoydigital.brakes.storefront.forms.ForgotpasswordForm;


/**
 * @author himansu.durgapal
 *
 */
@Controller
public class ServiceLayerPopupController extends AbstractController
{

	@Resource(name = "registerCheckoutFacade")
	private RegisterCheckoutFacade registerCheckoutFacade;

	@Resource(name = "userFacade")
	private UserFacade userFacade;

	@Resource(name = "userService")
	private UserService userService;

	@ModelAttribute("titles")
	public Collection<TitleData> getTitles()
	{
		return userFacade.getTitles();
	}

	/**
	 * This method will return the html code for guest checkout popup, returns empty string if customer is logged in or
	 * using B2B site
	 *
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/register-checkout/popup", method = RequestMethod.GET)
	public String getServiceLayerPopupData(final Model model)
	{
		//check if customer logged in or using B2b site

		if (!registerCheckoutFacade.showRegisterCheckoutPopup())
		{
			model.addAttribute("showpopup", Boolean.FALSE);
			return ControllerConstants.Views.Fragments.B2cPopup.RegisterCheckoutPopup;
		}

		model.addAttribute("brakesB2cRegisterForm", new BrakesB2cRegisterForm());
		final LoginForm loginForm = new LoginForm();
		model.addAttribute(loginForm);

		final ForgotpasswordForm forgotPasswordForm = new ForgotpasswordForm();
		model.addAttribute(forgotPasswordForm);


		//Get the B2b unitss
		model.addAttribute("b2cUnits", registerCheckoutFacade.getAvailableB2CUnits());
		return ControllerConstants.Views.Fragments.B2cPopup.RegisterCheckoutPopup;
	}

	@RequestMapping(value = "/b2c-checkout-add-details/popup", method = RequestMethod.GET)
	public String getServiceLayerCheckoutDetailsPopupData(final Model model)
	{

		if (!registerCheckoutFacade.showFinishSignUpCheckoutPopup())
		{
			model.addAttribute("showpopup", Boolean.FALSE);
			return ControllerConstants.Views.Fragments.B2cPopup.B2cCheckoutDetailsPopup;
		}

		model.addAttribute("userId", userService.getCurrentUser().getUid());
		model.addAttribute("brakesB2cRegisterForm", new BrakesB2cRegisterForm());
		return ControllerConstants.Views.Fragments.B2cPopup.B2cCheckoutDetailsPopup;
	}

}
