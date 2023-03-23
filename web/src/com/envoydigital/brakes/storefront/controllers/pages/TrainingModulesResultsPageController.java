package com.envoydigital.brakes.storefront.controllers.pages;

import com.envoydigital.brakes.core.model.QuizResultRecordModel;
import com.envoydigital.brakes.core.services.impl.GenerateQuizCertificateException;
import com.envoydigital.brakes.core.services.impl.QuizResultAuthorizationException;
import com.envoydigital.brakes.facades.quiz.QuizFacade;
import com.envoydigital.brakes.facades.quiz.data.QuizResultRecordData;
import com.envoydigital.brakes.facades.quiz.impl.QuizResultSearchPageEvaluator;
import com.envoydigital.brakes.facades.quiz.impl.QuizSearchContext;
import com.envoydigital.brakes.facades.search.impl.SearchContext;
import com.envoydigital.brakes.storefront.forms.TrainingModulesResultsForm;
import de.hybris.platform.acceleratorstorefrontcommons.annotations.RequireHardLogIn;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.ThirdPartyConstants;
import de.hybris.platform.acceleratorstorefrontcommons.controllers.pages.AbstractPageController;
import de.hybris.platform.cms2.exceptions.CMSItemNotFoundException;
import de.hybris.platform.cms2.model.pages.ContentPageModel;
import de.hybris.platform.core.servicelayer.data.SearchPageData;
import de.hybris.platform.servicelayer.i18n.I18NService;
import de.hybris.platform.servicelayer.search.paginated.constants.SearchConstants;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.*;
import java.util.stream.Stream;


/**
 * @author thomas.domin
 */
@Controller
@RequestMapping(value = "**/" + TrainingModulesResultsPageController.TRAINING_MODULES_RESULTS_CMS_PAGE)
public class TrainingModulesResultsPageController extends AbstractPageController {

    private static final Logger LOG = LoggerFactory.getLogger ( TrainingModulesResultsPageController.class );

    public static final String TRAINING_MODULES_RESULTS_CMS_PAGE = "training-modules-results";

    @Resource
    private QuizResultSearchPageEvaluator quizResultSearchPageEvaluator;

    @Resource(name = "messageSource")
    private MessageSource messageSource;

    @Resource(name = "i18nService")
    private I18NService i18nService;

    @Resource(name = "quizFacade")
    private QuizFacade quizFacade;


    @RequireHardLogIn
    @RequestMapping(method = RequestMethod.GET)
    public String trainingModulesResultsPage(final Model model)
            throws CMSItemNotFoundException {

        model.addAttribute ( "quizResultsPageData", performQuizResultsPage ( null, null, 0, SearchContext.ShowMode.Page ) );

        return getContentPage ( model, TRAINING_MODULES_RESULTS_CMS_PAGE );
    }

    @RequireHardLogIn
    @RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody
    ResponseEntity<SearchPageData<QuizResultRecordData>> getQuizResults(
            @Valid final TrainingModulesResultsForm trainingModulesResultsForm,
            final BindingResult bindingResult)
    {
        if (bindingResult.hasErrors ()) {
            return new ResponseEntity (  createErrorMessagesData (bindingResult.getFieldErrors ()), HttpStatus.OK );
        }

        SearchPageData<QuizResultRecordData> searchPageData =
                performQuizResultsPage (
                        trainingModulesResultsForm.getStartDate (),
                        trainingModulesResultsForm.getEndDate (),
                        0,
                        SearchContext.ShowMode.Page
                );

        return new ResponseEntity ( searchPageData, HttpStatus.OK );
    }

    @RequireHardLogIn
    @RequestMapping(value = "/certificate", method = RequestMethod.GET, produces = MediaType.APPLICATION_PDF_VALUE)
    public @ResponseBody ResponseEntity<byte[]> downloadCertificate(@RequestParam final String resultCode)
    {
        try {

            byte[] output = quizFacade.getCertificateAsPdf ( resultCode );

            HttpHeaders responseHeaders = new HttpHeaders();
            responseHeaders.setContentType(MediaType.APPLICATION_PDF);
            responseHeaders.setContentLength(output.length);
            responseHeaders.set(HttpHeaders.CONTENT_DISPOSITION, String.format("attachment; filename=certificate-%s.pdf", new Date ().getTime ()) );

            return new ResponseEntity(output, responseHeaders, HttpStatus.OK);

        } catch (QuizResultAuthorizationException | GenerateQuizCertificateException e) {
            LOG.error ("Download certificate: ", e);
            final String uriLocation = ServletUriComponentsBuilder.fromCurrentRequest ()
                    .replaceQuery ( StringUtils.EMPTY )
                    .build ()
                    .toUriString ()
                    .replace("/certificate", "/404");
            return ResponseEntity.status(HttpStatus.FOUND).header(HttpHeaders.LOCATION, uriLocation).build();
        }
    }

    private String getContentPage(Model model, String cmsPageName) throws CMSItemNotFoundException {
        final ContentPageModel cmsPage = getContentPageForLabelOrId ( cmsPageName );
        storeCmsPageInModel ( model, cmsPage );
        setUpMetaDataForContentPage ( model, cmsPage );
        model.addAttribute ( ThirdPartyConstants.SeoRobots.META_ROBOTS, ThirdPartyConstants.SeoRobots.NOINDEX_NOFOLLOW );
        setUpMetaData ( model, null, cmsPage.getMetaDescription () );
        return getViewForPage ( model );
    }

    protected SearchPageData<QuizResultRecordData> performQuizResultsPage(final Date startDate, final Date endDate, final int page, final SearchContext.ShowMode showMode) {
        QuizSearchContext searchContext = new QuizSearchContext ( startDate, endDate, page, showMode, Collections.singletonMap ( QuizResultRecordModel.DATE, SearchConstants.ASCENDING ) );
        return quizResultSearchPageEvaluator.doSearch (searchContext);
    }

    private Map<String, String> createErrorMessagesData(final List<FieldError> fieldErrors) {
        final LinkedHashMap errorMessages = new LinkedHashMap<> ();

        for( FieldError fieldError : fieldErrors ) {
            Optional.ofNullable ( fieldError )
                    .map ( FieldError::getCodes )
                    .map ( Arrays::stream )
                    .flatMap ( Stream::findFirst )
                    .ifPresent ( code -> errorMessages.put ( fieldError.getField (), messageSource.getMessage ( code, null, i18nService.getCurrentLocale () ) ) );

        }
        return errorMessages;
    }

}
