# [Gatsby Example](https://www.gatsbyjs.org/)

### ⚽️ Running in the browser

1. Create Expo project `expo init`
2. Install the plugin: `yarn add react-native-web gatsby-plugin-react-native-web` or `npm install --save react-native-web gatsby-plugin-react-native-web`
3. Create a `gatsby-config.js` and use the plugin:
   [`gatsby-config.js`](./gatsby-config.js)

   ```js
   module.exports = {
     plugins: [
       `gatsby-plugin-react-native-web`,
       /* ... */
     ],
   }
   ```

4. Install the babel preset for React Native web: `yarn add --dev babel-preset-expo` or `npm install --save-dev babel-preset-expo`

5. Create a `babel.config.js` and use the Babel preset:
   [`babel.config.js`](./babel.config.js)

   ```js
   module.exports = { presets: ['babel-preset-expo'] }
   ```

6. Add `/.cache` and `/public` to your [`.gitignore`](./.gitignore)
7. Run `yarn gatsby develop` to try it out!


### 🏁 New Commands

- **Starting web**
  - 🚫 `expo start:web`
  - ✅ `yarn gatsby develop`

- **Building web**
  - 🚫 `expo build:web`
  - ✅ `yarn gatsby build`

- **Serving your static project**
  - 🚫 `serve web-build`
  - ✅ `yarn gatsby serve`

### 👀 More Info

- Related: [Expo support PR](https://github.com/slorber/gatsby-plugin-react-native-web/pull/14)