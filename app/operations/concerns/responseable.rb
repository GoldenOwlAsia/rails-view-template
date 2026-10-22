module Responseable
  extend ActiveSupport::Concern

  class Response
    attr_reader :success, :data, :errors

    def initialize(success, data, errors = [])
      @success = success
      @data = wrap(data)
      @errors = errors
    end

    class << self
      def success(data)
        new(true, normalize_data(data))
      end

      def failure(errors)
        new(false, nil, errors)
      end

      def normalize_data(data)
        return data if data.is_a?(Hash)

        { data.class.name.split('::').last.downcase.to_sym => data }
      end
    end

    def success?
      success
    end

    def failure?
      !success
    end

    def on_success
      success? ? yield(data) : self
    end

    def on_failure
      failure? ? yield(errors) : self
    end

    def method_missing(name, *args, &block)
      if data.respond_to?(name)
        data.public_send(name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      data.respond_to?(name) || super
    end

    def wrap(value)
      case value
      when Hash
        Data.define(*value.keys).new(*value.values.map { |v| wrap(v) })
      else
        value
      end
    end
  end

  private

  def success(data)
    Response.success(data)
  end

  def failure(errors)
    Response.failure(errors)
  end
end
