import isOverflow from '../../utils/isOverflow';

export default (compString: string) => {
  const readMoreLess = document.querySelector(compString) as HTMLDivElement;
  const twoLineElement = readMoreLess?.querySelector(`${compString}__paragraph`) as HTMLDivElement;

  if (twoLineElement && isOverflow(twoLineElement)) {
    const readMoreButton = readMoreLess?.querySelector(`${compString}__buttons`) as HTMLButtonElement;
    readMoreButton?.classList.remove('hide');
  }
};
