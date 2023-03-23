<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="quiz" tagdir="/WEB-INF/tags/responsive/quiz" %>
<script>
  window.quizCounter = {
    current: ${quizSession.currentPosition},
    total: ${quizSession.lastPosition}
  }
</script>
<c:set var="progressBarStep" value="${100/quizSession.lastPosition}" />
<c:set var="progressBarCurrent" value="${progressBarStep * quizSession.currentPosition}" />
<c:set var="progressBarDone" value="${progressBarCurrent - progressBarStep}" />

<div class="row">
  <div class="col-xs-12">
    <div class="site-header site-header--align-left">
      <h1 class="site-header__text site-header--align-left">${cmsPage.title}</h1>
      <span class="site-header__rectangle site-header__rectangle--align-left"></span>
      <p class="site-header__subtext"><spring:theme code="trainingModules.description" /></p>
    </div>

    <quiz:viewResults/>

  </div>
  <div class="col-xs-12">
    <form:form method="post" id="trainingModuleSubmitForm" action="${contextPath}/my-country-choice/training-module-submit" class="site-form js-quizForm js-formValidation site-form__quiz quiz">
      <div class="site-form__section is-active">
        <div class="site-form__section-content">
          <div class="row">
            <div class="col-xs-12">
              <div class="site-form__mix-group">
                <h3>${quizSession.currentQuiz.name}</h3>

                <div class="quiz__progress-bar quiz__progress-bar--main">
                  <span class="quiz__progress-bar quiz__progress-bar--current js-progressBarCurrent" style="width: ${progressBarCurrent}%"></span>
                  <span class="quiz__progress-bar quiz__progress-bar--done js-progressBarDone" style="width: ${progressBarDone}%"></span>
                </div>
                <div class="col-xs-12">

                </div>
                <div class="quiz__progress-count">
                <spring:theme code="trainingModulePerform.progress.bar" arguments="${quizSession.currentPosition},${quizSession.lastPosition}">
                  </spring:theme>
                </div>
                <div id="jsQuizQuestionContainer">
                  <div class="site-form__mix-group-header">
                    ${quizSession.currentQuestion.title}
                  </div>
                  <div class="row h-pad-top-2 m-0">
                    <div class="col-12">
                      <c:if test="${not empty errorMsg}">
                        <spring:theme code="${errorMsg}" />
                      </c:if>
                    </div>
                    <div class="row h-padding-top-2 h-padding-bottom-2 m-0">
                      <div class="col-xs-12 col-sm-6 col-md-6">
                        <!-- Answers -->
                        <c:forEach items="${quizSession.currentQuestion.answers}" var="answer" varStatus="loop">
                          <div class="site-form__formgroup form-group js-formGroup">
                            <div class="radio">
                            <input id="trainingModulePerform.partOfGroup.option${loop.index}" name="answer" class="js-radioButtonGroup js-quizAnswer" type="radio" value="${answer.code}" />
                            <label class="control-label " for="trainingModulePerform.partOfGroup.option${loop.index}">${answer.title}</label>
                            </div>
                          </div>
                        </c:forEach>
                      </div>
                      <!-- IMAGE -->
                      <div class="col-xs-12 col-sm-6 col-md-6 text-center">
                        <spring:url value="${quizSession.currentQuestion.image.url}" var="questionImageUrl" htmlEscape="true">
                          <spring:param name="img404" value="image-not-available"/>
                        </spring:url>
                        <c:set var="altTextHtml" value="${fn:escapeXml(quizSession.currentQuestion.image.altText)}" />
                        <c:if test="${not empty questionImageUrl}">
                          <picture class="quiz__picture">
                              <source data-size="desktop" srcset="${questionImageUrl}" media="(min-width: 1240px)">
                              <source data-size="tablet" srcset="${questionImageUrl}" media="(min-width: 768px)">
                              <source data-size="mobile" srcset="${questionImageUrl}">
                              <img class="question__image question-image js-fallbackImage" src="${questionImageUrl}" alt="${altTextHtml}" title="${altTextHtml}">
                          </picture>
                        </c:if>
                      </div>
                    </div>
                    <!-- Form Actions -->
                    <div class="site-form__actions form-actions clearfix">
                        <ycommerce:testId code="trainingModulePerform_Back_button">
                          <c:if test="${quizSession.prevQuestion != null}">
                            <button type="button" name="action" value="prevQuestion" data-action="action" data-action-type="prevQuestion" class="btn btn-secondary quiz__button js-backBtn js-quizBtn" <c:if test="${quizSession.prevQuestion == null}"> disabled</c:if>>
                                <spring:theme code="trainingModulePerform.back" />
                            </button>
                            </c:if>
                        </ycommerce:testId>
                        <ycommerce:testId code="trainingModulePerform_Next_button">
                        <c:choose>
                          <c:when test="${quizSession.nextQuestion != null}">
                            <button type="button" name="action" value="nextQuestion" data-action="action" data-action-type="nextQuestion" class="btn btn-primary quiz__button js-quizBtn">
                              <spring:theme code="trainingModulePerform.next" />
                            </button>
                          </c:when>
                          <c:otherwise>
                            <button type="button" class="btn btn-primary quiz__button js-quizBtn" data-action-type="submit">
                              <spring:theme code="trainingModulePerform.submit" />
                            </button>
                          </c:otherwise>
                        </c:choose>
                        </ycommerce:testId>
                      </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </form:form>
  </div>
</div>


<script id="quiz-question-template" type="text/x-handlebars-template">
  {{#with currentQuestion}}
    <div class="site-form__mix-group-header">{{title}}</div>
    <div class="row h-pad-top-2 h-padding-bottom-2 m-0">
      <div class="col-xs-12 col-sm-6 col-md-6">
        {{#each answers}}
        <div class="site-form__formgroup form-group js-formGroup">
          <div class="radio">
            <input id="trainingModulePerform.partOfGroup.option{{@index}}" name="answer" class="js-radioButtonGroup js-quizAnswer" type="radio" value="{{code}}" {{#if selected}}checked{{/if}}/>
            <label class="control-label " for="trainingModulePerform.partOfGroup.option{{@index}}">{{title}}</label>
          </div>
        </div>
        {{/each}}
      </div>
      <div class="col-xs-12 col-sm-6 col-md-6">
        {{#with image}}
        <%-- Image --%>
        <picture class="quiz__picture">
          <source data-size="desktop" srcset="{{url}}" media="(min-width: 1240px)">
          <source data-size="tablet" srcset="{{url}}" media="(min-width: 768px)">
          <source data-size="mobile" srcset="{{url}}">
          <img class="question__image question-image js-fallbackImage" src="{{url}}" alt="{{altText}}" title="{{altText}}">
        </picture>
        {{/with}}
      </div>
    </div>
    <!-- actions -->
    <div class="site-form__actions form-actions clearfix">
        {{#if ../prevQuestion}}
          <button type="button" name="action" data-action="action" data-action-type="prevQuestion" class="btn btn-secondary quiz__button js-quizBtn"><spring:theme code="trainingModulePerform.back" /></button>
        {{/if}}
        {{#if ../nextQuestion}}
          <button type="button" name="action" data-action="action" data-action-type="nextQuestion" class="btn btn-primary quiz__button js-quizBtn"><spring:theme code="trainingModulePerform.next" /></button>
        {{else}}
          <button type="button" class="btn btn-primary quiz__button js-quizBtn" data-action-type="submit">
              <spring:theme code="trainingModulePerform.submit" />
          </button>
        {{/if}}
    </div>
    
  {{/with}}
</script>