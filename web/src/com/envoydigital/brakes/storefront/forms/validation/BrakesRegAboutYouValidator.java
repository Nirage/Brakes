package com.envoydigital.brakes.storefront.forms.validation;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.storefront.forms.RegisterForm;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import java.util.regex.Matcher;

@Component("brakesRegAboutYouValidator")
public class BrakesRegAboutYouValidator implements Validator {

    @Override
    public boolean supports(final Class<?> aClass)
    {
        return RegisterForm.class.equals(aClass);
    }

    @Override
    public void validate(final Object object, final Errors errors)
    {
        final RegisterForm registerForm = (RegisterForm) object;

        if (StringUtils.isEmpty(registerForm.getJobTitle()))
        {
            errors.rejectValue("jobTitle", "error.empty.jobTitle");
        }

        final String titleCode = registerForm.getTitle();
        final String firstName = registerForm.getFirstName();
        final String lastName = registerForm.getLastName();
        final String mobileNumber = registerForm.getMobileNumber();

        if (StringUtils.length(firstName) + StringUtils.length(lastName) > 255)
        {
            errors.rejectValue("lastName", "error.empty.lastName");
            errors.rejectValue("firstName", "error.empty.firstName");
        }
        if (StringUtils.isEmpty(firstName))
        {
            errors.rejectValue("firstName", "error.empty.firstName");
        }
        if (StringUtils.isEmpty(lastName))
        {
            errors.rejectValue("lastName", "error.empty.lastName");
        }
        validateTitleCode(errors, titleCode);
        validateMobileNumber(errors, mobileNumber);

    }

    protected void validateTitleCode(final Errors errors, final String titleCode)
    {
        if (StringUtils.isEmpty(titleCode))
        {
            errors.rejectValue("title", "error.empty.title");
        }
        else if (StringUtils.length(titleCode) > 255)
        {
            errors.rejectValue("title", "error.invalid.title");
        }
    }

    /**
     * @param errors
     * @param mobileNumber
     */
    private void validateMobileNumber(final Errors errors, final String mobileNumber)
    {
        if (StringUtils.isEmpty(mobileNumber) || (mobileNumber.length() > 11 && !validatemobileNumber(mobileNumber)))
        {
            errors.rejectValue("mobileNumber", "error.empty.phone");
        }
    }

    final boolean validatemobileNumber(final String mobileNumber)
    {
        final Matcher matcher = BrakesCoreConstants.MOBILE_NUMBER.matcher(mobileNumber);
        return matcher.matches();
    }
}
