module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          private

          def find_image(small_image:, big_image:, options:)
            asset_host       = options.asset_host
            small_image_path = options.small_image_path
            big_image_path   = options.big_image_path

            if big_image
              uri = URI::HTTP.build({
                host: asset_host,
                path: "#{big_image_path}/#{big_image}.jpg"
              })

              return uri.to_s if uri_exist? uri
            end

            if small_image
              big_image = small_image.sub 's', 'b'

              uri = URI::HTTP.build({
                host: asset_host,
                path: "#{big_image_path}/#{big_image}.jpg"
              })

              return uri.to_s if uri_exist? uri

              uri = URI::HTTP.build({
                host: asset_host,
                path: "#{small_image_path}/#{small_image}.jpg"
              })

              return uri.to_s if uri_exist? uri
            end
          end

          def find_or_create_category(name:, template:, parent_id:, text: nil)
            transient = @client.find_category_by_name name

            if not transient
              info "Category “#{name}” does not exists, creating new one...", indent: true if options.verbose?

              properties = {
                name: name,
                cmsHeadline: name,
                template: template,
                parentId: parent_id
              }

              properties[:cmsText] = text if text and not text.empty?

              category = @client.create_category properties

              @client.get_category category['id']
            else
              info "Category “#{name}” already exists.", indent: true if options.verbose?

              transient
            end
          end

          def create_or_update_category(name:, template:, parent_id:, text: nil)
            transient = @client.find_category_by_name name

            properties = {
              name: name,
              cmsHeadline: name,
              template: template,
              parentId: parent_id
            }

            properties[:cmsText] = text if text and not text.empty?

            if not transient
              info "Category “#{name}” does not exists, creating new one...", indent: true if options.verbose?

              category = @client.create_category properties

              @client.get_category category['id']
            else
              info "Category “#{name}” already exists, updating category...", indent: true if options.verbose?

              @client.update_category transient['id'], properties
            end
          end

          def generate_number(text:, index: nil)
            text = text.to_str.gsub(' ', '-').gsub('/', '-').upcase

            index ? "#{text}.#{index}" : text
          end

          def enclose(text)
            "<p>#{text}</p>" if text
          end

          def uri_exist?(uri)
            request  = Net::HTTP.new uri.host, uri.port
            response = request.request_head uri.path

            response.code == '200'
          end
        end
      end
    end
  end
end