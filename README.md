# Platform Engineer Technical Test

## Overview
This technical test evaluates your skills as a Platform Engineer. You will deploy a .NET application to Azure using GitHub Actions, implement a health check endpoint, and create both deployment and destruction workflows.

## Provided Files
- `credentials.json`: Contains Azure service principal credentials for authentication and deployment
- `backend.json`: Optional Terraform backend configuration file (use at your discretion)
- `validate.tests.ps1`: Pester test script to help validate your submission (Tested with Powershell v7 and Pester v5)
- Application source code (functional but without health check endpoint)

## Prerequisites
- GitHub account with repository creation permissions
- Basic understanding of GitHub Actions, Terraform, and .NET
- Familiarity with Azure App Service

## Instructions

### 1. Repository Setup
1. Create a new GitHub repository for your solution
2. Copy the `src` folder for the dummy application into your new repository
3. Structure the repository as you see fit for the deployment

### 2. Implement Health Check Endpoint
Add a health check endpoint to the .NET application in `src/AjgPlatformTest/Program.cs`:
- Use the `Microsoft.Extensions.Diagnostics.HealthChecks` package
- Add a `/health` endpoint that returns HTTP 200 OK with a simple JSON response
- Ensure the health check verifies basic application functionality

### 3. Create GitHub Actions Workflows
Create the following workflows in `.github/workflows/`:

#### Deploy Workflow
- **Trigger**: Manual dispatch
- **Steps**:
  1. Authenticate with Azure using the provided credentials (store securely)
  2. Run `terraform init` and `terraform apply`
  3. Build and publish the .NET application
  4. Deploy the application to Azure App Service (use free tier Linux App Service)
  5. Validate the deployment

#### Destroy Workflow
- **Trigger**: Manual dispatch
- **Steps**:
  1. Authenticate with Azure using the provided credentials
  2. Run `terraform destroy`
  3. Clean up any remaining resources

### 4. Secure Credential Management
- Store Azure credentials securely in GitHub repository secrets
- Do not commit `credentials.json` directly to the repository (!!!)
- Use GitHub's encrypted secrets feature

### 5. Testing and Verification
1. Push your changes and trigger the deploy workflow
2. Verify the infrastructure is created successfully
3. Confirm the application is deployed and accessible
4. Test both `/calculate` and `/health` endpoints
5. Run the provided Pester validation tests:
   ```powershell
   Invoke-Pester .\validate.tests.ps1
   ```
   The script validates:
   - Suggested Terraform infrastructure outputs
   - API functionality (/calculate endpoint)
   - Health check endpoint (/health)
   - GitHub Actions workflow files presence
   - Terraform configuration presence
6. Run the destroy workflow to clean up resources

### 6. Submit Your Solution
1. Ensure your workflows are functional
2. Commit and push your final solution
3. Share the GitHub repository URL with us
4. Be prepared to explain your implementation choices and solution

## Requirements
- **Functional deploy workflow**: Terraform apply + app deployment
- **Functional destroy workflow**: Complete resource cleanup
- **Health check endpoint**: Properly implemented in the application
- **Cost-effective**: Use free tier Linux App Service
- **Secure**: No insecure credential handling

## Additional Notes
- AI coding assistance is acceptable for this technical test, but please ensure you review the generated output and are able to explain it in detail
- Optionally, if you would like Azure portal access, request it by contacting the recruiter or e-mailing `thomas.keirl@redington.co.uk`, submitting your personal Microsoft account email address
- Focus on automation, security, and cost efficiency
- The solution should demonstrate Infrastructure as Code proficiency and understanding of applications and automation

## Evaluation Criteria
- Successful automated deployment via GitHub Actions
- Proper health check implementation
- Secure credential management
- Cost-effective resource usage
- Clean destroy workflow
- Code quality and documentation
- Infrastructure as Code practices
