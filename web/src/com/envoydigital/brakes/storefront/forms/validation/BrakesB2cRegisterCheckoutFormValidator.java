package com.envoydigital.brakes.storefront.forms.validation;

import com.envoydigital.brakes.storefront.forms.BrakesB2cRegisterForm;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

@Component("brakesB2cRegisterCheckoutFormValidator")
public class BrakesB2cRegisterCheckoutFormValidator implements Validator {

    @Override
    public boolean supports(final Class<?> aClass) {
        return BrakesB2cRegisterForm.class.equals(aClass);
    }


    @Override
    public void validate(final Object object, final Errors errors) {

        final BrakesB2cRegisterForm brakesB2cRegisterForm = (BrakesB2cRegisterForm) object;

        if (StringUtils.isBlank(brakesB2cRegisterForm.getFirstName()))
        {
            errors.rejectValue("firstName", "register.popup.firstName");
        }

        if (StringUtils.isBlank(brakesB2cRegisterForm.getLastName()))
        {
            errors.rejectValue("lastName", "register.popup.lastName");
        }

        if (StringUtils.isBlank(brakesB2cRegisterForm.getPhone()))
        {
            errors.rejectValue("phone", "register.popup.phone");
        }

        if (StringUtils.isBlank(brakesB2cRegisterForm.getCounty()))
        {
            errors.rejectValue("county", "register.popup.county");
        }

        if (StringUtils.isBlank(brakesB2cRegisterForm.getAddressLine1()))
        {
            errors.rejectValue("addressLine1", "register.popup.addressLine1");
        }

        if (StringUtils.isBlank(brakesB2cRegisterForm.getTown()))
        {
            errors.rejectValue("town", "register.popup.town");
        }

        if (StringUtils.isBlank(brakesB2cRegisterForm.getPostcode()))
        {
            errors.rejectValue("postcode", "register.popup.postcode");
        }

        if (null == brakesB2cRegisterForm.getVehicleRestriction())
        {
            errors.rejectValue("vehicleRestriction", "register.popup.vehicleRestriction");
        }

        if (null == brakesB2cRegisterForm.getLargeVehicleParking())
        {
            errors.rejectValue("largeVehicleParking", "register.popup.largeVehicleParking");
        }

        if (null == brakesB2cRegisterForm.getDistanceFromCarParking())
        {
            errors.rejectValue("distanceFromCarParking", "register.popup.distanceFromCarParking");
        }
    }
}
