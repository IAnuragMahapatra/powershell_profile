# ==============================================================================
# ANURAG MAHAPATRA'S POWERSHELL PROFILE
# ===============================================================================

# ---------------------------
# oh-my-posh
# ---------------------------
if (Get-Command git -ErrorAction SilentlyContinue) {
    if (git rev-parse --is-inside-work-tree 2>$null) {
        Import-Module posh-git -ErrorAction SilentlyContinue
    }
}

$ompPath = Join-Path $env:LOCALAPPDATA "Programs\oh-my-posh\themes\anurag.json"
if (Test-Path $ompPath) {
    oh-my-posh init pwsh --config $ompPath | Invoke-Expression
}

# ---------------------------
# Developer shortcuts
# ---------------------------
function gh     { param([string]$repo) Start-Process "https://github.com/$repo" }
function mygh   { Start-Process "https://github.com/IAnuragMahapatra" }
function o      { Start-Process explorer.exe "." }

# ---------------------------
# System & network info
# ---------------------------
function sysinfo { systeminfo | Select-String "^OS|^System|^Total Physical Memory" }
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
Add-Type -AssemblyName System.Web

function search {
    param (
        [switch]$b,
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$query
    )

    $queryString = $query -join ' '

    if ($queryString -match '^https?://') {
        # If input starts with http:// or https://, treat as direct URL
        $url = $queryString
    }
    else {
        $encodedQuery = [System.Web.HttpUtility]::UrlEncode($queryString)
        if ($encodedQuery) {
            $url = "https://www.google.com/search?q=$encodedQuery"
        } else {
            $url = "https://www.google.com"
        }
    }

    if ($b) {
        Start-Process "brave.exe" $url
    } else {
        Start-Process "chrome.exe" "--profile-directory=Default", $url
    }
}


function yt {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$query
    )

    if ($query) {
        $rawQuery = $query -join ' '
        $encodedQuery = [System.Web.HttpUtility]::UrlEncode($rawQuery)
        $url = "https://www.youtube.com/results?search_query=$encodedQuery"
    } else {
        $url = "https://www.youtube.com"
    }

    Start-Process "brave.exe" $url
}
function play {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$query
    )

    if ($query) {
        $joinedQuery = $query -join ' '
        $encodedQuery = [System.Web.HttpUtility]::UrlEncode($joinedQuery)
        $url = "https://open.spotify.com/search/$encodedQuery"
    } else {
        $url = "https://open.spotify.com/collection/tracks"
    }

    Start-Process "brave.exe" $url
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
    Write-Host " - GitHub:     gh, mygh, o"
    Write-Host " - Sys:        sysinfo, ip, killport, ports"
    Write-Host " - Docker:     dcb, dcr, dcu, dcd, dki"
    Write-Host " - Git:        g,gst, gss, ga, cmt, push, pull, glog"
    Write-Host " - AI:         gpt, gemini"
    Write-Host " - Browsers:   search [-b query], yt, play"
    Write-Host " - Python:     py, pipi, mkenv, av, dv, uvi, uva, uvr, uvs, uvl, uvrn, uvp, urm"
    Write-Host " - Editors:    code, vim, tmux"
    Write-Host " - Utils:      unzip, json, pingurl, reload"
    Write-Host " - Aliases:   c (clear), ll (ls -a), la (ls -aR), grep, top, .., np, utf8"
}

# ---------------------------
# Welcome
# ---------------------------
Clear-Host
$timeStamp = Get-Date -Format 'dddd, MMMM dd, yyyy - HH:mm:ss'
Write-Host "[+] User: $env:USERNAME" -ForegroundColor DarkYellow
Write-Host "[+] Date: $timeStamp" -ForegroundColor DarkYellow
