module Alblogs
  class Entry < Struct.new(:line, *::Alblogs::FIELDS.keys)
    REGEXP = Regexp.new(::Alblogs::FIELDS.values.join(' '))

    def request_parts
      @request_parts ||= request.split(' ', 3)
    end

    def request_method
      request_parts[0]
    end

    def request_url
      request_parts[1]
    end

    def request_protocol
      request_parts[2]
    end

    def request_uri
      @request_uri ||= URI(request_url)
    end

    def timestamp
      @timestamp ||= Time.iso8601(self[:timestamp])
    end

    def target_processing_time
      self[:target_processing_time].to_f
    end

    # this is the response code the client received
    def elb_status_code
      self[:elb_status_code].to_i
    end

    def target_status_code
      self[:target_status_code] == '-' ? nil : self[:target_status_code].to_i
    end

    def self.from_line(line)
      new(*get_fields(line))
    end

    def self.get_fields(line)
      REGEXP.match(line).to_a
    end

    def self.each_entry(io)
      while !io.eof?
        yield from_line(io.readline)
      end
    end
  end
end
