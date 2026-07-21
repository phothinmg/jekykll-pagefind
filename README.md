<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable MD041 -->
<p align="center">
<img src="https://pub-c9ba018358dd48a99b70013b65a25e5f.r2.dev/logo/rubygems_logo.webp" width="160" height="160" alt="mmdevs" style="border-radius:50%" />
</p>
<h1 align="center">jekyll-pagefind</h1>

[![Gem Version](https://badge.fury.io/rb/jekyll-pagefind.svg?icon=si%3Arubygems)](https://badge.fury.io/rb/jekyll-pagefind)

## Overview

Jekyll-Pagefind is a plugin that runs the Pagefind binary for a Jekyll site.

## Install

Install the gem and add it to your application's Gemfile by running:

```sh
bundle add jekyll-pagefind
```

In your `Gemfile`:

```ruby
group :jekyll_plugins do
  # other jekyll plugins
  gem 'jekyll-pagefind' # add pagefind plugin
end
```

```sh
bundle install
```

If Bundler is not being used to manage dependencies, install the gem by running:

```sh
gem install jekyll-pagefind
```

RubyGems will install the platform-specific package that matches the host OS and CPU.
If no matching platform gem is selected, the generic `ruby` gem raises a clear error telling the user to add the deploy platform to `Gemfile.lock`.

## Use

### Jekyll site configuration

**`_config.yml`**

```yaml
plugins:
  # other plugin
  - jekyll-pagefind
# other config
# Optional Jekyll Pagefind Options
jekyll_pagefind:
  output_subdir: pagefind
```

---

### Jekyll Pagefind options (optional)

These options map to the settings available in [Pagefind config files](https://pagefind.app/docs/config-sources/#:~:text=overriding%20configuration%20files.-,Config%20files,-Pagefind%20will%20look).

For more details, see [Pagefind CLI configuration options](https://pagefind.app/docs/config-options/). `jekyll_pagefind` supports the following options.

#### 1. output_subdir

The folder where the search bundle is written, relative to Jekyll `{{ site.dest }}`. The default is `pagefind`.

**Example:**

```yaml
output_subdir: pf # becomes _site/pf
```

#### 2. exclude_selectors

Pass extra element selectors that Pagefind should ignore when indexing.

**Example :**

```yaml
exclude_selectors:
  - "#my_navigation"
  - "blockquote > span"
  - "[id^='prefix-']"
```

#### 3. keep_index_url

Keeps `index.html` at the end of search result paths. The default is `false`.

By default, a file at `animals/cat/index.html` will be given the URL `/animals/cat/`. Setting this option to true will result in the URL `/animals/cat/index.html`.

#### 4. quiet

Logs only errors and warnings while indexing the site.

---

### Pagefind UI

#### 1. Using the Default UI

Using the Default UI is still supported, but it is no longer Pagefind's primary recommendation.

You can add the Pagefind UI to any page with the following snippet. The `/pagefind/` directory, or the directory specified by `output_subdir` in the [config](#1-output_subdir), will be created along with its files.

```liquid
<script src="{% pagefind_asset_url 'pagefind-ui.js' %}"></script>
<link rel="stylesheet" href="{% pagefind_asset_url 'pagefind-ui.css' %}" />

<div id="search"></div>
<script>
    window.addEventListener('DOMContentLoaded', (event) => {
        new PagefindUI({
            element: "#search",
            showSubResults: true,
            bundlePath: "{% pagefind_bundle_path %}"
        });
    });
</script>
```

`{% pagefind_asset_url 'filename' %}` and `{% pagefind_bundle_path %}` both handle all four combinations of `baseurl` and `output_subdir` being set or unset, so the snippet works correctly for root deployments, GitHub Pages project sites, and custom `output_subdir` values without any extra configuration.

For dark mode:

```css
body.dark {
  --pagefind-ui-primary: #eeeeee;
  --pagefind-ui-text: #eeeeee;
  --pagefind-ui-background: #152028;
  --pagefind-ui-border: #152028;
  --pagefind-ui-tag: #152028;
}
```

For more details, see [Using the Default UI](https://pagefind.app/docs/ui-usage/).

#### 2. Pagefind Component UI

Add the following snippet to `<head>`. The bundle directory specified by `output_subdir` in the [config](#1-output_subdir) (default: `pagefind`) will be created along with its files.

```liquid
<script src="{% pagefind_asset_url 'pagefind-component-ui.js' %}" type="module"></script>
<link rel="stylesheet" href="{% pagefind_asset_url 'pagefind-component-ui.css' %}" />
```

If you initialize the component via JavaScript, pass `bundlePath: "{% pagefind_bundle_path %}"` so the search bundle resolves correctly when `baseurl` is set.

For dark mode:

```html
<div data-pf-theme="dark">
  <pagefind-searchbox></pagefind-searchbox>
</div>
```

```css
@media (prefers-color-scheme: dark) {
  :root {
    --pf-text: #e5e5e5;
    --pf-text-secondary: #a0a0a0;
    --pf-text-muted: #949494;
    --pf-background: #1a1a1a;
    --pf-border: #333;
    --pf-border-focus: #555;
    --pf-skeleton: #2a2a2a;
    --pf-skeleton-shine: #333;
    --pf-hover: #252525;
    --pf-mark: #e5e5e5;
    --pf-scroll-shadow: rgba(255, 255, 255, 0.1);
    --pf-outline-focus: #58a6ff;

    --pf-shadow-sm: 0 2px 8px rgba(0, 0, 0, 0.3);
    --pf-shadow-md: 0 4px 12px rgba(0, 0, 0, 0.4);
    --pf-shadow-lg: 0 16px 48px rgba(0, 0, 0, 0.5);

    --pf-error-bg: #2a1a1a;
    --pf-error-border: #5c2828;
    --pf-error-text: #f87171;
    --pf-error-text-secondary: #ef4444;
  }
}
```

For more details, see [Pagefind Component UI](https://pagefind.app/docs/search-ui/).

---

## Contributing

## Maintainer Release Notes

This gem is published as platform-specific packages so users only download the binary for their host OS.

Build the current host variant:

```sh
make build
```

Run the fixture-based smoke test:

```sh
make smoke-test
```

Build every supported variant:

```sh
make build-all
```

Publish the built platform gems for a version:

```sh
make publish
```

GitHub Actions trusted publishing is supported.

To enable it on RubyGems.org for this repo:

1. Open the `jekyll-pagefind` gem page.
2. Go to `Trusted publishers`.
3. Create a publisher with repository `phothinmg/jekyll-pagefind`, workflow filename `release.yml`, and environment `release`.

After that, pushing a tag like `v0.3.2` will run `.github/workflows/release.yml` and publish all built gems without a stored API token or manual OTP entry.

`bin/build-platform-gems` currently maps these asset folders to RubyGems platforms:

- `ruby` -> `ruby` (generic fallback gem with no bundled binary)
- `assets/linux-x64` -> `x86_64-linux-gnu`, `x86_64-linux-musl`
- `assets/linux-arm64` -> `aarch64-linux-gnu`, `aarch64-linux-musl`
- `assets/macos-x64` -> `x86_64-darwin`
- `assets/macos-arm64` -> `arm64-darwin`
- `assets/windows-x64` -> `x64-mingw32`, `x64-mingw-ucrt`
- `assets/windows-arm64` -> `arm64-mingw32`, `arm64-mingw-ucrt`

Bug reports and pull requests are welcome on GitHub at <https://github.com/phothinmg/jekyll-pagefind>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/phothinmg/jekyll-pagefind/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jekyll::Pagefind project's codebase, issue trackers, chat rooms, and mailing lists is expected to follow the [code of conduct](https://github.com/phothinmg/jekyll-pagefind/blob/master/CODE_OF_CONDUCT.md).
