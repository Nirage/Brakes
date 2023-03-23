package com.envoydigital.brakes.storefront.controllers.misc;

import com.envoydigital.brakes.facades.product.data.ProductReferenceDataList;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.catalog.enums.ProductReferenceTypeEnum;
import de.hybris.platform.commercefacades.product.ProductFacade;
import de.hybris.platform.commercefacades.product.ProductOption;
import de.hybris.platform.servicelayer.config.ConfigurationService;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import org.apache.log4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.List;

@Controller
public class SearchResultReferencesController extends AbstractController {


    @Resource(name = "productVariantFacade")
    private ProductFacade productFacade;

    @Resource(name = "configurationService")
    private ConfigurationService configurationService;

    private static final Logger LOG = Logger.getLogger(SearchResultReferencesController.class);

    protected static final List<ProductOption> PRODUCT_OPTIONS = Arrays.asList(ProductOption.BASIC, ProductOption.PRICE,
    ProductOption.ADDITIONAL_PRICE_ATTR, ProductOption.BRAKESPRODUCTDETAILS, ProductOption.CART, ProductOption.PRODCT_TILE_ICONS);

    @RequestMapping(value = "/search-result-references", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public ResponseEntity<ProductReferenceDataList> getSearchResultReferences(@RequestParam(value = "productCode", required = true) final String productCode,
                          @RequestParam(value = "type", required = true) final String type) {
        ProductReferenceDataList alternativesList = new  ProductReferenceDataList();
        try {
            alternativesList.setProductReferences(productFacade.getProductReferencesForCode(productCode, Arrays.asList(ProductReferenceTypeEnum.valueOf(type)), PRODUCT_OPTIONS,
                    configurationService.getConfiguration().getInt("search.result.references.show.count", 4)));
            return new ResponseEntity(alternativesList, HttpStatus.OK);

        }catch (final UnknownIdentifierException ex) {

            LOG.error(String.format("Product could not be found for alternative - %s", ex.getMessage()));
            return new ResponseEntity(alternativesList, HttpStatus.FORBIDDEN);
        }
    }
}
