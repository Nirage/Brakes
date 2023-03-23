package com.envoydigital.brakes.storefront.forms;

import java.util.List;

public class CollectNectarForm
{
    public static final String LEGAL_OWNER = "LEGAL_OWNER";
    public static final String AUTHORISED_SIGNATORY = "AUTHORISED_SIGNATORY";
    public static final String EMPLOYEE = "EMPLOYEE";

    private String nectarCardNo;
    private String businessName;
    private String addressLine1;
    private String addressLine2;
    private String town;
    private String county;
    private String postCode;
    private String deliveryPostCode;
    private String email;
    private String confirmEmail;
    private String phoneNumber;
    private String mobileNumber;
    private List<String> accountNumber;
    private List<String> accountType;
    private String title;
    private String firstName;
    private String lastName;
    private String ownersTitle;
    private String ownersFirstName;
    private String ownersLastName;
    private String relationType;
    private Boolean relationShipCheck;
    private Boolean termsCheck;

    public String getNectarCardNo() {
        return nectarCardNo;
    }

    public void setNectarCardNo(String nectarCardNo) {
        this.nectarCardNo = nectarCardNo;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getAddressLine1() {
        return addressLine1;
    }

    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }

    public String getAddressLine2() {
        return addressLine2;
    }

    public void setAddressLine2(String addressLine2) {
        this.addressLine2 = addressLine2;
    }

    public String getTown() {
        return town;
    }

    public void setTown(String town) {
        this.town = town;
    }

    public String getPostCode() {
        return postCode;
    }

    public void setPostCode(String postCode) {
        this.postCode = postCode;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getConfirmEmail() {
        return confirmEmail;
    }

    public void setConfirmEmail(String confirmEmail) {
        this.confirmEmail = confirmEmail;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public List<String> getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(List<String> accountNumber) {
        this.accountNumber = accountNumber;
    }

    public List<String> getAccountType() {
        return accountType;
    }

    public void setAccountType(List<String> accountType) {
        this.accountType = accountType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getOwnersTitle() {
        return ownersTitle;
    }

    public void setOwnersTitle(String ownersTitle) {
        this.ownersTitle = ownersTitle;
    }

    public String getOwnersFirstName() {
        return ownersFirstName;
    }

    public void setOwnersFirstName(String ownersFirstName) {
        this.ownersFirstName = ownersFirstName;
    }

    public String getOwnersLastName() {
        return ownersLastName;
    }

    public void setOwnersLastName(String ownersLastName) {
        this.ownersLastName = ownersLastName;
    }

    public String getRelationType() {
        return relationType;
    }

    public void setRelationType(String relationType) {
        this.relationType = relationType;
    }

    public boolean isLegalOwner() {
        return LEGAL_OWNER.equals(relationType);
    }

    public boolean isAuthorizedSignatory() {
        return AUTHORISED_SIGNATORY.equals(relationType);
    }

    public boolean isEmployee() {
        return EMPLOYEE.equals(relationType);
    }

    public Boolean getRelationShipCheck() {
        return relationShipCheck;
    }

    public void setRelationShipCheck(Boolean relationShipCheck) {
        this.relationShipCheck = relationShipCheck;
    }

    public Boolean getTermsCheck() {
        return termsCheck;
    }

    public void setTermsCheck(Boolean termsCheck) {
        this.termsCheck = termsCheck;
    }

    public String getCounty() {
        return county;
    }

    public void setCounty(String county) {
        this.county = county;
    }

    public String getDeliveryPostCode() {
        return deliveryPostCode;
    }

    public void setDeliveryPostCode(String deliveryPostCode) {
        this.deliveryPostCode = deliveryPostCode;
    }
}
