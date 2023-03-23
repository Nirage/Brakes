package com.envoydigital.brakes.storefront.forms.validation;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.core.services.BrakesNectarAccountService;
import com.envoydigital.brakes.storefront.forms.CollectNectarBonusForm;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import javax.annotation.Resource;
import java.util.regex.Matcher;

@Component("brakesNectarCollectBonusValidator")
public class BrakesNectarCollectBonusValidator implements Validator {

    @Resource(name = "brakesNectarAccountService")
    private BrakesNectarAccountService brakesNectarAccountService;

    @Override
    public boolean supports(Class<?> aClass) {

        return CollectNectarBonusForm.class.equals(aClass);
    }

    @Override
    public void validate(Object object, Errors errors) {

        final CollectNectarBonusForm collectNectarBonusForm = (CollectNectarBonusForm) object;

        if (StringUtils.isEmpty(collectNectarBonusForm.getTitle()))
        {
            errors.rejectValue("title", "error.empty.title");
        }
        if (StringUtils.isEmpty(collectNectarBonusForm.getFirstName()))
        {
            errors.rejectValue("firstName", "error.empty.firstName");
        }
        if (StringUtils.isEmpty(collectNectarBonusForm.getLastName()))
        {
            errors.rejectValue("lastName", "error.empty.lastName");
        }
        if (StringUtils.isEmpty(collectNectarBonusForm.getEmail()))
        {
            errors.rejectValue("email", "error.empty.email");

        }else if(StringUtils.isNotEmpty(collectNectarBonusForm.getEmail()) && !validateEmailAddress(collectNectarBonusForm.getEmail())) {

            errors.rejectValue("email", "error.invalid.email");
        }
        if (StringUtils.isEmpty(collectNectarBonusForm.getConfirmEmail()))
        {
            errors.rejectValue("confirmEmail", "error.empty.confirmEmail");
        }else if(StringUtils.isNotEmpty(collectNectarBonusForm.getConfirmEmail())
                && StringUtils.isNotEmpty(collectNectarBonusForm.getEmail())
                && !collectNectarBonusForm.getEmail().equals(collectNectarBonusForm.getConfirmEmail())) {

            errors.rejectValue("confirmEmail", "error.invalid.confirmEmail");
        }

        if(StringUtils.isEmpty(collectNectarBonusForm.getNectarCardNo())) {

            errors.rejectValue("nectarCardNo", "error.empty.nectarCardNo");
        }else if(StringUtils.isNotEmpty(collectNectarBonusForm.getNectarCardNo())
                 && !brakesNectarAccountService.validateNectarCardNumber(collectNectarBonusForm.getNectarCardNo())) {

            errors.rejectValue("nectarCardNo", "error.invalid.nectarCardNo");
        }
        if(StringUtils.isEmpty(collectNectarBonusForm.getOptInCode())) {

            errors.rejectValue("optInCode", "error.empty.optInCode");
        }

    }

    private boolean validateEmailAddress(final String email)
    {
        final Matcher matcher = BrakesCoreConstants.EMAIL_REGEX.matcher(email);
        return matcher.matches();
    }
}
