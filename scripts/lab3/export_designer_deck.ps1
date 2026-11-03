param(
    [string]$PptxPath,
    [string]$PdfPath,
    [string]$PreviewDirectory
)
$ErrorActionPreference = 'Stop'
$lab3Workspace = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$lab3Pptx = Join-Path $lab3Workspace 'output/lab3/Power9_Lab3_Designer.pptx'
$lab3Pdf = Join-Path $lab3Workspace 'output/lab3/Power9_Lab3_Slides.pdf'
$lab3Previews = Join-Path $lab3Workspace '.build/lab3-design/powerpoint-render'
if ($PptxPath) { $lab3Pptx = [System.IO.Path]::GetFullPath($PptxPath) }
if ($PdfPath) { $lab3Pdf = [System.IO.Path]::GetFullPath($PdfPath) }
if ($PreviewDirectory) { $lab3Previews = [System.IO.Path]::GetFullPath($PreviewDirectory) }
New-Item -ItemType Directory -Path $lab3Previews -Force | Out-Null
$lab3HadPowerPoint = @(Get-Process POWERPNT -ErrorAction SilentlyContinue).Count -gt 0
$lab3PowerPoint = New-Object -ComObject PowerPoint.Application
$lab3Presentation = $null
try {
    $lab3PowerPoint.DisplayAlerts = 1
    # Open read-only, without a visible presentation window.
    $lab3Presentation = $lab3PowerPoint.Presentations.Open($lab3Pptx, -1, 0, 0)
    if ($lab3Presentation.Slides.Count -ne 15) { throw 'Expected 15 slides' }
    # ppSaveAsPDF=32 avoids the optional COM enum-binding issue in PowerShell 7.
    $lab3Presentation.SaveAs($lab3Pdf, 32)
    $lab3Presentation.Export($lab3Previews, 'PNG', 1600, 900)
    @{ slides = $lab3Presentation.Slides.Count; pdf = $lab3Pdf; previewDirectory = $lab3Previews; nativePowerPointOpened = $true } | ConvertTo-Json -Compress
} finally {
    if ($null -ne $lab3Presentation) { $lab3Presentation.Close() }
    if (-not $lab3HadPowerPoint) { $lab3PowerPoint.Quit() }
}
