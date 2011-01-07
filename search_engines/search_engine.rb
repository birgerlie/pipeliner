require_relative '../event_handler'

module Indexer

class SearchEngine
  attr_accessor :name
  include EventHandler
  DOCUMENT_ID = :document_id

  def initialize(options = {})
    super()

    @connection_args = options[:connection_args]
    @options = options
    options[:name] ? @name = options[:name] : self.class.name

    after_initialize
  end

  def publish(document)
    puts document
    
    info_message("publishing doc #{document[DOCUMENT_ID]}")
    transformed = transform_document_before_write(document)
    write_document_to_index(transformed)
  end

   def attach_info_listener(*args, &p)
    listen_event(:info, *args, &p)
   end

  protected

  def after_initialize
  0
  end

  def transform_document_before_write(document)
    document
  end

#  def info_message(information)
#    trigger_event(:info, information, self)
#  end

  def write_document_to_index(document)

  end
  end
end