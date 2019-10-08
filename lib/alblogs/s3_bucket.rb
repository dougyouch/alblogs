module Alblogs
  class S3Bucket
    attr_reader :bucket,
                :aws_profile

    def initialize(bucket, aws_profile=nil)
      @bucket = bucket
      @aws_profile = aws_profile
    end

    def get_s3_files(date_path)
      s3_url = "#{bucket}/#{date_path}/"
      cmd = "aws"
      cmd << " --profile #{Shellwords.escape(aws_profile)}" if aws_profile
      cmd << " s3 ls #{Shellwords.escape(s3_url)}"
      output = ::Alblogs::Utils.run_or_die(cmd)
      output.split("\n").map do |line|
        line =~ /(\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2}) +(\d+) +(.+)/
        last_modified_at = Time.parse($1).utc
        file_size = $2.to_i
        file = $3
        ::Alblogs::S3File.new("#{s3_url}#{file}", file_size, last_modified_at)
      end
    end

    def get_s3_files_in_range(range)
      s3_files = {}
      time = range.begin
      while time < range.end
        date_path = time.strftime('%Y/%m/%d')
        get_s3_files(date_path).each do |s3_file|
          next unless s3_file.in_range?(range)
          s3_files[s3_file.file] ||= s3_file
        end
        time += 86_400
      end
      s3_files
    end

    def download_s3_file(s3_file, dest)
      cmd = "aws"
      cmd << " --profile #{Shellwords.escape(aws_profile)}" if aws_profile
      cmd << " s3 cp #{Shellwords.escape(s3_file.file)} #{Shellwords.escape(dest)}.gz"
      ::Alblogs::Utils.run_or_die(cmd)
      cmd = "gzip -f -d #{Shellwords.escape(dest)}.gz"
      ::Alblogs::Utils.run_or_die(cmd)
    end
  end
end
