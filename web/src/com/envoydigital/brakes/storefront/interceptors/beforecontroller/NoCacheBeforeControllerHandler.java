/**
 *
 */
package com.envoydigital.brakes.storefront.interceptors.beforecontroller;

import de.hybris.platform.acceleratorstorefrontcommons.interceptors.BeforeControllerHandler;

import java.lang.annotation.Annotation;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.method.HandlerMethod;

import com.envoydigital.brakes.storefront.annotations.NoCache;


public class NoCacheBeforeControllerHandler implements BeforeControllerHandler
{

	@Override
	public boolean beforeController(final HttpServletRequest request, final HttpServletResponse response, final HandlerMethod handler)
			throws Exception
	{
		final NoCache noCache = findAnnotation(handler, NoCache.class);
      if(noCache!=null){
          response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
          response.setHeader("Pragma", "no-cache");
          response.setDateHeader("Expires", 0);
      }
      return true;
	}

	 protected <T extends Annotation> T findAnnotation(final HandlerMethod handlerMethod, final Class<T> annotationType)
    {
        // Search for method level annotation
        final T annotation = handlerMethod.getMethodAnnotation(annotationType);
        if (annotation != null)
        {
            return annotation;
        }
        return null;
    }
}