module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from StandardError do |e|
          respond(:standard_error, 500, e.to_s)
        end
      end
    end

    def respond(_error, _status, _message)
      json = Helpers::Render.json(_error, _status, _message)
      render json: json
    end
  end
end