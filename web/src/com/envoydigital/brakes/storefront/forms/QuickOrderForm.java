/**
 *
 */
package com.envoydigital.brakes.storefront.forms;

/**
 * Form for validating field on quick order page.
 */
public class QuickOrderForm
{
	private String productCode;

	private Long qty;

	private String orderCode;


	public void setProductCode(final String productCode)
	{
		this.productCode = productCode;
	}

	public String getProductCode()
	{
		return productCode;
	}

	public void setQty(final Long quantity)
	{
		this.qty = quantity;
	}

	public Long getQty()
	{
		return qty;
	}


	public QuickOrderForm()
	{
		super();
	}

	public QuickOrderForm(final String productCode, final Long qty)
	{
		super();
		this.productCode = productCode;
		this.qty = qty;
	}

	public void setOrderCode(final String orderCode)
	{
		this.orderCode = orderCode;
	}

	public String getOrderCode()
	{
		return orderCode;
	}
}
