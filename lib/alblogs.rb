module Alblogs
  autoload :Entry, 'alblogs/entry'
  autoload :RequestMatcher, 'alblogs/request_matcher'
  autoload :S3Bucket, 'alblogs/s3_bucket'
  autoload :S3File, 'alblogs/s3_file'
  autoload :Utils, 'alblogs/utils'
  
  FIELDS =
    begin
      not_a_space = '([^ ]+)'
      in_quotes = '"(.*?)"'
      
      {
        type: not_a_space,
        timestamp: not_a_space,
        elb: not_a_space,
        client_port: not_a_space,
        target_port: not_a_space,
        request_processing_time: not_a_space,
        target_processing_time: not_a_space,
        response_processing_time: not_a_space,
        elb_status_code: not_a_space,
        target_status_code: not_a_space,
        received_bytes: not_a_space,
        sent_bytes: not_a_space,
        request: in_quotes,
        user_agent: in_quotes,
        ssl_cipher: not_a_space,
        ssl_protocol: not_a_space,
        target_group_arn: not_a_space,
        trace_id: in_quotes,
        domain_name: in_quotes,
        chosen_cert_arn: in_quotes,
        matched_rule_priority: not_a_space,
        request_creation_time: not_a_space,
        actions_executed: in_quotes,
        redirect_url: in_quotes,
        error_reason: in_quotes
      }
    end
end
