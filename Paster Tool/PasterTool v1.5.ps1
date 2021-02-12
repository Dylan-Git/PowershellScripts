<#To Do
- Make edit form work and save to the config file
- Allow adding and removing buttons
-- Useful if at max buttons - $button1.Enabled = $false
- make a maximum of 11 buttons and consider allowing 2 columns of buttons have up to 20
- Allow opening programs or running shortcuts
#>

[reflection.assembly]::loadwithpartialname(“System.Windows.Forms”) | Out-Null
[reflection.assembly]::loadwithpartialname(“System.Drawing”) | Out-Null

Set-StrictMode -Version 2.0

# Hide PowerShell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)

# Check for config csv file and create it if needed
$ConfigFile = ".\PasterTool.config"
If(!(Test-Path $ConfigFile)){ "ButtonText,ButtonValue" > $ConfigFile}

# Form Colors
$Global:FormColor = 'Gainsboro'
$Global:FormColorDark = 'DimGray'
$Global:FormColorLight = 'Gainsboro'

# Create Form Objects
$Form = New-Object System.Windows.Forms.Form
$EditForm = New-Object System.Windows.Forms.Form

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
    $Button.Font = [System.Drawing.Font]::new('Arial Rounded MT Bold', 9.5, [System.Drawing.FontStyle]::Bold)
    $Button.ForeColor = 'Navy'
    $Button.Size = New-Object System.Drawing.Size(260,30)
    $Button.UseVisualStyleBackColor = $True
    $Button.BackColor = 'WhiteSmoke'
    $Button.Location = New-Object System.Drawing.Point(13,(35*$LineNumber))
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
    $Global:Textbox = New-Object System.Windows.Forms.Textbox
    
    # Settings for Value Textboxes
    $MultiLineSize2 = 0
    $MultiLineSize = 0
    $MultiLineLocation = 0
    If($MultiLine -eq $True){
        $Textbox.Multiline = $True
        $MultiLineLocation = 155
        $MultiLineSize = 45
        $MultiLineSize2 = 235
    }
    
    $Textbox.Text = $Value
    $Textbox.TabIndex = $ListNumber
    $Textbox.Name = "Textbox$ListNumber"
    $Textbox.Scrollbars = "Vertical"
    $Textbox.Size = New-Object System.Drawing.Size((145+$MultiLineSize2),(30+$MultiLineSize))
    If(!($LineNumber -eq 1)){$Textbox.Location = New-Object System.Drawing.Point((13+$MultiLineLocation),(-78+88*$LineNumber))}
    Else{$Textbox.Location = New-Object System.Drawing.Point((13+$MultiLineLocation),(11))}
    $Textbox.DataBindings.DefaultDataSourceUpdateMode = 0

    Return $Textbox
}


Function Generate-MenuBar{
    
    $MenuStrip = new-object System.Windows.Forms.MenuStrip
    $MenuStrip_File = new-object System.Windows.Forms.ToolStripMenuItem
    $MenuStrip_File_Open = new-object System.Windows.Forms.ToolStripMenuItem
    $MenuStrip_Configure = new-object System.Windows.Forms.ToolStripMenuItem
    $MenuStrip_Configure_ButtonConfiguration = new-object System.Windows.Forms.ToolStripMenuItem
    $MenuStrip_Configure_ToggleDarkMode = new-object System.Windows.Forms.ToolStripMenuItem

    # Main Menu Bar
    $MenuStrip.Location = new-object System.Drawing.Point(0, 0)
    $MenuStrip.Name = "MenuStrip"
    $MenuStrip.Size = new-object System.Drawing.Size(354, 24)
    $MenuStrip.TabIndex = 0
    $MenuStrip.Text = "MenuStrip"
    $MenuStrip.Items.AddRange(@(
        $MenuStrip_File,
        $MenuStrip_Configure
        ))
    
        # File Tab
        $MenuStrip_File.Name = "MenuStrip_File"
        $MenuStrip_File.Size = new-object System.Drawing.Size(35, 20)
        $MenuStrip_File.Text = "&File"
        $MenuStrip_File.DropDownItems.AddRange(@(
            $MenuStrip_File_Open
            ))
    
            # File -> Open Tab
            $MenuStrip_File_Open.Name = "MenuStrip_File_Open"
            $MenuStrip_File_Open.Size = new-object System.Drawing.Size(35, 20)
            $MenuStrip_File_Open.Text = "&Open"
    
        # Configure Tab
        $MenuStrip_Configure.Name = "MenuStrip_Configure"
        $MenuStrip_Configure.Size = new-object System.Drawing.Size(35, 20)
        $MenuStrip_Configure.Text = "&Configure"
        $MenuStrip_Configure.DropDownItems.AddRange(@(
            $MenuStrip_Configure_ButtonConfiguration,
            $MenuStrip_Configure_ToggleDarkMode
            ))

            # Configure -> Edit Button Configuration
            $MenuStrip_Configure_ButtonConfiguration.Name = "MenuStrip_Configure_ButtonConfiguration"
            $MenuStrip_Configure_ButtonConfiguration.Size = new-object System.Drawing.Size(35, 20)
            $MenuStrip_Configure_ButtonConfiguration.Text = "&Button Configuration"
            $MenuStrip_Configure_ButtonConfiguration.Add_Click( { Generate-EditForm } )
    

            # Configure -> EnableDarkMode Tab
            $MenuStrip_Configure_ToggleDarkMode.Name = "MenuStrip_onfigure_ToggleDarkMode"
            $MenuStrip_Configure_ToggleDarkMode.Size = new-object System.Drawing.Size(35, 20)
            $MenuStrip_Configure_ToggleDarkMode.Text = "&Toggle Dark Mode"
            $MenuStrip_Configure_ToggleDarkMode.Add_Click($ExecutionContext.InvokeCommand.NewScriptBlock('
                If($Form.BackColor -eq $FormColorLight){
                    $Form.BackColor = $FormColorDark
                    $EditForm.BackColor = $FormColorDark
                    $Global:FormColor = $FormColorDark
                    }
                Else{ 
                    $Form.BackColor = $FormColorLight
                    $EditForm.BackColor = $FormColorLight
                    $Global:FormColor = $FormColorLight
                }
                ')
            )
    
    
    # Add Menu Bar to Form
    $Form.MainMenuStrip = $MenuStrip
    $Form.Controls.Add($MenuStrip)

}


Function Generate-Form {
 
    # Form Variables
    #==========================
    $Config = Import-CSV $ConfigFile

    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
    $OnLoadForm_StateCorrection= {$Form.WindowState = $InitialFormWindowState}
 
    $Form.Text = “Paster Tool”
    $Form.Name = “Form”
    $Form.Topmost = $True
    $Form.BackColor = $Global:FormColor
    $Form.FormBorderStyle = 'Fixed3D'
    $Form.MaximizeBox = $false
    $Form.DataBindings.DefaultDataSourceUpdateMode = 0
    $Form.ClientSize = New-Object System.Drawing.Size(287,(75+(30*($Config.count))))
   
    
    # Menu Buttons on Form
    #==========================
    Generate-MenuBar
    
    
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
 
    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
    $OnLoadForm_StateCorrection= {$EditForm.WindowState = $InitialFormWindowState}
 
    $EditForm.Text = “Edit Paste Buttons”
    $EditForm.Name = “EditForm”
    $EditForm.Topmost = $True
    $EditForm.MaximizeBox = $false
    $EditForm.BackColor = $Global:FormColor
    $EditForm.FormBorderStyle = 'Fixed3D'
    $EditForm.DataBindings.DefaultDataSourceUpdateMode = 0
    $EditForm.ClientSize = New-Object System.Drawing.Size(590,(50+(83*$Config.count)))
   
   
    # Generate- Buttons on Form
    #==========================
    $Config = Import-CSV $ConfigFile
    $LineNumber = 1
    $ButtonTextList = @()
    $ButtonValueList = @()
    Foreach($Line in $Config){
        $ButtonText = (Generate-EditTextbox -Value $Line.ButtonText -LineNumber $LineNumber -MultiLine $False)
        $EditForm.Controls.Add($ButtonText)
        $ButtonTextList += $ButtonText
        $ButtonValue = (Generate-EditTextbox -Value $Line.ButtonValue -LineNumber $LineNumber -MultiLine $True)
        $EditForm.Controls.Add($ButtonValue)
        $ButtonValueList += $ButtonValue
        $LineNumber++
        
     }
    $ButtonTextList
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
