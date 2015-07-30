require 'csv'
require 'securerandom'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Readers
            class Reader
              attr_reader :csv, :headers, :quantity

              def initialize(file:, column_separator: '|', quote_character: '"')
                options = {
                  headers: :first_row,
                  header_converters: :symbol,
                  converters: [],
                  col_sep: column_separator,
                  quote_char: quote_character
                }

                @csv      = CSV.read file, options
                @headers  = @csv.headers
                @quantity = @csv.length
              end

              private

              def search(criterions:)
                matches = @csv.find_all do |row|
                  match = true

                  criterions.keys.each do |key|
                    match = match && (row[key] == criterions[key])
                  end

                  match
                end
              end

              def find(criterions:, data:)
                matches = data.find do |row|
                  match = true

                  criterions.keys.each do |key|
                    match = match && (row[key] == criterions[key])
                  end

                  match
                end
              end

              def find_all(criterions:, data:)
                matches = data.find_all do |row|
                  match = true

                  criterions.keys.each do |key|
                    match = match && (row[key] == criterions[key])
                  end

                  match
                end
              end

              def column(key:, data:)
                data.map { |row| row[key] }.compact.uniq
              end
            end
          end
        end
      end
    end
  end
end