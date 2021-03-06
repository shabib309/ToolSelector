$folder = $args[0]

# --------------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Tool Selector'
$form.Size = New-Object System.Drawing.Size(275, 135)
$form.StartPosition = 'CenterScreen'

# --------------------------------------------------------------

$Formatter = New-Object System.Windows.Forms.Button
$Formatter.Text = "Format Repository"
$Formatter.Location = New-Object System.Drawing.Size(20, 10)
$Formatter.Size = New-Object System.Drawing.Size(220, 25)
$Formatter.Add_Click({
    Set-Location "\\sitsrv061\WinFrame\Transfer\cir.al\StandaloneDevTools\TxtFormatter"
    .\Format-Repository.ps1 $folder
})

# --------------------------------------------------------------

$Migrator = New-Object System.Windows.Forms.Button
$Migrator.Text = "Create Migration Codeunit"
$Migrator.Location = New-Object System.Drawing.Size(20, 35)
$Migrator.Size = New-Object System.Drawing.Size(220, 25)
$Migrator.Add_Click({
    Set-Location "\\sitsrv061\WinFrame\Transfer\cir.al\StandaloneDevTools\Migrator"
    .\Migrate-Tables.ps1
})

# --------------------------------------------------------------

$FieldAdder = New-Object System.Windows.Forms.Button
$FieldAdder.Text = "Field Adder"
$FieldAdder.Location = New-Object System.Drawing.Size(20, 60)
$FieldAdder.Size = New-Object System.Drawing.Size(220, 25)
$FieldAdder.Add_Click({
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $startFolder
    if ($foldername.ShowDialog() -eq "OK") {
        Set-Location "\\sitsrv061\WinFrame\Transfer\cir.al\StandaloneDevTools\FieldAdder"
        $folder += $foldername.SelectedPath
        .\FieldAdder.ps1 $folder
    }
})

# --------------------------------------------------------------

$form.Controls.Add($Formatter)
$form.Controls.Add($Migrator)
$form.Controls.Add($FieldAdder)
$form.Topmost = $true
$form.KeyPreview = $true #This is the important part
$form.Add_KeyDown{
    param ( 
        [Parameter(Mandatory)][Object]$sender,
        [Parameter(Mandatory)][System.Windows.Forms.KeyEventArgs]$e
    )
    if($e.KeyCode -eq "Escape"){
        $Form.close()
    }
}
$form.FormBorderStyle = 'FixedDialog';
$form.MaximizeBox = $false;
$form.MinimizeBox = $false;
$result = $form.ShowDialog()