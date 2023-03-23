package com.envoydigital.brakes.storefront.forms;

import javax.validation.constraints.NotNull;

/**
 * @author thomas.domin
 */
public class TrainingModulePerformForm {

    private String answer;
    private String answerName;
    @NotNull(message = "{general.required}")
    private String action;

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getAnswerName() {
        return answerName;
    }

    public void setAnswerName(String answerName) {
        this.answerName = answerName;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }
}
