require 'csv'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          class Reader
            attr_reader :csv

            def initialize(file, col_sep = '|', quote_char = '"')
              options = {
                headers: :first_row,
                converters: [:numeric],
                col_sep: col_sep,
                quote_char: quote_char
              }

              @cvs = CSV.read file, options
            end

            def quantity
              @cvs.length
            end
          end
        end
      end
    end
  end
end