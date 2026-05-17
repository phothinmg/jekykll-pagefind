<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable MD041 -->
<p align="center">
<img src="https://susee.phothin.dev/logo/rubygems_logo.png" width="160" height="160" alt="mmdevs" style="border-radius:50%" />
</p>
<h1 align="center">jekyll-pagefind</h1>

[![Gem Version](https://badge.fury.io/rb/jekyll-pagefind.svg?icon=si%3Arubygems)](https://badge.fury.io/rb/jekyll-pagefind)

## Overview

Jekyll-Pagefind is a plugin that running pagefind binary in jekyll site.

## Install

Install the gem and add to the application's Gemfile by executing:

```sh
bundle add jekyll-pagefind
```

In `Gemfile`

```ruby
group :jekyll_plugins do
  # other jekyll plugins
  gem 'jekyll-pagefind' # add pagefind plugin
end
```

```sh
bundle install
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
gem install jekyll-pagefind
```

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

### Jekyll Pagefind options(optional)

These options act as options in [Pagefind Config files](https://pagefind.app/docs/config-sources/#:~:text=overriding%20configuration%20files.-,Config%20files,-Pagefind%20will%20look).

More detail about options at [Pagefind CLI configuration options](https://pagefind.app/docs/config-options/), `jekyll_pagefind` supports the following options.

#### 1. output_subdir

The folder to output the search bundle into, relative to jekyll {{site.dest}}.Default `pagefind`.

**Example :**

```yaml
output_subdir: pf # become _site/pf
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

Keeps `index.html` at the end of search result paths.Default `false`

By default, a file at `animals/cat/index.html` will be given the URL `/animals/cat/`. Setting this option to true will result in the URL `/animals/cat/index.html`.

#### 4. quiet

Only logs errors and warnings while indexing the site.

---

### Pagefind UI

#### 1. Using the Default UI

Using the Default UI is still supported but no longer the primary recommendation by Pagefind.

Pagefind UI can be added to any page with the following snippet.The `/pagefind/` or `output_subdir` options in [config](#1-output_subdir) directory and containing files will be created.

```liquid
<script src="{{ '/pagefind/pagefind-ui.js' | relative_url }}"></script>
<link rel="stylesheet" href="{{ '/pagefind/pagefind-ui.css' | relative_url }}" />

<div id="search"></div>
<script>
    window.addEventListener('DOMContentLoaded', (event) => {
        new PagefindUI({ element: "#search", showSubResults: true });
    });
</script>
```

for dark mode:

```css
body.dark {
  --pagefind-ui-primary: #eeeeee;
  --pagefind-ui-text: #eeeeee;
  --pagefind-ui-background: #152028;
  --pagefind-ui-border: #152028;
  --pagefind-ui-tag: #152028;
}
```

For more detail at [Using the Default UI](https://pagefind.app/docs/ui-usage/).

#### 2. Pagefind Component UI

Add the following snippet to `<head>`.The `/pagefind/` or `output_subdir` options in [config](#1-output_subdir) directory and containing files will be created.

```liquid
<script src="{{ '/pagefind/pagefind-component-ui.js' | relative_url }}" type="module"></script>
<link rel="stylesheet" href="{{ '/pagefind/pagefind-component-ui.css' | relative_url }}" />
```

for dark mode:

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

---

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/phothinmg/jekyll-pagefind>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/phothinmg/jekyll-pagefind/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jekyll::Pagefind project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/phothinmg/jekyll-pagefind/blob/master/CODE_OF_CONDUCT.md).
