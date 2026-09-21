# popzxc personal blog

Personal blog at <https://popzxc.github.io>, built with Zola 0.23.3.

## Local development

```sh
zola serve
```

Open <http://127.0.0.1:1111>. Zola rebuilds and reloads the site when files change.

The minimal dark theme lives in `templates/` and `static/site.css`. It uses system
fonts and Zola's built-in syntax highlighting, with no JavaScript, external theme,
or additional build dependencies. Site settings and social links are in `zola.toml`.

## Writing posts

Add a Markdown file under `content/posts/`, for example `2026-09-21-hello.md`:

```markdown
+++
title = "Hello"
date = 2026-09-21
draft = true
+++

Write the post here.
```

Preview drafts with `zola serve --drafts`, then remove `draft = true` to publish.
Posts appear newest first on the homepage and at `/posts/`. Date prefixes are kept
in URLs, preserving the existing `/posts/2020-09-26-rust-2021/` address.

Use a language on fenced code blocks (for example, `rust`) to enable highlighting.
RSS remains at `/index.xml` and `/posts/index.xml`; Atom is available at `/atom.xml`
and `/posts/atom.xml`.

## Validation and deployment

```sh
zola check --skip-external-links
zola build
```

External link checks are skipped so archived posts do not depend on third-party
hosts accepting automated requests. Run `zola check` to check those links as well.

The Pages workflow builds with Zola 0.23.3 and deploys on pushes to `main`, or when
started manually. GitHub Pages must use **GitHub Actions** as its source.

## License

Code and code snippets in the repository are licensed under the [MIT License](LICENSE).
Text in blog posts is licensed under the [CC0 license](https://creativecommons.org/public-domain/cc0/).
