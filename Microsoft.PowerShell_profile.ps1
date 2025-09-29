# --- PROMPT ---
if (Get-Command starship -ErrorAction SilentlyContinue) {
    try { Invoke-Expression (& starship init powershell) } 
    catch { Write-Host "Starship init failed" -ForegroundColor Red }
}

# --- ZOXIDE ---
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression ((zoxide init powershell) -join "`n")
    function zz { zoxide query -i | Set-Location }
}

# --- VERSION CONTROL ---
function g { git init }
function gst { git status }
function gss { git status -s }
function ga { git add . }
function cmt { 
    param([string]$msg) 
    if (-not $msg) { git commit } else { git commit -m $msg } 
}
function push { git push }
function pull { git pull }
function glog { git log --oneline -10 }
function gs { git switch @args }
function gd { git diff @args }
function gco { git checkout @args }
function github { 
    param([string]$repo) 
    if (-not $repo) { Write-Host "Usage: github <username/repo>" -ForegroundColor Yellow; return }
    Start-Process "https://github.com/$repo" 
}
function mygh { Start-Process "https://github.com/IAnuragMahapatra" }
function gcl {
    param([string]$repo)
    if (-not $repo) { Write-Host "Usage: gcl <username/repo>" -ForegroundColor Yellow; return }
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { 
        Write-Host "gh CLI not found" -ForegroundColor Yellow; return 
    }
    gh repo clone $repo
    $folder = [System.IO.Path]::GetFileNameWithoutExtension($repo)
    if (Test-Path $folder) { Set-Location $folder } 
    else { Write-Host "Cloned but could not cd into $folder" -ForegroundColor Yellow }
}
function gpr { 
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { 
        Write-Host "gh CLI not found" -ForegroundColor Yellow; return 
    }
    gh pr create --fill 
}
function gprv { 
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { 
        Write-Host "gh CLI not found" -ForegroundColor Yellow; return 
    }
    gh pr view --web 
}
function gci { 
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { 
        Write-Host "gh CLI not found" -ForegroundColor Yellow; return 
    }
    gh issue create --web 
}

# --- AI PLATFORMS ---
function gpt { Start-Process "https://chat.openai.com/" -WindowStyle Maximized }
function gemini { Start-Process "https://gemini.google.com/app" -WindowStyle Maximized }
function grok { Start-Process "https://grok.com/" -WindowStyle Maximized }

# --- WEB & SEARCH ---
Add-Type -AssemblyName System.Web
function search { 
    param([switch]$b, [string[]]$query)
    if (-not $query) { Write-Host "Usage: search [-b] <query>" -ForegroundColor Yellow; return }
    $q = $query -join ' '
    $url = if ($q -match '^https?://') { $q } 
           else { "https://www.google.com/search?q=$([System.Web.HttpUtility]::UrlEncode($q))" }
    $browser = if ($b) { "brave.exe" } else { "chrome.exe" }
    if (Get-Command $browser -ErrorAction SilentlyContinue) { 
        Start-Process $browser $url -ErrorAction SilentlyContinue 
    } else { 
        Write-Host "$browser not found" -ForegroundColor Yellow 
    }
}
function yt { 
    param([string[]]$query)
    $url = if ($query) { 
        "https://www.youtube.com/results?search_query=$([System.Web.HttpUtility]::UrlEncode($query -join ' '))" 
    } else { 
        "https://www.youtube.com" 
    }
    if (Get-Command brave.exe -ErrorAction SilentlyContinue) { 
        Start-Process "brave.exe" $url -ErrorAction SilentlyContinue 
    } else { 
        Write-Host "brave.exe not found" -ForegroundColor Yellow 
    }
}
function api { 
    param([string[]]$args)
    posting @args 
}

# --- PYTHON ECOSYSTEM ---
function py { 
    param([string]$file) 
    if ($file) { python $file } else { python } 
}
function pipi { 
    param([string[]]$pkgs) 
    if (-not $pkgs) { Write-Host "Usage: pipi <package1> [package2...]" -ForegroundColor Yellow; return }
    pip install @pkgs 
}
function mkenv { 
    param([string]$name='venv') 
    python -m venv $name 
}
function av { 
    param([string]$name='venv') 
    if (-not (Test-Path ".\$name\Scripts\Activate.ps1")) {
        Write-Host "Virtual environment '$name' not found" -ForegroundColor Red; return
    }
    & .\$name\Scripts\Activate 
}
function dv { deactivate }
function uvi { 
    param([string]$dir='') 
    uv init $dir 
}
function uva { 
    param([string[]]$pkgs) 
    if (-not $pkgs) { Write-Host "Usage: uva <package1> [package2...]" -ForegroundColor Yellow; return }
    uv add @pkgs 
}
function uvr { 
    param([string[]]$pkgs) 
    if (-not $pkgs) { Write-Host "Usage: uvr <package1> [package2...]" -ForegroundColor Yellow; return }
    uv remove @pkgs 
}
function uvs { uv sync }
function uvl { uv lock }
function uvrn { 
    param([string[]]$args) 
    if (-not $args) { Write-Host "Usage: uvrn <command> [args...]" -ForegroundColor Yellow; return }
    uv run @args 
}
function uvp { 
    param([string[]]$args) 
    if (-not $args) { Write-Host "Usage: uvp <pip-command> [args...]" -ForegroundColor Yellow; return }
    uv pip @args 
}
function urm { 
    param([string[]]$args) 
    if (-not $args) { Write-Host "Usage: urm <package1> [package2...]" -ForegroundColor Yellow; return }
    uv run mcp install @args 
}

# --- DEVELOPMENT TOOLS ---
function np { 
    param([string]$path)
    if (-not $path) { 
        Start-Process "notepad" 
    } else {
        Start-Process "notepad" $path 
    }
}
function code { 
    param([string]$path='.') 
    Start-Process "code" $path 
}
function cursor { 
    param([string]$path='.') 
    Start-Process "cursor" $path 
}
function kiro { 
    param([string]$path='.') 
    Start-Process "kiro" $path 
}
function vim { 
    param([string]$path='.') 
    Start-Process "nvim" $path -NoNewWindow 
}

# --- SYSTEM MONITORING ---
function ff { fastfetch --logo windows @Args }
function kp { 
    param([int]$port)
    if (-not $port) { Write-Host "Usage: kp <port>" -ForegroundColor Yellow; return }
    $conns = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($conns) { 
        $conns | ForEach-Object { 
            try { 
                Stop-Process -Id $_.OwningProcess -Force 
                Write-Host "Killed PID $($_.OwningProcess)" -ForegroundColor Green
            } catch { 
                Write-Host "Failed to kill PID $($_.OwningProcess)" -ForegroundColor Red 
            }
        } 
    } else { 
        Write-Host "No process on port $port" -ForegroundColor Yellow 
    }
}
function netstat { 
    Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, State, OwningProcess | Sort-Object LocalPort 
}
function top { 
    if (Get-Command glances -ErrorAction SilentlyContinue) { 
        glances 
    } else { 
        Write-Host "glances not found" -ForegroundColor Yellow 
    }
}
function fkill { 
    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) { 
        Write-Host "fzf not found" -ForegroundColor Yellow; return 
    }
    Get-Process | ForEach-Object { "$($_.Id)`t$($_.Name)`t$($_.CPU)" } | 
    fzf --multi --header "Select processes to kill (Tab for multi-select)" | 
    ForEach-Object { 
        if ($_ -match '^(\d+)') { 
            $pid = $Matches[1]
            Stop-Process -Id $pid -Force -Confirm:$false
            Write-Host "Killed process $pid" -ForegroundColor Green
        }
    }
}
function httping { 
    param([string]$url) 
    if (-not $url) { Write-Host "Usage: httping <url>" -ForegroundColor Yellow; return }
    try { 
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    } catch { 
        Write-Host "Request failed: $($_.Exception.Message)" -ForegroundColor Red 
    } 
}

# --- NAVIGATION & FILESYSTEM ---
# Remove built-in aliases
Remove-Item alias:ls -Force
Remove-Item alias:dir -Force

function d { Set-Location D:/ }
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function unzip { 
    param([string]$archive, [string]$dest=".")
    if (-not $archive) { Write-Host "Usage: unzip <archive> [destination]" -ForegroundColor Yellow; return }
    if (-not (Test-Path $archive)) { Write-Host "Archive not found: $archive" -ForegroundColor Red; return }
    if (Test-Path "D:\Programs\7-Zip\7z.exe") {
        & "D:\Programs\7-Zip\7z.exe" x -y $archive "-o$dest"
    } else {
        Write-Host "7-Zip not found at D:\Programs\7-Zip\7z.exe" -ForegroundColor Yellow
    }
}
function ll { 
    if (Get-Command eza -ErrorAction SilentlyContinue) { 
        eza -l 
    } else { 
        Get-ChildItem | Format-Table 
    }
}
function la { 
    if (Get-Command eza -ErrorAction SilentlyContinue) { 
        eza -l --all 
    } else { 
        Get-ChildItem -Force | Format-Table 
    }
}
function lt {
    param(
        [int]$level
    )

    if (Get-Command eza -ErrorAction SilentlyContinue) {
        $args = @('--all', '--tree')
        if ($PSBoundParameters.ContainsKey('level')) {
            $args += "--level=$level"
        }
        eza @args
    } else {
        if ($PSBoundParameters.ContainsKey('level')) {
            Write-Warning "Windows 'tree' does not support depth limiting; showing full tree."
        }
        tree /f
    }
}
function lg { 
    if (Get-Command eza -ErrorAction SilentlyContinue) { 
        eza --git --all --long 
    } else { 
        Get-ChildItem | Format-Table 
    }
}

# --- SEARCH & FIND ---
function grep { 
    param($pattern, $path=".")
    if (-not $pattern) { Write-Host "Usage: grep <pattern> [path]" -ForegroundColor Yellow; return }
    if (Get-Command ripgrep -ErrorAction SilentlyContinue) {
        rg $pattern $path
    } elseif (Get-Command rg -ErrorAction SilentlyContinue) {
        rg $pattern $path
    } else {
        Get-ChildItem $path -Recurse | Select-String $pattern 
    }
}
function find { 
    param([string]$name, [string]$path=".")
    if (-not $name) { Write-Host "Usage: find <name> [path]" -ForegroundColor Yellow; return }
    if (Get-Command fd -ErrorAction SilentlyContinue) {
        fd $name $path
    } else {
        Get-ChildItem -Path $path -Recurse -Name "*$name*" | ForEach-Object { Join-Path $path $_ }
    }
}

# --- DATA PROCESSING ---
function json { 
    param([string]$file) 
    if (-not $file) { Write-Host "Usage: json <file>" -ForegroundColor Yellow; return }
    if (-not (Test-Path $file)) { Write-Host "File not found: $file" -ForegroundColor Red; return }
    if (-not (Get-Command jq -ErrorAction SilentlyContinue)) { 
        Write-Host "jq not found" -ForegroundColor Yellow; return 
    }
    if (Get-Command bat -ErrorAction SilentlyContinue) {
        Get-Content $file -Raw | jq . | bat --language json
    } else {
        Get-Content $file -Raw | jq .
    }
}
function jqq { 
    param([string]$filter=".")
    if (Get-Command jq -ErrorAction SilentlyContinue) {
        if (Get-Command bat -ErrorAction SilentlyContinue) {
            $input | jq $filter | bat --language json
        } else {
            $input | jq $filter
        }
    } else {
        Write-Host "jq not found" -ForegroundColor Yellow
    }
}

# --- UTILITIES ---
function reload { . $PROFILE }
function clear { Clear-Host }
function c { Clear-Host }
function copy { param([string]$text) Set-Clipboard $text }
function paste { Get-Clipboard }
Remove-Item alias:cat -Force
function cat { bat @args }

# --- ENTERTAINMENT ---
function ls { curl -k https://ascii.live/rick }
function dir { curl -k https://ascii.live/rick }
function sw { 
    try {
        $c = New-Object Net.Sockets.TcpClient("towel.blinkenlights.nl", 23)
        $r = New-Object IO.StreamReader($c.GetStream())
        while ($r.Peek() -ge 0) { Write-Host $r.ReadLine() }
        $r.Close()
        $c.Close()
    } catch {
        Write-Host "Could not connect to Star Wars server" -ForegroundColor Red
    }
}
function yup {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $r = Invoke-RestMethod "https://zenquotes.io/api/random" -SkipCertificateCheck
    "$($r[0].q) — $($r[0].a)"
}

# --- HELP ---
function hlp {
    Write-Host "`nVERSION CONTROL:" -ForegroundColor Yellow
    Write-Host " g - git init"
    Write-Host " gst - git status"
    Write-Host " gss - git status -s"
    Write-Host " ga - git add ."
    Write-Host " cmt [msg] - git commit [with message]"
    Write-Host " push - git push"
    Write-Host " pull - git pull"
    Write-Host " glog - git log --oneline -10"
    Write-Host " gs <branch> - git switch"
    Write-Host " gd [files] - git diff"
    Write-Host " gco <branch/files> - git checkout"
    Write-Host " github <repo> - open GitHub repo"
    Write-Host " mygh - open my GitHub profile"
    Write-Host " gcl <repo> - gh clone and cd"
    Write-Host " gpr - gh pr create --fill"
    Write-Host " gprv - gh pr view --web"
    Write-Host " gci - gh issue create --web"
    
    Write-Host "`nAI PLATFORMS:" -ForegroundColor Yellow
    Write-Host " gpt - open ChatGPT"
    Write-Host " gemini - open Google Gemini"
    Write-Host " grok - open Grok"
    
    Write-Host "`nWEB & SEARCH:" -ForegroundColor Yellow
    Write-Host " search [-b] <query> - Google search [in Brave]"
    Write-Host " yt [query] - YouTube [search]"
    Write-Host " api <args> - API testing tool (Posting)"
    
    Write-Host "`nPYTHON ECOSYSTEM:" -ForegroundColor Yellow
    Write-Host " py [file] - run Python [file]"
    Write-Host " pipi <packages> - pip install"
    Write-Host " mkenv [name] - create venv"
    Write-Host " av [name] - activate venv"
    Write-Host " dv - deactivate venv"
    Write-Host " uvi [dir] - uv init"
    Write-Host " uva <packages> - uv add"
    Write-Host " uvr <packages> - uv remove"
    Write-Host " uvs - uv sync"
    Write-Host " uvl - uv lock"
    Write-Host " uvrn <command> - uv run"
    Write-Host " uvp <args> - uv pip"
    Write-Host " urm <packages> - uv run mcp install"
    
    Write-Host "`nDEVELOPMENT TOOLS:" -ForegroundColor Yellow
    Write-Host " np [path] - open Notepad"
    Write-Host " code [path] - open VS Code"
    Write-Host " cursor [path] - open Cursor"
    Write-Host " kiro [path] - open Kiro"
    Write-Host " vim [path] - open Neovim"
    
    Write-Host "`nSYSTEM MONITORING:" -ForegroundColor Yellow
    Write-Host " ff - system info (fastfetch)" 
    Write-Host " kp <port> - kill process on port"
    Write-Host " netstat - show network connections"
    Write-Host " top - system monitor (glances)"
    Write-Host " fkill - interactive process killer"
    Write-Host " httping <url> - HTTP status check"
    
    Write-Host "`nNAVIGATION & FILESYSTEM:" -ForegroundColor Yellow
    Write-Host " d - go to D:/"
    Write-Host " .. - go up one directory"
    Write-Host " ... - go up two directories"
    Write-Host " .... - go up three directories"
    Write-Host " unzip <archive> [dest] - extract archive"
    Write-Host " ll - list files (detailed)"
    Write-Host " la - list all files (detailed)"
    Write-Host " lt [level] - tree view"
    Write-Host " lg - list with git status"
    
    Write-Host "`nSEARCH & FIND:" -ForegroundColor Yellow
    Write-Host " grep <pattern> [path] - search in files"
    Write-Host " find <name> [path] - find files"
    
    Write-Host "`nDATA PROCESSING:" -ForegroundColor Yellow
    Write-Host " json <file> - pretty print JSON"
    Write-Host " jqq [filter] - jq with bat syntax highlighting"
    
    Write-Host "`nUTILITIES:" -ForegroundColor Yellow
    Write-Host " reload - reload PowerShell profile"
    Write-Host " clear - clear screen"
    Write-Host " c - clear screen (short)"
    Write-Host " copy <text> - copy text to clipboard"
    Write-Host " paste - paste text from clipboard"
    Write-Host " cat - Uses bat instead of Get-Content"
    Write-Host " zz - interactive directory jump (zoxide)"
    Write-Host " hlp - show this help"
    
#    Write-Host "`nENTERTAINMENT:" -ForegroundColor Yellow
#    Write-Host " ls/dir - Rick Roll"
#    Write-Host " sw - ASCII Star Wars"
#    Write-Host " yup - random quote"
    
#    Write-Host "`nREQUIRED TOOLS (install if needed):" -ForegroundColor Cyan
#    Write-Host " starship, zoxide, gh, brave.exe, chrome.exe, fzf, glances, jq, bat, eza"
#    Write-Host " ripgrep/rg, fd, posting, spotify, 7-zip"
}

# --- CONSOLE RESET & CHOCOLATEY PROFILE IMPORT ---
Clear-Host
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) { 
    try { Import-Module "$ChocolateyProfile" } catch {} 
}