require 'csv'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          class Reader
            attr_reader :csv, :headers, :quantity

            def initialize(file, col_sep = '|', quote_char = '"')
              options = {
                headers: :first_row,
                converters: [:numeric],
                col_sep: col_sep,
                quote_char: quote_char
              }

              @csv      = CSV.read file, options
              @headers  = @csv.headers
              @quantity = @csv.length
            end

            def search(criterions)
              matches = @csv.find_all do |row|
                match = true

                criterions.keys.each do |key|
                  match = match && (row[key] == criterions[key])
                end

                match
              end
            end
          end
        end
      end
    end
  end
end