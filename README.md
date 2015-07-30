[Shopware]
==========

[![Travis CI Status][Travis CI Status]][Travis CI] [![Gemnasium Status][Gemnasium Status]][Gemnasium]

**A Ruby client for the Shopware API.**

Warning
-------

**Although potentially exciting, this is still really a WIP, use at your own risk.**

Installation
------------

1. Add shopware to your Gemfile:

    ```
    gem 'shopware', github: 'bitaculous/shopware'
    ```

2. Run `bundle install`

Usage
-----

1. Create a `.shopware` config file:

    ```yml
    api:
      username: "api"
      key: "foobar"
      uri: "http://your-awesome-shop.com/api"
    ```

2. Run `shopware --help` or `shopware help <COMMAND>`

### Articles

#### List articles

```
$ shopware articles list
```

#### Show article

```
$ shopware articles show <ID>
```

#### Delete article

```
$ shopware articles delete <ID>
```

### Categories

#### List categories

```
$ shopware categories list
```

#### Show category

```
$ shopware categories show <ID>
```

#### Delete category

```
$ shopware categories delete <ID>
```

### Property groups

#### List property groups

```
$ shopware property_groups list
```

#### Show property group

```
$ shopware property_groups show <ID>
```

#### Delete property group

```
$ shopware property_groups delete <ID>
```

### Variants

#### Show variant

```
$ shopware variants show <ID>
```

#### Delete variant

```
$ shopware variants delete <ID>
```

Client
------

See [client.rb].

Development
-----------

### Specs

Use the `rspec` command to run the specs:

```
$ rspec
```

or via [Guard]:

```
$ guard -g spec
```

Bug Reports
-----------

Github Issues are used for managing bug reports and feature requests. If you run into issues, please search the issues
and submit new problems [here].

Versioning
----------

This library aims to adhere to [Semantic Versioning 2.0.0]. Violations of this scheme should be reported as bugs.
Specifically, if a minor or patch version is released that breaks backward compatibility, that version should be
immediately yanked and / or a new version should be immediately released that restores compatibility.

License
-------

Shopware is released under the [MIT License (MIT)], see [LICENSE].

[client.rb]: https://github.com/bitaculous/shopware/blob/master/lib/shopware/api/client.rb "client.rub"
[Gemnasium]: https://gemnasium.com/bitaculous/shopware "Shopware at Gemnasium"
[Gemnasium Status]: https://img.shields.io/gemnasium/bitaculous/shopware.svg?style=flat "Gemnasium Status"
[Guard]: http://guardgem.org "A command line tool to easily handle events on file system modifications."
[here]: https://github.com/bitaculous/shopware/issues "Github Issues"
[LICENSE]: https://raw.githubusercontent.com/bitaculous/shopware/master/LICENSE "License"
[MIT License (MIT)]: http://opensource.org/licenses/MIT "The MIT License (MIT)"
[Semantic Versioning 2.0.0]: http://semver.org "Semantic Versioning 2.0.0"
[Shopware]: https://bitaculous.github.io/shopware/ "A Ruby client for the Shopware API."
[Travis CI]: https://travis-ci.org/bitaculous/shopware "Shopware at Travis CI"
[Travis CI Status]: https://img.shields.io/travis/bitaculous/shopware.svg?style=flat "Travis CI Status"