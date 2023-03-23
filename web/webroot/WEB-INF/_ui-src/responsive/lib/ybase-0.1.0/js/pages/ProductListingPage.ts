import ReadMoreLess from '../components/ReadMoreLess/ReadMoreLess';
import Facets from '../components/Facets/Facets';

import facets from '../acc.facets';

const ACC = window.ACC as Window;

Object.assign(ACC, {
  facets
});

ReadMoreLess('.read-more-less');
Facets();
