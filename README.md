# alblogs

Utility script for processing ALB access logs over a given time range

### Requirements

Need to have the AWS CLI installed.  Can be found here https://aws.amazon.com/cli/

### Install

```
gem install alblogs
```

### Usage

```
Usage: alblogs [options]
    -s, --start=TIME_EXP             Start time
    -e, --end=TIME_EXP               End time
        --include=REGEX              Include filter
        --exclude=REGEX              Exclude filter
    -p, --profile=PROFILE            AWS profile
    -b, --bucket=ALB_S3_BUCKET       ALB S3 Bucket and Path
    -o, --output=OUTPUT_FILE         File to stream matching ALB log entries to
        --stats                      Display Stats
        --request-times-over=SECONDS Find requests that took over X seconds
```

### Example

Find all requests that took over 500ms to process in the last 12 hours.

```
alblogs -b 's3://<my-aws-alb-bucket-name>/access_logs/AWSLogs/<aws-account-id>/elasticloadbalancing/<aws-region>' -s '12 hours' -o slow-requests.log --request-times-over 0.5
```

