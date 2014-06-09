module Sweepstakes
  module Routes
    class Base < Sinatra::Application
      configure do
        set :root, File.expand_path('../../../', __FILE__)

        disable :method_override
        disable :protection
        # disable :static
        # set :erb, escape_html: true

        # Exceptions
        enable :use_code
        set :show_exceptions, :after_handler
      end

      before do
        Tenant.current_id = Tenant.where(subdomain: request.host.split('.')[0]).first!.id
      end

      register Extensions::API
      # register Extensions::Assets
      register Extensions::Auth
      # register Extensions::Cache

      error Sequel::ValidationFailed do
        status 406
        json error: {
          type: 'validation_failed',
          messages: env['sinatra.error'].errors
        }
      end

      error Sequel::NoMatchingRow do
        status 404
        json error: {type: 'unknown_record'}
      end

      error Sequel::UniqueConstraintViolation do
        status 404
        json error: {
          type: 'duplicate_record',
          messages: env['sinatra.error'].errors}
      end

    end
  end
end