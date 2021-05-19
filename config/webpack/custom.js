const customConfig = {
  // resolve: {
  //   extensions: [".svg", ".png", ".ico", ".gif", ".css", ".scss", ".js"]
  // },
  module: {
    rules: [
      {
        test: /\.(scss|sass|css)$/i,
        use: [
          { loader: "style-loader" }, // inject CSS into the DOM
          { loader: "css-loader" },   // interprets @import and url() like import/require() and will resolve them into JS
          { loader: "sass-loader" }   // loads a Sass/SCSS file and compiles it to CSS
        ]
      },
      {
        test: /\.(svg|png|jpg|ico|gif)$/i,
        type: "asset/resource"
      }
    ]
  }
};
