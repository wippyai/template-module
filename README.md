<p align="center">
    <a href="https://wippy.ai" target="_blank">
        <picture>
            <source media="(prefers-color-scheme: dark)" srcset="https://github.com/wippyai/.github/blob/main/logo/wippy-text-dark.svg?raw=true">
            <img width="30%" align="center" src="https://github.com/wippyai/.github/blob/main/logo/wippy-text-light.svg?raw=true" alt="Wippy logo">
        </picture>
    </a>
</p>
<h1 align="center">Wippy Module Template</h1>
<div align="center">

[![License](https://img.shields.io/github/license/wippyai/template-module?style=flat-square)](LICENSE)
[![Documentation](https://img.shields.io/badge/Wippy-Documentation-brightgreen.svg?style=flat-square)][wippy-documentation]

</div>

A template for building, testing, and publishing a [Wippy][wippy] module. It ships GitHub Actions
that lint and test the module on every pull request, then automatically version and publish it to
the [Wippy registry][modules-registry] on every merge to `main`, driven by
[Conventional Commits][conventional-commits].

The repository is itself a working example module (a `greeting` library plus a test) so its own CI
is green out of the box. Replace the example with your code.

## What you get

- Lint and test on every pull request, using the `wippy` CLI from the [runtime][runtime].
- The pull request title is enforced to be a valid Conventional Commit.
- Automated semantic versioning and registry publishing via [release-please][release-please].
- A single source of truth: the heavy lifting lives in reusable workflows hosted here; modules
  call them by reference, so the pipeline is updated in one place for every module.

## Versioning

The version lives in `wippy.yaml` and is bumped automatically from the Conventional Commit
messages merged since the last release:

| Commit | Bump | Example |
| --- | --- | --- |
| `fix:` | patch | `1.2.3` to `1.2.4` |
| `feat:` | minor | `1.2.3` to `1.3.0` |
| `feat!:` or a `BREAKING CHANGE:` footer | major | `1.2.3` to `2.0.0` |
| `chore:`, `docs:`, `refactor:`, `test:`, `ci:`, ... | none on their own | no release |

Because merges use squash, the pull request title becomes the commit message, which is why a valid
Conventional Commit title is required.

Pre-1.0 note: by default a breaking change on a `0.x` module bumps to `1.0.0`. To remain in `0.x`,
add `"bump-minor-pre-major": true` to `release-please-config.json`.

## How a release happens

1. Merge pull requests to `main` as usual.
2. release-please opens and maintains a release pull request that bumps `version` in `wippy.yaml`,
   updates `CHANGELOG.md`, and updates `.release-please-manifest.json`.
3. Merge the release pull request. release-please creates the git tag and GitHub release, and the
   same workflow run then executes `wippy publish`, pushing the new immutable version to the
   registry. (Publishing happens in the same run, so it does not depend on the tag event.)

## Use this template for a new module

1. Click "Use this template".
2. In `wippy.yaml`, set `organization`, `module`, and `description`. Keep `version` at `0.0.0` and
   keep `.release-please-manifest.json` at `0.0.0`; release-please takes over from there.
3. Rename the namespace in `src/_index.yaml` and `src/test/_index.yaml`, and update the `exclude`
   entry pattern in `wippy.yaml` so it matches your test namespace (it keeps test-only entries out
   of the published artifact).
4. Set `package-name` in `release-please-config.json`.
5. Replace the example `greeting` library and `src/test` with your own entries and tests. Update
   `src/README.md`, which is the registry-facing README referenced by the `ns.definition` entry.
6. Add a `WIPPY_TOKEN` repository secret (a registry token). Optionally add `WIPPY_REGISTRY` to
   target a non-default registry.
7. `.github/workflows/ci.yml` and `release.yml` already call the central reusable workflows at
   `wippyai/template-module@v1`. You may delete `self-test.yml` and the two `reusable-*.yml`
   files; they only run inside this template repository.

## Migrate an existing module

Add the following to your module repository and open a pull request:

- `wippy.yaml` with `organization`, `module`, `version`, the `ns.definition` README reference, and
  any `exclude` patterns for test-only entries.
- `release-please-config.json` (set `package-name` to your module) and
  `.release-please-manifest.json`, seeding the manifest with the module's current published version.
- `.github/workflows/ci.yml` and `.github/workflows/release.yml` copied from this template (they
  reference `wippyai/template-module@v1`).
- A `WIPPY_TOKEN` repository secret.

## Notes

- The release pull request is opened by `GITHUB_TOKEN`, so `pull_request` workflows do not run on
  it. Do not make the CI or PR-title checks required status checks on the release pull request, or
  it will be unmergeable; otherwise use a PAT for release-please.
- CI downloads the `wippy` binary from public `wippyai/runtime` releases using the repository
  `GITHUB_TOKEN`.

## Maintaining this template

The reusable workflows are consumed at `wippyai/template-module@v1`. Releasing the template means
pushing a `vX.Y.Z` tag on `main`; `tag-major.yml` then moves the floating `v1` tag to it, so
consumers pinned to `@v1` pick up the change. Create the first `v1` line with:

```sh
git tag v1.0.0 && git push origin v1.0.0
```

## Local development

Install the `wippy` CLI by downloading a release binary from [runtime releases][runtime-releases],
then from the module directory:

```sh
wippy lint --level error
wippy test
wippy publish --dry-run --version 0.1.0
```

## Layout

```
.
├── .github/workflows/
│   ├── ci.yml               # calls the reusable CI on pull requests and pushes
│   ├── release.yml          # calls the reusable release on pushes to main
│   ├── reusable-ci.yml      # lint, test, and PR-title check (reusable)
│   ├── reusable-release.yml # release-please and publish (reusable)
│   ├── self-test.yml        # runs the reusable CI against this template only
│   └── tag-major.yml        # moves the v1 tag when a vX.Y.Z tag is pushed (template only)
├── release-please-config.json
├── .release-please-manifest.json
├── wippy.yaml               # module manifest (organization, module, version)
├── wippy.lock               # dependency lock
└── src/                     # module source and tests
```

[wippy]: https://wippy.ai
[wippy-documentation]: https://docs.wippy.ai
[modules-registry]: https://modules.wippy.ai
[conventional-commits]: https://www.conventionalcommits.org
[release-please]: https://github.com/googleapis/release-please
[runtime]: https://github.com/wippyai/runtime
[runtime-releases]: https://github.com/wippyai/runtime/releases
