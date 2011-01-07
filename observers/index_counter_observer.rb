

class IndexCounterObserver
   def initialize(observable)
    @observable=nil
    if observable.respond_to? 'attach_new_document_listener'
      observable.attach_new_document_listener(method(:information))
      @observable = observable
    else
      puts "#{observable.class} does NOT respond to attach_info_listener"
    end

     @stats = {}
  end

  def information(document, connector)
    if @stats.has_key? connector
      @stats[connector] +=1
    else
      @stats[connector]=1
    end

    puts "current count:  #{@stats[connector]}"
  end

  def detach
    @observable.detach_new_document_listener(method(:information)) if @observable != nil
  end

  def count
    @stats
  end
end