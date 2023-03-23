package com.envoydigital.brakes.storefront.forms.validation;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.storefront.forms.RegisterForm;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import java.util.regex.Matcher;

@Component("brakesRegCompanyDetailsValidator")
public class BrakesRegCompanyDetailsValidator implements Validator {

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
                    || BrakesCoreConstants.companyTypes.PVT_LTD_COMPANY.equals(registerForm.getCompanyType())
                    || BrakesCoreConstants.companyTypes.PUBLIC_LTD_COMPANY.equals(registerForm.getCompanyType()))
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
}
