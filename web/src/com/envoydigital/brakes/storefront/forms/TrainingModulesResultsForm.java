package com.envoydigital.brakes.storefront.forms;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * @author thomas.domin
 */
public class TrainingModulesResultsForm {

    @DateTimeFormat(pattern="dd/MM/yyyy")
    private Date startDate;
    @DateTimeFormat(pattern="dd/MM/yyyy")
    private Date endDate;

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
}
