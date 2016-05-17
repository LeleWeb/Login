module Models
  module Common

    extend ActiveSupport::Concern

    module ClassMethods
      def cache_key
        count  = self.count
        max_updated_at = self.maximum(:updated_at).try(:to_time).try(:utc).try(:to_s, :number)
        "#{self.to_s.tableize}.all-#{count}-#{max_updated_at}"
      end

      def message_for(code, msg, data = {})
        Message::RESULT.call(code, msg, data)
      end

    end

    def message_for(code, msg, data = {})
      Message::RESULT.call(code, msg, data)
    end

  end
end
