resource "aws_ssm_parameter" "cloudwatch" {
  name = "/cloudwatch/config"
  type = "String"
  value = jsonencode({
    agent = {
      metrics_collection_interval = 60
    }
    metrics = {
      metrics_collected = {
        mem = {
          measurement = ["mem_used_percent"]
        }
        disk = {
          measurement = ["disk_used_percent"]
          resources   = ["/"]
        }
      }
    }
    logs = {
      logs_collected = {
        files = {
          collect_list = [
            {
              file_path       = "/var/log/apache2/access.log"
              log_group_name  = "/ec2/apache/access"
              log_stream_name = "{instance_id}"
            },
            {
              file_path       = "/var/log/apache2/error.log"
              log_group_name  = "/ec2/apache/error"
              log_stream_name = "{instance_id}"
            }
          ]
        }
      }
    }
  })

  tags = {
    Environment = var.environment
  }
}
