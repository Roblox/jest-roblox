# Contributing to Jest Roblox
Thanks for considering contributing to Jest Roblox! This guide has a few tips and guidelines to make contributing to the project as easy as possible.

## Bug Reports
Any bugs (or things that look like bugs) can be reported on the [GitHub issue tracker](https://github.com/Roblox/jest-roblox-internal/issues).

If possible, file an issue or create a pull request to fix the bug in upstream [Jest](https://github.com/facebook/jest) and link to it here.

Make sure you check to see if someone has already reported your bug first! Don't fret about it; if we notice a duplicate we'll send you a link to the right issue!

## Working on Jest Roblox
To get started working on Jest Roblox, you'll need:
* Git
* Lua 5.1
* NPM
* Rust

### Adding Modules
Run `bin/bootstrap.sh PACKAGE_NAME` to initialize a new module under the `src/Modules` directory.

New modules must:
* Be aligned to the [v27.4.7](https://github.com/facebook/jest/tree/v27.4.7/packages) version of Jest
* Have a README.md file with notes about the translation
* All deviations are notated in code with `-- ROBLOX deviation: comment`
* Translated files include a comment with a link to the upstream file at the top
* Translated files use Luau strict mode if possible, else nonstrict mode
* Pass all translated upstream tests and all existing tests

### Running Tests

You need to create a GitHub Access Token:
* GitHub.com → Settings → Developer Settings → Personal Access Tokens
* On that same page, you then need to click Enable SSO
* BE SURE TO COPY THE ACCESS TOKEN SOMEWHERE 

```
npm login --registry=https://npm.pkg.github.com/ --scope=@roblox
```
For your password here, you will enter the GitHub Access Token from the instructions above.

```
npm install --global @roblox/rbx-aged-cli
```

Before you can use rbx-aged-cli, you need to be logged into the VPN so the Artifactory repository is accessible.

```
mkdir ~/bin
rbx-aged-cli download roblox-cli --dst ~/bin
export PATH=$PATH:~/bin
roblox-cli --help
git clone git@github.com:Roblox/jest-roblox-internal.git
cd jest-roblox
```

Foreman uses Rust, so you'll have to install Rust first.

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH=$PATH:$HOME/.cargo/bin
cargo install foreman
foreman github-auth  # your auth token should be in your ~/.npmrc
foreman install
export PATH=$PATH:~/.foreman/bin/
```

Run `rotrieve install` to install our dependencies.

Now you can run the tests, edit code, and contribute!

```
bin/ci.sh
```

### Code Style
Try to match the existing code style! In short:

* Tabs for indentation
* Double quotes
* One statement per line

### Changelog
Adding an entry to [CHANGELOG.md](CHANGELOG.md) alongside your commit makes it easier for everyone to keep track of what's been changed.

Add a line under an "Unreleased Changes" heading. When we make a new release, all of those bullet points will be attached to a new version and the "Unreleased Changes" section will be removed.

### Tests
When submitting a bug fix, create a test that verifies the broken behavior and that the bug fix works. This helps us avoid regressions!