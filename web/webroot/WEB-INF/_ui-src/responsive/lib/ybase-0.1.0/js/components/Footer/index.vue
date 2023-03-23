<script setup lang="ts">
import 'lazysizes';

interface Props {
  footerData: {
    prop: string;
    url: string;
  };
}

const props = defineProps<Props>();
const data = props.footerData;
</script>

<template>
  <footer>
    <div class="container-fluid">
      <input type="checkbox" id="heading-AboutUsNavNode" name="footer-accordion" autocomplete="off" />
      <input type="checkbox" id="heading-OurRangeNavNode" name="footer-accordion" autocomplete="off" />
      <input type="checkbox" id="heading-DiscoverUsNavNode" name="footer-accordion" autocomplete="off" />
      <input type="checkbox" id="heading-HelpSupportNavNode" name="footer-accordion" autocomplete="off" />
      <div class="footer__section-wrapper">
        <div class="footer__section">
          <label role="heading" aria-level="4" for="heading-AboutUsNavNode" class="footer__heading"
            >Our Business<i class="icon icon-chevron"></i
          ></label>
          <ul class="footer__link-list">
            <li class="yCmsComponent footer__link">
              <a href="/why-brakes" title="Why Brakes">Why Brakes</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/why-brakes/sustainability" title="Sustainability">Sustainability</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="https://www.brakescareers.co.uk/" title="Careers" target="_blank" rel="noopener noreferrer">Careers</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="https://www.sysco.com/" title="Sysco" target="_blank" rel="noopener noreferrer">Sysco</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a
                href="https://brakes.a.bigcontent.io/v1/static/Modern_Slavery_Statement_Brakes_June_2022"
                title="Modern Slavery Statement"
                target="_blank"
                rel="noopener noreferrer"
                >Modern Slavery Statement</a
              >
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/policies/gender-pay-gap" title="Gender Pay Gap">Gender Pay Gap</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a
                href="https://brakes.a.bigcontent.io/v1/static/BRAKE-BROS-LIMITED-Annual_Report_2019"
                title="Annual Report 2019"
                target="_blank"
                rel="noopener noreferrer"
                >Annual Report 2019</a
              >
            </li>
            <li class="yCmsComponent footer__link">
              <a href="https://www.mealsandmore.co.uk" title="Meals &amp; More" target="_blank" rel="noopener noreferrer">Meals &amp; More</a>
            </li>
          </ul>
        </div>
        <div class="footer__section">
          <label role="heading" aria-level="4" for="heading-OurRangeNavNode" class="footer__heading"
            >Explore Our Range<i class="icon icon-chevron"></i
          ></label>
          <ul class="footer__link-list">
            <li class="yCmsComponent footer__link">
              <a href="/shop-our-brands" title="Brands">Brands</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/inspirational-food/category" title="Food Categories">Food Categories</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/inspirational-food/special-occasions" title="Food Occasions">Food Occasions</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/promotions" class="nav__link--highlighted" title="Promotions">Promotions</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/inspirational-food/menu-ideas/recipes" title="Recipes">Recipes</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/why-brakes/your-sector" title="Sector Specialists">Sector Specialists</a>
            </li>
          </ul>
        </div>
        <div class="footer__section">
          <label role="heading" aria-level="4" for="heading-DiscoverUsNavNode" class="footer__heading"
            >Our Website<i class="icon icon-chevron"></i
          ></label>
          <ul class="footer__link-list">
            <li class="yCmsComponent footer__link">
              <a href="/party-calculator" title="Party Calculator">Party Calculator</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/gross-profit-calculator" title="Gross Profit Calculator">Gross Profit Calculator</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/supplier-information-and-isupply" title="Supplier Info &amp; iSupply">Supplier Info &amp; iSupply</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/policies" title="Policies">Policies</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/news" title="News">News</a>
            </li>
          </ul>
        </div>
        <div class="footer__section">
          <label role="heading" aria-level="4" for="heading-HelpSupportNavNode" class="footer__heading"
            >Customer Care<i class="icon icon-chevron"></i
          ></label>
          <ul class="footer__link-list">
            <li class="yCmsComponent footer__link">
              <button id="" type="button" class="js-popover-loading nav__button">FAQ</button>
            </li>
            <li class="yCmsComponent footer__link">
              <button id="" type="button" class="js-popover-loading nav__button">Help Guides</button>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/help/my-brakes-online-ordering" title="mybrakes">mybrakes</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/become-a-customer-eligible" title="Become A Customer">Become A Customer</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/help/contact-us" title="Contact Us">Contact Us</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/help/contact-us" title="Media queries">Media queries</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a href="/waste-oil-collection" title="Waste Oil Collection">Waste Oil Collection</a>
            </li>
            <li class="yCmsComponent footer__link">
              <a class="ot-sdk-show-settings" title="Cookie settings">Cookies Settings</a>
            </li>
          </ul>
        </div>
      </div>

      <div class="row">
        <div class="footer__bottom nope">
          <div class="col-md-12 text-center">
            <div class="banner__component simple-banner">
              <a tabindex="0" href="https://twitter.com/brakes_food" target="_blank"
                ><img
                  title="Twitter"
                  alt="Twitter"
                  src="/medias/twitter.svg?context=bWFzdGVyfGltYWdlc3w4NzF8aW1hZ2Uvc3ZnK3htbHxoNWYvaDg0Lzg3OTYxNDAzMzkyMzAvdHdpdHRlci5zdmd8M2Y4Zjc0YTM1NjNjY2M0YzU1NmRlZThiODNjZDY1ZWQ4ODZlN2RmMzgxYzk4YjhjNTVmNmVkYzk4NWMyMGQ4OA"
              /></a>
            </div>
            <div class="banner__component simple-banner">
              <a tabindex="0" href="https://www.facebook.com/BrakesFood/" target="_blank"
                ><img
                  title="Facebook"
                  alt="Facebook"
                  src="/medias/facebook.svg?context=bWFzdGVyfGltYWdlc3wzNjF8aW1hZ2Uvc3ZnK3htbHxoNmYvaDg3Lzg3OTYxNDA0MDQ3NjYvZmFjZWJvb2suc3ZnfDlhMGFmNzVlZmM3ZGJkNTdmMTY0ZmU2OTcwMWM0YjVjZDJlOTAyZWI2NGVmOTI5NjVjZDUzYWFmMzAxZWMxZDM"
              /></a>
            </div>
            <div class="banner__component simple-banner">
              <a tabindex="0" href="https://www.instagram.com/brakesfood/" target="_blank"
                ><img
                  title="Instagram"
                  alt="Instagram"
                  src="/medias/instagram.svg?context=bWFzdGVyfGltYWdlc3wxMDAyfGltYWdlL3N2Zyt4bWx8aGM4L2g4NC84Nzk2MTQwMzcxOTk4L2luc3RhZ3JhbS5zdmd8M2M3MjU1NDM1MjVlZTdiNWRkYzhhNDkzZDM1OTJhNzRlNDZhMGIwMDJlNDlkNmVkOTc0NjRkZTU4MTdhN2JjNw"
              /></a>
            </div>
            <div class="content">
              <p>© Brakes 2023 | Brake Bros Ltd.</p>

              <p>Registered office: Enterprise House, Eureka Business Park, Ashford, Kent, TN25 4AG. Registered in England No. 02035315</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>
