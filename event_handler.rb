module Indexer
  module EventHandler
    def initialize
      @listeners = Hash.new
    end

    def listen_event(name, *func, &p)
      if p
        (@listeners[name] ||= Array.new) << p
      else
        (@listeners[name] ||= Array.new) << func[0]
      end
    end

    def ignore_event(name, func)
      return if !@listeners.has_key?(name)
      @listeners[name].delete_if { |o| o == func }
    end

    def trigger_event(name, *args)
      return if !@listeners.has_key?(name)
      @listeners[name].each { |f| f.call(*args) }
    end

    def attach_info_listener(*args, &p)
      listen_event(:info, *args, &p)
    end
     def detach_info_listener(func)
      ignore_event(:info,func )
    end

    protected
    def info_message(information)
      trigger_event(:info, information, self)
    end
  end
end