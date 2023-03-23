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

@Component("brakesSFRegAboutYourBusinessValidator")
public class BrakesSFRegAboutYourBusinessValidator implements Validator {

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
            final List<CompanyData> subSectors = brakesCompanyFacade.getSFSubSectors(registerForm.getSector());
            if (CollectionUtils.isNotEmpty(subSectors) && StringUtils.isEmpty(registerForm.getSubSector()))
            {
                errors.rejectValue("subSector", "error.empty.businessSubSector");
            }

        }
    }

    private boolean isRegistrationForBrakes() {
        return brakesSiteFacade.isBrakesSite() && brakesBaseStoreFacade.isCurrentStoreBrakes();
    }
}
