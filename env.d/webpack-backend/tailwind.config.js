module.exports = {
    mode: "jit",
    purge: ["./resources/**/*.{js,jsx,ts,tsx}", "./public/**/*.{js,jsx,ts,tsx}"],
    darkMode: false, // or 'media' or 'class'
    theme: {
        extend: {},
    },
    variants: {
        extend: {},
    },
    plugins: [],
}

// v3
// module.exports = {
//     mode: "jit",
//     content: ["./src/**/*.{js,jsx,ts,tsx}", "./public/**/*.{js,jsx,ts,tsx}"],
//     darkMode: 'media', // or 'media' or 'class'
//     theme: {
//         extend: {},
//     },
//     variants: {
//         extend: {},
//     },
//     plugins: [],
// }
