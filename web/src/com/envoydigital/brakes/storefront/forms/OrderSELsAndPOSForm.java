package com.envoydigital.brakes.storefront.forms;

import com.envoydigital.brakes.facades.orderPosSel.data.CCProductForPOSandSELData;
import com.envoydigital.brakes.facades.orderPosSel.data.OptionPOSandSELData;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * @author thomas.domin
 */
public class OrderSELsAndPOSForm {

    @NotEmpty(message = "{error.empty.category}")
    private String categoryCode;
    private String note;
    @NotEmpty(message = "{error.empty.firstName}")
    private String firstName;
    @NotEmpty(message = "{error.empty.surname}")
    private String surname;
    @NotEmpty(message = "{error.empty.businessName}")
    private String businessName;
    @NotEmpty(message = "{error.empty.addressLine1}")
    private String addressLine1;
    private String addressLine2;
    private String addressLine3;
    @NotEmpty(message = "{error.empty.postcode}")
    private String postcode;
    private List<CCProductForPOSandSELData> products;
    private OptionPOSandSELData option;

    public String getCategoryCode() { return categoryCode; }

    public void setCategoryCode(String categoryCode) { this.categoryCode = categoryCode; }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getAddressLine1() {
        return addressLine1;
    }

    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }

    public String getAddressLine2() {
        return addressLine2;
    }

    public void setAddressLine2(String addressLine2) {
        this.addressLine2 = addressLine2;
    }

    public String getAddressLine3() {
        return addressLine3;
    }

    public void setAddressLine3(String addressLine3) {
        this.addressLine3 = addressLine3;
    }

    public String getPostcode() {
        return postcode;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public List<CCProductForPOSandSELData> getProducts() {
        return products;
    }

    public void setProducts(List<CCProductForPOSandSELData> products) {
        this.products = products;
    }

    public OptionPOSandSELData getOption() {
        return option;
    }

    public void setOption(OptionPOSandSELData option) {
        this.option = option;
    }
}
