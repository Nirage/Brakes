package com.envoydigital.brakes.storefront.forms.validation;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.storefront.forms.RegisterForm;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import java.util.regex.Matcher;

@Component("brakesSFRegCompanyDetailsValidator")
public class BrakesSFRegCompanyDetailsValidator implements Validator {

    private final static String EMAIL = "email";

    @Override
    public boolean supports(final Class<?> aClass)
    {
        return RegisterForm.class.equals(aClass);
    }

    @Override
    public void validate(final Object object, final Errors errors)
    {
        final RegisterForm registerForm = (RegisterForm) object;
        final String companyRegNumber = registerForm.getCompanyRegNumber();
        final String email = registerForm.getEmail();
        final String confirmEmail = registerForm.getConfirmEmail();
        final String landLineNumber = registerForm.getPhoneNumber();
        final String mobileNumber = registerForm.getMobileNumber();

        if (StringUtils.isEmpty(mobileNumber) && StringUtils.isEmpty(landLineNumber))
        {
            errors.rejectValue("mobileNumber", "error.empty.mobileNumber");
        }

        if(StringUtils.isNotEmpty(landLineNumber) && !validateLandLineNumber(landLineNumber)) {
            errors.rejectValue("phoneNumber", "error.invalid.phoneNumber");
        }

        if(StringUtils.isNotEmpty(mobileNumber) && !validateMobileNumber(mobileNumber)) {
           errors.rejectValue("mobileNumber", "error.invalid.mobileNumber");
        }

        if (StringUtils.isEmpty(registerForm.getTradingName()))
        {
            errors.rejectValue("tradingName", "error.empty.tradingName");
        }

        validatePostcode(errors, registerForm.getPostCode());

        if (StringUtils.isEmpty(registerForm.getLine1()))
        {
            errors.rejectValue("line1", "error.empty.line1");
        }
        if (StringUtils.isEmpty(registerForm.getCity()))
        {
            errors.rejectValue("city", "error.empty.town");
        }
        if (StringUtils.isEmpty(registerForm.getCounty()))
        {
            errors.rejectValue("county", "error.empty.county");
        }
        if(StringUtils.isEmpty(email)) {
            errors.rejectValue(EMAIL, "error.empty.email");
        }

        validateEmail(errors, email);

        if(StringUtils.isEmpty(confirmEmail)) {
            errors.rejectValue("confirmEmail", "error.empty.confirmEmail");
        }

        if(!StringUtils.isEmpty(email) && !StringUtils.isEmpty(confirmEmail)
          && !email.equals(confirmEmail)) {
            errors.rejectValue("confirmEmail", "error.invalid.confirmEmail");
        }

        if (StringUtils.isEmpty(registerForm.getCompanyType()))
        {
            errors.rejectValue("companyType", "error.empty.companyType");
        }
        else
        {
            if (BrakesCoreConstants.companyTypes.LLP.equals(registerForm.getCompanyType())
                    || BrakesCoreConstants.companyTypes.SFPVT_LTD_COMPANY.equals(registerForm.getCompanyType())
                    || BrakesCoreConstants.companyTypes.SFPUBLIC_LTD_COMPANY.equals(registerForm.getCompanyType()))
            {
                validateCompanyRegNumber(errors, companyRegNumber);
                if (StringUtils.isEmpty(registerForm.getCompanyRegName()))
                {
                    errors.rejectValue("companyRegName", "error.empty.companyRegName");
                }
            }
        }

        if (!registerForm.isLegalOwner())
        {
            if (StringUtils.isEmpty(registerForm.getLegalOwnerName()))
            {
                errors.rejectValue("legalOwnerName", "error.empty.legalOwnerName");
            }
        }
    }

    private void validateCompanyRegNumber(final Errors errors, final String companyRegNumber)
    {

        if (StringUtils.isNotEmpty(companyRegNumber) && !validateCompanyRegNumber(companyRegNumber))
        {
            errors.rejectValue("companyRegNumber", "error.invalid.companyRegNumber");
        }
        else if (StringUtils.isEmpty(companyRegNumber))
        {
            errors.rejectValue("companyRegNumber", "error.empty.companyRegNumber");
        }
    }

    public boolean validateCompanyRegNumber(final String companyRegNumber)
    {
        final Matcher matcher = BrakesCoreConstants.COMPANY_REG_NUMBER.matcher(companyRegNumber);
        return matcher.matches();

    }

    protected void validateEmail(final Errors errors, final String email)
    {
        if (StringUtils.isEmpty(email))
        {
            errors.rejectValue(EMAIL, "error.empty.email");
        }
        else if (StringUtils.length(email) > 255 || !validateEmailAddress(email))
        {
            errors.rejectValue(EMAIL, "error.invalid.email");
        }
    }

    public boolean validateEmailAddress(final String email)
    {
        final Matcher matcher = BrakesCoreConstants.EMAIL_REGEX.matcher(email);
        return matcher.matches();
    }

    /**
     * @param errors
     * @param postCode
     */
    private void validatePostcode(final Errors errors, final String postCode)
    {
        if (StringUtils.isEmpty(postCode) || !validatepostCode(postCode))
        {
            errors.rejectValue("postCode", "error.empty.deliveryPostcode");
        }
    }

    /**
     * @param postCode
     * @return
     */
    private boolean validatepostCode(final String postCode)
    {
        final Matcher matcher = BrakesCoreConstants.POSTCODE_REGEX.matcher(postCode);
        return matcher.matches();
    }

    private boolean validateLandLineNumber(final  String landLineNumber) {
        final Matcher matcher = BrakesCoreConstants.COMPANY_LAND_LINE_NO_REGEX.matcher(landLineNumber);
        return matcher.matches();
    }

    private boolean validateMobileNumber(final  String mobileNumber) {
       final Matcher matcher = BrakesCoreConstants.MOBILE_NO_REGEX.matcher(mobileNumber);
       return matcher.matches();
   }
}
