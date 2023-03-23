/**
 *
 */
package com.envoydigital.brakes.storefront.controllers.misc;

import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.commercefacades.product.data.ProductData;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.envoydigital.brakes.facades.BrakesProductFacade;


/**
 * @author mahesh
 *
 */
@RestController
@RequestMapping("/productpromo")
public class ProductPromotionController extends AbstractController
{
	@Resource(name = "productFacade")
	private BrakesProductFacade productFacade;


	@PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity getProductPromotions(@RequestBody
	final List<String> productCodes)
	{
		final List<String> externalPromoProductCodes = productFacade.getExternalPromoProductCodes();
		if (CollectionUtils.isNotEmpty(productCodes))
		{
			final List<ProductData> response = new ArrayList<>();
			for (final String code : productCodes)
			{
				ProductData productData = productFacade.getPromotionalInfo(code);
				if(CollectionUtils.isNotEmpty(externalPromoProductCodes) && externalPromoProductCodes.contains(code))
				{
					productData.setHasPotentialPromo(Boolean.TRUE);
				}
				response.add(productData);
			}
			return new ResponseEntity(response, HttpStatus.OK);
		}
		return new ResponseEntity(HttpStatus.NO_CONTENT);
	}
}
