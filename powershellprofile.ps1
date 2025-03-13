<#
Antes de formatear:

Copiar:
    powershell profile
    windows terminal settings
    git settins "~\.gitconfig"
    lf file manager settings ""
    global npm packages
    winget list programs
    neovim directory
        instalar "npm i -g typescript-language-server tailwindcss-language-server eslint_d"
    nvm list installed
#>


# oh-my-posh prompt init pwsh --config 'C:\Users\pcast\AppData\Local\Programs\oh-my-posh\themes\powerlevel10k_rainbow.omp.json' | Invoke-Expression
oh-my-posh prompt init pwsh --config 'C:\Users\pcast\OneDrive\CONFIG\MY_THEMES\ys_one_dark.omp.json' | Invoke-Expression

#Z
Import-Module z
#git
Import-Module posh-git

#icons
Import-Module -Name Terminal-Icons
Import-Module PSReadLine
Import-Module PSFzf

# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
# Autocompletion for arrow keys
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -Colors @{emphasis = '#C678DD'; inlinePrediction = '#61AFEF'}

Set-PSReadLineKeyHandler -Key F7 `
                         -BriefDescription History `
                         -LongDescription 'Show command history' `
                         -ScriptBlock {
    $pattern = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
    if ($pattern)
    {
        $pattern = [regex]::Escape($pattern)
    }

    $history = [System.Collections.ArrayList]@(
        $last = ''
        $lines = ''
        foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineOption).HistorySavePath))
        {
            if ($line.EndsWith('`'))
            {
                $line = $line.Substring(0, $line.Length - 1)
                $lines = if ($lines)
                {
                    "$lines`n$line"
                }
                else
                {
                    $line
                }
                continue
            }

            if ($lines)
            {
                $line = "$lines`n$line"
                $lines = ''
            }

            if (($line -cne $last) -and (!$pattern -or ($line -match $pattern)))
            {
                $last = $line
                $line
            }
        }
    )
    $history.Reverse()

    $command = $history | Out-GridView -Title History -PassThru
    if ($command)
    {
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

    if ($commandAst -ne $null)
    {
        $commandName = $commandAst.GetCommandName()
        if ($commandName -ne $null)
        {
            $command = $ExecutionContext.InvokeCommand.GetCommand($commandName, 'All')
            if ($command -is [AliasInfo])
            {
                $commandName = $command.ResolvedCommandName
            }

            if ($commandName -ne $null)
            {
                Get-Help $commandName -ShowWindow
            }
        }
    }
}

#Fuzzy Finder
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PsFzfOption -TabExpansion
Set-PsFzfOption -EnableFd:$true

# Show tips about newly added commands
function Get-Tips {

  $tips = @(
    [pscustomobject]@{
      Command     = 'fcd'
      Description = 'navigate to subdirectory'

    },
    [pscustomobject]@{
      Command     = 'ALT+C'
      Description = 'navigate to deep subdirectory'

    },
    [pscustomobject]@{
      Command     = 'z'
      Description = 'ZLocation'

    },
    [pscustomobject]@{
      Command     = 'fz'
      Description = 'ZLocation through fzf'

    },
    [pscustomobject]@{
      Command     = 'fe'
      Description = 'fuzzy edit file'

    },
    [pscustomobject]@{
      Command     = 'fh'
      Description = 'fuzzy invoke command from history'

    },
    [pscustomobject]@{
      Command     = 'fkill'
      Description = 'fuzzy stop process'

    },
    [pscustomobject]@{
      Command     = 'fd'
      Description = 'find https://github.com/sharkdp/fd#how-to-use'

    },
    [pscustomobject]@{
      Command     = 'rg'
      Description = 'find in files https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md'

    }
  )

  Write-Output $tips | Format-Table
}

# Define aliases to call fuzzy methods from PSFzf
New-Alias -Scope Global -Name fcd -Value Invoke-FuzzySetLocation2 -ErrorAction Ignore
New-Alias -Scope Global -Name fe -Value Invoke-FuzzyEdit -ErrorAction Ignore
New-Alias -Scope Global -Name fh -Value Invoke-FuzzyHistory -ErrorAction Ignore
New-Alias -Scope Global -Name fkill -Value Invoke-FuzzyKillProcess -ErrorAction Ignore
New-Alias -Scope Global -Name fz -Value Invoke-FuzzyZLocation -ErrorAction Ignore
#Set-PsFzfOption -EnableFd

#Set-PsFzfOption -TabExpansion
# Use it to switch directories

#Alias
function FNconfigfiles{
	code c:\xampp\php\php.ini && code C:\xampp\mysql\bin\my.ini && code C:\xampp\phpMyAdmin\config.inc.php && code c:\Windows\System32\drivers\etc\hosts && code C:\xampp\apache\conf\extra\httpd-vhosts.conf && code C:\Users\pcast\OneDrive\CONFIG\settings.txt
}
New-Alias configfiles FNConfigfiles

function FNwtSettings{
	 code C:\Users\pcast\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json
}
New-Alias wtsettings FNwtSettings

function FNGruvboxTheme {
	code C:\Users\pcast\.vscode\extensions\tomphilbin.gruvbox-themes-1.0.0\themes\dark-medium.tmTheme
}
New-Alias themegruvbox FNGruvboxTheme

function FNDraculaTheme{
	code C:\Users\pcast\.vscode\extensions\dracula-theme.theme-dracula-2.24.1\theme\dracula.json
}
New-Alias themedracula FNDraculaTheme

function FNvsSettings{
	nvim C:\Users\pcast\AppData\Roaming\Code\User\settings.json
}

New-Alias vssettings FNvsSettings

function FNListGlobalNpmPackages {
	npm list -g --depth 0
}

New-Alias globalnpm FNListGlobalNpmPackages

function FNTrash {
	Start-Process shell:RecycleBinFolder
}

New-Alias trash FNTrash

function FNXampp {
	Start-Process C:\xampp\xampp-control.exe
}

New-Alias xampp FNXampp

function FNLandings {
	set-location E:\Projects\landing && Get-ChildItem
}

New-Alias landings FNLandings

function FNHTML {
	set-location E:\Projects\HTML && Get-ChildItem
}

New-Alias html FNHTML

function FNAusntral {
	set-location E:\Projects\AUSTRAL\spfx && Get-ChildItem
}

New-Alias austral FNAusntral

function FNOncosalud {
	set-location E:\Projects\drupals\weboncosalud\themes\oncosalud && Get-ChildItem
}

New-Alias prodoncosalud FNOncosalud

function FNOncosaludDEV {
	set-location E:\Projects\drupals\weboncosalud_dev\themes\oncosalud && Get-ChildItem
}

New-Alias devoncosalud FNOncosaludDEV

function FNOncosaludQA {
	set-location E:\Projects\drupals\weboncosalud_qa\themes\oncosalud && Get-ChildItem
}

New-Alias qaoncosalud FNOncosaludQA

function FNAfiliateOnco {
	set-location E:\Projects\drupals\afiliate\themes\custom\edoecommerce && Get-ChildItem
}

New-Alias afiliateonco FNAfiliateOnco

function FNAfiliateAuna {
	set-location E:\Projects\drupals\afiliate_auna\themes\custom\edoecommerce && Get-ChildItem
}

New-Alias afiliateauna FNAfiliateAuna

function FNPortalAfiliadosPRD {
	set-location E:\Projects\drupals\portal_afiliados_prod\themes\custom\portal_afiliados && Get-ChildItem
}

New-Alias prodportalafiliados FNPortalAfiliadosPRD

function FNPortalAfiliadosGTM {
	set-location E:\Projects\drupals\portal_afiliados_gtm\themes\custom\portal_afiliados && Get-ChildItem
}

New-Alias qaportalafiliados FNPortalAfiliadosGTM

function FNPortalAfiliadosDEV {
	set-location E:\Projects\drupals\portal_afiliados_dev\themes\custom\portal_afiliados && Get-ChildItem
}

New-Alias devportalafiliados FNPortalAfiliadosDEV

function FNPortalAfiliadosOriginal {
	set-location E:\Projects\drupals\portal_afiliados_original\themes\custom\portal_afiliados && Get-ChildItem
}

New-Alias cdpao FNPortalAfiliadosOriginal

function FNDownloads {
	set-location C:\Users\pcast\Downloads\ && Get-ChildItem
}

New-Alias downloads FNDownloads

function FNDocumentos {
	set-location C:\Users\pcast\OneDrive\Documentos\ && Get-ChildItem
}

New-Alias documentos FNDocumentos

function FNImagenes {
	set-location C:\Users\pcast\OneDrive\Imagenes && Get-ChildItem
}

New-Alias imagenes FNImagenes

function FNVideos {
	set-location C:\Users\pcast\Videos && Get-ChildItem
}

New-Alias videos FNVideos

function FNBascQA {
	set-location 'E:\Projects\basc\operaciones\basc-client-qa' && Get-ChildItem
}

New-Alias bascqa FNBascQA

function FNBascDEV {
	set-location 'E:\Projects\basc\operaciones\basc-client-dev' && Get-ChildItem
}

New-Alias bascdev FNBascDEV

function FNBascPROD {
	set-location 'E:\Projects\basc\operaciones\basc-client-prod' && Get-ChildItem
}

New-Alias bascprod FNBascPROD

function FNBascExtranet {
	set-location 'E:\Projects\basc\Extranet\Modulo.Extranet\Extranet\Controllers\Extranet.Services.Api\ClientApp' && Get-ChildItem && code .\basc-extranet.code-workspace
}
New-Alias bascExtranet FNBascExtranet

function FNSig {
	set-location 'E:\Projects\basc\sig\Modulo.SigProyectos' && Get-ChildItem
}

New-Alias sig FNSig

function FNHeaderBasc {
	set-location 'E:\Projects\basc\Header BASC' && Get-ChildItem
}

New-Alias cdheaderbasc FNHeaderBasc

function FNConfig {
	set-location 'C:\Users\pcast\OneDrive\CONFIG\' && Get-ChildItem
}
New-Alias config FNConfig

function FNExtranet{
    set-location 'E:\Projects\basc\Extranet\Modulo.Extranet\Extranet\Controllers\Extranet.Services.Api\ClientApp' && Get-ChildItem
}
New-alias extranet FNExtranet

function pshistory{
	nvim 'C:\Users\pcast\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt'
}

function vsrepos{
	set-location 'E:\Projects\VisualStudio\source\repos'
}

function vskeys {
	nvim 'C:\Users\pcast\OneDrive\CONFIG\vscode\usefull keys.txt' && Get-ChildItem
}

function touch {
	Param(
	    [Parameter(Mandatory=$true)]
			    [string]$Path

			)

		if (Test-Path -LiteralPath $Path) {
			    (Get-Item -Path $Path).LastWriteTime = Get-Date

		} else {
			    New-Item -Type File -Path $Path

		}

}

function FNPoweroff{
	shutdown /s /t 5
}

New-Alias poweroff FNPoweroff


function .. { Set-Location ..\. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function ..... { Set-Location ..\..\..\.. }
function ...... { Set-Location ..\..\..\..\.. }
function ....... { Set-Location ..\..\..\..\..\.. }
function ........ { Set-Location ..\..\..\..\..\..\.. }
function ......... { Set-Location ..\..\..\..\..\..\..\.. }

function Get-ChildItem-Wide
{
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

function Get-ChildItem-All
{
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
    if ($Attributes)
    {
        $PSBoundParameters.Remove('Attributes');
    }
    Get-ChildItem -Attributes ReadOnly, Hidden, System, Normal, Archive, Directory, Encrypted, NotContentIndexed, Offline, ReparsePoint, SparseFile, Temporary @PSBoundParameters
}

function Get-ChildItem-All-Wide
{
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

Set-Alias ls Get-ChildItem-Wide -Option "AllScope"
Set-Alias ll Get-ChildItem
Set-Alias lla Get-ChildItem-All
Set-Alias la Get-ChildItem-All-Wide
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'


# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}


# Change working dir in powershell to last dir in lf on exit.
#
# You need to put this file to a folder in $ENV:PATH variable.
#
# You may also like to assign a key to this command:
#
#     Set-PSReadLineKeyHandler -Chord Ctrl+o -ScriptBlock {
#         [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
#         [Microsoft.PowerShell.PSConsoleReadLine]::Insert('lfcd.ps1')
#         [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
#     }
#
# You may put this in one of the profiles found in $PROFILE.
#


$ENV:nvim = "C:\Program Files\Neovim\bin\nvim.exe"


function Set-BingWallpaper {
    $fecha=Get-Date -Format "yyyyMMdd"
    $bingUrl = "https://bingwallpaperimages.azureedge.net"
    $apiUrl = "$bingUrl/hpimages/Latest/3840x2160/$fecha.jpg"
    #$imagePath = $response
    #$fullImagePath = "$bingUrl/$imagePath"
    $imageFile = "C:\Users\pcast\Downloads\$fecha.jpg"
    Invoke-WebRequest $apiUrl -OutFile $imageFile
    #Invoke-WebRequest $response -OutFile $imageFile
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'Wallpaper' -Value $imageFile
    rundll32.exe user32.dll,UpdatePerUserSystemParameters
}

function Set-PexelWallpaper {
    $numeroDePagina = Get-Random -Minimum 1 -Maximum 300
    $fecha=Get-Date -Format "yyyyMMdd"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add('Authorization','UGRvtnMQaGtbhFS32cbUApMZlLyxiSCK9VSszWJJboxxt3Xk84A7UFvS')
    $uriPexel="https://api.pexels.com/v1/search?query=night&per_page=1&page=$numeroDePagina&orientation=landscape"
    $json =Invoke-RestMethod -Uri $uriPexel -Headers $headers


    $apiUrl=$json[0].photos[0].src.original
    # $apiUrl = "$bingUrl/hpimages/Latest/3840x2160/$fecha.jpg"
    #$imagePath = $response
    #$fullImagePath = "$bingUrl/$imagePath"
    $imageFile = "C:\Users\pcast\Downloads\$fecha.jpg"
    Invoke-WebRequest $apiUrl -OutFile $imageFile
    #Invoke-WebRequest $response -OutFile $imageFile
    Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'Wallpaper' -Value $imageFile
    rundll32.exe user32.dll,UpdatePerUserSystemParameters
}

function Get-FolderSize {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    $size = (Get-ChildItem $Path -Recurse | Measure-Object -Property Length -Sum).Sum
    $sizeInGB = $size / 1GB
    $sizeInMB = $size / 1MB
    $sizeInKB = $size / 1KB

    [PSCustomObject]@{
        "Folder" = $Path
        "Size (GB)" = "{0:N2} GB" -f $sizeInGB
        "Size (MB)" = "{0:N2} MB" -f $sizeInMB
        "Size (KB)" = "{0:N2} KB" -f $sizeInKB
        "Size (bytes)" = "$size bytes"
    }
}

# Comprimir una carpeta en un archivo ZIP y excluir algunos archivos
# Compress-ToZip -SourcePath "C:\Users\UserName\Documents" -DestinationPath "C:\Users\UserName\Documents.zip" -Exclude "SecretNotes.txt", "Confidential\*"
function Compress-ToZip {
    param (
        [Parameter(Mandatory=$true)]
        [string]$SourcePath,
        [Parameter(Mandatory=$true)]
        [string]$DestinationPath,
        [string[]]$Exclude = @()
    )

    if (-not (Test-Path $SourcePath)) {
        throw "El directorio $SourcePath no existe."
    }

    if (Test-Path $DestinationPath) {
        throw "El archivo $DestinationPath ya existe."
    }

    $excludeArgs = $Exclude | ForEach-Object { "-Exclude", $_ }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($SourcePath, $DestinationPath, 0, $false, 'Optimal', 'NoCompression', $true, $excludeArgs)
}


# Función para descomprimir un archivo ZIP en una carpeta
# Descomprimir un archivo ZIP en una carpeta
#Expand-Zip -SourcePath "C:\Users\UserName\Documents.zip" -DestinationPath "C:\Users\UserName\ExtractedDocuments"
function Expand-Zip {
    param (
        [Parameter(Mandatory=$true)]
        [string]$SourcePath,
        [Parameter(Mandatory=$true)]
        [string]$DestinationPath
    )

    if (-not (Test-Path $SourcePath)) {
        throw "El archivo $SourcePath no existe."
    }

    if (-not (Test-Path $DestinationPath)) {
        New-Item -ItemType Directory -Path $DestinationPath | Out-Null
    }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($SourcePath, $DestinationPath)
}
$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
$errorlog = "$DesktopPath\winget_error.log"
function Install-Apps{

    #$appsList = $apps -join " && "
    Write-Output "Installing Apps"
    $apps = @(
        @{name = "JanDeDobbeleer.OhMyPosh"; extra=""},
        @{name = "Logitech.GHUB"; extra=""},
        @{name = "9P1TBXR6QDCX"; extra="--exact --source msstore"},
        @{name = "Microsoft.WindowsTerminal.Preview"; extra=""},
        @{name = "Spotify"; extra=""},
        @{name = "Git.Git"; extra=""},
        @{name = "Whatsapp.Whatsapp.beta"; extra=""},
        @{name = "Google.Chrome"; extra=""},
        @{name = "Microsoft.Office"; extra=""},
        @{name = "Postman.Postman"; extra=""},
        @{name = "Microsoft.VisualStudioCode"; extra="-i"},
        @{name = "ApacheFriends.Xampp.8.2"; extra="-i"},
        @{name = "Discord.Discord"; extra=""},
        @{name = "Rarlab.Winrar"; extra=""},
        @{name = "Appwork.Jdownloader"; extra="-i"},
        @{name = "Gimp.Gimp"; extra=""},
        @{name = "Valve.Steam"; extra="-i" }, # Includes AzureDataStu; extra=""io
        @{name = "Microsoft.Teams"; extra=""},
        @{name = "CoreyButler.NVMforWindows"; extra=""},
        @{name = "Neovim.Neovim"; extra=""},
        @{name = "Nvidia.GeForceExperience"; extra=""},
        @{name = "VideoLAN.VLC"; extra=""},
        @{name = "Microsoft.VisualStudio.2019.Professional"; extra=""},
        @{name = "Microsoft.VisualStudio.2022.Community"; extra=""},
        @{name = "MSPCManager"; extra=""},
        @{name = "VMware.WorkstationPlayer"; extra=""},
        @{name = "EpicGames.EpicGamesLauncher"; extra=""},
        @{name = "Microsoft.DotNet.SDK.5"; extra=""},
        @{name = "Microsoft.DotNet.SDK.6"; extra=""},
        @{name = "Microsoft.DotNet.SDK.7";extra="" },
	  @{name = "winget install dev47apps.DroidCam";extra="" }
    );
    Foreach ($app in $apps) {
        #$listApp = winget list --exact --accept-source-agreements -q $app.name
        #if (![String]::Join("", $listApp).Contains($app.name)) {
        #    Write-host "Installing: " $app.name
        #    winget install --exact --interactive --accept-source-agreements --accept-package-agreements $app.extra --id $app.name
        #}
        #else {
        #    Write-host "Skipping: " $app.name " (already installed)"
        #}
	  $listGUI = winget list --exact --accept-source-agreements -q $app.name
        if (![String]::Join("", $listGUI).Contains($app.name)) {
            Write-Host -ForegroundColor Yellow "Install:" $app.name
            winget install --exact --interactive --accept-source-agreements --accept-package-agreements $app.extra $app.name
            if ($LASTEXITCODE -eq 0) {
                Write-Host -ForegroundColor Green "$app.name successfully installed."
            }
            else {
                "$gui couldn't be installed." | Add-Content $errorlog
                Write-Warning "$app.name couldn't be installed."
                Write-Host -ForegroundColor Yellow "Write in $errorlog"
                Pause
            }
        }
        else {
            Write-Host -ForegroundColor Yellow "$app.name already installed. Skip..."
        }
    }
}

function CopiarAntesDeFormatear{
    cp -r C:\Users\pcast\AppData\local\nvim D:\backups\windows\config\ && winget list > D:\backups\windows\config\wingetlist.txt && nvm ls > D:\backups\windows\config\nvmls.txt && globalnpm > D:\backups\windows\config\globalnpm.txt && cp ~\AppData\local\lf\lfrc D:\backups\windows\config\lfrc.txt && cp ~\.gitconfig D:\backups\windows\config\gitconfig.txt && cat $PROFILE > D:\backups\windows\config\powershellprofile.ps1
}
