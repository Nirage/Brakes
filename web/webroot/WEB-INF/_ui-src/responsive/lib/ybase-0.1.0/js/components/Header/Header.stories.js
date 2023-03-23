import Header from './index';

import * as AutocompleteStories from '../Autocomplete/Autocomplete.stories';

export default {
  title: 'Brakes/Header',
  component: Header,
  parameters: {
    layout: 'fullscreen'
  }
};

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { Header },
  template: '<Header :user="user" @onLogin="onLogin" @onLogout="onLogout" @onCreateAccount="onCreateAccount" />'
});

export const LoggedIn = Template.bind({});
LoggedIn.args = {
  user: {
    name: 'Jane Doe'
  },
  ...AutocompleteStories.Default.args
};

export const LoggedOut = Template.bind({});
LoggedOut.args = {
  ...AutocompleteStories.Default.args
};
