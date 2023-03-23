package com.envoydigital.brakes.storefront.controllers.json;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.facades.BrakesExternalPriceFacade;
import com.envoydigital.brakes.facades.price.data.ExternalPriceData;
import com.envoydigital.brakes.facades.price.data.ExternalPriceDataList;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;

import org.apache.commons.lang.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/externalPrices")
public class JsonPriceController extends AbstractController {

	 private static final int PRODUCT_CODE_LENGTH_IN_MESSAGE = 18;
    @Resource(name = "brakesExternalPriceFacade")
    private BrakesExternalPriceFacade externalPriceFacade;

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ExternalPriceDataList getExternalPrices(@RequestBody final List<String> productCodes) {
        final ExternalPriceDataList externalPriceDataList = new ExternalPriceDataList();
        if (productCodes.isEmpty()) {
            return externalPriceDataList;
        }
        final List<ExternalPriceData> result = getExternalPriceFacade().getExternalPricesForProducts(formatProductCodes(productCodes));
        externalPriceDataList.setPrices(result);
        return externalPriceDataList;
  	}

  	/**
  	 * @param productCodes
  	 * @return
  	 */
  	private List<String> formatProductCodes(final List<String> productCodes)
  	{
  		final List<String> codes = new ArrayList<String>();
  		for (final String productCode : productCodes)
  		{
  			if (productCode.length() < 18)
  			{
  				codes.add(StringUtils.leftPad(productCode, PRODUCT_CODE_LENGTH_IN_MESSAGE, BrakesCoreConstants.ZERO));
  			}
  			else 
  			{
  				codes.add(productCode);
  			}
  		}
  		return codes;
  	}
    protected BrakesExternalPriceFacade getExternalPriceFacade() {
        return externalPriceFacade;
    }
}
