export default (element: HTMLElement) => {
  const { clientWidth, clientHeight, scrollWidth, scrollHeight } = element;
  return scrollHeight - 1 > clientHeight || scrollWidth > clientWidth;
};
