/**
 *
 */
package com.envoydigital.brakes.storefront.forms.validation;



import de.hybris.platform.commercefacades.user.data.CompanyData;

import java.util.List;
import java.util.regex.Matcher;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.facades.BrakesCompanyFacade;
import com.envoydigital.brakes.facades.site.BrakesSiteFacade;
import com.envoydigital.brakes.facades.store.BrakesBaseStoreFacade;
import com.envoydigital.brakes.storefront.forms.RegisterForm;



/**
 * @author Lakshmi
 *
 */
@Component("brakesRegistrationValidator")
public class RegistrationValidator implements Validator
{


	Logger LOG = LoggerFactory.getLogger(RegistrationValidator.class);


	@Resource(name = "brakesCompanyFacade")
	private BrakesCompanyFacade brakesCompanyFacade;

	@Resource
	private BrakesSiteFacade brakesSiteFacade;

	@Resource
	private BrakesBaseStoreFacade brakesBaseStoreFacade;

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
		if (StringUtils.isEmpty(registerForm.getTradingName()))
		{
			errors.rejectValue("tradingName", "error.empty.tradingName");
		}
		if (StringUtils.isEmpty(registerForm.getBudget()))
		{
			if(isRegistrationForBrakes()) {
				errors.rejectValue("budget", "error.empty.monthlySpend");
			}
		}
		if (StringUtils.isEmpty(registerForm.getSector()))
		{
			errors.rejectValue("sector", "error.empty.businessSector");
		}
		if (StringUtils.isNotEmpty(registerForm.getSector()))
		{
			final List<CompanyData> subSectors = brakesCompanyFacade.getSubSectors(registerForm.getSector());
			if (CollectionUtils.isNotEmpty(subSectors) && StringUtils.isEmpty(registerForm.getSubSector()))
			{
				errors.rejectValue("subSector", "error.empty.businessSubSector");
			}

		}
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

		if (StringUtils.isEmpty(registerForm.getPhoneNumber()))
		{
			errors.rejectValue("phoneNumber", "error.empty.phoneNumber");
		}

		final String titleCode = registerForm.getTitle();
		final String firstName = registerForm.getFirstName();
		final String lastName = registerForm.getLastName();
		final String email = registerForm.getEmail();
		final String mobileNumber = registerForm.getMobileNumber();
		final String postCode = registerForm.getPostCode();
		final String companyRegNumber = registerForm.getCompanyRegNumber();



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
		validateEmail(errors, email);
		validatePostcode(errors, postCode);
		validateMobileNumber(errors, mobileNumber);
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

		if(StringUtils.isNotEmpty(registerForm.getLeadSourceText()))
		{
			validateLeadInputText(errors, registerForm.getLeadSourceText(), "leadSourceText");
		}

		if(StringUtils.isNotEmpty(registerForm.getLeadReason()))
		{
			validateLeadInputText(errors, registerForm.getLeadReason(), "leadReason");
		}
		
		if(StringUtils.isNotEmpty(registerForm.getPreviousSupplier()))
		{
			validatePreviousSupplierText(errors, registerForm.getPreviousSupplier(), "previousSupplier");
		}

	}

	/**
	 * Validating the LeadInputText
	 *
	 * @param errors
	 * @param inputText
	 */
	private void validateLeadInputText(final Errors errors, final String inputText, final String field) {

		if(inputText.length() > 170) {

			errors.rejectValue(field, "error.leadSourceText.maxLength");

		}

		if(!BrakesCoreConstants.REGISTER_LEAD_TEXT_REGEX.matcher(inputText).matches()) {

			errors.rejectValue(field, "error.leadSourceText.onlyEnglish");
		}
	}
	
	/**
	 * Validating the LeadInputText
	 *
	 * @param errors
	 * @param inputText
	 */
	private void validatePreviousSupplierText(final Errors errors, final String inputText, final String field) {

		if(inputText.length() > 100) {

			errors.rejectValue(field, "error.maxChars.previousSupplier");

		}

		if(!BrakesCoreConstants.REGISTER_LEAD_TEXT_REGEX.matcher(inputText).matches()) {

			errors.rejectValue(field, "error.invalid.previousSupplier");
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

	protected void validateEmail(final Errors errors, final String email)
	{
		if (StringUtils.isEmpty(email))
		{
			errors.rejectValue("email", "error.empty.email");
		}
		else if (StringUtils.length(email) > 255 || !validateEmailAddress(email))
		{
			errors.rejectValue("email", "error.invalid.email");
		}
	}

	public boolean validateEmailAddress(final String email)
	{
		final Matcher matcher = BrakesCoreConstants.EMAIL_REGEX.matcher(email);
		return matcher.matches();
	}

	protected void validateName(final Errors errors, final String name, final String propertyName, final String property)
	{
		if (StringUtils.isBlank(name))
		{
			errors.rejectValue(propertyName, property);
		}
		else if (StringUtils.length(name) > 255)
		{
			errors.rejectValue(propertyName, property);
		}
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

	private boolean isRegistrationForBrakes() {
		return brakesSiteFacade.isBrakesSite() && brakesBaseStoreFacade.isCurrentStoreBrakes();
	}
}
