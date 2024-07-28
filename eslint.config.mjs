import globals from "globals";
import pluginJs from "@eslint/js";
import pluginReact from "eslint-plugin-react";

export default [
  {
    files: ["**/*.{js,mjs,cjs,jsx}"],
    settings: {
      react: {
        version: "detect",
      },
    },
  },
  { languageOptions: { globals: { ...globals.browser, ...globals.node } } },
  pluginJs.configs.recommended,
  pluginReact.configs.flat.recommended,
  {
    ignores: [
      ".cache/",
      ".yarn/",
      "app/assets/builds/*",
      "db/",
      "docs/",
      "lib/",
      "log/*",
      "node_modules/",
      "public/assets/*",
      "spec/",
      "storage/",
      "tmp/",
      "vendor/",
    ],
  },
];
