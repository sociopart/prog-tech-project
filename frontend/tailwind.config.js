/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./pages/index.html"],
  theme: {
    fontFamily: {
      'sans': ['Your Font Name', 'system-ui', '-apple-system', 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', 'sans-serif'],
      'serif': ['Your Font Name', 'Georgia', 'Cambria', 'Times New Roman', 'Times', 'serif'],
      'mono': ['Your Font Name', 'Menlo', 'Monaco', 'Consolas', 'Liberation Mono', 'Courier New', 'monospace']
    },
    colors:{
      mainPurple: '#60435F',
      lightBrown: '#6F6262',
      usualWhite: '#FDF7FA',
      vkBlue: '#0077FF',
      casualBlack: '#333333',
      lightBlue: '#50E7DE',
      lightGrey: '#C0C0C0'
    },
    extend: {
      
    },
  },
  plugins: [],
}

