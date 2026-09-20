$ErrorActionPreference = 'Stop'
$target = Join-Path $PSScriptRoot '虫害目标检测.rar'
$parts = @(Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'archive-parts') -Filter '*.part*' | Sort-Object Name)
if (($parts | Measure-Object Length -Sum).Sum -ne 7931076980) { throw 'Missing or invalid archive parts.' }
$output = [IO.File]::Open($target, [IO.FileMode]::CreateNew)
try {
    foreach ($part in $parts) {
        $inputStream = [IO.File]::OpenRead($part.FullName)
        try { $inputStream.CopyTo($output) } finally { $inputStream.Dispose() }
    }
} finally { $output.Dispose() }
Write-Output "Restored: $target"
