Observability

1. Monitoring Health and Performance

This serverless application focuses on monitoring Lambda, API Gateway, and S3. Key metrics include:

Lambda: invocation count, execution duration, error count, throttles, and concurrent executions.

API Gateway (HTTP): 4XX/5XX error rates, latency, and request count. HTTP API is chosen for cost efficiency (~70% cheaper) as we can secure it with policies. 
If more security is needed, for example WAF, certificates, api keys, throttoling or more features like traces or caching it should be changed to rest api.

S3: request count, error rates, and storage trends.

Logs are centralized in CloudWatch, with Lambda and API Gateway writing structured logs for easier parsing and debugging.

2. Dashboarding and Alerting (not done via code)

For metrics I would use Amazon managed Grafana (or host it depending on team size and company needs) while for logs opensearch (can also be serverless)

Alerting: for alerts on AWS we can use a mix of technologies, cloudwatch metric filter -> cloudwatch alarm -> SNS -> chatbot -> slack or teams
or alering related to metrics we can use Grafana (they charge per active user)

3. Reducing Noise

Alerts should be time averaged to avoid false positives.

Log-based filters isolate specific errors from generic ones.

Security

Please note, I did this project with my personal account so I used the root account. I would either use specific services or specific roles.

1. API Gateway

HTTP API restricts access via IAM policies to specific roles.

Requests are encrypted using HTTPS.

Optional Cognito integration can be used if authentication is required.

2. Lambda

The Lambda function only lists S3 bucket contents.

Its IAM role grants the least privilege required: only s3:ListBucket for the target bucket.

Logs are written to a dedicated CloudWatch Log Group, optionally encrypted with KMS.

3. S3 and KMS

Objects in S3 are encrypted with KMS keys.

Access is granted to:

Lambda (for listing objects)

GitHub Actions role and root (for deployment and management; in production, replace root with specific user roles)

S3 itself for operations requiring KMS permissions

Even though not everybody can access the bucket because of it's policy some people might still be able to delete the policy and access it 
that's why the data is encrypted with kms keys

4. CI/CD Integration

GitHub Actions handles both testing and deployment:

PR workflow runs Python tests, if branch is protected people won't be able to merge if a test fail.

Build workflow packages Lambda functions/layers, uploads them to S3 with versioned tags, and runs Terraform for infrastructure changes.

Rollback strategies:

Application: redeploy previous version by selecting the version tag.

Infrastructure: reset the branch to the last known working tag.

This setup had app and infrastructure in a single pipeline but it's like they are 2 different things, for the application if in the s3
there is already code with the same version it will skip build and upload to s3

If there are no changes to the infrastructure terraform will skip deployment (assuming that nobody removed the state file)

5. Additional Hardening

Enable CloudTrail for auditing.

GuardDuty for threat detection. If added to a website Avanced Shield might be a good idea for DDOS attacks

Secrets stored in AWS Secrets Manager (there weren't any in this small project).

Lint scanning in CI/CD pipelines.

API gateway (REST) can be put in a VPC and made it private with vpc endpoints if needed

How to test
in terraform-infrastructure directory there is a test.py file for calling the API, make sure you add the role to the api policy that you have access to to get a 200
I chose github actions because it has a lot of features and the majority of devops know it so it becomes easier to hire.
