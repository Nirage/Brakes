package com.envoydigital.brakes.storefront.forms.validation;

import java.util.regex.Matcher;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.storefront.forms.EmailProductForm;


/**
 * @author Haridaskpillai
 *
 */
@Component("brakesEmailProductFormValidator")
public class BrakesEmailProductFormValidator implements Validator
{

	@Override
	public boolean supports(final Class<?> aClass)
	{
		return EmailProductForm.class.equals(aClass);
	}

	@Override
	public void validate(final Object object, final Errors errors)
	{
		final EmailProductForm emailProductForm = (EmailProductForm) object;

		if (StringUtils.isNotBlank(emailProductForm.getEmailAddress()))
		{
			validateEmail(errors, emailProductForm.getEmailAddress());
		}
		else
		{

			errors.rejectValue("emailAddress", "error.invalid.email");
		}

	}

	protected void validateEmail(final Errors errors, final String email)
	{
		if (StringUtils.isEmpty(email))
		{
			errors.rejectValue("emailAddress", "error.empty.email");
		}
		else if (StringUtils.length(email) > 255 || !validateEmailAddress(email))
		{
			errors.rejectValue("emailAddress", "error.invalid.email");
		}
	}

	public boolean validateEmailAddress(final String email)
	{
		final Matcher matcher = BrakesCoreConstants.EMAIL_REGEX.matcher(email);
		return matcher.matches();
	}

}
