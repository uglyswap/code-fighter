# @code-fighter/react-vite-component-tagger

A Vite plugin that automatically adds `data-code-fighter-id` and `data-code-fighter-name` attributes to your React components. This is useful for identifying components in the DOM, for example for testing or analytics.

## Installation

```bash
npm install @code-fighter/react-vite-component-tagger
# or
yarn add @code-fighter/react-vite-component-tagger
# or
pnpm add @code-fighter/react-vite-component-tagger
```

## Usage

Add the plugin to your `vite.config.ts` file:

```ts
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import codeFighterTagger from "@code-fighter/react-vite-component-tagger";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), codeFighterTagger()],
});
```

The plugin will automatically add `data-code-fighter-id` and `data-code-fighter-name` to all your React components.

The `data-code-fighter-id` will be a unique identifier for each component instance, in the format `path/to/file.tsx:line:column`.

The `data-code-fighter-name` will be the name of the component.

## Testing & Publishing

Bump it to an alpha version and test in Code Fighter app, eg. `"version": "0.0.1-alpha.0",`

Then publish it:

```sh
cd packages/@code-fighter/react-vite-component-tagger/ && npm run prepublishOnly && npm publish
```

Update the scaffold like this:

```sh
cd scaffold && pnpm remove @code-fighter/react-vite-component-tagger && pnpm add -D @code-fighter/react-vite-component-tagger
```

Run the E2E tests and make sure it passes.

Then, bump to a normal version, e.g. "0.1.0" and then re-publish. We'll try to match the main Code Fighter app version where possible.
