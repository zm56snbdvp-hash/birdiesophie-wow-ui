[CmdletBinding()]
param(
    [string]$WowRoot = 'C:\Program Files (x86)\World of Warcraft\_anniversary_'
)

$ErrorActionPreference = 'Stop'
$addonRoot = Join-Path $WowRoot 'Interface\AddOns'

if (-not (Test-Path -LiteralPath $WowRoot -PathType Container)) {
    throw "WoW installation not found: $WowRoot"
}

if (-not (Test-Path -LiteralPath $addonRoot -PathType Container)) {
    throw "Addon directory not found: $addonRoot"
}

$required = @(
    @{ Name = 'ElvUI'; Folder = 'ElvUI' },
    @{ Name = 'WeakAuras'; Folder = 'WeakAuras' },
    @{ Name = 'Details!'; Folder = 'Details' },
    @{ Name = 'BirdieSophieUI'; Folder = 'BirdieSophieUI' }
)

$results = foreach ($addon in $required) {
    $path = Join-Path $addonRoot $addon.Folder
    [pscustomobject]@{
        Addon = $addon.Name
        Installed = Test-Path -LiteralPath $path -PathType Container
        Path = $path
    }
}

$results | Format-Table -AutoSize

if ($results.Installed -contains $false) {
    Write-Warning 'At least one BirdieSophie dependency is missing.'
    exit 1
}

Write-Host 'BirdieSophie addon environment is complete.' -ForegroundColor Green

