# CI/CD Pipeline Templates

This directory contains reusable CI/CD pipeline templates for various application types.

## Node.js Application Pipeline Template

The `nodejs-pipeline-template.yml` file provides a comprehensive CI/CD pipeline for Node.js applications with the following features:

### Features

- **Multi-stage Pipeline**: Build, Test, Security Scan, Quality Scan, Approval, Deploy, and Post-Deploy stages
- **Code Quality**: SonarQube integration for code quality analysis
- **Security Scanning**: Snyk integration for dependency and container vulnerability scanning
- **Centralized Secrets Management**: Secure handling of sensitive information
- **Approval Gates**: Manual approval required before production deployments
- **Notifications**: Slack notifications for deployment status
- **Optimizations**: 
  - Parallel job execution for faster pipelines
  - Caching of dependencies
  - Cancellation of redundant pipeline runs
- **Deployment Strategy**: Blue-Green deployment for zero-downtime releases

### How to Use This Template

1. **Copy the Template**: Copy the `nodejs-pipeline-template.yml` file to your project repository.

2. **Configure Variables**: Update the variables section at the top of the file with your project-specific values.

3. **Set Up Secrets**: Configure the following secrets in your CI/CD platform's secure storage:
   - `DOCKER_REGISTRY_USER` and `DOCKER_REGISTRY_PASSWORD`: Docker registry credentials
   - `SNYK_TOKEN`: API token for Snyk
   - `SONAR_TOKEN`: API token for SonarQube
   - `SLACK_WEBHOOK_URL`: Webhook URL for Slack notifications

4. **Adapt for Your CI/CD Platform**: The template is designed to be adaptable to different CI/CD platforms:
   - **GitLab CI**: Use as-is with minimal changes
   - **GitHub Actions**: Convert job definitions to GitHub Actions workflow syntax
   - **Azure DevOps**: Convert to Azure Pipelines YAML format
   - **Jenkins**: Convert to Jenkinsfile format

5. **Customize Jobs**: Modify the job scripts as needed for your specific application requirements.

6. **Set Up Kubernetes Resources**: Create the necessary Kubernetes manifests in a `k8s` directory:
   - `deployment-green.yaml`: Deployment configuration for the green environment
   - `service-switch-to-green.yaml`: Service configuration to switch traffic to green

### Example Usage with Different CI/CD Platforms

#### GitLab CI

```yaml
include:
  - local: 'ci/nodejs-pipeline-template.yml'

variables:
  APP_NAME: "my-nodejs-app"
  NODE_VERSION: "18"
```

#### GitHub Actions

Convert the template to GitHub Actions format and include it in your workflow:

```yaml
name: Node.js CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  include-pipeline:
    uses: ./.github/workflows/nodejs-pipeline.yml
    with:
      app_name: "my-nodejs-app"
      node_version: "18"
    secrets: inherit
```

#### Azure DevOps

```yaml
resources:
  repositories:
    - repository: templates
      type: git
      name: YourProject/pipeline-templates

stages:
- template: ci/nodejs-pipeline-template.yml@templates
  parameters:
    appName: 'my-nodejs-app'
    nodeVersion: '18'
```

### Customization

The template is designed to be customizable. Common customization points include:

- **Test Commands**: Update the test scripts to match your project's test commands
- **Build Process**: Customize the build process for your specific Node.js framework
- **Deployment Configuration**: Adjust the deployment scripts for your infrastructure
- **Notification Content**: Customize the Slack notification message format

### Best Practices

- Keep secrets in your CI/CD platform's secure storage, never hardcode them
- Regularly update dependencies to address security vulnerabilities
- Use specific versions for tools and dependencies to ensure reproducible builds
- Add comments to explain complex pipeline logic
- Test pipeline changes in a development environment before applying to production