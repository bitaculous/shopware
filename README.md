[shopware](http://bitaculous.github.io/shopware "shopware")
===========================================================

**A Ruby client for the Shopware API.**

[![Travis CI Status](https://travis-ci.org/bitaculous/shopware.svg)](http://travis-ci.org/bitaculous/shopware) [![Gemnasium Status](https://gemnasium.com/bitaculous/shopware.svg)](https://gemnasium.com/bitaculous/shopware)

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

License
-------

Shopware is released under the MIT License (MIT), see [LICENSE](https://raw.githubusercontent.com/bitaculous/shopware/master/LICENSE "License").