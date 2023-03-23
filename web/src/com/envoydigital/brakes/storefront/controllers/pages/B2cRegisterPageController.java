package com.envoydigital.brakes.storefront.controllers.pages;

import com.envoydigital.brakes.facades.user.BrakesB2BCustomerFacade;
import com.envoydigital.brakes.storefront.forms.BrakesB2cRegisterForm;
import com.envoydigital.brakes.storefront.forms.validation.BrakesB2cRegisterCheckoutFormValidator;
import com.envoydigital.brakes.storefront.forms.validation.BrakesB2cRegisterFormValidator;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.acceleratorstorefrontcommons.security.AutoLoginStrategy;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.commercefacades.user.data.AddressData;
import de.hybris.platform.commercefacades.user.data.RegisterData;
import de.hybris.platform.servicelayer.session.SessionService;
import org.apache.log4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping(value = "/b2c-register")
public class B2cRegisterPageController extends AbstractPageController {

    private static final String FORM_GLOBAL_ERROR = "form.global.error";

    public static final String REDIRECT_TO_HOME = REDIRECT_PREFIX + "/";

    private static final Logger LOG = Logger.getLogger(B2cRegisterPageController.class);


    @Resource(name = "autoLoginStrategy")
    private AutoLoginStrategy autoLoginStrategy;

    @Resource(name = "b2bCustomerFacade")
    BrakesB2BCustomerFacade brakesB2BCustomerFacade;

    @Resource(name = "sessionService")
    SessionService sessionService;

    @Resource(name = "brakesB2cRegisterFormValidator")
    private BrakesB2cRegisterFormValidator brakesB2cRegisterFormValidator;

    @Resource(name = "brakesB2cRegisterCheckoutFormValidator")
    private BrakesB2cRegisterCheckoutFormValidator brakesB2cRegisterCheckoutFormValidator;

    @RequestMapping(method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<List<ObjectError>> b2cRegisterFormSubmit(final Model model, @ModelAttribute("brakesB2cRegisterForm")
    final BrakesB2cRegisterForm brakesB2cRegisterForm, final BindingResult bindingResult, final HttpServletRequest request,
                                                                   final HttpServletResponse response) throws CMSItemNotFoundException
    {
        brakesB2cRegisterFormValidator.validate(brakesB2cRegisterForm, bindingResult);
        if (bindingResult.hasErrors())
        {
            List<ObjectError> errors = bindingResult.getAllErrors();
            return new ResponseEntity(errors, HttpStatus.INTERNAL_SERVER_ERROR);
        }

        try
        {
            final RegisterData data = new RegisterData();
            data.setEmail(brakesB2cRegisterForm.getEmail());
            data.setPassword(brakesB2cRegisterForm.getPassword());
            data.setB2cUnit(brakesB2cRegisterForm.getB2cUnit());
            data.setLogin(brakesB2cRegisterForm.getEmail());

            final String userName = brakesB2BCustomerFacade.registerB2cUser(data);
            autoLoginStrategy.login(userName, data.getPassword(), request, response);
        }
        catch (final Exception e)
        {
            LOG.error("exception while auto login" + e);
            return new ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR);

        }

       return new ResponseEntity(HttpStatus.OK);
    }

    @RequestMapping(value = "/email-exists", method = RequestMethod.GET , produces = "application/json")
    @ResponseBody
    public ResponseEntity<Boolean> emailExists(@RequestParam(value = "email", required = true) final String email) {

        return new ResponseEntity(brakesB2BCustomerFacade.userExist(email), HttpStatus.OK);
    }


    @RequestMapping(value = "/checkout-update-details", method = RequestMethod.POST)
    @RequireHardLogIn
    public String b2cRegisterCheckoutFormSubmit(final Model model, @ModelAttribute("brakesB2cRegisterForm")
    final BrakesB2cRegisterForm brakesB2cRegisterForm, final BindingResult bindingResult, final HttpServletRequest request,
                                                final HttpServletResponse response) throws CMSItemNotFoundException
    {
        brakesB2cRegisterCheckoutFormValidator.validate(brakesB2cRegisterForm, bindingResult);
        if (bindingResult.hasErrors())
        {
            GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
            return REDIRECT_PREFIX + "/cart";
        }

        try
        {
            final RegisterData data = new RegisterData();
            data.setFirstName(brakesB2cRegisterForm.getFirstName());
            data.setLastName(brakesB2cRegisterForm.getLastName());
            data.setMobileNumber(brakesB2cRegisterForm.getPhone());
            data.setTitleCode(brakesB2cRegisterForm.getTitle());
            brakesB2BCustomerFacade.checkoutUpdateB2cUser(data);

            final AddressData addressData = new AddressData();
            addressData.setShippingAddress(Boolean.TRUE);
            addressData.setVisibleInAddressBook(Boolean.TRUE);
            addressData.setFirstName(brakesB2cRegisterForm.getFirstName());
            addressData.setLastName(brakesB2cRegisterForm.getLastName());
            addressData.setCellphone(brakesB2cRegisterForm.getPhone());
            addressData.setCounty(brakesB2cRegisterForm.getCounty());
            addressData.setLine1(brakesB2cRegisterForm.getAddressLine1());
            addressData.setLine2(brakesB2cRegisterForm.getAddressLine2());
            addressData.setTown(brakesB2cRegisterForm.getTown());
            addressData.setPostalCode(brakesB2cRegisterForm.getPostcode());
            addressData.setGroundFloor(brakesB2cRegisterForm.getGroundFloor());
            addressData.setVehicleRestriction(brakesB2cRegisterForm.getVehicleRestriction());
            addressData.setLargeVehicleParking(brakesB2cRegisterForm.getLargeVehicleParking());
            addressData.setDistanceFromCarParking(brakesB2cRegisterForm.getDistanceFromCarParking());
            addressData.setCommunalDoorCode(brakesB2cRegisterForm.getCommunalDoorCode());
            addressData.setLine3(brakesB2cRegisterForm.getAddressLine3());
            brakesB2BCustomerFacade.addAddressToLoggedInCustomerAndCart(addressData);
        }
        catch (final Exception e)
        {
            LOG.error("exception while updating details of b2c user on checkout" + e);
            GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
            return REDIRECT_PREFIX + "/cart";

        }

        return REDIRECT_PREFIX + "/checkout";
    }
}
