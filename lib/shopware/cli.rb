require 'pp'
require 'terminal-table'
require 'thor'

require_relative 'api/client'

module Shopware
  class CLI < Thor
    CONFIG = '.shopware'

    desc 'categories', 'List categories'
    def categories
      client = API::Client.new options.api

      categories = client.categories

      categories.each_with_index do |category, i|
        id             = category['id']            if category['id']
        name           = category['name']          if category['name']
        active         = category['active']        if category['active']
        position       = category['position']      if category['position']
        parent_id      = category['parentId']      if category['parentId']
        children_count = category['childrenCount'] if category['childrenCount']
        article_count  = category['articleCount']  if category['articleCount']

        rows = []
        rows << ['ID', id]                         if id
        rows << ['Name', name]                     if name
        rows << ['Active', active]                 if active
        rows << ['Position', position]             if position
        rows << ['Parent ID', parent_id]           if parent_id
        rows << ['Children count', children_count] if children_count
        rows << ['Article count', article_count]   if article_count

        table = ::Terminal::Table.new rows: rows

        puts table
      end
    end

    private

    def options
      original_options = super

      return original_options unless File.exists? CONFIG

      defaults = ::YAML::load_file CONFIG || {}

      Thor::CoreExt::HashWithIndifferentAccess.new defaults.merge(original_options) if defaults
    end
  end
end