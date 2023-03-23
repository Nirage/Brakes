package com.envoydigital.brakes.storefront.forms.validation;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.facades.BrakesCompanyFacade;
import com.envoydigital.brakes.facades.site.BrakesSiteFacade;
import com.envoydigital.brakes.facades.store.BrakesBaseStoreFacade;
import com.envoydigital.brakes.storefront.forms.RegisterForm;
import de.hybris.platform.commercefacades.user.data.CompanyData;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import javax.annotation.Resource;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.regex.Matcher;

@Component("brakesRegAboutYourBusinessValidator")
public class BrakesRegAboutYourBusinessValidator implements Validator {

    @Resource(name = "brakesCompanyFacade")
    private BrakesCompanyFacade brakesCompanyFacade;

    @Resource
    private BrakesSiteFacade brakesSiteFacade;

    @Resource
    private BrakesBaseStoreFacade brakesBaseStoreFacade;

    private static final String REG_FORM_DATE_ESTABLISHED_FORMAT = "dd-mm-yyyy";

    @Override
    public boolean supports(final Class<?> aClass)
    {
        return RegisterForm.class.equals(aClass);
    }

    @Override
    public void validate(final Object object, final Errors errors)
    {
        final RegisterForm registerForm = (RegisterForm) object;

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

        if(StringUtils.isNotEmpty(registerForm.getDateEstablished())) {

            try {
                new SimpleDateFormat(REG_FORM_DATE_ESTABLISHED_FORMAT).parse(registerForm.getDateEstablished());
            } catch (ParseException e) {
                errors.rejectValue("dateEstablished", "error.invalid.dateEstablished");
            }
        }

        if(StringUtils.isNotEmpty(registerForm.getNumberOfFullTimeEmployees())) {
            try {
                Long.parseLong(registerForm.getNumberOfFullTimeEmployees());
            } catch (NumberFormatException e) {
                errors.rejectValue("numberOfFullTimeEmployees", "error.invalid.numberOfFullTimeEmployees");
            }
        }

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

    private boolean isRegistrationForBrakes() {
        return brakesSiteFacade.isBrakesSite() && brakesBaseStoreFacade.isCurrentStoreBrakes();
    }
}
