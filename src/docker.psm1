function cleanup_docker() {
    $VHDX_PATH = "$env:LOCALAPPDATA\Docker\wsl\disk\docker_data.vhdx"
    Write-Host "Docker Cleanup Script Starting..." -ForegroundColor Green
    Write-Host "VHDX Target: $VHDX_PATH" -ForegroundColor Cyan

    # Check Docker is running
    try {
        docker info --format '{{.ServerVersion}}' | Out-Null
        Write-Host "Docker daemon running" -ForegroundColor Green
    }
    catch {
        Write-Host "Docker Desktop not running! Start it first." -ForegroundColor Red
        exit 1
    }

    # Show space BEFORE
    Write-Host "`nSpace BEFORE prune:" -ForegroundColor Yellow
    docker system df

    # PRUNE (interactive) - keeps stopped containers AND their volumes
    $confirm = Read-Host "Prune build cache + unused images/networks? Keeps stopped containers & volumes. (y/N)"
    if ($confirm -match '^[Yy]$') {
        Write-Host "Pruning build cache..." -ForegroundColor Red
        docker builder prune -a -f

        Write-Host "Pruning unused images (referenced images, incl. by stopped containers, are kept)..." -ForegroundColor Red
        docker image prune -a -f

        Write-Host "Pruning unused networks..." -ForegroundColor Red
        docker network prune -f

        Write-Host "Prune complete! Stopped containers and volumes untouched." -ForegroundColor Green
    }
    else {
        Write-Host "Skipping prune" -ForegroundColor Yellow
    }

    # Shutdown WSL
    Write-Host "`nShutting down WSL..." -ForegroundColor Yellow
    wsl --shutdown
    Start-Sleep -Seconds 3

    # Find VHDX
    if (-not (Test-Path $VHDX_PATH)) {
        $altPath = "$env:LOCALAPPDATA\Docker\wsl\data\docker_data.vhdx"
        if (Test-Path $altPath) {
            $VHDX_PATH = $altPath
            Write-Host "Found VHDX at: $VHDX_PATH" -ForegroundColor Cyan
        }
        else {
            Write-Host "VHDX not found! Check:" -ForegroundColor Red
            Write-Host "  $env:LOCALAPPDATA\Docker\wsl\data\" -ForegroundColor Gray
            exit 1
        }
    }

    # OPTIMIZE VHDX
    Write-Host "`nOptimizing VHDX..." -ForegroundColor Yellow
    try {
        $sizeBefore = (Get-Item $VHDX_PATH).Length / 1GB
        Write-Host "Size before: $([math]::Round($sizeBefore,1))GB"
        sudo Optimize-VHD -Path $VHDX_PATH -Mode Full
        Write-Host "VHDX optimized! Check TreeSize." -ForegroundColor Green
    }
    catch {
        Write-Host "Optimize-VHD failed: $_" -ForegroundColor Red
    }

    Write-Host "`nDone! Restart Docker Desktop." -ForegroundColor Green
}
Export-ModuleMember -Function cleanup_docker
