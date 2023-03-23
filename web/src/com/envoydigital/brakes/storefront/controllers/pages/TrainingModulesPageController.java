package com.envoydigital.brakes.storefront.controllers.pages;

import com.envoydigital.brakes.core.services.impl.SaveQuizResultRecordException;
import com.envoydigital.brakes.facades.quiz.QuizFacade;
import com.envoydigital.brakes.facades.quiz.data.QuizData;
import com.envoydigital.brakes.facades.quiz.data.QuizResultRecordData;
import com.envoydigital.brakes.facades.quiz.data.QuizSessionData;
import com.envoydigital.brakes.storefront.controllers.ControllerConstants;
import com.envoydigital.brakes.storefront.forms.TrainingModulePerformForm;
import com.envoydigital.brakes.storefront.forms.TrainingModulesForm;
import com.envoydigital.brakes.storefront.forms.validation.TrainingModulesFormValidator;

import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.breadcrumb.impl.ContentPageBreadcrumbBuilder;
import de.hybris.platform.acceleratorstorefrontcommons.constants.WebConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.util.GlobalMessages;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Validator;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.Collection;


/**
 * @author thomas.domin
 *
 */
@Controller
public class TrainingModulesPageController extends AbstractPageController
{
	private static final Logger LOG = LoggerFactory.getLogger ( TrainingModulesPageController.class );

	public static final String TRAINING_MODULES_CMS_PAGE = "training-modules";
	public static final String TRAINING_MODULE_PERFORM_CMS_PAGE = "training-module-perform";
	public static final String TRAINING_MODULE_SUBMIT_CMS_PAGE = "training-module-submit";
	private static final String FORM_GLOBAL_ERROR = "form.global.error";

	@Resource(name = "contentPageBreadcrumbBuilder")
	private ContentPageBreadcrumbBuilder contentPageBreadcrumbBuilder;

	@Resource(name = "quizFacade")
	private QuizFacade quizFacade;
	
	@Resource(name="trainingModulesFormValidator")
	private Validator trainingModulesFormValidator;

	@ModelAttribute("quizzes")
	public Collection<QuizData> getQuizzes()
	{
		return quizFacade.getQuizzes ();
	}

	@RequireHardLogIn
	@RequestMapping(value = "**/" + TrainingModulesPageController.TRAINING_MODULES_CMS_PAGE, method = RequestMethod.GET)
	public String trainingModulesPage(final Model model)
			throws CMSItemNotFoundException
	{
		return getContentPage ( model, TRAINING_MODULES_CMS_PAGE );
	}

	@RequireHardLogIn
	@RequestMapping(value = "**/" + TrainingModulesPageController.TRAINING_MODULES_CMS_PAGE, method = RequestMethod.POST)
	public String startTrainingModule(@Valid final TrainingModulesForm trainingModulesForm,
									  final BindingResult bindingResult, final Model model) throws CMSItemNotFoundException {
		trainingModulesFormValidator.validate(trainingModulesForm, bindingResult);
        if (bindingResult.hasErrors()) {
      	  GlobalMessages.addErrorMessage(model, FORM_GLOBAL_ERROR);
      	  storeCmsPageInModel(model, getContentPageForLabelOrId(TRAINING_MODULES_CMS_PAGE));
           setUpMetaDataForContentPage(model, getContentPageForLabelOrId(TRAINING_MODULES_CMS_PAGE));
           return getViewForPage(model);
        }

        quizFacade.performQuiz ( trainingModulesForm.getFirstName (), trainingModulesForm.getSurname (), trainingModulesForm.getQuiz () );

		return REDIRECT_PREFIX + TRAINING_MODULE_PERFORM_CMS_PAGE;
	}

	@RequireHardLogIn
	@RequestMapping(value = "**/" + TrainingModulesPageController.TRAINING_MODULE_PERFORM_CMS_PAGE, method = RequestMethod.GET)
	public String trainingModulePerformPage(final Model model)
			throws CMSItemNotFoundException
	{
        if ( ! quizFacade.hasPerformQuiz () )
            return REDIRECT_PREFIX + TRAINING_MODULES_CMS_PAGE;

		return getContentPage ( model, TRAINING_MODULE_PERFORM_CMS_PAGE );
	}

	@RequireHardLogIn
	@RequestMapping(value = "**/" + TrainingModulesPageController.TRAINING_MODULE_PERFORM_CMS_PAGE, method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody ResponseEntity<QuizSessionData> question(@Valid final TrainingModulePerformForm trainingModulesForm,
                                                                  final BindingResult bindingResult)
	{
		if (!quizFacade.hasPerformQuiz () || bindingResult.hasErrors() )
			return new ResponseEntity ( new QuizSessionData (), HttpStatus.OK );

		QuizSessionData quizSessionData = new QuizSessionData ();

		switch (trainingModulesForm.getAction ()) {
			case ControllerConstants.QuizAction.PREV_QUESTION:
				quizSessionData = quizFacade.prevQuestion ();
				break;
			case ControllerConstants.QuizAction.NEXT_QUESTION:
				quizSessionData = quizFacade.nextQuestion ( trainingModulesForm.getAnswer () );
				break;
		}

		return new ResponseEntity ( quizSessionData, HttpStatus.OK );
	}

	@RequireHardLogIn
	@RequestMapping(value = "**/" + TrainingModulesPageController.TRAINING_MODULE_SUBMIT_CMS_PAGE + "/{resultCode:.*}", method = RequestMethod.GET)
	public String trainingModuleSubmitPage(@PathVariable final String resultCode,final Model model)
			throws CMSItemNotFoundException
	{
		try {
			model.addAttribute ( "quizResultRecord", quizFacade.getQuizResultRecord ( resultCode ) );
		} catch (final Exception e) {
			LOG.warn("Attempted to load an quiz result that does not exist or is not visible. Redirect to training start page.", e.getMessage ());
			return REDIRECT_PREFIX + TRAINING_MODULES_CMS_PAGE;
		}

		return getContentPage ( model, TRAINING_MODULE_SUBMIT_CMS_PAGE );
	}

	@RequireHardLogIn
	@RequestMapping(value = "**/" + TrainingModulesPageController.TRAINING_MODULE_SUBMIT_CMS_PAGE, method = RequestMethod.POST)
	public String submitQuiz(final Model model)
	{
		if ( ! quizFacade.hasPerformQuiz () )
			return REDIRECT_PREFIX + TRAINING_MODULES_CMS_PAGE;

		QuizResultRecordData quizResultRecordData = null;
		try {
			quizResultRecordData = quizFacade.finalizeQuiz ();
			return REDIRECT_PREFIX + TRAINING_MODULE_SUBMIT_CMS_PAGE + "/" + quizResultRecordData.getCode ();
		} catch (SaveQuizResultRecordException e) {
			LOG.error (e.getMessage());
			model.addAttribute("errorMsg", "trainingModuleSubmit.internal.error");
		}
		return REDIRECT_PREFIX + TRAINING_MODULE_PERFORM_CMS_PAGE;
	}


	private String getContentPage(Model model, String cmsPageName) throws CMSItemNotFoundException {
		final ContentPageModel cmsPage = getContentPageForLabelOrId ( cmsPageName );
		storeCmsPageInModel ( model, cmsPage );
		setUpMetaDataForContentPage ( model, cmsPage );
		model.addAttribute( WebConstants.BREADCRUMBS_KEY, contentPageBreadcrumbBuilder.getBreadcrumbs(cmsPage));
		model.addAttribute ( ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW );
		setUpMetaData ( model, null, cmsPage.getMetaDescription () );
		return getViewForPage ( model );
	}


}
