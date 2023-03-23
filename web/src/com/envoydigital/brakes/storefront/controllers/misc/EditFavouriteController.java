package com.envoydigital.brakes.storefront.controllers.misc;

import com.envoydigital.brakes.core.services.BrakesWishlist2Service;
import com.envoydigital.brakes.core.util.BrakesCoreUtils;
import com.envoydigital.brakes.facades.wishlist.FavouritesFacade;
import com.envoydigital.brakes.facades.wishlist.data.FavouriteModificationData;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.AbstractController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.servicelayer.i18n.I18NService;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.Pattern;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;


/**
 * Controller functionality for edit Favourites.
 */
@Controller
public class EditFavouriteController extends AbstractController
{
	private static final String FAVOURITE_UID_PATH_VARIABLE_PATTERN = "/{favouriteUid:.*}";
	private static final String REGEX_PATTREN_WISHLIST_NAME = "^((?!#).)*$";
	private static final String RENAME_VALIDATION_ERROR_KEY = "ERROR";
	private static final int RENAME_MAX_LENGTH = 80;
	private static final Logger LOG = Logger.getLogger(EditFavouriteController.class);

	@Resource
	private FavouritesFacade favouritesFacade;

	@Resource(name = "messageSource")
	private MessageSource messageSource;

	@Resource(name = "i18nService")
	private I18NService i18nService;



	@RequestMapping(value = "/favourite/rename/page/" + FAVOURITE_UID_PATH_VARIABLE_PATTERN, method = RequestMethod.GET)
	@RequireHardLogIn
	public String loadRenameFavouritesPage(@PathVariable final String favouriteUid, final Model model)
	{
		model.addAttribute("favouriteUid", favouriteUid);
		return ControllerConstants.Views.Fragments.Favourites.RenameFavouritesPopup;
	}


	@RequireHardLogIn
	@RequestMapping(value = "/favourite/rollover/create", method = RequestMethod.GET, produces = "application/json")
	public @ResponseBody String createFavouritePopup(@RequestParam final String productCode, final Model model,
												   final RedirectAttributes redirectAttributes) throws CMSItemNotFoundException
	{
		model.addAttribute("productCode", productCode);
		return ControllerConstants.Views.Fragments.Favourites.CreateFavouritePopup;
	}

	@RequireHardLogIn
	@RequestMapping(value = "/favourite/create", method = RequestMethod.POST, produces = "application/json")
	public @ResponseBody ResponseEntity<String> createFavourite(@RequestParam
															   @Pattern(regexp = REGEX_PATTREN_WISHLIST_NAME)
															   final String name,
															   @RequestParam(required = false) final String productCode, final RedirectAttributes redirectModel, final HttpServletRequest request)
	{
		final Locale locale = i18nService.getCurrentLocale();
		final String response;
		try {
            final FavouriteModificationData modificationData = favouritesFacade.createFavourite ( name, productCode );
            if (BrakesWishlist2Service.SUCCESS.equals ( modificationData.getStatusCode () ))
				{
					modificationData.setStatusMessage ( messageSource.getMessage("wishlist.create.success", null, locale) );
				}
				else if (BrakesWishlist2Service.MAXSIZE.equals ( modificationData.getStatusCode () ))
			{
				modificationData.setStatusMessage ( messageSource.getMessage("favourite.create.maxsize", null, locale) );
			}
			else
			{
				modificationData.setStatusMessage ( messageSource.getMessage("wishlist.name.exist", new Object[]{ name }, locale) );
			}

			if (modificationData.getUid() != null)
			{
				modificationData.setUid(BrakesCoreUtils.encrypt(modificationData.getUid()));
			}

			return new ResponseEntity ( modificationData, HttpStatus.OK );
		}
		catch (final Exception e) {
            LOG.error ( e.getMessage () );
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@RequestMapping(value = "/favourite/namechange", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	@RequireHardLogIn
	public ResponseEntity<String> renameFavourite(@RequestParam
	final String favouriteUid,
			@RequestParam
			final String favouriteName, final Model model)
	{
		Map<String , String> validationMap = new HashMap<>();
		if(StringUtils.isEmpty(favouriteName))
		{
			validationMap.put(RENAME_VALIDATION_ERROR_KEY, "favourite.name.empty");
			return new ResponseEntity ( validationMap, HttpStatus.OK );
		}else if(!StringUtils.isEmpty(favouriteName) && favouriteName.length() > RENAME_MAX_LENGTH) {

			validationMap.put(RENAME_VALIDATION_ERROR_KEY, "favourite.name.exceeds.max.length");
			return new ResponseEntity ( validationMap, HttpStatus.OK );
		}
		final Locale locale = i18nService.getCurrentLocale ();
		try {
			final FavouriteModificationData modificationData = favouritesFacade.renameFavourite ( favouriteUid, favouriteName );
			if (BrakesWishlist2Service.SUCCESS.equals ( modificationData.getStatusCode () ))
			{
				modificationData.setStatusMessage ( messageSource.getMessage ( "favourite.rename.success", null, locale ) );
			}
			else
			{
				modificationData.setStatusMessage ( messageSource.getMessage ( "wishlist.name.exist", new Object[]{favouriteName}, locale ) );
			}

			modificationData.setUid(BrakesCoreUtils.encrypt(modificationData.getUid()));

			return new ResponseEntity ( modificationData, HttpStatus.OK );
		} catch (final Exception e) {
			LOG.error ( e.getMessage () );
			return new ResponseEntity ( HttpStatus.INTERNAL_SERVER_ERROR );
		}
	}


	@RequestMapping(value = "/favourite/delete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	@RequireHardLogIn
	public ResponseEntity<String> deleteFavourite(@RequestParam
	final String favouriteUid, final Model model)
	{
		if (favouritesFacade.deleteFavourites(favouriteUid))
		{
			return new ResponseEntity("deleted", HttpStatus.OK);
		}
		else
		{
			return new ResponseEntity("internal failure", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}


	@RequestMapping(value = "/favourite/changeorder", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	@RequireHardLogIn
	public ResponseEntity<FavouriteModificationData> changeOrder(@RequestParam
	final String favouriteUid, @RequestParam
	final String moveTo)
	{
		ResponseEntity response = null;
		FavouriteModificationData favouritesData = null;

		switch (moveTo)
		{
			case ControllerConstants.WishlistAction.MOVE_UP:
				favouritesData = favouritesFacade.moveUpFavourite(favouriteUid);
				response = new ResponseEntity(favouritesData, HttpStatus.OK);
				break;
			case ControllerConstants.WishlistAction.MOVE_DOWN:
				favouritesData = favouritesFacade.moveDownFavourite (favouriteUid);
				response = new ResponseEntity(favouritesData, HttpStatus.OK);
				break;
			case ControllerConstants.WishlistAction.MOVE_TOP:
				favouritesData = favouritesFacade.moveToTopFavourite(favouriteUid);
				response = new ResponseEntity(favouritesData, HttpStatus.OK);
			break;
			case ControllerConstants.WishlistAction.MOVE_BOTTOM:
				favouritesData = favouritesFacade.moveToBottomFavourite(favouriteUid);
				response = new ResponseEntity(favouritesData, HttpStatus.OK);
				break;
		}


		return response;
	}

}
