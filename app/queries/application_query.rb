class ApplicationQuery
  attr_reader :relation, :options

  class_attribute :relation_class

  def initialize(relation = nil, **kwargs)
    @relation = relation || self.class.base_relation
    @options = kwargs.with_indifferent_access
  end

  def call
    raise NotImplementedError, "You must define `call` as instance method in #{self.class.name} class."
  end

  class None
    def self.all; end
  end

  class << self
    def call(...)
      new(...).call
    end

    def query_on(object)
      raise StandardError, "#{name} class's query_on method require param as a model class name, can not be blank." if object.blank?

      self.relation_class = object.is_a?(String) ? object.constantize : object
    end

    def base_relation
      raise StandardError, "#{name} class require relation class defined. Use query_on method to define it." unless relation_class

      relation_class.all
    end
  end
end
