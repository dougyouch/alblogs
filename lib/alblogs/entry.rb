module Alblogs
  class Entry < Struct.new(:line, *::Alblogs::FIELDS.keys)
    REGEXP = Regexp.new(::Alblogs::FIELDS.values.join(' '))

    def timestamp
      @timestamp ||= Time.iso8601(self[:timestamp])
    end

    def target_processing_time
      self[:target_processing_time].to_f
    end

    def self.from_line(line)
      new(*get_fields(line))
    end

    def self.get_fields(line)
      REGEXP.match(line).to_a
    end
  end
end
