import template from './template';

export default (data: any, App: any) => {
  const obj = { ...data };
  const component = document.getElementById(obj.id);
  const intersection = new IntersectionObserver((entries) => {
    entries.map((entry) => {
      if (entry.isIntersecting) {
        template(obj, App);
        intersection.unobserve(entry.target);
        return true;
      }
      return false;
    });
  });

  return component && intersection.observe(component);
};
