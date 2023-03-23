/**
 *
 */
package com.envoydigital.brakes.storefront.forms;


/**
 * @author maheshroyal
 *
 */
public class RegisterForm
{
	private String title;
	private String firstName;
	private String lastName;
	private String email;
	private String confirmEmail;
	private String mobileNumber;
	private String businessTelephoneNumber;
	private String jobTitle;
	private String tradingName;
	private String budget;
	private String sector;
	private String subSector;
	private String deliveryRestrictions;
	private String postCode;
	private String line1;
	private String line2;
	private String line3;
	private String city;
	private String county;
	private String pk;

	private String businessPostCode;
	private String businessLine1;
	private String businessLine2;
	private String businessLine3;
	private String businessCity;
	private String businessCounty;
	private Boolean businessAddressDifferent;

	private String companyType;
	private String companyRegNumber;
	private String companyRegName;

	private String phoneNumber;
	private boolean businessGroup;
	private boolean legalOwner;
	private String businessGroupName;
	private String legalOwnerName;
	private Boolean marketingPreference;
	private Boolean termsCheck;
	private Boolean privacyPolicy;
	private String leadSource;
	private String leadSourceText;
	private String leadReason;
	private String step;
	private String dateEstablished;
	private String numberOfFullTimeEmployees;
	private String annualStoreTurnover;
	private String previousSupplier;
	private String currentSupplier;
	private String currentSupplierComments;
	private boolean hybrisLockedLead;

	public String getLeadReason() {
		return leadReason;
	}

	public void setLeadReason(String leadReason) {
		this.leadReason = leadReason;
	}

	public String getLeadSourceText() {
        return leadSourceText;
    }

    public void setLeadSourceText(String leadSourceText) {
        this.leadSourceText = leadSourceText;
    }

    public String getLeadSource() {
		return leadSource;
	}

	public void setLeadSource(String leadSource) {
		this.leadSource = leadSource;
	}

	/**
	 * @return the title
	 */
	public String getTitle()
	{
		return title;
	}

	/**
	 * @param title
	 *           the title to set
	 */
	public void setTitle(final String title)
	{
		this.title = title;
	}

	/**
	 * @return the firstName
	 */
	public String getFirstName()
	{
		return firstName;
	}

	/**
	 * @param firstName
	 *           the firstName to set
	 */
	public void setFirstName(final String firstName)
	{
		this.firstName = firstName;
	}

	/**
	 * @return the lastName
	 */
	public String getLastName()
	{
		return lastName;
	}

	/**
	 * @param lastName
	 *           the lastName to set
	 */
	public void setLastName(final String lastName)
	{
		this.lastName = lastName;
	}

	/**
	 * @return the email
	 */
	public String getEmail()
	{
		return email;
	}

	/**
	 * @param email
	 *           the email to set
	 */
	public void setEmail(final String email)
	{
		this.email = email;
	}

	/**
	 * @return the mobileNumber
	 */
	public String getMobileNumber()
	{
		return mobileNumber;
	}

	/**
	 * @param mobileNumber
	 *           the mobileNumber to set
	 */
	public void setMobileNumber(final String mobileNumber)
	{
		this.mobileNumber = mobileNumber;
	}

	/**
	 * @return the jobTitle
	 */
	public String getJobTitle()
	{
		return jobTitle;
	}

	/**
	 * @param jobTitle
	 *           the jobTitle to set
	 */
	public void setJobTitle(final String jobTitle)
	{
		this.jobTitle = jobTitle;
	}

	/**
	 * @return the tradingName
	 */
	public String getTradingName()
	{
		return tradingName;
	}

	/**
	 * @param tradingName
	 *           the tradingName to set
	 */
	public void setTradingName(final String tradingName)
	{
		this.tradingName = tradingName;
	}





	/**
	 * @return the deliveryRestrictions
	 */
	public String getDeliveryRestrictions()
	{
		return deliveryRestrictions;
	}

	/**
	 * @param deliveryRestrictions
	 *           the deliveryRestrictions to set
	 */
	public void setDeliveryRestrictions(final String deliveryRestrictions)
	{
		this.deliveryRestrictions = deliveryRestrictions;
	}

	/**
	 * @return the postCode
	 */
	public String getPostCode()
	{
		return postCode;
	}

	/**
	 * @param postCode
	 *           the postCode to set
	 */
	public void setPostCode(final String postCode)
	{
		this.postCode = postCode;
	}

	/**
	 * @return the line1
	 */
	public String getLine1()
	{
		return line1;
	}

	/**
	 * @param line1
	 *           the line1 to set
	 */
	public void setLine1(final String line1)
	{
		this.line1 = line1;
	}

	/**
	 * @return the line2
	 */
	public String getLine2()
	{
		return line2;
	}

	/**
	 * @param line2
	 *           the line2 to set
	 */
	public void setLine2(final String line2)
	{
		this.line2 = line2;
	}

	/**
	 * @return the line3
	 */
	public String getLine3()
	{
		return line3;
	}

	/**
	 * @param line3
	 *           the line3 to set
	 */
	public void setLine3(final String line3)
	{
		this.line3 = line3;
	}

	/**
	 * @return the city
	 */
	public String getCity()
	{
		return city;
	}

	/**
	 * @param city
	 *           the city to set
	 */
	public void setCity(final String city)
	{
		this.city = city;
	}


	/**
	 * @return the county
	 */
	public String getCounty()
	{
		return county;
	}

	/**
	 * @param county
	 *           the county to set
	 */
	public void setCounty(final String county)
	{
		this.county = county;
	}

	/**
	 * @return the budget
	 */
	public String getBudget()
	{
		return budget;
	}

	/**
	 * @param budget
	 *           the budget to set
	 */
	public void setBudget(final String budget)
	{
		this.budget = budget;
	}

	/**
	 * @return the sector
	 */
	public String getSector()
	{
		return sector;
	}

	/**
	 * @param sector
	 *           the sector to set
	 */
	public void setSector(final String sector)
	{
		this.sector = sector;
	}

	/**
	 * @return the subSector
	 */
	public String getSubSector()
	{
		return subSector;
	}

	/**
	 * @param subSector
	 *           the subSector to set
	 */
	public void setSubSector(final String subSector)
	{
		this.subSector = subSector;
	}

	/**
	 * @return the companyType
	 */
	public String getCompanyType()
	{
		return companyType;
	}

	/**
	 * @param companyType
	 *           the companyType to set
	 */
	public void setCompanyType(final String companyType)
	{
		this.companyType = companyType;
	}

	/**
	 * @return the companyRegNumber
	 */
	public String getCompanyRegNumber()
	{
		return companyRegNumber;
	}

	/**
	 * @param companyRegNumber
	 *           the companyRegNumber to set
	 */
	public void setCompanyRegNumber(final String companyRegNumber)
	{
		this.companyRegNumber = companyRegNumber;
	}

	/**
	 * @return the companyRegName
	 */
	public String getCompanyRegName()
	{
		return companyRegName;
	}

	/**
	 * @param companyRegName
	 *           the companyRegName to set
	 */
	public void setCompanyRegName(final String companyRegName)
	{
		this.companyRegName = companyRegName;
	}

	/**
	 * @return the phoneNumber
	 */
	public String getPhoneNumber()
	{
		return phoneNumber;
	}

	/**
	 * @param phoneNumber
	 *           the phoneNumber to set
	 */
	public void setPhoneNumber(final String phoneNumber)
	{
		this.phoneNumber = phoneNumber;
	}

	/**
	 * @return the businessGroup
	 */
	public boolean isBusinessGroup()
	{
		return businessGroup;
	}

	/**
	 * @param businessGroup
	 *           the businessGroup to set
	 */
	public void setBusinessGroup(final boolean businessGroup)
	{
		this.businessGroup = businessGroup;
	}

	/**
	 * @return the legalOwner
	 */
	public boolean isLegalOwner()
	{
		return legalOwner;
	}

	/**
	 * @param legalOwner
	 *           the legalOwner to set
	 */
	public void setLegalOwner(final boolean legalOwner)
	{
		this.legalOwner = legalOwner;
	}

	/**
	 * @return the businessGroupName
	 */
	public String getBusinessGroupName()
	{
		return businessGroupName;
	}

	/**
	 * @param businessGroupName
	 *           the businessGroupName to set
	 */
	public void setBusinessGroupName(final String businessGroupName)
	{
		this.businessGroupName = businessGroupName;
	}

	/**
	 * @return the legalOwnerName
	 */
	public String getLegalOwnerName()
	{
		return legalOwnerName;
	}

	/**
	 * @param legalOwnerName
	 *           the legalOwnerName to set
	 */
	public void setLegalOwnerName(final String legalOwnerName)
	{
		this.legalOwnerName = legalOwnerName;
	}

	/**
	 * @return the marketingPreference
	 */
	public Boolean getMarketingPreference()
	{
		return marketingPreference;
	}

	/**
	 * @param marketingPreference
	 *           the marketingPreference to set
	 */
	public void setMarketingPreference(final Boolean marketingPreference)
	{
		this.marketingPreference = marketingPreference;
	}

	/**
	 * @return the termsCheck
	 */
	public Boolean getTermsCheck()
	{
		return termsCheck;
	}

	/**
	 * @param termsCheck
	 *           the termsCheck to set
	 */
	public void setTermsCheck(final Boolean termsCheck)
	{
		this.termsCheck = termsCheck;
	}

	/**
	 * @return the privacyPolicy
	 */
	public Boolean getPrivacyPolicy()
	{
		return privacyPolicy;
	}

	/**
	 * @param privacyPolicy
	 *           the privacyPolicy to set
	 */
	public void setPrivacyPolicy(final Boolean privacyPolicy)
	{
		this.privacyPolicy = privacyPolicy;
	}

	public String getStep() {
		return step;
	}

	public void setStep(String step) {
		this.step = step;
	}

	public String getConfirmEmail() {
		return confirmEmail;
	}

	public void setConfirmEmail(String confirmEmail) {
		this.confirmEmail = confirmEmail;
	}

	public String getBusinessPostCode() {
		return businessPostCode;
	}

	public void setBusinessPostCode(String businessPostCode) {
		this.businessPostCode = businessPostCode;
	}

	public String getBusinessLine1() {
		return businessLine1;
	}

	public void setBusinessLine1(String businessLine1) {
		this.businessLine1 = businessLine1;
	}

	public String getBusinessLine2() {
		return businessLine2;
	}

	public void setBusinessLine2(String businessLine2) {
		this.businessLine2 = businessLine2;
	}

	public String getBusinessLine3() {
		return businessLine3;
	}

	public void setBusinessLine3(String businessLine3) {
		this.businessLine3 = businessLine3;
	}

	public String getBusinessCity() {
		return businessCity;
	}

	public void setBusinessCity(String businessCity) {
		this.businessCity = businessCity;
	}

	public String getBusinessCounty() {
		return businessCounty;
	}

	public void setBusinessCounty(String businessCounty) {
		this.businessCounty = businessCounty;
	}

	public Boolean getBusinessAddressDifferent() {
		return businessAddressDifferent;
	}

	public void setBusinessAddressDifferent(Boolean businessAddressDifferent) {
		this.businessAddressDifferent = businessAddressDifferent;
	}

	public String getBusinessTelephoneNumber() {
		return businessTelephoneNumber;
	}

	public void setBusinessTelephoneNumber(String businessTelephoneNumber) {
		this.businessTelephoneNumber = businessTelephoneNumber;
	}

	public String getDateEstablished() {
		return dateEstablished;
	}

	public void setDateEstablished(String dateEstablished) {
		this.dateEstablished = dateEstablished;
	}

	public String getNumberOfFullTimeEmployees() {
		return numberOfFullTimeEmployees;
	}

	public void setNumberOfFullTimeEmployees(String numberOfFullTimeEmployees) {
		this.numberOfFullTimeEmployees = numberOfFullTimeEmployees;
	}

	public String getAnnualStoreTurnover() {
		return annualStoreTurnover;
	}

	public void setAnnualStoreTurnover(String annualStoreTurnover) {
		this.annualStoreTurnover = annualStoreTurnover;
	}

	/**
	 * @return the previousSupplier
	 */
	public String getPreviousSupplier()
	{
		return previousSupplier;
	}

	public String getCurrentSupplier() {
		return currentSupplier;
	}

	public void setCurrentSupplier(String currentSupplier) {
		this.currentSupplier = currentSupplier;
	}

	public String getCurrentSupplierComments() {
		return currentSupplierComments;
	}

	public void setCurrentSupplierComments(String currentSupplierComments) {
		this.currentSupplierComments = currentSupplierComments;
	}

	/**
	 * @param previousSupplier
	 *           the previousSupplier to set
	 */
	public void setPreviousSupplier(final String previousSupplier)
	{
		this.previousSupplier = previousSupplier;
	}


	public boolean isHybrisLockedLead() {
		return hybrisLockedLead;
	}

	public void setHybrisLockedLead(boolean hybrisLockedLead) {
		this.hybrisLockedLead = hybrisLockedLead;
	}

	/**
	 * @return the pk
	 */
	public String getPk()
	{
		return pk;
	}

	/**
	 * @param pk the pk to set
	 */
	public void setPk(String pk)
	{
		this.pk = pk;
	}
}
