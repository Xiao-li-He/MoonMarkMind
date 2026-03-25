param(
  [int]$Port = 8000,
  [switch]$NoOpenBrowser
)

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($root)) {
  $root = Split-Path -Parent $PSCommandPath
}
if ([string]::IsNullOrWhiteSpace($root)) {
  $root = (Get-Location).Path
}

$webDir = Join-Path $root "web"
$source = Join-Path $root "_build/js/release/build/cmd/main/main.js"
$output = Join-Path $webDir "main.bundle.js"
$apiName = "MoonMarkMind"

moon build --target js --release

if (!(Test-Path $webDir)) {
  New-Item -ItemType Directory -Path $webDir | Out-Null
}

function Find-LocalExportSymbol {
  param(
    [string]$ExportName
  )

  $pattern = "([A-Za-z0-9`$_]+)\s+as\s+$ExportName\b"
  $match = Select-String -Path $source -Pattern $pattern | Select-Object -First 1
  if (-not $match) {
    throw "Failed to locate MoonBit export symbol '$ExportName' in $source"
  }
  return $match.Matches[0].Groups[1].Value
}

$sampleSymbol = Find-LocalExportSymbol "sample_markdown"
$outlineSymbol = Find-LocalExportSymbol "outline_json"
$renameSymbol = Find-LocalExportSymbol "rename_heading"
$moveSymbol = Find-LocalExportSymbol "move_heading"
$addChildSymbol = Find-LocalExportSymbol "add_child_heading"
$deleteSymbol = Find-LocalExportSymbol "delete_heading"
$startSymbol = Find-LocalExportSymbol "start_web_app"

$bridge = @'

globalThis.__API_NAME__ = {
  sampleMarkdown() {
    return __SAMPLE_SYMBOL__();
  },
  outlineJson(markdown) {
    return __OUTLINE_SYMBOL__(markdown);
  },
  renameHeading(markdown, flatIndex, title) {
    return __RENAME_SYMBOL__(markdown, flatIndex, title);
  },
  moveHeading(markdown, fromFlatIndex, toFlatIndex, placeAfter) {
    return __MOVE_SYMBOL__(markdown, fromFlatIndex, toFlatIndex, placeAfter);
  },
  addChildHeading(markdown, parentFlatIndex, title) {
    return __ADD_CHILD_SYMBOL__(markdown, parentFlatIndex, title);
  },
  deleteHeading(markdown, flatIndex) {
    return __DELETE_SYMBOL__(markdown, flatIndex);
  },
  startWebApp() {
    return __START_SYMBOL__();
  },
};

globalThis.__API_NAME__.startWebApp();

export const __API_NAME__ = globalThis.__API_NAME__;
'@

$bridge = $bridge.
  Replace("__SAMPLE_SYMBOL__", $sampleSymbol).
  Replace("__OUTLINE_SYMBOL__", $outlineSymbol).
  Replace("__RENAME_SYMBOL__", $renameSymbol).
  Replace("__MOVE_SYMBOL__", $moveSymbol).
  Replace("__ADD_CHILD_SYMBOL__", $addChildSymbol).
  Replace("__DELETE_SYMBOL__", $deleteSymbol).
  Replace("__START_SYMBOL__", $startSymbol).
  Replace("__API_NAME__", $apiName)

Copy-Item $source $output -Force
Add-Content $output $bridge -Encoding utf8

function Get-PythonCommand {
  if (Get-Command python -ErrorAction SilentlyContinue) {
    return "python"
  }
  if (Get-Command py -ErrorAction SilentlyContinue) {
    return "py"
  }
  throw "Python is required to serve the preview."
}

$pythonCmd = Get-PythonCommand
$serverArgs = if ($pythonCmd -eq "py") {
  @("-3", "-m", "http.server", $Port.ToString(), "--bind", "127.0.0.1")
} else {
  @("-m", "http.server", $Port.ToString(), "--bind", "127.0.0.1")
}

$server = Start-Process `
  -FilePath $pythonCmd `
  -ArgumentList $serverArgs `
  -WorkingDirectory $webDir `
  -PassThru `
  -WindowStyle Hidden

$previewUrl = "http://127.0.0.1:$Port/index.html"
if (-not $NoOpenBrowser) {
  Start-Process $previewUrl | Out-Null
}

Write-Output "Built web bundle: $output"
Write-Output "Preview server: $previewUrl"
Write-Output "Server PID: $($server.Id)"
