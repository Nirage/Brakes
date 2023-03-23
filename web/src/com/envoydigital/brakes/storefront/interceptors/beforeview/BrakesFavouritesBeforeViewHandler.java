package com.envoydigital.brakes.storefront.interceptors.beforeview;

import com.envoydigital.brakes.core.services.BrakesWishlist2Service;
import de.hybris.platform.acceleratorstorefrontcommons.interceptors.BeforeViewHandler;
import de.hybris.platform.servicelayer.user.UserService;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class BrakesFavouritesBeforeViewHandler implements BeforeViewHandler {

    private BrakesWishlist2Service wishlistService;
    private UserService userService;

    @Override
    public void beforeView(final HttpServletRequest request, final HttpServletResponse response, final ModelAndView modelAndView) {
        boolean hasFavourites = false;

        if ( !userService.isAnonymousUser(userService.getCurrentUser()) )
            hasFavourites = CollectionUtils.isNotEmpty ( getWishlistService ().getWishlists () );

        modelAndView.addObject ( "hasFavourites", hasFavourites );
    }

    public BrakesWishlist2Service getWishlistService() {
        return wishlistService;
    }

    @Required
    public void setWishlistService(BrakesWishlist2Service wishlistService) {
        this.wishlistService = wishlistService;
    }

    public UserService getUserService() {
        return userService;
    }

    @Required
    public void setUserService(UserService userService) {
        this.userService = userService;
    }
}
