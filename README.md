<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable MD041 -->
<p align="center">
<img src="https://github.com/phothinmg/jekykll-pagefind/blob/main/rubygems_logo.png" width="160" height="160" alt="mmdevs" style="border-radius:50%" />
</p>
<h1 align="center">Jekyll::Pagefind</h1>

## Overview

Jekyll-Pagefind is a plugin I use for my personal and project sites. It was inspired by [Adding search to Jekyll using pagefind][pf_to_jekyll]. It fits easily into the default Jekyll GitHub Actions workflow for deploying to GitHub Pages.

## Install

Install the gem and add to the application's Gemfile by executing:

```sh
bundle add jekyll-pagefind
```

```sh
bundle install
```

In `Gemfile`

```ruby
group :jekyll_plugins do
  # other jekyll plugins
  gem 'jekyll-pagefind' # add pagefind plugin
end
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
gem install jekyll-pagefind
```

## How to

This guide is intended for Jekyll sites deployed to GitHub Pages.

### Download pagefind

First, download the standalone binary (`pagefind`) from the [pagefind releases][pf_release_page] page.

Make sure to use the correct binary:

1. For local development, download the standalone binary (`pagefind`) for your host platform.
2. For deployment to GitHub Pages, the binary must be `pagefind-v{version}-x86_64-unknown-linux-musl.tar.gz`.

### Place the binary file `pagefind`

Place the `pagefind` binary in the root of your Jekyll project, which is the recommended default, or anywhere else under the project root.

### Jekyll Config

**`_config.yml`**

```yaml
plugins:
  # other plugin
  - jekyll-pagefind
```

If your `pagefind` binary is not in the project root, add this configuration option:

```yaml
pagefind: path_to_your/pagefind # where your `pagefind` was located
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/phothinmg/jekyll-pagefind>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/phothinmg/jekyll-pagefind/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jekyll::Pagefind project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/phothinmg/jekyll-pagefind/blob/master/CODE_OF_CONDUCT.md).

<!-- markdownlint-disable MD053 -->

[pf_release_page]: https://github.com/Pagefind/pagefind/releases/latest
[pf_to_jekyll]: https://www.bfoliver.com/2025/pagefind
