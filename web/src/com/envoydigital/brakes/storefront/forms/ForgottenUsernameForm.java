package com.envoydigital.brakes.storefront.forms;

import javax.validation.constraints.NotNull;

public class ForgottenUsernameForm {

    private String emailAddress;

    @NotNull
    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }
}
