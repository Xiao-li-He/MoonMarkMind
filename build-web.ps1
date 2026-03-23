$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($root)) {
  $root = Split-Path -Parent $PSCommandPath
}
if ([string]::IsNullOrWhiteSpace($root)) {
  $root = (Get-Location).Path
}

$webDir = Join-Path $root "web"
$source = Join-Path $root "target/js/release/build/cmd/main/main.js"
$output = Join-Path $webDir "main.bundle.js"
$apiName = "MoonMarkMind"

moon build --target js --release

if (!(Test-Path $webDir)) {
  New-Item -ItemType Directory -Path $webDir | Out-Null
}

$sampleMatch = Select-String -Path $source -Pattern 'function\s+([A-Za-z0-9$_]+)\$\$sample_markdown\(' | Select-Object -First 1
if (-not $sampleMatch) {
  throw "Failed to locate MoonBit sample_markdown symbol in $source"
}

$symbolPrefix = $sampleMatch.Matches[0].Groups[1].Value
$sampleSymbol = $symbolPrefix + '$$sample_markdown'
$outlineSymbol = $symbolPrefix + '$$outline_json'
$renameSymbol = $symbolPrefix + '$$rename_heading'
$moveSymbol = $symbolPrefix + '$$move_heading'
$addChildSymbol = $symbolPrefix + '$$add_child_heading'
$deleteSymbol = $symbolPrefix + '$$delete_heading'
$renderSymbol = $symbolPrefix + '$$render_ascii_mindmap'
$demoSymbol = $symbolPrefix + '$$demo_output'
$startSymbol = $symbolPrefix + '$$start_web_app'

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
  renderAsciiMindmap(markdown) {
    return __RENDER_SYMBOL__(markdown);
  },
  demoOutput() {
    return __DEMO_SYMBOL__();
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
  Replace("__RENDER_SYMBOL__", $renderSymbol).
  Replace("__DEMO_SYMBOL__", $demoSymbol).
  Replace("__START_SYMBOL__", $startSymbol).
  Replace("__API_NAME__", $apiName)

Copy-Item $source $output -Force
Add-Content $output $bridge -Encoding utf8

Write-Output "Built web bundle: $output"
