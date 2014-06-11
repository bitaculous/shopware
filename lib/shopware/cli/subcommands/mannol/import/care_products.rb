module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module CareProducts
            def self.included(thor)
              thor.class_eval do
                private

                def get_categories_for_care_product(care_product:, options:, defaults:)
                  categories = []

                  category = care_product.category

                  if category
                    category = find_or_create_category(
                      name: category,
                      template: defaults['category_template'],
                      parent_id: options.root_category_id
                    )

                    if category
                      categories << category['id']

                      subcategory = care_product.subcategory

                      if subcategory
                        subcategory = find_or_create_category(
                          name: subcategory,
                          template: defaults['category_template'],
                          parent_id: category['id']
                        )

                        if subcategory
                          categories << subcategory['id']
                        else
                          error 'Uuuuuppppss, something went wrong while creating subcategory.', indent: true if options.verbose?
                        end
                      end
                    else
                      error 'Uuuuuppppss, something went wrong while creating category.', indent: true if options.verbose?
                    end
                  end

                  categories
                end

                def get_article_data_for_care_product(care_product:, categories:, options:, defaults:)
                  name            = care_product.name
                  description     = care_product.description
                  supplier        = care_product.supplier
                  number          = care_product.number
                  small_image     = care_product.small_image
                  big_image       = care_product.big_image

                  description = enclose description if options.enclose_descriptions

                  data = {
                    name: name,
                    descriptionLong: description,
                    supplier: supplier,
                    tax: 19,
                    mainDetail: {
                      number: number,
                      propertyGroup: '2',
                      prices: [
                        {
                          customerGroupKey: 'EK',
                          price: defaults['price']
                        }
                      ]
                    },
                    images: [],
                    filterGroupId: options.filter_group_id,
                    propertyValues: [],
                    categories: [],
                    configuratorSet: {
                      groups: []
                    },
                    active: true
                  }

                  image = find_image(
                    small_image: small_image,
                    big_image: big_image,
                    options: options
                  )

                  if image
                    data[:images] << { link: image }
                  end

                  if not categories.empty?
                    categories.each do |category|
                      data[:categories] << { id: category }
                    end
                  end

                  data
                end
              end
            end
          end
        end
      end
    end
  end
end