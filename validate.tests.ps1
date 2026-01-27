[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TerraformConfigurationPath
)

BeforeAll {
    $ErrorActionPreference = 'Continue'
    $script:appServiceUrl = $null
    Push-Location $TerraformConfigurationPath
    $outputJson = terraform output -json | ConvertFrom-Json -AsHashtable
    Pop-Location
    if ($outputJson.app_service_url) {
        $script:appServiceUrl = $outputJson.app_service_url.value
    }
}

Describe "Web Tests" {

    BeforeAll {
        if (-not $script:appServiceUrl) {
            throw "App Service URL not available. Cannot test API functionality."
        }
    }

    Context "Terraform Infrastructure" {

        It "Should have app_service_url output defined" {
            $script:appServiceUrl | Should -Not -BeNullOrEmpty
        }

        It "App Service URL should be a valid HTTPS endpoint" {
            $script:appServiceUrl | Should -Match '^https://'
        }
    }

    Context "API Functionality" {

        It "Should have a /calculate endpoint" {
            $calculateUrl = "$script:appServiceUrl/calculate?a=5&b=3"
            { Invoke-RestMethod -Uri $calculateUrl -Method Get -ErrorAction Stop } | Should -Not -Throw
        }

        It "Should correctly calculate sum via API" {
            $calculateUrl = "$script:appServiceUrl/calculate?a=5&b=3"
            $result = Invoke-RestMethod -Uri $calculateUrl -Method Get

            $result | Should -Be 8
        }

        It "Should handle different numbers correctly" {
            $calculateUrl = "$script:appServiceUrl/calculate?a=10&b=15"
            $result = Invoke-RestMethod -Uri $calculateUrl -Method Get

            $result | Should -Be 25
        }
    }

    Context "Healthcheck Endpoint Pattern" {

        It "Should have a /health endpoint" {
            $calculateUrl = "$script:appServiceUrl/health"
            { Invoke-RestMethod -Uri $calculateUrl -Method Get -ErrorAction Stop } | Should -Not -Throw
        }
    }
}

Describe "Actions Tests" {

    Context "GitHub Actions Workflow" {

        It "Should have a deploy workflow file" {
            (Test-Path ".github/workflows/deploy.yml") -or (Test-Path ".github/workflows/deploy.yaml") | Should -BeTrue
        }

        It "Should have a destroy workflow file" {
            (Test-Path ".github/workflows/destroy.yml") -or (Test-Path ".github/workflows/destroy.yaml") | Should -BeTrue
        }
    }
}

Describe "Terraform tests" {

    Context "Terraform Configuration" {

        It "Should have main Terraform configurations" {
            Push-Location $TerraformConfigurationPath
            Test-Path "*.tf" | Should -Be $true
            Pop-Location
        }
    }
}

# Run the tests
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Platform Engineer Technical Test Validator" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Prerequisites:" -ForegroundColor Yellow
Write-Host "  - Terraform must be initialized and applied" -ForegroundColor Yellow
Write-Host "  - API must be deployed and running`n" -ForegroundColor Yellow

Write-Host "Running validation tests...`n" -ForegroundColor Green
