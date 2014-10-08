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

### Mannol

#### Create an oil property group

```
$ shopware mannol create_oil_property_group
```

#### Imports

##### Import oils as a CSV file

```
$ shopware mannol import_oils <FILE> --oil_category_id=<OIL_CATEGORY_ID> --spec_category_id=<SPEC_CATEGORY_ID> --filter_group_id=<FILTER_GROUP_ID>

$ shopware mannol import_oils <FILE> --oil_category_id=<OIL_CATEGORY_ID> --spec_category_id=<SPEC_CATEGORY_ID> --filter_group_id=<FILTER_GROUP_ID> --number_of_oils=<NUMBER_OF_OILS> --verbose
```

##### Import care products as a CSV file

```
$ shopware mannol import_car_products <FILE> --root_category_id=<ROOT_CATEGORY_ID>

$ shopware mannol import_car_products <FILE> --root_category_id=<ROOT_CATEGORY_ID> --number_of_care_products=<NUMBER_OF_CARE_PRODUCTS> --verbose
```

##### Import filters as a CSV file

```
$ shopware mannol filters <FILE> --root_category_id=<ROOT_CATEGORY_ID>

$ shopware mannol filters <FILE> --root_category_id=<ROOT_CATEGORY_ID> --number_of_filters=<NUMBER_OF_FILTERS> --verbose
```

Client
------

See [client.rb].

License
-------

Shopware is released under the [MIT License (MIT)], see [LICENSE].

[client.rb]: https://github.com/bitaculous/shopware/blob/master/lib/shopware/api/client.rb "client.rub"
[Gemnasium]: https://gemnasium.com/bitaculous/shopware "Shopware at Gemnasium"
[Gemnasium Status]: http://img.shields.io/gemnasium/bitaculous/shopware.svg?style=flat "Gemnasium Status"
[LICENSE]: https://raw.githubusercontent.com/bitaculous/shopware/master/LICENSE "License"
[MIT License (MIT)]: http://opensource.org/licenses/MIT "The MIT License (MIT)"
[Shopware]: http://bitaculous.github.io/shopware "A Ruby client for the Shopware API."
[Travis CI]: https://travis-ci.org/bitaculous/shopware "Shopware at Travis CI"
[Travis CI Status]: http://img.shields.io/travis/bitaculous/shopware.svg?style=flat "Travis CI Status"