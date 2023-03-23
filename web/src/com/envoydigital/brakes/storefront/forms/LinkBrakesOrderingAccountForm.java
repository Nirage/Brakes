/**
 *
 */
package com.envoydigital.brakes.storefront.forms;

import java.util.List;


/**
 * @author maheshroyal
 *
 */
public class LinkBrakesOrderingAccountForm
{
	private String firstName;
	private String lastName;
	private String email;
	private String tradingName;
	private String postCode;
	private List<String> accountNumbers;
	private Boolean termsCheck;
	private Boolean privacyPolicy;

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

	/**
	 * @return the accountNumbers
	 */
	public List<String> getAccountNumbers()
	{
		return accountNumbers;
	}

	/**
	 * @param accountNumbers
	 *           the accountNumbers to set
	 */
	public void setAccountNumbers(final List<String> accountNumbers)
	{
		this.accountNumbers = accountNumbers;
	}
}
