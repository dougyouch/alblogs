module Alblogs
  class S3File
    MINUTES_5 = 5 * 60

    attr_reader :file,
                :file_size,
                :last_modified_at

    def initialize(file, file_size, last_modified_at)
      @file = file
      @file_size = file_size
      @last_modified_at = last_modified_at
    end

    def end_time
      @end_time ||=
        begin
          unless @file =~ /_(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})Z_/
            raise("unable to find time stamp in #{@file}")
          end
          Time.new($1, $2, $3, $4, $5, 0, 0)
        end
    end

    def start_time
      @start_time ||= (end_time - MINUTES_5)
    end

    def in_range?(range)
      return false if end_time < range.begin
      return false if start_time > range.end
      true
    end
  end
end
