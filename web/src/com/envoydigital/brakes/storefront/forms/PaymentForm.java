package com.envoydigital.brakes.storefront.forms;

public class PaymentForm
{
	private String selectedAccount;
	private Boolean addToAllAccount;

	/**
	 * @return the selectedAccount
	 */
	public String getSelectedAccount()
	{
		return selectedAccount;
	}

	/**
	 * @param selectedAccount
	 *           the selectedAccount to set
	 */
	public void setSelectedAccount(final String selectedAccount)
	{
		this.selectedAccount = selectedAccount;
	}

	/**
	 * @return the addToAllAccount
	 */
	public Boolean getAddToAllAccount()
	{
		return addToAllAccount;
	}

	/**
	 * @param addToAllAccount
	 *           the addToAllAccount to set
	 */
	public void setAddToAllAccount(final Boolean addToAllAccount)
	{
		this.addToAllAccount = addToAllAccount;
	}
}
