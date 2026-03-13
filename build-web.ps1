$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$webDir = Join-Path $root "web"
$source = Join-Path $root "target/js/release/build/cmd/main/main.js"
$output = Join-Path $webDir "main.bundle.js"

moon build --target js --release

if (!(Test-Path $webDir)) {
  New-Item -ItemType Directory -Path $webDir | Out-Null
}

$bridge = @'

const __md2mind_sample = "# MindDown Demo\n## Parser\n### Heading extraction\n### Level mapping\n## Renderer\n### ASCII mindmap\n### Round-trip preview";

globalThis.md2mind = {
  sampleMarkdown() {
    return __md2mind_sample;
  },
  outlineJson(markdown) {
    return huangxl$md2mind$$outline_json(markdown);
  },
  renameHeading(markdown, flatIndex, title) {
    return huangxl$md2mind$$rename_heading(markdown, flatIndex, title);
  },
  moveHeading(markdown, fromFlatIndex, toFlatIndex, placeAfter) {
    return huangxl$md2mind$$move_heading(markdown, fromFlatIndex, toFlatIndex, placeAfter);
  },
  addChildHeading(markdown, parentFlatIndex, title) {
    return huangxl$md2mind$$add_child_heading(markdown, parentFlatIndex, title);
  },
  deleteHeading(markdown, flatIndex) {
    return huangxl$md2mind$$delete_heading(markdown, flatIndex);
  },
  renderAsciiMindmap(markdown) {
    return huangxl$md2mind$$render_ascii_mindmap(markdown);
  },
  demoOutput() {
    return huangxl$md2mind$$demo_output();
  },
};

export const md2mind = globalThis.md2mind;
'@

Copy-Item $source $output -Force
Add-Content $output $bridge -Encoding utf8

Write-Output "Built web bundle: $output"
