[Shopware]
==========

**A Ruby client for the Shopware API.**

[![Travis CI Status][Travis CI Status]][Travis CI]
[![Gemnasium Status][Gemnasium Status]][Gemnasium]

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

2. Run `shopware --help` or `shopware help <command>`

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

### Mannol

#### Create oil property group

```
$ shopware mannol create_oil_property_group
```

#### Imports

##### Import oils as a CSV file

```
$ shopware mannol import_oils <file> --oil_category_id=<oil_category_id> --spec_category_id=<spec_category_id> --filter_group_id=<filter_group_id>

$ shopware mannol import_oils <file> --oil_category_id=<oil_category_id> --spec_category_id=<spec_category_id> --filter_group_id=<filter_group_id> --number_of_oils=<number_of_oils> --verbose
```

##### Import care products as a CSV file

```
$ shopware mannol import_car_products <file> --root_category_id=<root_category_id>

$ shopware mannol import_car_products <file> --root_category_id=<root_category_id> --number_of_care_products=<number_of_care_products> --verbose
```

##### Import filters as a CSV file

```
$ shopware mannol filters <file> --root_category_id=<root_category_id>

$ shopware mannol filters <file> --root_category_id=<root_category_id> --number_of_filters=<number_of_filters> --verbose
```

Client
------

See [client.rb].

License
-------

Shopware is released under the [MIT License (MIT)], see [LICENSE].

[client.rb]: https://github.com/bitaculous/shopware/blob/master/lib/shopware/api/client.rb "client.rub"
[Gemnasium Status]: http://img.shields.io/gemnasium/bitaculous/shopware.svg?style=flat "Gemnasium Status"
[Gemnasium]: https://gemnasium.com/bitaculous/shopware "Shopware at Gemnasium"
[LICENSE]: https://raw.githubusercontent.com/bitaculous/shopware/master/LICENSE "License"
[MIT License (MIT)]: http://opensource.org/licenses/MIT "The MIT License (MIT)"
[Shopware]: http://bitaculous.github.io/shopware "A Ruby client for the Shopware API."
[Travis CI Status]: http://img.shields.io/travis/bitaculous/shopware.svg?style=flat "Travis CI Status"
[Travis CI]: https://travis-ci.org/bitaculous/shopware "Shopware at Travis CI"