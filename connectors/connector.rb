require_relative '../event_handler'

module Indexer

class Connector
  include EventHandler

  attr_accessor :connection, :last_run, :pipeline,:description,:name, :state

  DOCUMENT_ID = :document_id

  def initialize(connection_args={},pipeline =[] ,name = self.class.to_s, description ='')
    super()
    @name =name
    @connection_args = connection_args
    @pipeline = pipeline
    @description = description
    @state = :initialized
    after_initialize()
  end



  def index_content(timestamp = nil)
    connector_starting
    @state = :running
    start
    connector_complete
  end

  def start(timestamp = nil)

  end

  def stop
    @state =:stopping
  end

  def attach_connector_complete(*args, &p)
    listen_event(:connector_complete, *args,&p)
  end


  def attach_connector_starting(*args, &p)
    listen_event(:connector_starting, *args,&p)
  end

  def attach_new_document_listener(*args, &p)
    listen_event(:document_found, *args, &p)
  end
  def detach_new_document_listener(func)
    ignore_event(:document_found, func)
  end

#  def attach_info_listener(*args, &p)
#    listen_event(:info, *args, &p)
#  end
  protected

  #hook for child classes to alter data before the new_document event is raised
  def before_new_document(document)

  end

  #hook for child classes to alter data after the new_document event is raised
  def after_new_document(document)

  end

  #raising a new document event - listened to by indexer etc
  def new_document(document)
    before_new_document(document)

    @pipeline.each{|processor| processor.process(document)}

    trigger_event(:document_found, document,self)
    after_new_document(document)
  end

  def create_document_id(document)
    document
  end

  def after_initialize

  end

#  def info_message(information)
#    trigger_event(:info, information, self)
#  end

  def connector_complete
    @state =:complete
    trigger_event(:connector_complete, self)
  end

  def connector_starting
    @state =:starting
    trigger_event(:connector_starting, self)
  end

end
end