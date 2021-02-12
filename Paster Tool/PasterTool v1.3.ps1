[reflection.assembly]::loadwithpartialname(“System.Windows.Forms”) | Out-Null
[reflection.assembly]::loadwithpartialname(“System.Drawing”) | Out-Null

Set-StrictMode -Version 2.0

# Check for config csv file and create it if needed
$ConfigFile = ".\PasterTool.config"
If(!(Test-Path $ConfigFile)){ "ButtonText,ButtonValue" > $ConfigFile}

# Button Value Sanitization
$DisabledSymbols = @(
    "%{",
    "else(",
    "foreach(",
    "while(",
    "if(",
    "Function*{",
    "*:\*",
    '";'
)


Function Generate-ErrorBox {
    
    [CmdletBinding()]
        Param(
        [parameter(Mandatory=$true)]
        [String]$Message,

        [parameter(Mandatory=$true)]
        [String]$Title

    )

[System.Windows.MessageBox]::Show("$Message","$Title",'OK','Error')

}


Function Generate-PasteButton {
    
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
    $Button.add_Click($ExecutionContext.InvokeCommand.NewScriptBlock(('Set-ClipBoard '+"""$Value""")))
    Return $Button
}


Function Generate-EditTextbox {
    
    [CmdletBinding()]
    Param(

        [parameter(Mandatory=$true)]
        [String]$Value,
        
        [parameter(Mandatory=$true)]
        [String]$LineNumber,

        [parameter(Mandatory=$true)]
        [Boolean]$MultiLine
    
    )

    $ListNumber = $LineNumber-1
    $Textbox = New-Object System.Windows.Forms.Textbox
    
    # Settings for Value Textboxes
    $MultiLineSize2 = 0
    $MultiLineSize = 0
    $MultiLineLocation = 0
    If($MultiLine -eq $True){
        $Textbox.Multiline = $True
        $MultiLineLocation = 155
        $MultiLineSize = 50
        $MultiLineSize2 = 235
        }
    
    $Textbox.Text = $Value
    $Textbox.TabIndex = $ListNumber
    $Textbox.Name = "Textbox$ListNumber"
    $Textbox.Size = New-Object System.Drawing.Size((145+$MultiLineSize2),(25+$MultiLineSize))
    If(!($LineNumber -eq 1)){$Textbox.Location = New-Object System.Drawing.Point((13+$MultiLineLocation),(-78+88*$LineNumber))}
    Else{$Textbox.Location = New-Object System.Drawing.Point((13+$MultiLineLocation),(11))}
    $Textbox.DataBindings.DefaultDataSourceUpdateMode = 0

    Return $Textbox
}


Function Generate-Form {
 
    # Form Variables
    #==========================
    
    # Get CSV with button config
    $Config = Import-CSV $ConfigFile

    $Form = New-Object System.Windows.Forms.Form
    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
    $OnLoadForm_StateCorrection= {$Form.WindowState = $InitialFormWindowState}
 
    $Form.Text = “Paster Tool”
    $Form.Name = “Form”
    $Form.Topmost = $True
    $Form.FormBorderStyle = 'Fixed3D'
    $Form.MaximizeBox = $false
    $Form.DataBindings.DefaultDataSourceUpdateMode = 0
    $FormDrawingSize = New-Object System.Drawing.Size(295,(50+(25*($Config.count))))
    $Form.ClientSize = $FormDrawingSize
   
   
   
    # Generate Buttons on Form
    #==========================

    $LineNumber = 1
    Foreach($Line in $Config){
        If( $DisabledSymbols | Where-Object {$Line.ButtonValue -like "*$_*"}){
            Generate-ErrorBox -Message ("Forbidden Symbol in Button $LineNumber, Only Letters, Numbers and Dashes are allowed.

--------------------------------------------------------------

"+$Line.ButtonValue)  -Title "Forbidden Symbol"
            Generate-EditForm -ExitOnClose $True
        }
        Else{
            $Form.Controls.Add((Generate-PasteButton -Text $Line.ButtonText -Value $Line.ButtonValue -LineNumber $LineNumber))
            $LineNumber++
        }
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
    $Button.add_Click({Generate-EditForm})
    $Form.Controls.Add($Button)


    # Load Form
    #==========================
    $InitialFormWindowState = $Form.WindowState
    $Form.add_Load($OnLoadForm_StateCorrection)
    $Form.ShowDialog()| Out-Null
 
}


Function Generate-EditForm {
 
     [CmdletBinding()]
     Param(
        [Boolean]$ExitOnClose
        )
 
    $EditForm = New-Object System.Windows.Forms.Form
    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
    $OnLoadForm_StateCorrection= {$Form.WindowState = $InitialFormWindowState}
 
    $EditForm.Text = “Edit Paste Buttons”
    $EditForm.Name = “EditForm”
    $EditForm.Topmost = $True
    $EditForm.MaximizeBox = $false
    $EditForm.FormBorderStyle = 'Fixed3D'
    $EditForm.DataBindings.DefaultDataSourceUpdateMode = 0
    $EditFormDrawingSize = New-Object System.Drawing.Size(590,(50+(83*$Config.count)))
    $EditForm.ClientSize = $EditFormDrawingSize
   
   
    # Generate- Buttons on Form
    #==========================
    $Config = Import-CSV $ConfigFile
    $LineNumber = 1
    Foreach($Line in $Config){

            $EditForm.Controls.Add((Generate-EditTextbox -Value $Line.ButtonText -LineNumber $LineNumber -MultiLine $False))
            $EditForm.Controls.Add((Generate-EditTextbox -Value $Line.ButtonValue -LineNumber $LineNumber -MultiLine $True))
            $LineNumber++
        
     }
 
    # Generate- Save Button on Form
    #==========================
    
    
    $CheckButton = New-Object System.Windows.Forms.Button 
    $CheckButton.Text = "✔"
    $CheckButton.Name = “✔” 
    $CheckButton.Size = New-Object System.Drawing.Size(25,25)
    $CheckButton.UseVisualStyleBackColor = $True
    $CheckButton.Location = New-Object System.Drawing.Point(557,5)
    $CheckButton.DataBindings.DefaultDataSourceUpdateMode = 0 
    $CheckButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    #$CheckButton.add_Click(($ExecutionContext.InvokeCommand.NewScriptBlock("Write-host $Textbox1."))) #FINISH THIS
    $EditForm.AcceptButton = $CheckButton
    $EditForm.Controls.Add($CheckButton)

    $CancelButton = New-Object System.Windows.Forms.Button 
    $CancelButton.Text = "✘"
    $CancelButton.TabIndex = $LineNumber-1
    $CancelButton.Name = “✘” 
    $CancelButton.Size = New-Object System.Drawing.Size(25,25)
    $CancelButton.UseVisualStyleBackColor = $True
    $CancelButton.Location = New-Object System.Drawing.Point(557,35)
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
    $AddButton.Location = New-Object System.Drawing.Point(557,65)
    $AddButton.DataBindings.DefaultDataSourceUpdateMode = 0
    $EditForm.Controls.Add($AddButton)

    # Load Form
    #==========================
    $InitialFormWindowState = $EditForm.WindowState
    $EditForm.add_Load($OnLoadForm_StateCorrection)
    $EditForm.ShowDialog()| Out-Null
 
If($ExitOnClose){ exit }
}
 


Generate-Form
