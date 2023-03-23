package com.envoydigital.brakes.storefront.forms.validation;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.core.services.BrakesNectarAccountService;
import com.envoydigital.brakes.facades.BrakesB2BUnitFacade;
import com.envoydigital.brakes.storefront.forms.CollectNectarForm;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import javax.annotation.Resource;
import java.util.regex.Matcher;

@Component("brakesNectarCollectValidator")
public class BrakesNectarCollectValidator implements Validator {

    @Resource(name = "brakesB2BUnitFacade")
    private BrakesB2BUnitFacade brakesB2BUnitFacade;

    @Resource(name = "brakesNectarAccountService")
    private BrakesNectarAccountService brakesNectarAccountService;

    @Override
    public boolean supports(Class<?> aClass) {

        return CollectNectarForm.class.equals(aClass);
    }

    @Override
    public void validate(Object object, Errors errors) {

        final CollectNectarForm collectNectarForm = (CollectNectarForm) object;
        if (StringUtils.isEmpty(collectNectarForm.getNectarCardNo()))
        {
            errors.rejectValue("nectarCardNo", "error.empty.nectarCardNo");
        }
        else if (StringUtils.isNotEmpty(collectNectarForm.getNectarCardNo()) && !brakesNectarAccountService.validateNectarCardNumber(collectNectarForm.getNectarCardNo()))
        {
            errors.rejectValue("nectarCardNo", "error.invalid.nectarCardNo");
        }
        else if(validateCardExists(collectNectarForm.getNectarCardNo())) {
            errors.rejectValue("nectarCardNo", "error.duplicate.nectarCardNo");
        }
        if(StringUtils.isEmpty(collectNectarForm.getBusinessName())) {

            errors.rejectValue("businessName", "error.empty.businessName");
        }
        if(StringUtils.isEmpty(collectNectarForm.getAddressLine1())) {

            errors.rejectValue("addressLine1", "error.empty.addressLine1");
        }
        if(StringUtils.isEmpty(collectNectarForm.getTown())) {

            errors.rejectValue("town", "error.empty.town");
        }
        if(StringUtils.isEmpty(collectNectarForm.getCounty())) {

            errors.rejectValue("county", "error.empty.county");
        }
        if(StringUtils.isEmpty(collectNectarForm.getPostCode())) {

            errors.rejectValue("postCode", "error.empty.postCode");
        }
        else if (StringUtils.isNotEmpty(collectNectarForm.getPostCode()) && !validatePostcode(collectNectarForm.getPostCode()))
        {
            errors.rejectValue("postCode", "error.invalid.postCode");
        }
        if (StringUtils.isEmpty(collectNectarForm.getEmail()))
        {
            errors.rejectValue("email", "error.empty.email");
        }
        else if (StringUtils.isNotEmpty(collectNectarForm.getEmail()) && !validateEmailAddress(collectNectarForm.getEmail()))
        {
            errors.rejectValue("email", "error.invalid.email");
        }
        if (StringUtils.isEmpty(collectNectarForm.getConfirmEmail()))
        {
            errors.rejectValue("confirmEmail", "error.empty.confirmEmail");

        }else if(StringUtils.isNotEmpty(collectNectarForm.getEmail()) && StringUtils.isNotEmpty(collectNectarForm.getConfirmEmail())
                && !collectNectarForm.getEmail().equals(collectNectarForm.getConfirmEmail()) ) {

            errors.rejectValue("confirmEmail", "error.invalid.confirmEmail");
        }

        if(CollectionUtils.isEmpty(collectNectarForm.getAccountNumber())) {

            errors.rejectValue("accountNumber", "error.empty.accountNumber");

        }else if(collectNectarForm.getAccountNumber().size() > 24) {

            errors.rejectValue("accountNumber", "error.max.accountNumber");

        } else {


            for (String accountNumber :collectNectarForm.getAccountNumber()) {

                if(StringUtils.isNotEmpty(accountNumber) && !validateAccount(accountNumber)) {

                    errors.rejectValue("accountNumber", "error.invalid.accountNumber");
                }
            }
        }

        if(CollectionUtils.isEmpty(collectNectarForm.getAccountType())) {

            errors.rejectValue("accountType", "error.empty.accountType");
        }
        if(!collectNectarForm.isEmployee() && !collectNectarForm.isAuthorizedSignatory() && !collectNectarForm.isLegalOwner()) {

            errors.rejectValue("employee", "error.empty.employee");
            errors.rejectValue("authorizedSignatory", "error.empty.authorizedSignatory");
            errors.rejectValue("legalOwner", "error.empty.legalOwner");
        }else if(collectNectarForm.isEmployee()) {

            if(StringUtils.isEmpty(collectNectarForm.getTitle())) {

                errors.rejectValue("title", "error.empty.title");
            }

            if(StringUtils.isEmpty(collectNectarForm.getFirstName())) {

                errors.rejectValue("firstName", "error.empty.firstName");
            }

            if(StringUtils.isEmpty(collectNectarForm.getLastName())) {

                errors.rejectValue("lastName", "error.empty.lastName");
            }

            if(StringUtils.isEmpty(collectNectarForm.getOwnersTitle())) {

                errors.rejectValue("ownersTitle", "error.empty.ownersTitle");
            }

            if(StringUtils.isEmpty(collectNectarForm.getOwnersFirstName())) {

                errors.rejectValue("ownersFirstName", "error.empty.ownersFirstName");
            }

            if(StringUtils.isEmpty(collectNectarForm.getOwnersLastName())) {

                errors.rejectValue("ownersLastName", "error.empty.ownersLastName");
            }
        }else if(collectNectarForm.isAuthorizedSignatory() || collectNectarForm.isLegalOwner()) {

            if(StringUtils.isEmpty(collectNectarForm.getTitle())) {

                errors.rejectValue("title", "error.empty.title");
            }

            if(StringUtils.isEmpty(collectNectarForm.getFirstName())) {

                errors.rejectValue("firstName", "error.empty.firstName");
            }

            if(StringUtils.isEmpty(collectNectarForm.getLastName())) {

                errors.rejectValue("lastName", "error.empty.lastName");
            }
        }
    }

    private boolean validatePostcode(final String postCode)
    {
        final Matcher matcher = BrakesCoreConstants.POSTCODE_REGEX.matcher(postCode);
        return matcher.matches();
    }

    public boolean validateEmailAddress(final String email)
    {
        final Matcher matcher = BrakesCoreConstants.EMAIL_REGEX.matcher(email);
        return matcher.matches();
    }

    public boolean validateAccount(final String accountNumber)
    {
        return brakesB2BUnitFacade.validateAccount(accountNumber);
    }

    public boolean validateCardExists(final String cardNumber)
    {
        return brakesNectarAccountService.checkNectarCardNumberExists(cardNumber);
    }
}
