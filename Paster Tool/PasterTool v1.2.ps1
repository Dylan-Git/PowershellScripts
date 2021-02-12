# Check for config csv file and create it if needed
If(!(Test-Path $ConfigFile)){ "ButtonText,ButtonValue" > $ConfigFile}
$ConfigFile = ".\PasterTool.config"

Set-StrictMode -Version 2.0

function Set-ActionOnClic{ 
param($path)
    Set-ClipBoard $Value
}


Function GeneratePasteButton {
    
    [CmdletBinding()]
    Param(
        [parameter(Mandatory=$true)]
        [String]$Text,
        
        [parameter(Mandatory=$true)]
        [String]$Value,
        
        [parameter(Mandatory=$true)]
        [String]$LineNumber
    
    )
    
    $ListNumber = $LineNumber-1
    $Button = New-Object System.Windows.Forms.Button 
    $Button.Text = $Text
    $Button.TabIndex = $ListNumber
    $Button.Name = “$Text” 
    $Button.Size = New-Object System.Drawing.Size(240,23)
    $Button.UseVisualStyleBackColor = $True
    $Button.Location = New-Object System.Drawing.Point(13,(-20+30*$LineNumber))
    $Button.DataBindings.DefaultDataSourceUpdateMode = 0 
    $Button.add_Click($ExecutionContext.InvokeCommand.NewScriptBlock('Set-ClipBoard '+$Value))
    Return $Button
}


Function GenerateEditTextbox {
    
    [CmdletBinding()]
    Param(
        [parameter(Mandatory=$true)]
        [String]$Text,
        
        [parameter(Mandatory=$true)]
        [String]$Value,
        
        [parameter(Mandatory=$true)]
        [String]$LineNumber
    
    )
    $ListNumber = $LineNumber-1
    $Textbox = New-Object System.Windows.Forms.Textbox 
    $Textbox.Text = $Text
    $Textbox.TabIndex = $ListNumber
    $Textbox.Name = $Text 
    $Textbox.Size = New-Object System.Drawing.Size(240,23)
    $Textbox.Location = New-Object System.Drawing.Point(13,(-20+30*$LineNumber))
    $Textbox.DataBindings.DefaultDataSourceUpdateMode = 0

    Return $Textbox
}


Function GenerateForm {
 
    # Form Variables
    #==========================
    [reflection.assembly]::loadwithpartialname(“System.Windows.Forms”) | Out-Null
    [reflection.assembly]::loadwithpartialname(“System.Drawing”) | Out-Null
 
    $Form = New-Object System.Windows.Forms.Form
    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
    $OnLoadForm_StateCorrection= {$Form.WindowState = $InitialFormWindowState}
 
    $Form.Text = “Paster Tool”
    $Form.Name = “Form”
    $Form.Topmost = $True
    $Form.DataBindings.DefaultDataSourceUpdateMode = 0
    $FormDrawingSize = New-Object System.Drawing.Size(295,275)
    $Form.ClientSize = $FormDrawingSize
   
   
   
    # Generate Buttons on Form
    #==========================
    $Config = Import-CSV $ConfigFile
    $LineNumber = 1
    Foreach($Line in $Config){
        $Form.Controls.Add((GeneratePasteButton -Text $Line.ButtonText -Value $Line.ButtonValue -LineNumber $LineNumber))
        $LineNumber++
     }
 
    # Generate Edit Button on Form
    #==========================
    $Button = New-Object System.Windows.Forms.Button 
    $Button.Text = "❖"
    $Button.TabIndex = $LineNumber-1
    $Button.Name = “❖” 
    $Button.Size = New-Object System.Drawing.Size(25,25)
    $Button.UseVisualStyleBackColor = $True
    $Button.Location = New-Object System.Drawing.Point(262.5,5)
    $Button.DataBindings.DefaultDataSourceUpdateMode = 0 
    $Button.add_Click({GenerateEditForm})
    $Form.Controls.Add($Button)


    # Load Form
    #==========================
    $InitialFormWindowState = $Form.WindowState
    $Form.add_Load($OnLoadForm_StateCorrection)
    $Form.ShowDialog()| Out-Null
 
}

Function GenerateEditForm {
 
    # Form Variables
    #==========================
    [reflection.assembly]::loadwithpartialname(“System.Windows.Forms”) | Out-Null
    [reflection.assembly]::loadwithpartialname(“System.Drawing”) | Out-Null
 
    $EditForm = New-Object System.Windows.Forms.Form
    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
    $OnLoadForm_StateCorrection= {$Form.WindowState = $InitialFormWindowState}
 
    $EditForm.Text = “Edit Paste Buttons”
    $EditForm.Name = “EditForm”
    $EditForm.Topmost = $True
    $EditForm.DataBindings.DefaultDataSourceUpdateMode = 0
    $EditFormDrawingSize = New-Object System.Drawing.Size(295,275)
    $EditForm.ClientSize = $EditFormDrawingSize
   
   
    # Generate Buttons on Form
    #==========================
    $Config = Import-CSV $ConfigFile
    $LineNumber = 1
    Foreach($Line in $Config){
        $EditForm.Controls.Add((GenerateEditTextbox -Text $Line.ButtonText -Value $Line.ButtonValue -LineNumber $LineNumber))
        $LineNumber++
     }
 
    # Generate Save Button on Form
    #==========================
    
    
    $CheckButton = New-Object System.Windows.Forms.Button 
    $CheckButton.Text = "✔"
    $CheckButton.Name = “✔” 
    $CheckButton.Size = New-Object System.Drawing.Size(25,25)
    $CheckButton.UseVisualStyleBackColor = $True
    $CheckButton.Location = New-Object System.Drawing.Point(262.5,5)
    $CheckButton.DataBindings.DefaultDataSourceUpdateMode = 0 
    $CheckButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $EditForm.AcceptButton = $CheckButton
    $EditForm.Controls.Add($CheckButton)

    $CancelButton = New-Object System.Windows.Forms.Button 
    $CancelButton.Text = "✘"
    $CancelButton.TabIndex = $LineNumber-1
    $CancelButton.Name = “✘” 
    $CancelButton.Size = New-Object System.Drawing.Size(25,25)
    $CancelButton.UseVisualStyleBackColor = $True
    $CancelButton.Location = New-Object System.Drawing.Point(262.5,35)
    $CancelButton.DataBindings.DefaultDataSourceUpdateMode = 0 
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $EditForm.CancelButton = $CancelButton
    $EditForm.Controls.Add($CancelButton)

    $AddButton = New-Object System.Windows.Forms.Button 
    $AddButton.Text = "✚"
    $AddButton.TabIndex = $LineNumber-1
    $AddButton.Name = “✚” 
    $AddButton.Size = New-Object System.Drawing.Size(25,25)
    $AddButton.UseVisualStyleBackColor = $True
    $AddButton.Location = New-Object System.Drawing.Point(262.5,65)
    $AddButton.DataBindings.DefaultDataSourceUpdateMode = 0
    $EditForm.Controls.Add($AddButton)

    # Load Form
    #==========================
    $InitialFormWindowState = $EditForm.WindowState
    $EditForm.add_Load($OnLoadForm_StateCorrection)
    $EditForm.ShowDialog()| Out-Null
 
}
 
GenerateForm
