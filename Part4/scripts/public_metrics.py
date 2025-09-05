import boto3

cloudwatch = boto3.client('cloudwatch', region_name='us-east-1')

def publish_active_users(value):
    cloudwatch.put_metric_data(
        Namespace='MyApp',
        MetricData=[
            {
                'MetricName': 'ActiveUsers',
                'Value': value,
                'Unit': 'Count'
            }
        ]
    )

if __name__ == "__main__":
    publish_active_users(42)
