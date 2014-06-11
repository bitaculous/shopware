require 'shopware/cli/subcommands/mannol/import/models/filter'
require 'shopware/cli/subcommands/mannol/import/readers/reader'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Readers
            class Filter < Reader
              def filters
                filters = @csv[:name].uniq

                filters.map do |name|
                  filter name
                end
              end

              def filter(name)
                filter = Models::Filter.new

                full = search(
                  criterions: {
                    name: name
                  }
                )

                entity = find(
                  criterions: {
                    name: name
                  },
                  data: full
                )

                filter.number   = generate_number
                filter.name     = name
                filter.supplier = entity[:supplier]

                filter.category    = entity[:category]
                filter.subcategory = entity[:subcategory]

                filter
              end
            end
          end
        end
      end
    end
  end
end