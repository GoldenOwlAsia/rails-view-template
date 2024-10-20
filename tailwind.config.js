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
    'app/frontend/components/**/**/*.{rb,slim,html.slim,js,scss}',
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
    themes: [
      'light',
      'dark',
      'cupcake',
      'bumblebee',
      'emerald',
      'corporate',
      'synthwave',
      'retro',
      'cyberpunk',
      'valentine',
      'halloween',
      'garden',
      'forest',
      'aqua',
      'lofi',
      'pastel',
      'fantasy',
      'wireframe',
      'black',
      'luxury',
      'dracula',
      'cmyk',
      'autumn',
      'business',
      'acid',
      'lemonade',
      'night',
      'coffee',
      'winter',
      'dim',
      'nord',
      'sunset',
    ],
  },
};
