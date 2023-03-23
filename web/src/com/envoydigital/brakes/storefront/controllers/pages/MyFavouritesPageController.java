package com.envoydigital.brakes.storefront.controllers.pages;

import com.envoydigital.brakes.core.util.BrakesCoreUtils;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.ResourceBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.commercefacades.order.CartFacade;
import de.hybris.platform.core.servicelayer.data.SearchPageData;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;

import java.util.Collections;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.envoydigital.brakes.facades.search.data.SearchResultsData;
import com.envoydigital.brakes.facades.search.impl.SearchContext;
import com.envoydigital.brakes.facades.wishlist.data.FavouriteSearchPageData;
import com.envoydigital.brakes.facades.wishlist.data.FavouritesData;
import com.envoydigital.brakes.facades.wishlist.data.FavouritesEntryData;
import com.envoydigital.brakes.facades.wishlist.impl.FavouriteItemsSearchPageEvaluator;


/**
 * @author thomas.domin
 */
@Controller
@RequestMapping(value = "/my-account/favourites")
@RequireHardLogIn
public class MyFavouritesPageController extends AbstractPageController
{

	private static final String FAVOURITE_UID_PATH_VARIABLE_PATTERN = "/{favouriteUid:.*}";

	public static final int MAX_PAGE_LIMIT = 100; // is configurable

	private static final String FAVOURITES_CMS_PAGE = "favourites";
	private static final String FAVOURITE_ITEMS_CMS_PAGE = "favourite-items";
	private static final String TEXT_ACCOUNT_FAVOURITES = "text.account.favourites";
	private static final String BREADCRUMBS_ATTR = "breadcrumbs";

	@Resource(name = "accountBreadcrumbBuilder")
	private ResourceBreadcrumbBuilder accountBreadcrumbBuilder;

	@Resource(name = "favouriteItemsSearchPageEvaluator")
	private FavouriteItemsSearchPageEvaluator favouriteItemsSearchPageEvaluator;

	@Resource(name = "cartFacade")
	private CartFacade cartFacade;

	@RequestMapping(method = RequestMethod.GET)
	public String favourites(final HttpServletRequest request, final HttpServletResponse response, final Model model)
			throws CMSItemNotFoundException
	{
		storeContinueUrl(request);

		final ContentPageModel cmsPage = getContentPageForLabelOrId ( FAVOURITES_CMS_PAGE );
		storeCmsPageInModel(model, cmsPage);
		setUpMetaDataForContentPage(model, cmsPage);

		model.addAttribute(BREADCRUMBS_ATTR, accountBreadcrumbBuilder.getBreadcrumbs(TEXT_ACCOUNT_FAVOURITES));
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);

		setUpMetaData(model, null, cmsPage.getMetaDescription());

		return getViewForPage(model);
	}

	@RequestMapping(value = FAVOURITE_UID_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	public String favouriteItems(@PathVariable final String favouriteUid,
			@RequestParam(value = "page", defaultValue = "1") final int page,
			@RequestParam(value = "show", defaultValue = "Page") final SearchContext.ShowMode showMode,
			@RequestParam(value = "sort", required = false, defaultValue = "rank-asc")
			final String sortCode, final Model model,
			final HttpServletRequest request, final HttpServletResponse response) throws CMSItemNotFoundException
	{

		final String decryptedFavouriteUid = BrakesCoreUtils.decrypt(favouriteUid);
		final FavouriteSearchPageData<FavouritesEntryData, FavouritesData> searchPageData = performFavouriteItemsPage(decryptedFavouriteUid,
				page, showMode, sortCode);
		populateModel(model, searchPageData, showMode);

		storeContinueUrl(request);

		storeCmsPageInModel(model, getContentPageForLabelOrId(FAVOURITE_ITEMS_CMS_PAGE));
		setUpMetaDataForContentPage(model, getContentPageForLabelOrId(FAVOURITE_ITEMS_CMS_PAGE));
		model.addAttribute(ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW);
		return getViewForPage(model);
	}

	@ExceptionHandler(UnknownIdentifierException.class)
	public String handleUnknownIdentifierException(final UnknownIdentifierException exception, final HttpServletRequest request)
	{
		request.setAttribute("message", exception.getMessage());
		return FORWARD_PREFIX + "/404";
	}

	@ResponseBody
	@RequestMapping(value = FAVOURITE_UID_PATH_VARIABLE_PATTERN + "/results", method = RequestMethod.GET)
	public SearchResultsData<FavouritesEntryData, FavouritesData> getResults(@PathVariable
	final String favouriteUid,
			@RequestParam(value = "page", defaultValue = "1") final int page,
			@RequestParam(value = "show", defaultValue = "Page") final SearchContext.ShowMode showMode,
			@RequestParam(value = "sort", required = false, defaultValue = "rank-asc")
			final String sortCode, final Model model,
			final HttpServletRequest request, final HttpServletResponse response)
	{
		final String decryptedFavouriteUid = BrakesCoreUtils.decrypt(favouriteUid);
		final FavouriteSearchPageData<FavouritesEntryData, FavouritesData> searchPageData =
				performFavouriteItemsPage(decodeWithScheme(decryptedFavouriteUid, UTF_8), page, showMode, sortCode);

		final SearchResultsData<FavouritesEntryData, FavouritesData> searchResultsData = new SearchResultsData<>();
		searchResultsData.setResults(searchPageData.getResults());

		final String encryptedFavouriteUid = BrakesCoreUtils.encrypt(searchPageData.getFavourite().getUid());
		final FavouritesData favouriteData = searchPageData.getFavourite();
		favouriteData.setUid(encryptedFavouriteUid);
		
		searchResultsData.setDetails(favouriteData);
		searchResultsData.setPagination(searchPageData.getPagination());
		return searchResultsData;
	}

	protected void populateModel(final Model model,
			final FavouriteSearchPageData<FavouritesEntryData, FavouritesData> searchPageData, final SearchContext.ShowMode showMode)
	{
		model.addAttribute("favouriteItemPageData", searchPageData);
		model.addAttribute("isShowAllAllowed", calculateShowAll(searchPageData, showMode));
		model.addAttribute("isShowPageAllowed", calculateShowPaged(searchPageData, showMode));
	}

	/**
	 * Special case, when total number of results > {@link #MAX_PAGE_LIMIT}
	 */
	protected boolean isShowAllAllowed(final SearchPageData<?> searchPageData)
	{
		return searchPageData.getPagination().getNumberOfPages() > 1
				&& searchPageData.getPagination().getTotalNumberOfResults() < MAX_PAGE_LIMIT;
	}

	protected Boolean calculateShowAll(final SearchPageData<?> searchPageData, final SearchContext.ShowMode showMode)
	{
		return (showMode != SearchContext.ShowMode.All && searchPageData.getPagination().getTotalNumberOfResults() > searchPageData
				.getPagination().getPageSize()) && isShowAllAllowed(searchPageData);
	}

	protected Boolean calculateShowPaged(final SearchPageData<?> searchPageData, final SearchContext.ShowMode showMode)
	{
		return showMode == SearchContext.ShowMode.All
				&& (searchPageData.getPagination().getNumberOfPages() > 1 || searchPageData.getPagination().getPageSize() == MAX_PAGE_LIMIT);
	}

	/**
	 * Do result item pagination.
	 */
	protected FavouriteSearchPageData<FavouritesEntryData, FavouritesData> performFavouriteItemsPage(
			final String favouriteUid, final int page, final SearchContext.ShowMode showMode,
			final String sortCode)
	{
		final SearchContext searchContext = new SearchContext ( favouriteUid, page, null, showMode, Collections.singletonMap(sortCode, null) );
		return favouriteItemsSearchPageEvaluator.doSearch (searchContext);
	}

}
