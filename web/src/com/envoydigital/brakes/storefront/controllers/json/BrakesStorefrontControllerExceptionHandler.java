package com.envoydigital.brakes.storefront.controllers.json;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.google.common.base.Strings;
import de.hybris.platform.integrationservices.util.Log;
import de.hybris.platform.servicelayer.i18n.I18NService;
import org.slf4j.Logger;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.context.Theme;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@RestControllerAdvice
public class BrakesStorefrontControllerExceptionHandler {

	private static final Logger LOG = Log.getLogger(BrakesStorefrontControllerExceptionHandler.class);

	@Resource(name = "i18nService")
	private I18NService i18nService;

	@ExceptionHandler(value = Throwable.class)
	public ResponseEntity<ObjectNode> handleException(final HttpServletRequest request, final Throwable exception) {
		return handleHttpException(request, exception);
	}

	private ResponseEntity<ObjectNode> handleHttpException(final HttpServletRequest request, final Throwable exception) {
		final String payload = getMessageSource().getMessage("text.message.rest.exception", null,
				i18nService.getCurrentLocale()) + exception.getMessage();
		LOG.error(getMessage(exception), exception);

		ObjectMapper mapper = new ObjectMapper();
		ObjectNode responseErrorPayload = mapper.createObjectNode();
		responseErrorPayload.put("error", payload);

		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
				.contentType(MediaType.APPLICATION_JSON)
				.body(responseErrorPayload);
	}

	private static String getMessage(final Throwable exception) {
		final StringBuilder msg = new StringBuilder(exception.getLocalizedMessage());
		if (exception.getCause() != null && !Strings.isNullOrEmpty(exception.getCause().getLocalizedMessage())) {
			msg.append("\n").append(exception.getCause().getLocalizedMessage());
		}
		return msg.toString();
	}

	protected MessageSource getMessageSource() {
		final ServletRequestAttributes requestAttributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
		if (requestAttributes != null) {
			final HttpServletRequest request = requestAttributes.getRequest();
			final Theme theme = RequestContextUtils.getTheme(request);
			if (theme != null) {
				return theme.getMessageSource();
			}
		}
		return null;
	}
}