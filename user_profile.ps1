# . c:\users\pcast\.config\powershell\menu-interactive.ps1
# oh-my-posh prompt init pwsh --config 'c:\Users\pcast\AppData\Local\Programs\oh-my-posh\themes\powerlevel10k_rainbow.omp.json' | Invoke-Expression
$ompFile = 'c:\Users\pcast\OneDrive\CONFIG\oh my posh themes\powerlevel10k_tokyo_paulo.omp.json'
oh-my-posh init pwsh --config $ompFile | Invoke-Expression

# $ENV:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"
#Z
Import-Module z
#git
Import-Module posh-git

#icons
Import-Module -Name Terminal-Icons
Import-Module PSReadLine
Import-Module PSFzf
# Import-Module -Name PS-Menu



#Enable-PoshTransientPrompt
# function Invoke-Starship-TransientFunction {
#   &starship module character
# }
# edit $PROFILE
# function Invoke-Starship-PreCommand {
#   $host.ui.RawUI.WindowTitle = "$env:USERNAME@$env:COMPUTERNAME`: $pwd `a"
# }

# Invoke-Expression (&starship init powershell)

# Enable-TransientPrompt
# $env:POSH_GIT_ENABLED = $true

# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
# Autocompletion for arrow keys
# Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -Colors @{emphasis = '#C678DD'; inlinePrediction = '#61AFEF' }

Set-PSReadLineKeyHandler -Key F7 `
    -BriefDescription History `
    -LongDescription 'Show command history' `
    -ScriptBlock {
    $pattern = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
    if ($pattern) {
        $pattern = [regex]::Escape($pattern)
    }

    $history = [System.Collections.ArrayList]@(
        $last = ''
        $lines = ''
        foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineOption).HistorySavePath)) {
            if ($line.EndsWith('`')) {
                $line = $line.Substring(0, $line.Length - 1)
                $lines = if ($lines) {
                    "$lines`n$line"
                }
                else {
                    $line
                }
                continue
            }

            if ($lines) {
                $line = "$lines`n$line"
                $lines = ''
            }

            if (($line -cne $last) -and (!$pattern -or ($line -match $pattern))) {
                $last = $line
                $line
            }
        }
    )
    $history.Reverse()

    $command = $history | Out-GridView -Title History -PassThru
    if ($command) {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command -join "`n"))
    }
}
Set-PSReadLineKeyHandler -Key F1 `
    -BriefDescription CommandHelp `
    -LongDescription "Open the help window for the current command" `
    -ScriptBlock {
    param($key, $arg)

    $ast = $null
    $tokens = $null
    $errors = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

    $commandAst = $ast.FindAll( {
            $node = $args[0]
            $node -is [CommandAst] -and
            $node.Extent.StartOffset -le $cursor -and
            $node.Extent.EndOffset -ge $cursor
        }, $true) | Select-Object -Last 1

    if ($commandAst -ne $null) {
        $commandName = $commandAst.GetCommandName()
        if ($commandName -ne $null) {
            $command = $ExecutionContext.InvokeCommand.GetCommand($commandName, 'All')
            if ($command -is [AliasInfo]) {
                $commandName = $command.ResolvedCommandName
            }

            if ($commandName -ne $null) {
                Get-Help $commandName -ShowWindow
            }
        }
    }
}

#Fuzzy Finder
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PsFzfOption -TabExpansion
# Set-PsFzfOption -EnableFd:$true

# # Define aliases to call fuzzy methods from PSFzf
# New-Alias -Scope Global -Name fcd -Value Invoke-FuzzySetLocation2 -ErrorAction Ignore
# New-Alias -Scope Global -Name fe -Value Invoke-FuzzyEdit -ErrorAction Ignore
# New-Alias -Scope Global -Name fh -Value Invoke-FuzzyHistory -ErrorAction Ignore
# New-Alias -Scope Global -Name fkill -Value Invoke-FuzzyKillProcess -ErrorAction Ignore
# New-Alias -Scope Global -Name fz -Value Invoke-FuzzyZLocation -ErrorAction Ignore
#Set-PsFzfOption -EnableFd

#Set-PsFzfOption -TabExpansion

Set-Alias codei code-insiders

# Use it to switch directories
<# Set-Alias ls Get-ChildItem-Wide -Option "AllScope"
Set-Alias ll Get-ChildItem
Set-Alias lla Get-ChildItem-All
Set-Alias la Get-ChildItem-All-Wide
Set-Alias g git #>
Set-Alias ls newLs
Set-Alias la newLa
Set-Alias ll newLl
Set-Alias lls newLls
Set-Alias llt newLlt
#Set-Alias ripgrep 'C:\Users\pcast\AppData\Local\Microsoft\WinGet\Packages\BurntSushi.ripgrep.MSVC_Microsoft.Winget.Source_8wekyb3d8bbwe\ripgrep-13.0.0-x86_64-pc-windows-msvc\rg.exe'
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

# Variables
$ENV:nvim = "C:\Program Files\Neovim\bin\nvim.exe"

# Alias

# GIT
function gs { git sb }
function gbr { git br }
function gll { git ll }
function glast { git last }
function gl { git gl }
function gsave { git save }
function gpush { git push }
function gpull { git pull }
function gcontrib { git contrib }
function glg1 { git lg1 }
function glg2 { git lg2 }
function gfetch { git fetch }
function gclone { git clone }
function gstash { git stash }
function gpop { git stash pop }
function gstl { git gstl }
function gm($branch) { git merge $branch }
function gswitch ($branch) { git switch $branch }
function gstashm($message) {
    git stash push -m $message
}
function gstashmf {
    param (
        [string]$message,
        [string[]]$files
    )

    # Create the stash with the specified message and files
    git stash push -m $message -- $files
}
function gitCodeEditor() {
    git config --global core.editor "code -w"
}
function gitNeovimEditor() {
    git config --global core.editor "nvim -w"
}

# GULP
function gulpc { gulp clean }
function gulpb { gulp build }
function gulpbn { gulp bundle --ship }
function gulpp { gulp package-solution --ship }

# ls
function newLs { lsd -a --group-dirs first }
function newLa {
    lsd -la --group-dirs first
}
function newLl { lsd -l --group-dirs first }
function newLls { lsd -la --sort=size --group-dirs first }
function newLlt { lsd -la --sort=time --group-dirs first }

function .. { Set-Location ..\. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function ..... { Set-Location ..\..\..\.. }
function ...... { Set-Location ..\..\..\..\.. }
function ....... { Set-Location ..\..\..\..\..\.. }
function ........ { Set-Location ..\..\..\..\..\..\.. }
function ......... { Set-Location ..\..\..\..\..\..\..\.. }

function Get-ChildItem-Wide {
    param
    (
        $Path,
        $LiteralPath,
        $Filter,
        $Include,
        $Exclude,
        $Recurse,
        $Force,
        $Name,
        $UseTransaction,
        $Attributes,
        $Depth,
        $Directory,
        $File,
        $Hidden,
        $ReadOnly,
        $System
    )
    Get-ChildItem @PSBoundParameters | Format-Wide -AutoSize
}

function Get-ChildItem-All {
    param
    (
        $Path,
        $LiteralPath,
        $Filter,
        $Include,
        $Exclude,
        $Recurse,
        $Force,
        $Name,
        $UseTransaction,
        $Attributes,
        $Depth,
        $Directory,
        $File,
        $Hidden,
        $ReadOnly,
        $System
    )
    if ($Attributes) {
        $PSBoundParameters.Remove('Attributes');
    }
    Get-ChildItem -Attributes ReadOnly, Hidden, System, Normal, Archive, Directory, Encrypted, NotContentIndexed, Offline, ReparsePoint, SparseFile, Temporary @PSBoundParameters
}

function Get-ChildItem-All-Wide {
    param
    (
        $Path,
        $LiteralPath,
        $Filter,
        $Include,
        $Exclude,
        $Recurse,
        $Force,
        $Name,
        $UseTransaction,
        $Attributes,
        $Depth,
        $Directory,
        $File,
        $Hidden,
        $ReadOnly,
        $System
    )
    Get-ChildItem-All @PSBoundParameters | Format-Wide -AutoSize
}
# Configuraciones programas
function vssettings { nvim 'c:\Users\pcast\AppData\Roaming\Code\User\settings.json' }

function gitconfig { nvim 'c:\Users\pcast\.gitconfig' -n }

function editpwsh { code 'c:\Users\pcast\.config\powershell\user_profile.ps1' -n }
function editomp { nvim $ompFile -n }
function pshistory { nvim 'c:\Users\pcast\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt' }

function vskeys { nvim 'c:\Users\pcast\OneDrive\CONFIG\vscode\usefull keys.txt' }

# Utilitarios
function npmglobals { npm list -g --depth 0 }

function trash { Start-Process shell:RecycleBinFolder }

function xampp { Start-Process 'C:\xampp\xampp-control.exe' }
function navicat { Start-Process "C:\Program Files\PremiumSoft\Navicat Premium Lite 17\navicat.exe" }

function angularBuild { npm run build-prod }

function updateapps { winget upgrade --all --include-unknown }

function publish { npm run publish }

# Utilities
function touch {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Path

    )

    if (Test-Path -LiteralPath $Path) {
			    (Get-Item -Path $Path).LastWriteTime = Get-Date

    }
    else {
        New-Item -Type File -Path $Path

    }

}

function CopiarAntesDeFormatear {
    #url de configuracion de neovim https://github.com/slydragonn/dotfiles
    Copy-Item -r -Force 'c:\Users\pcast\AppData\local\nvim' 'D:\backups\windows-02-01-2025' &&
    winget list > 'D:\backups\windows-02-01-2025\wingetlist.txt' &&
    # nvm ls > 'D:\backups\windows-02-01-2025\nvmls.txt' &&
    npmglobals > 'D:\backups\windows-02-01-2025\globalnpm.txt' &&
    Copy-Item -r -Force c:\Users\pcast\AppData\local\lf\ 'D:\backups\windows-02-01-2025\' &&
    Copy-Item 'c:\Users\pcast\.config\lsd\lsd-config.yaml' 'D:\backups\windows-02-01-2025\lsd-config.yaml' &&
    Copy-Item c:\Users\pcast\.gitconfig 'D:\backups\windows-02-01-2025\gitconfig.txt' &&
    Copy-Item c:\Users\pcast\.config\powershell\user_profile.ps1 'D:\backups\windows-02-01-2025\user_profile.ps1' &&
    Copy-Item C:\xampp\php\php.ini 'D:\backups\windows-02-01-2025\php.ini' &&
    Copy-Item C:\xampp\mysql\bin\my.ini 'D:\backups\windows-02-01-2025\my.ini' &&
    Copy-Item C:\xampp\phpMyAdmin\config.inc.php 'D:\backups\windows-02-01-2025\config.inc.php'
    <# Copy-Item c:\Users\pcast\.zshrc D:\backups\windows\config\.zshrc &&
    Copy-Item c:\Users\pcast\.p10k.zsh D:\backups\windows\config\.p10k.zsh &&
    Copy-Item c:\Users\pcast\.bashrc D:\backups\windows\config\.bashrc &&
    Copy-Item c:\Users\pcast\.inputrc D:\backups\windows\config\.inputrc #>
}

function CopiarAlRepositorio{
    Copy-Item -r -Force 'c:\Users\pcast\AppData\local\nvim' 'E:\Projects\Personal\config-windows' &&
    winget list > 'E:\Projects\Personal\config-windows\wingetlist.txt' &&
    # nvm ls > 'E:\Projects\Personal\config-windows\nvmls.txt' &&
    npmglobals > 'E:\Projects\Personal\config-windows\globalnpm.txt' &&
    Copy-Item -r -Force c:\Users\pcast\AppData\local\lf\ 'E:\Projects\Personal\config-windows\' &&
    Copy-Item 'c:\Users\pcast\.config\lsd\lsd-config.yaml' 'E:\Projects\Personal\config-windows\lsd-config.yaml' &&
    Copy-Item c:\Users\pcast\.gitconfig 'E:\Projects\Personal\config-windows\gitconfig.txt' &&
    Copy-Item c:\Users\pcast\.gitmessage 'E:\Projects\Personal\config-windows\gitmessage.txt' &&
    Copy-Item c:\Users\pcast\.config\powershell\user_profile.ps1 'E:\Projects\Personal\config-windows\user_profile.ps1' &&
    Copy-Item C:\xampp\php\php.ini 'E:\Projects\Personal\config-windows\php.ini' &&
    Copy-Item C:\xampp\mysql\bin\my.ini 'E:\Projects\Personal\config-windows\my.ini' &&
    Copy-Item C:\xampp\phpMyAdmin\config.inc.php 'E:\Projects\Personal\config-windows\config.inc.php'
}


function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function Set-PexelWallpaper {
    $numeroDePagina = Get-Random -Minimum 1 -Maximum 300
    $fecha = Get-Date -Format "yyyyMMdd"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add('Authorization', 'UGRvtnMQaGtbhFS32cbUApMZlLyxiSCK9VSszWJJboxxt3Xk84A7UFvS')
    $uriPexel = "https://api.pexels.com/v1/search?query=night&per_page=1&page=$numeroDePagina&orientation=landscape"
    $json = Invoke-RestMethod -Uri $uriPexel -Headers $headers


    $apiUrl = $json[0].photos[0].src.original
    # $apiUrl = "$bingUrl/hpimages/Latest/3840x2160/$fecha.jpg"
    #$imagePath = $response
    #$fullImagePath = "$bingUrl/$imagePath"
    $imageFile = "c:\Users\pcast\Downloads\$fecha.jpg"
    Invoke-WebRequest $apiUrl -OutFile $imageFile
    #Invoke-WebRequest $response -OutFile $imageFile
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'Wallpaper' -Value $imageFile
    rundll32.exe user32.dll, UpdatePerUserSystemParameters
}
function Set-BingWallpaper {
    $fecha = Get-Date -Format "yyyyMMdd"
    $url = "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US"
    $response = Invoke-RestMethod -Uri $url
    $imageURL = "https://www.bing.com" + $response.images[0].url

    $imageFile = "c:\Users\pcast\Downloads\$fecha.jpg"
    Invoke-WebRequest $imageURL -OutFile $imageFile
    # Invoke-WebRequest $response -OutFile $imageFile

    $regKey = "HKCU:\Control Panel\Desktop"
    Set-ItemProperty -Path $regKey -Name Wallpaper -Value $imageFile
    rundll32.exe user32.dll, UpdatePerUserSystemParameters
}

function Get-FolderSize {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $size = (Get-ChildItem $Path -Recurse | Measure-Object -Property Length -Sum).Sum
    $sizeInGB = $size / 1GB
    $sizeInMB = $size / 1MB
    $sizeInKB = $size / 1KB

    [PSCustomObject]@{
        "Folder"       = $Path
        "Size (GB)"    = "{0:N2} GB" -f $sizeInGB
        "Size (MB)"    = "{0:N2} MB" -f $sizeInMB
        "Size (KB)"    = "{0:N2} KB" -f $sizeInKB
        "Size (bytes)" = "$size bytes"
    }
}
function findPort {
    param (
        [Parameter(Mandatory = $true)]
        [int]$port
    )
    netstat -ano | findstr :$port
}
function killPort {
    param(
        [Parameter(Mandatory = $true)]
        [int]$port
    )
    taskkill /PID $port /F
}
function killportAngular {
    npm kill-port 4200
}
function reloadProfile {
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) | ForEach-Object {
        if (Test-Path $_) {
            Write-Verbose "Running $_"
            . $_
        }
    }
}
function angularVersion {
    $filename = '.\package.json'
    if (!(Test-Path -path $filename)) {
        return ""
    }
    $angularversion = rg '@angular/cli' .\package.json
    $angularversionSplit = $angularversion -split (': ')
    $numberAngularVersion = $angularversionSplit[1] -replace '"', "" -replace ',', ""
    if ([string]::IsNullOrEmpty($numberAngularVersion)) {
        return "  0.0.0"
    }
    else {

        return "  $( $numberAngularVersion)"
    }
}
function reactVersion {
    $filename = '.\package.json'
    if (!(Test-Path -path $filename)) {
        return ""
    }
    $reactversion = rg '"react":' .\package.json
    $reactversionSplit = $reactversion -split (': ')
    $numberReactVersion = $reactversionSplit[1] -replace '"', "" -replace ',', ""
    if ([string]::IsNullOrEmpty($numberReactVersion)) {
        return "  0.0.0"
    }
    else {

        return "  $($numberReactVersion)"
    }
}

# Personal
function homeFolder { set-location '~' }
function landingsFolder { set-location 'E:\Projects\Personal\landing' }

function htmlFolder { set-location 'E:\Projects\Personal\HTML' }

function descargasFolder { set-location 'c:\Users\pcast\Downloads\' }

function documentosFolder { set-location 'c:\Users\pcast\OneDrive\Documentos\' }
function imagenesFolder { set-location 'c:\Users\pcast\OneDrive\Imagenes\' }

function configFolder { set-location 'c:\Users\pcast\OneDrive\CONFIG\' }

function vsreposFolder { set-location 'E:\Projects\Personal\VisualStudio\source\repos' }

#Proyectos Folder
function projectsFolder { set-location 'E:\Projects' }

# Trabajo
$australFolder = "E:\Projects\AUSTRAL\app\AUSTRAL.Intranet.MiPerfil"
$sigqaFolder = "E:\Projects\basc\sig\Modulo.SigProyectos"
$sigprdFolderBackup = "E:\Projects\basc\sig\produccion"
$sigprdFolder = "E:\Projects\basc\sig\ModuloSigProduccion\Modulo.SigProyectos.PRD"
$operacionesqaFolder = "E:\Projects\basc\operaciones\basc-client-qa"
$operacionesprdFolder = "E:\Projects\basc\operaciones\produccion"
# $operacionesdevFolder = "E:\Projects\basc\operaciones\basc-client-dev"
$extranetFolder = "E:\Projects\basc\Extranet\Modulo.Extranet\Extranet\Controllers\Extranet.Services.Api\ClientApp"
$capacitacionesqaFolder = "E:\Projects\basc\capacitaciones\Modulo.Capacitaciones"
$capacitacionesprdFolder = "E:\Projects\basc\capacitaciones\produccion"
$comunicacionesqaFolder = "E:\Projects\basc\comunicaciones\Modulo.Comunicaciones"
$comunicacionesprdFolder = "E:\Projects\basc\comunicaciones\produccion"
$alicorpFolder = "E:\Projects\alicorp\Portal.ROM"
# $engieFolder = "E:\Projects\Engie\Frontend"
$fichaCarFrontendMain = "E:\Projects\Engie\FichaCarMain\EEP_0001_InOne.front-end"
$inoneFolder = "E:\Projects\Engie\inone\InOneFrontend_Main\EEP_0001_InOne.front-end"
$fichacarbackendFolder = "E:\Projects\Engie\inone\backend_FichaCar\Ficha_Car_Backend"
$fichacarbackendQAFolder = "E:\Projects\Engie\inone\backend_FichaCar\EEP_0001_InOne_FichaCar.back-end"
$osisFrontendFolder = "E:\Projects\lap\LAP.Portal.OSIS.FrontEnd"
$osisBackendFolder = "E:\Projects\lap\LAP.Portal.OSIS.BackEnd"
$editorConfigFile = "c:\Users\pcast\editorselected.txt"
$activoFijoFrontendFolder = "E:\Projects\Engie\ACTIVO_FIJO\EEP_0001_InOne.front-end"
$activoFijoBackendFolder = "E:\Projects\Engie\EEP_0001_InOne_ActivoFijo.back-end"
$lapDocIsoFolder = "E:\Projects\lap\LAP_LDDOCISO_WEBPARTS"
$lapShpFolder = "E:\Projects\lap\Contratos-Gastos-SHP"
$bascModulosComunes = "E:\Projects\basc\modulos_comunes\Componentes.Comunes"

function RunProject {
    param (
        [string]$customWorkspacePath = '.',
        [bool]$run = $false
    )
    if (!$run) {
        return
    }
    code $customWorkspacePath && npm run start
}

function App {
    param([bool]$runProject = $false)

    $menuItems = @(
        @{ Key = 0; Value = "Operaciones PRD" },
        @{ Key = 1; Value = "Operaciones QA" },
        @{ Key = 2; Value = "SIG PRD" },
        @{ Key = 3; Value = "SIG PRD Backup" },
        @{ Key = 4; Value = "SIG QA" },
        @{ Key = 5; Value = "Extranet" },
        @{ Key = 6; Value = "Austral" },
        @{ Key = 7; Value = "InOne" },
        @{ Key = 8; Value = "Ficha Car Backend" },
        @{ Key = 9; Value = "Capacitaciones PRD" },
        @{ Key = 10; Value = "Capacitaciones QA" },
        @{ Key = 11; Value = "Comunicaciones PRD" },
        @{ Key = 12; Value = "Comunicaciones QA" },
        @{ Key = 13; Value = "Alicorp" },
        @{ Key = 14; Value = "Ficha Car Backend QA" },
        @{ Key = 15; Value = "OSIS Frontend DEV" },
        @{ Key = 16; Value = "OSIS Backend DEV" },
        @{ Key = 17; Value = "Activo Fijo Frontend" },
        @{ Key = 18; Value = "Activo Fijo Backend" },
        @{ Key = 19; Value = "FichaCar Frontend Main" },
        @{ Key = 20; Value = "Lap DOC ISO" }
        @{ Key = 21; Value = "Lap Gastos e Ingresos SHP" },
        @{ Key = 22; Value = "Basc Modulos Comunes" }
    )

    $fzfInput = ListToString -items $menuItems
    $selectedOption = $fzfInput | fzf
    $selectedKey = $selectedOption -split ':' | Select-Object -First 1

    switch ($selectedKey) {

        0 {
            Set-Location $operacionesprdFolder;
            RunProject -run $runProject -customWorkspacePath '.\produccion.code-workspace';
            break
        }
        1 {
            Set-Location $operacionesqaFolder;
            RunProject -run $runProject -customWorkspacePath '.\basc-client.code-workspace';
            break
        }
        2 {
            Set-Location $sigprdFolder;
            RunProject -run $runProject;
            break
        }
        3 {
            Set-Location $sigprdFolderBackup;
            RunProject -run $runProject;
            break
        }
        4 {
            Set-Location $sigqaFolder;
            RunProject -run $runProject -customWorkspacePath '.\sig.code-workspace';
            break
        }
        5 {
            Set-Location $extranetFolder;
            if ($runProject) {
                Start-Process 'E:\Projects\basc\Extranet\Modulo.Extranet\Extranet\Extranet.sln' && RunProject -run $runProject -customWorkspacePath '.\extranet.code-workspace';
            }
            break
        }
        6 {
            Set-Location $australFolder;
            RunProject -run $runProject -customWorkspacePath '.\austral-spfx.code-workspace';
            break
        }
        7 {
            Set-Location $inoneFolder;
            RunProject -run $runProject;
            break
        }
        8 {
            Set-Location $fichacarbackendFolder; break
        }
        9 {
            Set-Location $capacitacionesprdFolder;
            RunProject -run $runProject;
            break
        }
        10 {
            Set-Location $capacitacionesqaFolder;
            RunProject -run $runProject;
            break
        }
        11 {
            Set-Location $comunicacionesprdFolder;
            RunProject -run $runProject;
            break
        }
        12 {
            Set-Location $comunicacionesqaFolder;
            RunProject -run $runProject;
            break
        }
        13 {
            Set-Location $alicorpFolder;
            RunProject -run $runProject;
            break
        }
        14 {
            Set-Location $fichacarbackendQAFolder;
            if ($runProject) {
                Start-Process 'E:\Projects\Engie\inone\backend_FichaCar\EEP_0001_InOne_FichaCar.back-end\Engie.FichaCar.Api.sln';
            }
            break
        }
        15 {
            Set-Location $osisFrontendFolder;
            RunProject -run $runProject;
            break
        }
        16 {
            Set-Location $osisBackendFolder;
            if ($runProject) {
                Start-Process 'E:\Projects\lap\LAP.Portal.OSIS.BackEnd\Sol.LAP.OSIS.BackEnd.sln';
            }
            break
        }
        17 {
            Set-Location $activoFijoFrontendFolder;
            RunProject -run $runProject;
            break
        }
        18 {
            Set-Location $activoFijoBackendFolder;
            if ($runProject) {
                Start-Process 'E:\Projects\Engie\EEP_0001_InOne_ActivoFijo.back-end\src\Engie.ActivoFijo.sln';
            }
            break
        }
        19 {
            Set-Location $fichaCarFrontendMain;
            RunProject -run $runProject;
            break
        }
        20 {
            Set-Location $lapDocIsoFolder;
            RunProject -run $runProject;
        }
        21 {
            Set-Location $lapShpFolder;
            RunProject -run $runProject;
        }
        22 {
            Set-Location $bascModulosComunes;
            RunProject -run $runProject;
        }

        default {
            break
        }
    }
}

function Directorios {
    param([bool]$runProject = $false)

    $DirectoriosItems = @(
        @{ Key = 0; Value = "Home" },
        @{ Key = 1; Value = "Personal" },
        @{ Key = 2; Value = "Descargas" }
        @{ Key = 3; Value = "Projects" }
        @{ Key = 4; Value = "VS Repos" }
        @{ Key = 5; Value = "Papelera de reciclaje" }
    )
    $fzfInput = ListToString -items $DirectoriosItems
    $selectedOption = $fzfInput | fzf
    $selectedKey = $selectedOption -split ':' | Select-Object -First 1

    switch ($selectedKey) {
        0 {
            Set-Location C:\Users\pcast; break
        }
        1 {
            Set-Location 'E:\Projects\Personal'; break
        }
        2 {
            Set-Location 'c:\Users\pcast\Downloads'; break
        }
        3 {
            Set-Location 'E:\Projects'; break
        }
        4 {
            Set-Location 'E:\Projects\Personal\VisualStudio\source\repos'; break
        }
        5 {
            Start-Process shell:RecycleBinFolder; break
        }
    }

    $selectedOption = New-Menu -options $DirectoriosItems -title "Directorios" -hint "Usar las flechas para navegar, 'Enter' para seleccionar, 'Esc' para cancelar"

}

function GulpRun {
    $gulpItems = @(
        @{ Key = 0; Value = "Publish" },
        @{ Key = 1; Value = "Clean" },
        @{ Key = 2; Value = "Build" }
        @{ Key = 3; Value = "Bundle" }
        @{ Key = 4; Value = "Package" }
    )

    $fzfInput = ListToString -items $gulpItems
    $selectedOption = $fzfInput | fzf
    $selectedKey = $selectedOption -split ':' | Select-Object -First 1

    switch ($selectedKey) {
        0 {
            gulp clean && gulp build && gulp bundle --ship && gulp package-solution --ship; break
        }
        1 {
            gulp clean; break
        }
        2 {
            gulp build; break
        }
        3 {
            gulp bundle --ship; break
        }
        4 {
            gulp package-solution --ship; break
        }
    }
}

function setNodeVersion {
    $nodeVersionItems = @(
        @{ Key = 0; Value = "Latest" },
        @{ Key = 1; Value = "Austral" },
        @{ Key = 2; Value = "Basc" },
        @{ Key = 3; Value = "Engie" },
        @{ Key = 4; Value = "Lap OSIS" },
        @{ Key = 5; Value = "Lap Capex Opex" },
        @{ Key = 6; Value = "InOne" }
    )

    $fzfInput = ListToString -items $nodeVersionItems
    $selectedOption = $fzfInput | fzf
    $selectedKey = $selectedOption -split ':' | Select-Object -First 1

    switch ($selectedKey) {
        0 {
            nvm use latest; break
        }
        1 {
            nvm use 10.24.1; break
        }
        2 {
            nvm use 14.19.1; break
        }
        3 {
            nvm use 14.21.3; break
        }
        4 {
            nvm use 18.19.1; break
        }
        5 {
            nvm use 12.22.12; break
        }
        6 {
            nvm use 14.16.1; break
        }
    }

}

function getCurrentEditor {
    return get-content -Path $editorConfigFile
}

function editConfig {
    $editorActual = getCurrentEditor
    $newInstanceEditorconfig = ($editorActual -match "nvim")?"":" -n"
    $configItems = @(
        @{ Key = 0; Value = "VS Code" },
        @{ Key = 1; Value = "Git" },
        @{ Key = 2; Value = "PowerShell" },
        @{ Key = 3; Value = "Oh My Posh" },
        @{ Key = 4; Value = "Powerline history" }
    )

    $fzfInput = ListToString -items $configItems
    $selectedOption = $fzfInput | fzf
    $selectedKey = $selectedOption -split ':' | Select-Object -First 1

    switch ($selectedKey) {
        0 {
            Invoke-Expression "$($editorActual) c:\Users\pcast\AppData\Roaming\Code\User\settings.json$($newInstanceEditorconfig)"; break
        }
        1 {
            Invoke-Expression "$($editorActual) c:\Users\pcast\.gitconfig$($newInstanceEditorconfig)"; break
        }
        2 {
            Invoke-Expression "$($editorActual) c:\Users\pcast\.config\powershell\user_profile.ps1$($newInstanceEditorconfig)"; break
        }
        3 {
            Invoke-Expression "$($editorActual) '$($ompFile)'$($newInstanceEditorconfig)"; break
        }
        4 {
            Invoke-Expression "$($editorActual) c:\Users\pcast\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt$($newInstanceEditorconfig)"; break
        }
    }
}

function setEditorNvim {
    if (-not(Test-Path -Path $editorConfigFile)) {
        New-Item -Type File -Path $editorConfigFile
    }
    "nvim" | Out-File -FilePath $editorConfigFile
}

function setEditorVSCode {
    if (-not(Test-Path -Path $editorConfigFile)) {
        New-Item -Type File -Path $editorConfigFile
    }
    "code" | Out-File -FilePath $editorConfigFile
}

function Set-Wallpaper {
    # Directorio que contiene las imágenes
    $directoryPath = "C:\Users\pcast\OneDrive\Fotos\Wallpapers"

    # Obtener todas las imágenes del directorio
    $images = Get-ChildItem -Path $directoryPath -Include *.jpg, *.jpeg, *.png, *.bmp -File

    # Verificar si hay imágenes en el directorio
    if ($images.Count -eq 0) {
        Write-Host "No se encontraron imágenes en el directorio especificado."
        exit
    }

    # Seleccionar una imagen aleatoria
    $randomImage = Get-Random -InputObject $images

    # Ruta completa de la imagen seleccionada
    $imagePath = $randomImage.FullName

    # Cambiar el fondo de pantalla
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

    # Constante para cambiar el fondo de pantalla
    $SPI_SETDESKWALLPAPER = 0x0014
    $SPIF_UPDATEINIFILE = 0x01
    $SPIF_SENDCHANGE = 0x02

    # Cambiar el fondo de pantalla
    [Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $imagePath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

    Write-Host "Fondo de pantalla cambiado a: $imagePath"
}
# FZF CONFIG

# Ref: https://github.com/catppuccin/powershell#profile-usage
# https://github.com/catppuccin/fzf - not use background for transparent
$env:FZF_DEFAULT_OPTS = @"
--color=hl:$($Flavor.Red),fg:$($Flavor.Text),header:$($Flavor.Red)
--color=info:$($Flavor.Mauve),pointer:$($Flavor.Rosewater),marker:$($Flavor.Rosewater)
--color=fg+:$($Flavor.Text),prompt:$($Flavor.Mauve),hl+:$($Flavor.Red)
--color=border:$($Flavor.Surface2)
--layout=reverse
--cycle
--scroll-off=5
--border
--preview-window=right,60%,border-left
--bind ctrl-u:preview-half-page-up
--bind ctrl-d:preview-half-page-down
--bind ctrl-f:preview-page-down
--bind ctrl-b:preview-page-up
--bind ctrl-g:preview-top
--bind ctrl-h:preview-bottom
--bind alt-w:toggle-preview-wrap
--bind ctrl-e:toggle-preview
"@
Set-PsFzfOption -AltCCommand $commandOverride
Set-PsFzfOption -PSReadlineChordProvider "Ctrl+e" -PSReadlineChordReverseHistory "Ctrl+r" -GitKeyBindings -TabExpansion -EnableAliasFuzzyGitStatus -EnableAliasFuzzyEdit -EnableAliasFuzzyFasd -EnableAliasFuzzyKillProcess -EnableAliasFuzzyScoop
function _fzf_open_path {
    param (
        [Parameter(Mandatory = $true)]
        [string]$input_path
    )
    if ($input_path -match "^.*:\d+:.*$") {
        $input_path = ($input_path -split ":")[0]
    }
    if (-not (Test-Path $input_path)) {
        return
    }
    $cmds = @{
        'bat'    = { bat $input_path }
        'cat'    = { Get-Content $input_path }
        'cd'     = {
            if (Test-Path $input_path -PathType Leaf) {
                $input_path = Split-Path $input_path -Parent
            }
            Set-Location $input_path
        }
        'nvim'   = { nvim $input_path }
        'remove' = { Remove-Item -Recurse -Force $input_path }
        'echo'   = { Write-Output $input_path }
    }
    $cmd = $cmds.Keys | fzf --prompt 'Select command> '
    & $cmds[$cmd]
}

function _fzf_get_path_using_fd {
    $input_path = fd --type file --follow --hidden --exclude .git |
    fzf --prompt 'Files> ' `
        --header-first `
        --header 'CTRL-S: Switch between Files/Directories' `
        --bind 'ctrl-s:transform:if not "%FZF_PROMPT%"=="Files> " (echo ^change-prompt^(Files^> ^)^+^reload^(fd --type file^)) else (echo ^change-prompt^(Directory^> ^)^+^reload^(fd --type directory^))' `
        --preview 'if "%FZF_PROMPT%"=="Files> " (bat --color=always {} --style=plain) else (eza -T --colour=always --icons=always {})'
    return $input_path
}

function _fzf_get_path_using_rg {
    $INITIAL_QUERY = "${*:-}"
    $RG_PREFIX = "rg --column --line-number --no-heading --color=always --smart-case"
    $input_path = "" |
    fzf --ansi --disabled --query "$INITIAL_QUERY" `
        --bind "start:reload:$RG_PREFIX {q}" `
        --bind "change:reload:sleep 0.1 & $RG_PREFIX {q} || rem" `
        --bind 'ctrl-s:transform:if not "%FZF_PROMPT%" == "1. ripgrep> " (echo ^rebind^(change^)^+^change-prompt^(1. ripgrep^> ^)^+^disable-search^+^transform-query:echo ^{q^} ^> %TEMP%\rg-fzf-f ^& type %TEMP%\rg-fzf-r) else (echo ^unbind^(change^)^+^change-prompt^(2. fzf^> ^)^+^enable-search^+^transform-query:echo ^{q^} ^> %TEMP%\rg-fzf-r ^& type %TEMP%\rg-fzf-f)' `
        --color 'hl:-1:underline,hl+:-1:underline:reverse' `
        --delimiter ':' `
        --prompt '1. ripgrep> ' `
        --preview-label 'Preview' `
        --header 'CTRL-S: Switch between ripgrep/fzf' `
        --header-first `
        --preview 'bat --color=always {1} --highlight-line {2} --style=plain' `
        --preview-window 'up,60%,border-bottom,+{2}+3/3'
    return $input_path
}

function fdg {
    $path = $(_fzf_get_path_using_fd)
    if ($(-not [string]::IsNullOrEmpty($path))) {

        _fzf_open_path $(_fzf_get_path_using_fd)
    }
}

function rgg {
    $path = $(_fzf_get_path_using_rg)
    if ($(-not [string]::IsNullOrEmpty($path))) {

        _fzf_open_path $(_fzf_get_path_using_rg)
    }
}

Set-PSReadLineKeyHandler -Key "Ctrl+f" -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("fdg")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

Set-PSReadLineKeyHandler -Key "Ctrl+g" -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("rgg")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}


##########################################

# BAT CONFIG
function ListToString {
    param (
        [Parameter(Mandatory = $true)]
        [array]$items
    )
    $resultString = ""

    # Recorrer el array de objetos y unir cada iteración en una cadena
    foreach ($item in $items) {
        $resultString += "$($item.Key):$($item.Value)`n"
    }

    return $resultString
}
# function fcd {
#     param (
#         [string]$searchdir = $HOME
#     )

#     # Crear un archivo temporal
#     $tmpfile = [System.IO.Path]::GetTempFileName()

#     # Buscar directorios y pasarlos a fzf
#     Get-ChildItem -Path $searchdir -Directory -Recurse -Force |
#     Where-Object { -not ($_.FullName -match '\\\..*') -and ($_.Name -ne '__pycache__') } |
#     ForEach-Object { $_.FullName } |
#     fzf > $tmpfile

#     # Leer el directorio seleccionado
#     $destdir = Get-Content $tmpfile

#     # Eliminar el archivo temporal
#     Remove-Item $tmpfile

#     # Cambiar al directorio seleccionado si no está vacío
#     if ($destdir -ne "") {
#         Set-Location $destdir
#     }
#     else {
#         return 1
#     }
# }
