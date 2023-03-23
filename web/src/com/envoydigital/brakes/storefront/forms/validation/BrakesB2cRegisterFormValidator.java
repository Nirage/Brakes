package com.envoydigital.brakes.storefront.forms.validation;

import com.envoydigital.brakes.facades.user.BrakesB2BCustomerFacade;
import de.hybris.platform.b2bacceleratorfacades.customer.exception.InvalidPasswordException;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.envoydigital.brakes.storefront.forms.BrakesB2cRegisterForm;

import javax.annotation.Resource;


@Component("brakesB2cRegisterFormValidator")
public class BrakesB2cRegisterFormValidator implements Validator
{

	@Resource(name = "b2bCustomerFacade")
	private BrakesB2BCustomerFacade brakesB2BCustomerFacade;

	@Override
	public boolean supports(final Class<?> aClass)
	{
		return BrakesB2cRegisterForm.class.equals(aClass);
	}


	@Override
	public void validate(final Object object, final Errors errors)
	{
		final BrakesB2cRegisterForm brakesB2cRegisterForm = (BrakesB2cRegisterForm) object;

		if (StringUtils.isBlank(brakesB2cRegisterForm.getEmail()))
		{
			errors.rejectValue("email", "register.popup.email");
		}

		if (StringUtils.isBlank(brakesB2cRegisterForm.getB2cUnit()))
		{
			errors.rejectValue("b2cUnit", "register.popup.b2bunit");
		}

		if (StringUtils.isBlank(brakesB2cRegisterForm.getPassword()))
		{
			errors.rejectValue("password", "register.popup.password");
		}

		if (StringUtils.isBlank(brakesB2cRegisterForm.getConfirmPassword()))
		{
			errors.rejectValue("confirmPassword", "register.popup.confirmPassword");
		}

		if(StringUtils.isNotEmpty(brakesB2cRegisterForm.getPassword()) && StringUtils.isNotEmpty(brakesB2cRegisterForm.getConfirmPassword())
				&& !brakesB2cRegisterForm.getPassword().equals(brakesB2cRegisterForm.getConfirmPassword())) {

			errors.rejectValue("confirmPassword", "register.popup.passwords.not.matching");

		}else if(StringUtils.isNotEmpty(brakesB2cRegisterForm.getPassword()) && StringUtils.isNotEmpty(brakesB2cRegisterForm.getConfirmPassword())) {
			try
			{
				brakesB2BCustomerFacade.validatePassword(brakesB2cRegisterForm.getPassword());
			}
			catch (final InvalidPasswordException ex)
			{
				errors.rejectValue("password", "register.popup.password.invalid");
			}
		}

	}

}
