import Autocomplete from './components/Autocomplete/Autocomplete';
import Popover from './components/Popover/Popover';
import RedirectSaleForce from './components/RedirectSaleForce/RedirectSaleForce';
import ProductCarouselVue from './components/ProductCarouselVue/ProductCarouselVue';
import LoginPopover from './components/LoginPopover/LoginPopover';

import Acc from './acc';
import _autoload from './_autoload';

Autocomplete();
Popover();
RedirectSaleForce();
ProductCarouselVue(ACC.config as object);
LoginPopover();
Acc();
_autoload();
