# Contributing

Pull requests are squash-merged, so the pull request title becomes the commit on `main` and drives
the next version. The title must be a valid [Conventional Commit][conventional-commits]; CI rejects
it otherwise.

Allowed types: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `perf`, `build`, `ci`, `style`,
`revert`.

- `fix:` triggers a patch release.
- `feat:` triggers a minor release.
- A `feat!:` prefix or a `BREAKING CHANGE:` footer triggers a major release.

Before opening a pull request, run the checks locally from the module directory:

```sh
wippy lint --level error
wippy test
```

[conventional-commits]: https://www.conventionalcommits.org
