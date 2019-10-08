module Alblogs
  class Iterator
    include Enumerable

    attr_accessor :tmp_file,
                  :display_stats_proc

    attr_reader :s3_bucket,
                :date_range,
                :request_matcher,
                :stats

    def initialize(s3_bucket, date_range, request_matcher = nil)
      @s3_bucket = s3_bucket
      @date_range = date_range
      @request_matcher = request_matcher
      @tmp_file = '.download.alblogs.log'
    end

    def each
      @stop = false
      delete_tmp_file
      init_stats

      s3_bucket.get_s3_files_in_range(date_range).values.each do |s3_file|
        stats[:files] += 1

        stats[:total_download_time] += measure do
          s3_bucket.download_s3_file(s3_file, tmp_file)
        end

        stats[:total_file_processing_time] += measure do
          File.open(file, 'rb') do |f|
            ::Alblogs::Entry.each_entry(f) do |entry|
              break if @stop

              stats[:entries] += 1
              stats[:min_log_time] = ! stats[:min_log_time] || stats[:min_log_time] > entry.timestamp ? entry.timestamp : stats[:min_log_time]
              stats[:max_log_time] = ! stats[:max_log_time] || stats[:max_log_time] < entry.timestamp ? entry.timestamp : stats[:max_log_time]
              next if request_matcher && !request_matcher.match?(entry)
              stats[:matching_lines] += 1
              stats[:min_matched_log_time] = ! stats[:min_matched_log_time] || stats[:min_matched_log_time] > entry.timestamp ? entry.timestamp : stats[:min_matched_log_time]
              stats[:max_matched_log_time] = ! stats[:max_matched_log_time] || stats[:max_matched_log_time] < entry.timestamp ? entry.timestamp : stats[:max_matched_log_time]
              yield entry
            end
          end
        end

        File.unlink(tmp_file)

        display_stats
        break if @stop
      end
    end

    def stop!
      @stop = true
    end

    def display_stats
      display_stats_proc && display_stats_proc.call(stats)
    end

    private

    def measure 
      start = Time.now
      yield
      Time.now - start
    end

    def delete_tmp_file
      File.unlink(tmp_file) if File.exists?(tmp_file)
      File.unlink("#{tmp_file}.gz") if File.exists?("#{tmp_file}.gz")
    end

    def init_stats
      @stats = Hash.new(0)
      @stats[:started_at] = Time.now.utc
      @stats[:range_starts_at] = date_range.begin
      @stats[:range_ends_at] = date_range.end
      @stats[:min_log_time] = nil
      @stats[:max_log_time] = nil
      @stats[:min_matched_log_time] = nil
      @stats[:max_matched_log_time] = nil
    end
  end
end
