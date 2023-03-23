/**
 *
 */
package com.envoydigital.brakes.storefront.forms;

/**
 * @author himansu.durgapal
 *
 */
public class BrakesB2cRegisterForm
{
	private String addressLine1;
	private String addressLine2;
	private String addressLine3;
	private String town;
	private String county;
	private String postcode;
	private String firstName;
	private String lastName;
	private String phone;
	private String email;
	private String confirmEmail;
	private String title;
	private String b2cUnit;
	private Boolean groundFloor;
	private Boolean vehicleRestriction;
	private Boolean largeVehicleParking;
	private Double distanceFromCarParking;
	private String communalDoorCode;
	private String password;
	private String confirmPassword;

	public String getCommunalDoorCode() {
		return communalDoorCode;
	}

	public void setCommunalDoorCode(String communalDoorCode) {
		this.communalDoorCode = communalDoorCode;
	}

	/**
	 * @return the firstName
	 */
	public String getFirstName()
	{
		return firstName;
	}

	/**
	 * @param firstName
	 *           the firstName to set
	 */
	public void setFirstName(final String firstName)
	{
		this.firstName = firstName;
	}

	/**
	 * @return the lastName
	 */
	public String getLastName()
	{
		return lastName;
	}

	/**
	 * @param lastName
	 *           the lastName to set
	 */
	public void setLastName(final String lastName)
	{
		this.lastName = lastName;
	}

	/**
	 * @return the phone
	 */
	public String getPhone()
	{
		return phone;
	}

	/**
	 * @param phone
	 *           the phone to set
	 */
	public void setPhone(final String phone)
	{
		this.phone = phone;
	}

	/**
	 * @return the email
	 */
	public String getEmail()
	{
		return email;
	}

	/**
	 * @param email
	 *           the email to set
	 */
	public void setEmail(final String email)
	{
		this.email = email;
	}

	/**
	 * @return the b2cUnit
	 */
	public String getB2cUnit()
	{
		return b2cUnit;
	}

	/**
	 * @param b2cUnit
	 *           the b2cUnit to set
	 */
	public void setB2cUnit(final String b2cUnit)
	{
		this.b2cUnit = b2cUnit;
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

	public String getTown() {
		return town;
	}

	public void setTown(String town) {
		this.town = town;
	}

	public String getCounty() {
		return county;
	}

	public void setCounty(String county) {
		this.county = county;
	}

	public String getPostcode() {
		return postcode;
	}

	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}

	public String getConfirmEmail() {
		return confirmEmail;
	}

	public void setConfirmEmail(String confirmEmail) {
		this.confirmEmail = confirmEmail;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Boolean getGroundFloor() {
		return groundFloor;
	}

	public void setGroundFloor(Boolean groundFloor) {
		this.groundFloor = groundFloor;
	}

	public Boolean getVehicleRestriction() {
		return vehicleRestriction;
	}

	public void setVehicleRestriction(Boolean vehicleRestriction) {
		this.vehicleRestriction = vehicleRestriction;
	}

	public Boolean getLargeVehicleParking() {
		return largeVehicleParking;
	}

	public void setLargeVehicleParking(Boolean largeVehicleParking) {
		this.largeVehicleParking = largeVehicleParking;
	}

	public Double getDistanceFromCarParking() {
		return distanceFromCarParking;
	}

	public void setDistanceFromCarParking(Double distanceFromCarParking) {
		this.distanceFromCarParking = distanceFromCarParking;
	}


	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getConfirmPassword() {
		return confirmPassword;
	}

	public void setConfirmPassword(String confirmPassword) {
		this.confirmPassword = confirmPassword;
	}

	public String getAddressLine3() {
		return addressLine3;
	}

	public void setAddressLine3(String addressLine3) {
		this.addressLine3 = addressLine3;
	}
}
