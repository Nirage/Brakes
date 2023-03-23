package com.envoydigital.brakes.storefront.controllers.misc;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;

import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.envoydigital.brakes.facades.search.impl.SearchContext;
import com.envoydigital.brakes.facades.search.impl.SearchContext.ShowMode;
import com.envoydigital.brakes.facades.wishlist.FavouritesFacade;
import com.envoydigital.brakes.facades.wishlist.data.FavouriteSearchPageData;
import com.envoydigital.brakes.facades.wishlist.data.FavouritesData;
import com.envoydigital.brakes.facades.wishlist.data.FavouritesEntryData;
import com.envoydigital.brakes.facades.wishlist.impl.FavouriteItemsSearchPageEvaluator;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;


/**
 * Controller functionality for edit Favourites Itmes.
 */
@Controller
public class EditFavouriteItemsController extends AbstractPageController
{
	private static final Logger LOG = Logger.getLogger(EditFavouriteItemsController.class);

	@Resource
	private FavouritesFacade favouritesFacade;

	@Resource(name = "favouriteItemsSearchPageEvaluator")
	private FavouriteItemsSearchPageEvaluator favouriteItemsSearchPageEvaluator;



	@RequestMapping(value = "/favouriteitem/delete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	@RequireHardLogIn
	public ResponseEntity<String> deleteFavouriteEntry(@RequestParam
	final String favouriteUid, @RequestParam
	final String productCode, final Model model)
	{
		if (favouritesFacade.deleteFavouriteItem(favouriteUid, productCode))
		{
			return new ResponseEntity(HttpStatus.OK);
		}
		else
		{
			return new ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@RequestMapping(value = "/favouriteitem/changeorder", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	@RequireHardLogIn
	public ResponseEntity<List<FavouritesEntryData>> changeOrder(@RequestParam
	final String favouriteUid, @RequestParam
	final String productCode, @RequestParam
	final String moveTo, @RequestParam
	final int page, @RequestParam
	final String sortCode)
	{
		ResponseEntity response = null;
		List<FavouritesEntryData> favouriteEntriesData = null;

		switch (moveTo)
		{
			case ControllerConstants.WishlistAction.MOVE_UP:
				if (favouritesFacade.moveUpFavouriteItem(favouriteUid, productCode, page))
				{
					response = new ResponseEntity(favouriteEntriesData, HttpStatus.OK);
				}
				break;
			case ControllerConstants.WishlistAction.MOVE_DOWN:
				if (favouritesFacade.moveDownFavouriteItem(favouriteUid, productCode, page))
				{
					response = new ResponseEntity(favouriteEntriesData, HttpStatus.OK);
				}
				break;
			case ControllerConstants.WishlistAction.MOVE_TOP:
				if (favouritesFacade.moveToTopFavouriteItem(favouriteUid, productCode, page))
				{
					final FavouriteSearchPageData<FavouritesEntryData, FavouritesData> searchResultsData = performFavouriteItemsPage(
							favouriteUid, page, ShowMode.Page, sortCode);
					favouriteEntriesData = searchResultsData.getResults();
					response = new ResponseEntity(favouriteEntriesData, HttpStatus.OK);
				}
				break;
			case ControllerConstants.WishlistAction.MOVE_BOTTOM:
				if (favouritesFacade.moveToBottomFavouriteItem(favouriteUid, productCode, page))
				{
					response = new ResponseEntity(favouriteEntriesData, HttpStatus.OK);
				}
				break;
		}


		return response;
	}


	/**
	 * Do result item pagination.
	 */
	protected FavouriteSearchPageData<FavouritesEntryData, FavouritesData> performFavouriteItemsPage(final String favouriteUid,
			final int page, final SearchContext.ShowMode showMode, final String sortCode)
	{
		final SearchContext searchContext = new SearchContext(favouriteUid, page, null, showMode,
				Collections.singletonMap(sortCode, null));
		return favouriteItemsSearchPageEvaluator.doSearch(searchContext);
	}


}
