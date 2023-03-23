package com.envoydigital.brakes.storefront.populators;

import com.envoydigital.brakes.storefront.forms.RegisterForm;
import de.hybris.platform.commercefacades.user.data.RegisterData;
import de.hybris.platform.converters.Populator;
import de.hybris.platform.servicelayer.dto.converter.ConversionException;

import java.text.SimpleDateFormat;
import java.util.Date;

public class CustomerRegisterFormPopulator implements Populator<RegisterData, RegisterForm> {

    private static final String REG_FORM_DATE_FORMAT = "dd/mm/yyyy";

    @Override
    public void populate(RegisterData registerData, RegisterForm registerForm) throws ConversionException {
        registerForm.setFirstName(registerData.getFirstName());
        registerForm.setLastName(registerData.getLastName());
        registerForm.setTitle(registerData.getTitleCode());
        registerForm.setPk(registerData.getCustomerPk());
        registerForm.setEmail(registerData.getEmail());
        registerForm.setConfirmEmail(registerData.getEmail());
        registerForm.setMobileNumber(registerData.getMobileNumber());
        registerForm.setJobTitle(registerData.getJobTitle());
        registerForm.setTradingName(registerData.getTradingName());
        registerForm.setBudget(registerData.getBudget());
        registerForm.setSector(registerData.getSector());
        registerForm.setSubSector(registerData.getSubSector());
        registerForm.setDeliveryRestrictions(registerData.getDeliveryRestrictions());
        registerForm.setPostCode(registerData.getPostCode());
        registerForm.setLine1(registerData.getLine1());
        registerForm.setLine2(registerData.getLine2());
        registerForm.setLine3(registerData.getLine3());
        registerForm.setCity(registerData.getCity());
        registerForm.setCounty(registerData.getCounty());
        registerForm.setCompanyType(registerData.getCompanyType());
        registerForm.setCompanyRegNumber(registerData.getCompanyRegNumber());
        registerForm.setCompanyRegName(registerData.getCompanyRegName());
        registerForm.setPhoneNumber(registerData.getCompanyPhoneNumber());
        registerForm.setLegalOwner(registerData.isLegalOwner());
        registerForm.setBusinessGroup(registerData.isBusinessGroup());
        registerForm.setLegalOwnerName(registerData.getLegalOwnerName());
        registerForm.setBusinessGroupName(registerData.getBusinessGroupName());
        registerForm.setMarketingPreference(registerData.isMarketingPreference());
        registerForm.setLeadSource(registerData.getLeadSource());
        registerForm.setLeadSourceText(registerData.getLeadSourceText());
        registerForm.setLeadReason(registerData.getLeadReason());
        registerForm.setPreviousSupplier(registerData.getPreviousSupplier());
        registerForm.setStep(registerData.getStep());

        registerForm.setBusinessPostCode(registerData.getBusinessPostCode());
        registerForm.setBusinessLine1(registerData.getBusinessLine1());
        registerForm.setBusinessLine2(registerData.getBusinessLine2());
        registerForm.setBusinessLine3(registerData.getBusinessLine3());
        registerForm.setBusinessCity(registerData.getBusinessCity());
        registerForm.setBusinessCounty(registerData.getBusinessCounty());
        registerForm.setBusinessAddressDifferent(registerData.isBusinessAddressDifferent());
        registerForm.setBusinessTelephoneNumber(registerData.getBusinessTelephoneNumber());
        registerForm.setCurrentSupplier(registerData.getCurrentSupplier());
        registerForm.setCurrentSupplierComments(registerData.getCurrentSupplierComments());

        if(null != registerData.getDateEstablished()) {
            String establishedDate = new SimpleDateFormat(REG_FORM_DATE_FORMAT).format(registerData.getDateEstablished());
            registerForm.setDateEstablished(establishedDate);
        }
        if(null != registerData.getNumberOfFullTimeEmployees()) {
            registerForm.setNumberOfFullTimeEmployees(registerData.getNumberOfFullTimeEmployees().toString());
        }
        registerForm.setAnnualStoreTurnover(registerData.getAnnualStoreTurnover());
        registerForm.setTermsCheck(registerData.isTermsCheck());
        registerForm.setPrivacyPolicy(registerData.isPrivacyPolicy());
        registerForm.setHybrisLockedLead(registerData.isHybrisLockedLead());
    }
}
