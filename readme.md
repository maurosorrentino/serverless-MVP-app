# AWS Lambda + API Gateway Project

This project demonstrates a secure serverless application made by AWS Lambda function exposed via API Gateway, with CI/CD integration using GitHub Actions.

## 1. Monitoring Health and Performance

**Key Metrics:**

- **Lambda:** invocation count, execution duration, error count, throttles, concurrent executions  
- **API Gateway (HTTP API):** 4XX/5XX error rates, latency, request count  

> **Note:** HTTP API is chosen for cost efficiency (around 70% cheaper). For advanced security (WAF, API keys, throttling) or features like caching/traces, use REST API.

**Logging:**  
All logs are centralized in CloudWatch. Lambda and API Gateway write structured logs for easy parsing and debugging.

## 2. Dashboarding and Alerting (TODO)

**Metrics Visualization:**  
- Amazon Managed Grafana (or self-hosted based on team size and company goals)  

**Logs Analysis:**  
- OpenSearch (can be serverless)  

**Alerting:**  
- CloudWatch metric filter → CloudWatch alarm → SNS → chatbot → Slack/Teams  
- Grafana alerts

**Noise Reduction:**  
- Alerts are time-averaged to reduce false positives.

## 3. Security

> This project used a personal AWS root account. In production, use service-specific roles.

### API Gateway
- HTTP API restricts access via IAM policies.  
- Requests encrypted using HTTPS.  
- Optional Cognito integration for authentication.

### Lambda
- Only lists S3 bucket contents.  
- IAM role has least privilege: `s3:ListBucket` only.  
- Logs written to dedicated CloudWatch Log Group (optionally KMS encrypted).
- Lambda uses HTTPS by default.

### S3 and KMS
- Objects encrypted with KMS keys.  
- Access granted to:
  - Lambda (list objects)  
  - GitHub Actions role (deployment)  
  - Root (replace with specific roles in production)  
- S3 IAM Policy is for preventing access from other teams, KMS in case somebody has permissions to remove the policy.

## 4. CI/CD Integration

**GitHub Actions Workflow:**
- **PR Workflow:** Runs Python tests. Protected branches prevent merging on test failure.  
- **Build Workflow:** Runs tests, packages Lambda functions/layers, uploads to S3 with versioned tags, runs Terraform for infra chang

## 5. Additional Hardening

- **GuardDuty:** Threat detection  
- **AWS Advanced Shield:** Optional for DDoS protection
- **CI/CD Linting:** Ensures code quality and security checks 
- **API Gateway REST Options:** Can be put in a VPC and made private using VPC endpoints
- **S3 Versioning:** Optional for Lambda code backup (can retrieve older versions if deleted)  

## 6. How to Use / Test

1. Deploy resources in `terraform-bootstrap` for GitHub Actions permissions.  
2. Push code to GitHub to trigger pipeline for further deployments.  
3. In `terraform-infrastructure`, use `test.py` to call the API:  
   - Add your role to the API policy for a `200` response.  

> GitHub Actions was chosen for its features and wide familiarity among DevOps teams.
