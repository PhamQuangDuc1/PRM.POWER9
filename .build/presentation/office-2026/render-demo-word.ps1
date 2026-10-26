$officeReview = New-Object -ComObject Word.Application
$officeReview.Visible = $false
$officeReview.DisplayAlerts = 0
try {
    $officeDocument = $officeReview.Documents.Open('D:\PRM393\PRM.POWER9\output\presentation\Power9_Office_Lab2\Power9_Office_Kich_Ban_Thuyet_Trinh_Va_Demo.docx', $false, $true)
    $officeDocument.ExportAsFixedFormat('D:\PRM393\PRM.POWER9\.build\presentation\office-2026\demo-word.pdf', 17)
    $officeDocument.Close(0)
} finally {
    $officeReview.Quit()
}
