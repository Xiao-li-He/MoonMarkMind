$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$webDir = Join-Path $root "web"
$source = Join-Path $root "target/js/release/build/cmd/main/main.js"
$output = Join-Path $webDir "main.bundle.js"
$apiName = "MoonMarkMind"

moon build --target js --release

if (!(Test-Path $webDir)) {
  New-Item -ItemType Directory -Path $webDir | Out-Null
}

$outlineMatch = Select-String -Path $source -Pattern 'function\s+([A-Za-z0-9$_]+)\$\$outline_json\(' | Select-Object -First 1
if (-not $outlineMatch) {
  throw "Failed to locate MoonBit outline_json symbol in $source"
}

$symbolPrefix = $outlineMatch.Matches[0].Groups[1].Value

$bridge = @'

const __MoonMarkMind_sample = "# MoonMarkMind Demo\n## Parser\n### Heading extraction\n### Level mapping\n## Renderer\n### ASCII mindmap\n### Round-trip preview";
const __moonmarkmind_prefix = "__SYMBOL_PREFIX__";

globalThis.__API_NAME__ = {
  sampleMarkdown() {
    return __MoonMarkMind_sample;
  },
  outlineJson(markdown) {
    return globalThis[`${__moonmarkmind_prefix}$$outline_json`](markdown);
  },
  renameHeading(markdown, flatIndex, title) {
    return globalThis[`${__moonmarkmind_prefix}$$rename_heading`](markdown, flatIndex, title);
  },
  moveHeading(markdown, fromFlatIndex, toFlatIndex, placeAfter) {
    return globalThis[`${__moonmarkmind_prefix}$$move_heading`](markdown, fromFlatIndex, toFlatIndex, placeAfter);
  },
  addChildHeading(markdown, parentFlatIndex, title) {
    return globalThis[`${__moonmarkmind_prefix}$$add_child_heading`](markdown, parentFlatIndex, title);
  },
  deleteHeading(markdown, flatIndex) {
    return globalThis[`${__moonmarkmind_prefix}$$delete_heading`](markdown, flatIndex);
  },
  renderAsciiMindmap(markdown) {
    return globalThis[`${__moonmarkmind_prefix}$$render_ascii_mindmap`](markdown);
  },
  demoOutput() {
    return globalThis[`${__moonmarkmind_prefix}$$demo_output`]();
  },
};

export const __API_NAME__ = globalThis.__API_NAME__;
'@

$bridge = $bridge.Replace("__SYMBOL_PREFIX__", $symbolPrefix).Replace("__API_NAME__", $apiName)

Copy-Item $source $output -Force
Add-Content $output $bridge -Encoding utf8

Write-Output "Built web bundle: $output"

