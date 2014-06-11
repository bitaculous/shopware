[SHOPWARE](http://bitaculous.github.io/shopware "shopware")
===========================================================

**A Ruby client for the Shopware API.**

[![Travis CI Status](https://travis-ci.org/bitaculous/shopware.svg)](http://travis-ci.org/bitaculous/shopware) [![Gemnasium Status](https://gemnasium.com/bitaculous/shopware.svg)](https://gemnasium.com/bitaculous/shopware)

Warning
-------

Although potentially exciting, this is still really a WIP, use at your own risk.

Installation
------------

1. Install [specific_install](https://github.com/rdp/specific_install "Rubygems plugin to allow you to install an 'edge' gem straight from its GitHub repository")

    ```
    $ gem install specific_install
    ```

2. Install shopware straight from the GitHub repository

    ```
    $ gem specific_install https://github.com/bitaculous/shopware.git
    ```

Usage
-----

1. Create a `.shopware` config file:

    ```yml
    api:
      username: "api"
      key: "foobar"
      base_uri: "http://your-awesome-shop.com/api"
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

#### Create a base article

```
$ shopware mannol create_base_article
```

#### Imports

##### Import oils as a CSV file

```
$ shopware mannol import_oils <file> --root-category-id=<root-category-id> --car-manufacturer-category-id=<car-manufacturer-category-id> --filter_group_id=<filter_group_id>

$ shopware mannol import_oils <file> --root-category-id=<root-category-id> --car-manufacturer-category-id=<car-manufacturer-category-id> --filter_group_id=<filter_group_id> --number_of_oils=<number_of_oils> --verbose
```

##### Import care products as a CSV file

```
$ shopware mannol import_car_products <file> --root-category-id=<root-category-id>

$ shopware mannol import_car_products <file> --root-category-id=<root-category-id> --number_of_care_products=<number_of_care_products> --verbose
```

Client
------

See [client.rb](https://github.com/bitaculous/shopware/blob/lib/shopware/api/client.rb "client.rub").

License
-------

Shopware is released under the MIT License (MIT), see [LICENSE](https://raw.githubusercontent.com/bitaculous/shopware/master/LICENSE "License").