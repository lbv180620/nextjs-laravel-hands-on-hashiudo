/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      opacity: ["disabled"],
    },
  },
  plugins: [],
  corePlugins: {
    preflight: true,
  },
}
