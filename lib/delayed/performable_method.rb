module Delayed
  class PerformableMethod < Struct.new(:object, :delayed_method, :args)
    def initialize(object, delayed_method, args)
      raise NoMethodError, "undefined method `#{delayed_method}' for #{object.inspect}" unless object.respond_to?(delayed_method, true)

      self.object = object
      self.args   = args
      self.delayed_method = delayed_method.to_sym
    end
    
    def display_name
      "#{object.class}##{delayed_method}"
    end
    
    def perform
      object.send(delayed_method, *args) if object
    end
    
    def method_missing(symbol, *args)
      object.respond_to?(symbol) ? object.send(symbol, *args) : super
    end
       
    def respond_to?(symbol, include_private=false)
      object.respond_to?(symbol, include_private) || super
    end    
  end
end
