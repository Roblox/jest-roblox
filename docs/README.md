# Website

This website is built using [Docusaurus 3](https://docusaurus.io/), a modern static website generator.

## Installation

```console
npm install
```

## Local Development

```console
npm start
```

This command starts a local development server and open up a browser window. Most changes are reflected live without having to restart the server.

## Build

```console
npm run build
```

This command generates static content into the `build` directory and can be served using any static contents hosting service.

## Deployment

Pushing a `v*` tag on `Roblox/jest-roblox` publishes https://roblox.github.io/jest-roblox/ from that commit via `.github/workflows/docs.yml`. Use **Actions → Deploy Docs → Run workflow** for a one-off deploy (docs-only fixes, or the first publish before tags resume).

Bump `VERSION` in `docusaurus.config.js` in the same change as the package version so the navbar matches the tag.
