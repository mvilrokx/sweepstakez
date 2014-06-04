module Sweepstakes
  module Extensions
    module API extend self
      module Helpers
        def json(value, options = {})
          options = {user: current_user}.merge(options)
          # ap value
          # ap options
          content_type :json
          # puts value.to_json(options)
          value.to_json(options)
        end

      #   def stream_id
      #     env['HTTP_X_STREAM_ID']
      #   end

      #   def publish(types, data, options = {})
      #     if stream_id
      #       options = {except: stream_id}.merge(options)
      #     end

      #     message = {
      #       type:    Array(types).join(':'),
      #       data:    data,
      #       options: options
      #     }

      #     redis = Redis.connect
      #     redis.publish('pubsub', message.to_json)
      #   end
      end

      def registered(app)
        app.helpers Helpers
      end
    end
  end
end