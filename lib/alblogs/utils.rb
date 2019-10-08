module Alblogs
  module Utils
    module_function

    def parse_time_offset(str)
      if str =~ /min/
        str.sub(/ *min.*/, '').to_i * 60
      elsif str =~ /hour/
        str.sub(/ *hour.*/, '').to_i * 3600
      elsif str =~ /day/
        str.sub(/ *day.*/, '').to_i * 86400
      else
        nil
      end
    end

    def time_ago(now, str)
      if offset = parse_time_offset(str)
        time = now - offset
        time - (time.to_i % 60) # round to the start of the minute
      else
        Time.parse(str).utc
      end
    end

    def run_or_die(cmd)
      res = `#{cmd}`
      raise("command failed with #{$?}, #{cmd}") unless $?.success?
      res
    end
  end
end
