package com.envoydigital.brakes.storefront.filters;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import de.hybris.platform.servicelayer.session.SessionService;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ExternalPriceSessionFilter extends OncePerRequestFilter {

    private static final Logger LOG = LoggerFactory.getLogger(ExternalPriceSessionFilter.class);
    private static final String AJAX_PARAM = "ajax";
    private static final String SEARCH_TIME_PARAM = "searchTime";

    private SessionService sessionService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse httpServletResponse, FilterChain filterChain) throws IOException, ServletException {
        final String ajaxParam = request.getParameter(AJAX_PARAM);
        if (StringUtils.isNotBlank(ajaxParam)) {
            getSessionService().setAttribute(BrakesCoreConstants.PRICING_AJAX_ENABLED, Boolean.valueOf(ajaxParam.trim()));
        }

        final String searchTimeParam = request.getParameter(SEARCH_TIME_PARAM);
        if (StringUtils.isNotBlank(searchTimeParam)) {
            getSessionService().setAttribute(BrakesCoreConstants.PRICING_SEARCH_TIME_ENABLED, Boolean.valueOf(searchTimeParam.trim()));
        }
        filterChain.doFilter(request, httpServletResponse);
    }

    protected SessionService getSessionService() {
        return sessionService;
    }

    @Required
    public void setSessionService(SessionService sessionService) {
        this.sessionService = sessionService;
    }
}
