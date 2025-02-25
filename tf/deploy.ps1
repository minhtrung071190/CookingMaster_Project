$folders = @('backend-db', 'backend', 'frontend')

foreach ($folder in $folders) {
    Write-Host '🔹 Provisioning $folder...' -ForegroundColor Cyan
    Set-Location $folder

    terraform init -input=false
    if ($LASTEXITCODE -ne 0) { 
        Write-Host '❌ terraform init failed in $folder' -ForegroundColor Red
        exit 1
    }

    terraform apply -auto-approve
    if ($LASTEXITCODE -ne 0) { 
        Write-Host '❌ terraform apply failed in $folder' -ForegroundColor Red
        exit 1
    }

    Set-Location ..
    Write-Host '✅ $folder provisioned successfully!' -ForegroundColor Green
}

Write-Host '🎉 All Terraform resources have been provisioned!' -ForegroundColor Yellow
