package com.envoydigital.brakes.storefront.forms.validation;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.storefront.forms.RegisterForm;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import java.util.regex.Matcher;

@Component("brakesRegisterRetargetFormValidator")
public class BrakesRegisterRetargetFormValidator implements Validator {

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

        if(!Boolean.TRUE.equals(registerForm.getMarketingPreference())) {
            errors.rejectValue("marketingPreference", "error.invalid.marketingPreference");
        }
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

    private boolean validateEmailAddress(final String email)
    {
        final Matcher matcher = BrakesCoreConstants.EMAIL_REGEX.matcher(email);
        return matcher.matches();
    }

}
