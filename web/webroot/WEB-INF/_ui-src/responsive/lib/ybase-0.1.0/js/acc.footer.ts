const footer = {
  _autoload: ['init'],
  init(): void {
    const footer = document.querySelector('footer') as HTMLElement;
    this.footerAccordion(footer);
  },
  footerAccordion(footer: HTMLElement): void {
    const radio = footer.querySelectorAll('input[name="footer-accordion"]') as NodeListOf<HTMLInputElement>;

    footer.addEventListener('click', (event: MouseEvent): void => {
      const target = event.target as HTMLInputElement;
      if (target.type === 'checkbox' && target.name === 'footer-accordion') {
        radio.forEach((radioElement) => {
          if (radioElement.id !== target.id) radioElement.checked = false;
        });
      }
    });
  }
};

export default footer;
