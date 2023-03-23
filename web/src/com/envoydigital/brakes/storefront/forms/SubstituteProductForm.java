/**
 *
 */
package com.envoydigital.brakes.storefront.forms;

/**
 * @author Sridhar
 *
 */
public class SubstituteProductForm
{

	private String substituteProductCode;
	private Integer entryNumber;
	private String orderNumber;
	private boolean acceptSubstitute;

	public void setSubstituteProductCode(final String substituteProductCode)
	{
		this.substituteProductCode = substituteProductCode;
	}

	public String getSubstituteProductCode()
	{
		return substituteProductCode;
	}
	public Integer getEntryNumber()
	{
		return entryNumber;
	}

	public void setEntryNumber(final Integer entryNumber)
	{
		this.entryNumber = entryNumber;
	}

	public String getOrderNumber()
	{
		return orderNumber;
	}

	public void setOrderNumber(final String orderNumber)
	{
		this.orderNumber = orderNumber;
	}

	public boolean isAcceptSubstitute()
	{
		return acceptSubstitute;
	}

	public void setAcceptSubstitute(final boolean acceptSubstitute)
	{
		this.acceptSubstitute = acceptSubstitute;
	}


}
