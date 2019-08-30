# Product Assembly

[![CircleCI](https://circleci.com/gh/solidusio-contrib/solidus_product_assembly.svg?style=svg)](https://circleci.com/gh/solidusio-contrib/solidus_product_assembly)

Create a product which is composed of other products.

## Installation

Add the following line to your `Gemfile`
```ruby
gem 'solidus_product_assembly', github: 'solidusio-contrib/solidus_product_assembly', branch: 'master'
```

Run bundle install as well as the extension intall command to copy and run migrations and
append solidus_product_assembly to your js manifest file

    bundle install
    rails g solidus_product_assembly:install

## Use

To build a bundle (assembly product) you'd need to first check the "Can be part"
flag on each product you want to be part of the bundle. Then create a product
and add parts to it. By doing that you're making that product an assembly.

The store will treat assemblies a bit different than regular products on checkout.
Spree will create and track inventory units for its parts rather than for the product itself.
That means you essentially have a product composed of other products. From a
customer perspective it's like they are paying a single amount for a collection
of products.

## Releasing a new version

#### 1. Bump gem version and push to RubyGems

We use [gem-release](https://github.com/svenfuchs/gem-release) to release this
extension with ease.

Supposing you are on the master branch and you are working on a fork of this
extension, `upstream` is the main remote and you have write access to it, you
can simply run:

```bash
gem bump --version minor --tag --release
```

This command will:

- bump the gem version to the next minor (changing the `version.rb` file)
- commit the change and push it to upstream master
- create a git tag
- push the tag to the upstream remote
- release the new version on RubyGems

Or you can run these commands individually:

```bash
gem bump --version minor
gem tag
gem release
```

#### 2. Publish the updated CHANGELOG

After the release is done we can generate the updated CHANGELOG
using
[github-changelog-generator](https://github.com/github-changelog-generator/github-changelog-generator)
by running the following command:


```bash
bundle exec github_changelog_generator solidusio/solidus_auth_devise --token YOUR_GITHUB_TOKEN
git commit -am 'Update CHANGELOG'
git push upstream master
```

## Contributing

Spree is an open source project and we encourage contributions. Please see the [contributors guidelines][1] before contributing.

In the spirit of [free software][2], **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using prerelease versions
* by reporting [bugs][3]
* by suggesting new features
* by writing translations
* by writing or editing documentation
* by writing specifications
* by writing code (*no patch is too small*: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues][3]
* by reviewing patches

Starting point:

* Fork the repo
* Clone your repo
* Run `bundle install`
* Run `bundle exec rake test_app` to create the test application in `spec/test_app`
* Make your changes
* Ensure specs pass by running `bundle exec rspec spec`
* Submit your pull request

Copyright (c) 2014 [Spree Commerce Inc.][4] and [contributors][5], released under the [New BSD License][6]

[1]: http://guides.spreecommerce.com/developer/contributing.html
[2]: http://www.fsf.org/licensing/essays/free-sw.html
[3]: https://github.com/spree/spree-product-assembly/issues
[4]: https://github.com/spree
[5]: https://github.com/spree/spree-product-assembly/graphs/contributors
[6]: https://github.com/spree/spree-product-assembly/blob/master/LICENSE.md
