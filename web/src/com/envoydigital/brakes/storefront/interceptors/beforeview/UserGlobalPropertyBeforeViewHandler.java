package com.envoydigital.brakes.storefront.interceptors.beforeview;

import com.envoydigital.brakes.core.services.BrakesB2BUnitService;
import de.hybris.platform.acceleratorstorefrontcommons.interceptors.BeforeViewHandler;
import de.hybris.platform.b2b.model.B2BCustomerModel;
import de.hybris.platform.b2b.model.B2BUnitModel;
import de.hybris.platform.b2bcommercefacades.company.data.B2BUserGroupData;
import de.hybris.platform.core.model.security.PrincipalGroupModel;
import de.hybris.platform.core.model.user.UserModel;
import de.hybris.platform.servicelayer.user.UserService;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


public class UserGlobalPropertyBeforeViewHandler implements BeforeViewHandler {

    private UserService userService;
    private BrakesB2BUnitService brakesB2BUnitService;

    @Override
    public void beforeView(HttpServletRequest request, HttpServletResponse response, ModelAndView modelAndView) throws Exception {

        final UserModel currentUser = getUserService().getCurrentUser();



        if(!getUserService().isAnonymousUser(currentUser)) {

            List<B2BUserGroupData> b2BUserGroupDataList = new ArrayList<>();
            for (PrincipalGroupModel group : currentUser.getGroups()) {

                B2BUnitModel currentB2BUnit = brakesB2BUnitService.getCurrentB2BUnit();

                if (null != currentB2BUnit) {
                    Optional<PrincipalGroupModel> matchingGroup = currentB2BUnit.getGroups().stream().filter(uGroup -> uGroup.getUid().equals(group.getUid())).findAny();

                    if (matchingGroup.isPresent()) {
                        final B2BUserGroupData userGroupData = new B2BUserGroupData();
                        userGroupData.setUid(group.getUid());
                        userGroupData.setName(group.getName());
                        b2BUserGroupDataList.add(userGroupData);
                    }
                }
            }

            modelAndView.addObject("userGroups",  b2BUserGroupDataList);
            modelAndView.addObject("userStatus",  "logged in");
        }else {

            modelAndView.addObject("userStatus",  "logged out");
        }

        modelAndView.addObject("joinLoyaltyEnabled", currentUser instanceof B2BCustomerModel &&
                Boolean.TRUE.equals(((B2BCustomerModel)currentUser).getJoinLoyaltyEnabled()));

    }

    public UserService getUserService() {
        return userService;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public BrakesB2BUnitService getBrakesB2BUnitService() {
        return brakesB2BUnitService;
    }

    public void setBrakesB2BUnitService(BrakesB2BUnitService brakesB2BUnitService) {
        this.brakesB2BUnitService = brakesB2BUnitService;
    }
}
