module Bluepill
  module ProcessConditions
    class MemUsage < ProcessCondition
      MB         = (1024**2).freeze
      FORMAT_STR = '%d%s'.freeze
      MB_LABEL   = 'MB'.freeze
      KB_LABEL   = 'KB'.freeze

      def initialize(options = {})
        @below = options[:below]
      end

      def run(pid, include_children)
        # rss is on the 5th col
        System.memory_usage(pid, include_children).to_f
      end

      def check(value)
        value.kilobytes < @below
      rescue
        true
      end

      def format_value(value)
        if value.kilobytes >= MB
          format(FORMAT_STR, (value / 1024).round, MB_LABEL)
        else
          format(FORMAT_STR, value, KB_LABEL)
        end
      end
    end
  end
end
