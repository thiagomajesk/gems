/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    extend: {
      transitionTimingFunction: {
        spring: "cubic-bezier(0.5, 1.8, 0.3, 0.8)",
      },
    },
  },
};
