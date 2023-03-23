/**
 *
 */
package com.envoydigital.brakes.storefront.forms.validation;

import de.hybris.platform.b2bacceleratorfacades.customer.exception.InvalidPasswordException;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.envoydigital.brakes.facades.user.BrakesB2BCustomerFacade;
import com.envoydigital.brakes.storefront.forms.BrakesUpdatePwdForm;


/**
 * @author Haridaskpillai
 *
 */
@Component("brakesUpdatePasswordFormValidator")
public class BrakesUpdatePasswordFormValidator implements Validator
{

	@Resource(name = "b2bCustomerFacade")
	private BrakesB2BCustomerFacade brakesB2BCustomerFacade;

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.springframework.validation.Validator#supports(java.lang.Class)
	 */
	@Override
	public boolean supports(final Class<?> aClass)
	{
		return BrakesUpdatePwdForm.class.equals(aClass);
	}

	@Override
	public void validate(final Object object, final Errors errors)
	{
		final BrakesUpdatePwdForm updatePasswordForm = (BrakesUpdatePwdForm) object;
		final String newPassword = updatePasswordForm.getPwd();

		if (StringUtils.isEmpty(newPassword))
		{
			errors.rejectValue("pwd", "reset.pwd.invalid");
		}
		else
		{

			try
			{
				brakesB2BCustomerFacade.validatePassword(newPassword);
			}
			catch (final InvalidPasswordException ex)
			{
				errors.rejectValue("pwd", "reset.pwd.invalid");
			}
		}

	}

}
