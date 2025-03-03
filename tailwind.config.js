/* eslint-disable no-undef */
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'class',
  content: [
    'app/helpers/**/*.rb',
    'app/views/**/*.{html,html.erb,erb,js,ts,rb,slim,html.slim}',
    'app/frontend/**/*.{js,jsx,ts,tsx,vue}',
    'app/frontend/**/**/*.{js,jsx,ts,tsx,vue}',
    'app/frontend/entrypoints/*.js',
    'app/frontend/stylesheets/*.scss',
    'app/frontend/images/icons/*.svg',
    'config/initializers/simple_form.rb',
    'config/initializers/simple_form_daisyui.rb',
    'app/views/**/**/*.{html,html.erb,erb,js,ts,rb,slim,html.slim}',
    'app/views/devise/**/*.html.slim',
    'app/views/layouts/*.{html,html.erb,erb,js,ts,rb,slim,html.slim}',
  ],
  theme: {
    extend: {},
  },
  plugins: [require('daisyui')],
  daisyui: {
    themes: ['light', 'dark'],
  },
};
