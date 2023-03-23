package com.envoydigital.brakes.storefront.controllers.misc;

import com.envoydigital.brakes.facades.interactive.studio.InteractiveStudioFacade;
import com.envoydigital.brakes.facades.search.solrfacetsearch.BrakesProductSearchFacade;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.commercefacades.product.data.ProductData;
import de.hybris.platform.commercefacades.search.data.SearchQueryData;
import de.hybris.platform.commercefacades.search.data.SearchStateData;
import de.hybris.platform.commerceservices.search.facetdata.ProductSearchPageData;
import de.hybris.platform.commerceservices.search.pagedata.PageableData;
import de.hybris.platform.commerceservices.search.pagedata.PaginationData;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/interactionStudio")
public class InteractionStudioProductsController extends AbstractController {

    public static final int MAX_PAGE_LIMIT = 100;
    @Resource(name = "productSearchFacade")
    private BrakesProductSearchFacade<ProductData> productSearchFacade;

    @Resource(name = "interactiveStudioFacade")
    private InteractiveStudioFacade interactiveStudioFacade;

    @ResponseBody
    @RequestMapping(value = "/getProducts", method = RequestMethod.GET)
    public ProductSearchPageData<SearchStateData, ProductData> getProductResults(@RequestParam("url") final String url){
        final SearchStateData searchState = new SearchStateData();
        final SearchQueryData searchQueryData = new SearchQueryData();
        searchState.setQuery(searchQueryData);
        searchState.setInteractionStudioSearch(true);
        //searchState.setProductCodes(Arrays.asList("121528","121484","121530","121529", "121527", "121114"));
        final List<String> campaignProductCodes = interactiveStudioFacade.getCampaignProductCodes(url);
        if(CollectionUtils.isNotEmpty(campaignProductCodes)) {
            searchState.setProductCodes(campaignProductCodes);
            return productSearchFacade.textSearch(searchState, createPageableData());
        }
        return createEmptySearchData();
    }

    private PageableData createPageableData() {
        final PageableData pageableData = new PageableData();
        pageableData.setCurrentPage(0);
        pageableData.setPageSize(MAX_PAGE_LIMIT);
        return pageableData;
    }

    ProductSearchPageData<SearchStateData, ProductData> createEmptySearchData()
    {
        final ProductSearchPageData<SearchStateData, ProductData> productSearchStateData = new ProductSearchPageData();
        final PaginationData pagData = new PaginationData();
        pagData.setTotalNumberOfResults(0);
        productSearchStateData.setPagination(pagData);
        return productSearchStateData;
    }
}
