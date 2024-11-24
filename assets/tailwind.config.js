// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

import themes from "./themes";

const daisyui = {
  themes: themes,
};

module.exports = {
  content: ["./js/**/*.js", "../lib/gems_web.ex", "../lib/gems_web/**/*.*ex"],
  theme: { extend: {} },
  plugins: [require("@tailwindcss/typography"), require("daisyui")],
  daisyui: daisyui
};
