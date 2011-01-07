module Indexer

  class InformationObserver
  def initialize(observable)
    if observable.respond_to? 'attach_info_listener'
          observable.attach_info_listener(method(:information))
      @observable = observable
    else
      puts "#{observable.class} does NOT respond to attach_info_listener"
    end
  end
  
  def information(message, sender)
    puts "#info: #{message} from #{sender}"
  end

  def detach
    @observable.detach_info_listener(method(:information))
  end
  end

end