require_relative 'content_processor'

module Indexer
  class FieldNormalizerProcessor < ContentProcessor
    # To change this template use File | Settings | File Templates.

    def initialize(mapping = {})
      @mapping = mapping
    end

    def process(doc)
      
      new_doc = {
          :url=>doc[:page_url] || '',
          :title=>doc[:html_title] || doc['info:name'],
          :org_num=>doc['info:org_num'],
          :country=>doc['info:country_iso'],
          :industry_code=>doc['info:industry_code'] || 0,
          :region=>doc['info:region'],
          :continent=>doc['info:continent'],
          :emp_count =>doc["info:employees_count"].to_i,
          :company_exact=>doc['info:full_name'],
          :company_name=>doc['info:name'],
          :body=>doc[:html_text] || '',
          :key_words =>doc[:html_meta],
          :revenue =>doc[:total_revenue] || 0,
          :row_id =>doc['id'],
          :page_url_s =>doc['info:web_address'],
          :org_code=>doc['info:code'],
          :company_id=>doc['id'],
          :profit_before_tax =>doc[:profit_before_tax].to_i || 0
      }
      new_doc[:geo_location] = "#{doc['info:lat']},#{doc['info:lng']}" if doc['info:lng'] != nil and doc['info:lat'] != nil
      new_doc[:row_id] += "|" + doc[:page_url] if doc[:page_url] != nil 
      new_doc
    end

  end

end