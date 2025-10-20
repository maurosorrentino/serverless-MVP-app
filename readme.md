api gateway (http) as is around 70% cheaper, we could put a policy that will allow a specific service / role to call the api
and set origin header to a specific domain, cognito could be used for security, unless some rest feature is needed (for example for complicated API we should enable traces, it is usually fine to use http). if more security is needed, for example was, certificates, api keys, throttoling or more feature like traces or caching it should be changed to rest api

I chose github actions because it has a lot of features and the majority of devops know it so it becomes easier to hire.

there are 2 github actions, 1 runs the test of the python application on PR raise (if we protect the branch it won't be possible to merge with a failing test), another one builds lambda function and layer and puts them on an s3 bucket with a version tag (example dev-v1.0.0, prod-v1.0.0) if it doesn't exist. after this it runs terraform for instrastructure changes.

how to roll back
since app builds and infrastructure are separate, even though they are on the same pipeline, we can roll back changes for the application by just choosing the version in the input box. for infrastructure roll back we can reset the branch to the latest working tag

I would use opensearch (ELK stack owned by AWS) for logs and traces (if needed) and Grafana (can be hosted or Amazon Managed Grafana depending on team size, backlog etc.) for metrics

for alerts on AWS we can use a mix of technologies, cloudwatch metric filter -> cloudwatch alarm -> SNS -> chatbot -> slack or teams


