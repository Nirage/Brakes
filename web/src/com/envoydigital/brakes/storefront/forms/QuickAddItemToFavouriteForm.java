/**
 *
 */
package com.envoydigital.brakes.storefront.forms;

/**
 * Form for validating field on quick add favourite items page.
 */
public class QuickAddItemToFavouriteForm {
    private String favouriteUid;
    private String productCode;
    private Long qty;

    public void setProductCode(final String productCode) {
        this.productCode = productCode;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setQty(final Long quantity) {
        this.qty = quantity;
    }

    public Long getQty() {
        return qty;
    }

    public String getFavouriteUid() { return favouriteUid; }

    public void setFavouriteUid(String favouriteUid) { this.favouriteUid = favouriteUid; }

    public QuickAddItemToFavouriteForm() {
        super();
    }

    public QuickAddItemToFavouriteForm(String favouriteUid, String productCode, Long qty) {
        this.favouriteUid = favouriteUid;
        this.productCode = productCode;
        this.qty = qty;
    }

}
