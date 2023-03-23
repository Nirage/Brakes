package com.envoydigital.brakes.storefront.forms;

/**
 * @author kuber.pant
 *
 */
public class PurchaseOrderForm
{
	private String purchaseOrderNumber;
	private String customerPOFormat;

	/**
	 * @return the customerPOFormat
	 */
	public String getCustomerPOFormat()
	{
		return customerPOFormat;
	}

	/**
	 * @param customerPOFormat
	 *           the customerPOFormat to set
	 */
	public void setCustomerPOFormat(final String customerPOFormat)
	{
		this.customerPOFormat = customerPOFormat;
	}

	/**
	 * @return the purchaseOrderNumber
	 */
	public String getPurchaseOrderNumber()
	{
		return purchaseOrderNumber;
	}

	/**
	 * @param purchaseOrderNumber
	 *           the purchaseOrderNumber to set
	 */
	public void setPurchaseOrderNumber(final String purchaseOrderNumber)
	{
		this.purchaseOrderNumber = purchaseOrderNumber;
	}
}
