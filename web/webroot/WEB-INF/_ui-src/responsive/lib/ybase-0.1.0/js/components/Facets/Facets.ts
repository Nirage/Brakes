export default () => {
  const d = document;
  const { body } = d;
  const facetOverlay = d.getElementById('facet-overlay') as HTMLDivElement;

  if (!facetOverlay) return;

  const { classList, dataset } = facetOverlay;
  const type = dataset['animationType'] as string;
  const direction = dataset['animationDirection'] as string;
  const animateInClass = `${type}-in-${direction}` as string;
  const animateOutClass = `${type}-out-${direction}` as string;

  let firstTrigger = true;

  d.getElementById('facet-filter')?.addEventListener('click', (): void => {
    const { facets } = ACC;
    classList.remove('hide', animateOutClass);
    classList.add(animateInClass);
    body.classList.add('overflow-hide');
    if (firstTrigger) {
      facets.checkSubcategory();
      facets.setNutsAllergens();
      firstTrigger = false;
    }
  });

  body.querySelectorAll('.facet--close')?.forEach((el): void => {
    el.addEventListener('click', (): void => {
      classList.remove(animateInClass);
      classList.add(animateOutClass);
      body.classList.remove('overflow-hide');
      setTimeout(() => classList.add('hide'), 300);
      const applyButton = facetOverlay.querySelector('.js-facetsApply') as HTMLButtonElement;
      applyButton.disabled = true;
      body.style.overflow = '';
    });
  });

  d.getElementById('additionalCategory')?.addEventListener('change', (e): void => {
    const target = e.target as HTMLSelectElement;
    const { selectedIndex } = target;
    const href = target?.options[selectedIndex] as HTMLOptionElement;
    window.location.href = href?.value;
  });
};
