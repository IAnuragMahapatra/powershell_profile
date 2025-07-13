# ==============================================================================
# ANURAG MAHAPATRA'S POWERSHELL PROFILE
# ===============================================================================

# ---------------------------
# Lazy load modules
# ---------------------------
if (Get-Command git -ErrorAction SilentlyContinue) {
    if (git rev-parse --is-inside-work-tree 2>$null) {
        Import-Module posh-git -ErrorAction SilentlyContinue
    }
}

$ompPath = Join-Path $env:LOCALAPPDATA "Programs\oh-my-posh\themes\tokyo.omp.json"
if (Test-Path $ompPath) {
    oh-my-posh init pwsh --config $ompPath | Invoke-Expression
}

# ---------------------------
# Developer shortcuts
# ---------------------------
function gh     { param([string]$repo) Start-Process "https://github.com/$repo" }
function mygh   { Start-Process "https://github.com/IAnuragMahapatra" }
function so     { param([string]$q)   Start-Process "https://stackoverflow.com/search?q=$q" }
function pwc    { Start-Process "https://paperswithcode.com/" }
function o      { Start-Process explorer.exe "." }

# ---------------------------
# System & network info
# ---------------------------
function sysinfo { systeminfo | Select-String "^OS|^System|^Total Physical Memory" }
function ip { 
    $ip = Invoke-RestMethod "https://api.ipify.org"
    Write-Host " 🌐Public IP: $ip" -ForegroundColor Green
}
function killport {
    param([int]$port)
    $conns = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($conns) {
        foreach ($c in $conns) {
            Stop-Process -Id $c.OwningProcess -Force
            Write-Host "Killed process on port $port (PID: $($c.OwningProcess))"
        }
    } else {
        Write-Host "No process found on port $port"
    }
}
function ports { Get-NetTCPConnection | Select LocalAddress, LocalPort, State, OwningProcess | Sort LocalPort }

# ---------------------------
# ML & data science tools
# ---------------------------
function jup { jupyter lab }
function tb  { tensorboard --logdir=logs }
function mlf { mlflow ui }

# ---------------------------
# Docker & container tools
# ---------------------------
function dcb { param([string]$name) docker build -t $name . }
function dcr { param([string[]]$args) docker run -it --rm @args }
function dcu { docker-compose up -d }
function dcd { docker-compose down }
function dki { docker kill $(docker ps -q) }

# ---------------------------
# Git shortcuts
# ---------------------------
function g { git init }
function gst { git status }
function gss { git status -s }
function ga  { git add . }
function cmt  { param([string]$msg) git commit -m $msg }
function push  { git push }
function pull { git pull }
function glog  { git log --oneline -10 }

# ---------------------------
# AI Chat
# ---------------------------
function gpt    { Start-Process "https://chat.openai.com/" }
function gemini { Start-Process "https://aistudio.google.com/prompts/new_chat?model=gemini-2.5-pro" }

# ---------------------------
# Browsers & search
# ---------------------------
function chrome { Start-Process "chrome.exe" }
function brave  { Start-Process "brave.exe" }
function search {
    param([string]$flag, [string]$query)
    if ($flag -eq "-b" -and $query) {
        Start-Process "brave.exe" "--new-window https://www.google.com/search?q=$query"
    } elseif ($flag) {
        Start-Process "https://www.google.com/search?q=$flag"
    } else {
        Start-Process "https://www.google.com"
    }
}

function yt {
    param([string]$query)
    if ($query) {
        Start-Process "brave.exe" "--new-window https://www.youtube.com/results?search_query=$query"
    } else {
        Start-Process "brave.exe" "--new-window https://www.youtube.com"
    }
}

# ---------------------------
# Python & virtual environments
# ---------------------------
function py    { param([string]$file) if ($file) { python $file } else { python } }
function pipi  { param([string[]]$pkgs) pip install @pkgs }
function mkenv { param([string]$name = 'venv') python -m venv $name }
function av    { param([string]$name = 'venv') & .\$name\Scripts\Activate }
function dv    { deactivate }
function uvi { param([string]$dir="") uv init $dir }
function uva { param([string[]]$pkgs) uv add @pkgs }
function uvr { param([string[]]$pkgs) uv remove @pkgs }
function uvs { uv sync }
function uvl { uv lock }
function uvrn { param([string[]]$args) uv run @args }
function uvp { param([string[]]$args) uv pip @args }
function urm { param([string[]]$args) uv run mcp install @args }


# ---------------------------
# Kubernetes & cloud
# ---------------------------
function kctx   { param([string]$ctx) kubectl config use-context $ctx }
function kgn    { kubectl get nodes }
function kgp    { kubectl get pods }
function awscli { param([string[]]$args) aws @args }
function azcli  { param([string[]]$args) az @args }
function gcloud { param([string[]]$args) gcloud @args }

# ---------------------------
# Editors & terminal helpers
# ---------------------------
function code  { param([string]$path = '.') Start-Process "code" $path }
function cursor  { param([string]$path = '.') Start-Process "cursor" $path }
function vim {
    param([string]$file)
    if ($file) {
        Start-Process cmd.exe -ArgumentList "/k nvim $file"
    } else {
        Start-Process cmd.exe -ArgumentList "/k nvim"
    }
}
function tmux  { param([string]$args) Start-Process "wsl" "tmux $args" }

# ---------------------------
# Utils
# ---------------------------
function unzip {
    param(
        [string]$archive,
        [string]$dest = "."
    )
    & "C:\Program Files\WinRAR\winrar.exe" x -o+ $archive $dest
}
function json  { param([string]$file) Get-Content $file | ConvertFrom-Json | ConvertTo-Json -Depth 100 }
function pingurl { param([string]$url) (Invoke-WebRequest -Uri $url -UseBasicParsing).StatusCode }
function reload { ". $PROFILE"; Write-Host "✅ Profile reloaded." -ForegroundColor Green }
function c { Clear-Host }
function ll { Get-ChildItem -Force }
function la { Get-ChildItem -Force -Recurse }
function grep { param($pattern, $path) Get-ChildItem $path | Select-String $pattern }
function top { Get-Process }
function .. { Set-Location .. }
function wtree { param([int]$depth = 2) wsl tree -L $depth }
function wgrep { param([string]$pattern, [string]$path = '.') wsl grep -r $pattern $path }

# ---------------------------
# Aliases
# ---------------------------
Set-Alias np notepad
Set-Alias utf8 chcp 65001

# ---------------------------
# Help
# ---------------------------
function hlp {
    Write-Host "🛠️  Tools & Shortcuts" -ForegroundColor Cyan
    Write-Host " - GitHub:     gh, mygh, so, pwc, o"
    Write-Host " - Sys:        sysinfo, ip, killport, ports"
    Write-Host " - ML:         jup, tb, mlf"
    Write-Host " - Docker:     dcb, dcr, dcu, dcd, dki"
    Write-Host " - Git:        g,gst, gss, ga, cmt, push, pull, glog"
    Write-Host " - AI:         gpt, gemini"
    Write-Host " - Browsers:   chrome, brave, search [-b query], yt"
    Write-Host " - Python:     py, pipi, mkenv, av, dv, uvi, uva, uvr, uvs, uvl, uvrn, uvp, urm"
    Write-Host " - K8s & Cloud:kctx, kgn, kgp, awscli, azcli, gcloud"
    Write-Host " - Editors:    code, vim, tmux"
    Write-Host " - Utils:      unzip, json, pingurl, reload"
    Write-Host " - Aliases:   c (clear), ll (ls -a), la (ls -aR), grep, top, .., np, utf8"
}

# ---------------------------
# Welcome
# ---------------------------
Clear-Host
Write-Host "🎐 Welcome back, $env:USERNAME! ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))" -ForegroundColor WHITE
