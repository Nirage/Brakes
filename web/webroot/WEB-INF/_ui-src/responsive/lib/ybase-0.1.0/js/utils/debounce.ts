export default (func: Function, wait: number) => {
  let timeout: any;
  return function () {
    // @ts-ignore: Unreachable code error
    const context = this;
    const args = arguments;
    clearTimeout(timeout);
    timeout = setTimeout(() => func.apply(context, args), wait);
  };
};
