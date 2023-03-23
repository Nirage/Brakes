/**
 *
 */
package com.envoydigital.brakes.storefront.forms.validation;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.envoydigital.brakes.storefront.forms.TrainingModulesForm;


/**
 * @author Sathya.m
 *
 */
@Component("trainingModulesFormValidator")
public class TrainingModulesFormValidator implements Validator
{

	@Override
	public boolean supports(final Class<?> aClass)
	{
		return TrainingModulesForm.class.equals(aClass);
	}

	@Override
	public void validate(final Object object, final Errors errors)
	{
		final TrainingModulesForm trainingModulesForm = (TrainingModulesForm) object;
		final String firstName = trainingModulesForm.getFirstName();
		final String surname = trainingModulesForm.getSurname();

		if (StringUtils.length(firstName) + StringUtils.length(surname) > 255)
		{
			errors.rejectValue("surname", "error.empty.lastName");
			errors.rejectValue("firstName", "error.empty.firstName");
		}
		if (StringUtils.isEmpty(firstName))
		{
			errors.rejectValue("firstName", "error.empty.firstName");
		}
		if (StringUtils.isEmpty(surname))
		{
			errors.rejectValue("surname", "error.empty.lastName");
		}

	}

}
