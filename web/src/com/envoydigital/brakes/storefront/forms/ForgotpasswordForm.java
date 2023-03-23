package com.envoydigital.brakes.storefront.forms;

import javax.validation.constraints.NotNull;

/**
 * @author Haridaskpillai
 *
 */
public class ForgotpasswordForm {

    @NotNull(message = "{general.required}")
    private String username;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

}
