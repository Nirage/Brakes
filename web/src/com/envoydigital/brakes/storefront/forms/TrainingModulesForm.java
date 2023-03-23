package com.envoydigital.brakes.storefront.forms;

import javax.validation.constraints.NotNull;

/**
 * @author thomas.domin
 */
public class TrainingModulesForm {

    private String firstName;
    private String surname;
    @NotNull(message = "{error.empty.quiz}")
    private String quiz;


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

    public String getQuiz() {
        return quiz;
    }

    public void setQuiz(String quiz) {
        this.quiz = quiz;
    }
}
