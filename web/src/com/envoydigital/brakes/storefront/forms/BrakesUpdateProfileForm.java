package com.envoydigital.brakes.storefront.forms;

/**
 * Extended Form object for updating profile
 *
 */
public class BrakesUpdateProfileForm
{
	private String email;
	private String currentPassword;
	private String newPassword;
	private String selectedAccountCode;
	private String accountName;

	/**
	 * @return the email
	 */
	public String getEmail()
	{
		return email;
	}

	/**
	 * @return the currentPassword
	 */
	public String getCurrentPassword()
	{
		return currentPassword;
	}

	/**
	 * @param currentPassword
	 *           the currentPassword to set
	 */
	public void setCurrentPassword(final String currentPassword)
	{
		this.currentPassword = currentPassword;
	}

	/**
	 * @return the newPassword
	 */
	public String getNewPassword()
	{
		return newPassword;
	}

	/**
	 * @param newPassword
	 *           the newPassword to set
	 */
	public void setNewPassword(final String newPassword)
	{
		this.newPassword = newPassword;
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
	 * @return the selectedAccountCode
	 */
	public String getSelectedAccountCode()
	{
		return selectedAccountCode;
	}

	/**
	 * @param selectedAccountCode
	 *           the selectedAccountCode to set
	 */
	public void setSelectedAccountCode(final String selectedAccountCode)
	{
		this.selectedAccountCode = selectedAccountCode;
	}

	/**
	 * @return the accountName
	 */
	public String getAccountName()
	{
		return accountName;
	}

	/**
	 * @param accountName
	 *           the accountName to set
	 */
	public void setAccountName(final String accountName)
	{
		this.accountName = accountName;
	}
}
