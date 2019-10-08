module Alblogs
  class RequestMatcher
    attr_reader :range

    def initialize(options)
      @range = options[:start_time]..options[:end_time]
      @exclude_filter = options[:exclude_filter]
      @include_filter = options[:include_filter]
      @request_times_over = options[:request_times_over]
    end

    def match?(entry)
      return false unless @range.cover?(entry.timestamp)
      return false if @include_filter && ! @include_filter.match?(entry.line)
      return false if @exclude_filter && @exclude_filter.match?(entry.line)
      return false if @request_times_over && @request_times_over > entry.target_processing_time
      true
    end
  end
end
