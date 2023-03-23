package com.envoydigital.brakes.storefront.filters;

import org.apache.commons.io.IOUtils;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ReadListener;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class CleanCXMLPunchoutRequestFilter extends OncePerRequestFilter {

    private static final String PUNCHOUT_SETUP_URL_PATH = "/punchout/cxml/setup";

    @Override
    protected void doFilterInternal(final HttpServletRequest request, final HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        if (isPunchoutRequest(request)) {
            final ResettableStreamHttpServletRequest newRequest = getRequest(request);

            final String newBody = IOUtils.toString(newRequest.getInputStream()).replaceAll("(?s)<!DOCTYPE.*?>", "");

            newRequest.resetInputStream(newBody.getBytes());

            filterChain.doFilter(newRequest, response);
        } else {
            filterChain.doFilter(request, response);
        }
    }

    private boolean isPunchoutRequest(final HttpServletRequest request) {
        if (RequestMethod.POST.name().equals(request.getMethod())
                && PUNCHOUT_SETUP_URL_PATH.equals(request.getServletPath())) {
            return true;
        }
        return false;
    }

    private ResettableStreamHttpServletRequest getRequest(final HttpServletRequest request) {

        final ResettableStreamHttpServletRequest wrappedRequest = new ResettableStreamHttpServletRequest(request);
        return wrappedRequest;
    }

    private String getBodyFromRequest(final HttpServletRequest request) throws IOException {
        return IOUtils.toString(request.getReader());
    }

    /**
     * Resettable http request. This is needed to be able to read the content
     * multiple time
     */
    private static class ResettableStreamHttpServletRequest extends HttpServletRequestWrapper {

        private byte[] rawData;
        private final HttpServletRequest request;
        private final ResettableServletInputStream servletStream;

        public ResettableStreamHttpServletRequest(final HttpServletRequest request) {
            super(request);
            this.request = request;
            this.servletStream = new ResettableServletInputStream();
        }

        public void resetInputStream() {
            servletStream.stream = new ByteArrayInputStream(rawData);
        }

        public void resetInputStream(byte[] newRawData) {
            servletStream.stream = new ByteArrayInputStream(newRawData);
        }

        @Override
        public ServletInputStream getInputStream() throws IOException {
            if (rawData == null) {
                rawData = IOUtils.toByteArray(this.request.getReader());
                servletStream.stream = new ByteArrayInputStream(rawData);
            }
            return servletStream;
        }

        @Override
        public BufferedReader getReader() throws IOException {
            if (rawData == null) {
                rawData = IOUtils.toByteArray(this.request.getReader());
                servletStream.stream = new ByteArrayInputStream(rawData);
            }
            return new BufferedReader(new InputStreamReader(servletStream));
        }

        private class ResettableServletInputStream extends ServletInputStream {

            private InputStream stream;

            @Override
            public int read() throws IOException {
                return stream.read();
            }

            @Override
            public boolean isFinished() {
                return false;
            }

            @Override
            public boolean isReady() {
                return false;
            }

            @Override
            public void setReadListener(ReadListener readListener) {

                //Do nothing
            }
        }
    }

}
