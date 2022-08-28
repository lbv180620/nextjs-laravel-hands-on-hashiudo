module.exports = api => {
    const isProd = api.env("production");
    api.cache(true);

    return {
        "presets": [
            [
                "@babel/preset-env",
                {
                    targets: [
                        "last 1 versions",
                        "> 1%",
                        "maintained node versions",
                        "not dead"
                    ],
                    useBuiltIns: "usage",
                    corejs: 3
                }
            ],
            [
                "@babel/preset-react",
                {
                    targets: {
                        node: "current"
                    },
                    runtime: "automatic",
                    importSource: "@emotion/react"
                }
            ],
            isProd && [
                "minify",
                // production mode の時に console.log を削除する
                {
                    removeConsole: {
                        exclude: ["error", "info"],
                    }
                }
            ]
        ].filter(Boolean),
        "plugins": [
            "@babel/plugin-transform-runtime",
            "@emotion/babel-plugin"
        ]
    };
};
