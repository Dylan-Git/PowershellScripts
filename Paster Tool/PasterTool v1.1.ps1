#thing | clip.exe

#Generated Form Function 
function GenerateForm { 

[reflection.assembly]::loadwithpartialname(“System.Windows.Forms”) | Out-Null 
[reflection.assembly]::loadwithpartialname(“System.Drawing”) | Out-Null 

$PasterForm = New-Object System.Windows.Forms.Form 
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState 
$OnLoadForm_StateCorrection= {$PasterForm.WindowState = $InitialFormWindowState}

$PasterForm.Text = “Paster Tool” 
$PasterForm.Name = “PasterForm”
$PasterForm.Topmost = $True
$PasterForm.DataBindings.DefaultDataSourceUpdateMode = 0 
$System_Drawing_Size = New-Object System.Drawing.Size 
$System_Drawing_Size.Width = 265 
$System_Drawing_Size.Height = 275 
$PasterForm.ClientSize = $System_Drawing_Size


#=======================================================================

$System_Drawing_Size = New-Object System.Drawing.Size 
$System_Drawing_Size.Width = 240 
$System_Drawing_Size.Height = 23 

# Button 1
$PasteButton1 = New-Object System.Windows.Forms.Button 

$PasteButton1.Text = “apw”
$PasteButton1Value = "Waslookman3@"

$PasteButton1DrawingPoint = New-Object System.Drawing.Point 
$PasteButton1DrawingPoint.X = 13 
$PasteButton1DrawingPoint.Y = 10
$PasteButton1.TabIndex = 0 
$PasteButton1.Name = “PasteButton1” 
$PasteButton1.Size = $System_Drawing_Size 
$PasteButton1.UseVisualStyleBackColor = $True
$PasteButton1.Location = $PasteButton1DrawingPoint
$PasteButton1.DataBindings.DefaultDataSourceUpdateMode = 0 
$PasteButton1.add_Click({"$PasteButton1Value" | clip.exe})
$PasterForm.Controls.Add($PasteButton1)

# Button 2
$PasteButton2 = New-Object System.Windows.Forms.Button 

$PasteButton2.Text = “Ticket - VM for Callback”
$PasteButton2Value = "Left a voicemail for callback with client."

$PasteButton2DrawingPoint = New-Object System.Drawing.Point 
$PasteButton2DrawingPoint.X = 13
$PasteButton2DrawingPoint.Y = 40
$PasteButton2.TabIndex = 1 
$PasteButton2.Name = “PasteButton2” 
$PasteButton2.Size = $System_Drawing_Size 
$PasteButton2.UseVisualStyleBackColor = $True
$PasteButton2.Location = $PasteButton2DrawingPoint
$PasteButton2.DataBindings.DefaultDataSourceUpdateMode = 0 
$PasteButton2.add_Click({"$PasteButton2Value" | clip.exe})
$PasterForm.Controls.Add($PasteButton2)

# Button 3
$PasteButton3 = New-Object System.Windows.Forms.Button 

$PasteButton3.Text = “Ticket - Email for Callback”
$PasteButton3Value = "Left an email for callback with client."

$PasteButton3DrawingPoint = New-Object System.Drawing.Point 
$PasteButton3DrawingPoint.X = 13 
$PasteButton3DrawingPoint.Y = 70
$PasteButton3.TabIndex = 2 
$PasteButton3.Name = “PasteButton3” 
$PasteButton3.Size = $System_Drawing_Size 
$PasteButton3.UseVisualStyleBackColor = $True
$PasteButton3.Location = $PasteButton3DrawingPoint
$PasteButton3.DataBindings.DefaultDataSourceUpdateMode = 0 
$PasteButton3.add_Click({"$PasteButton3Value" | clip.exe})
$PasterForm.Controls.Add($PasteButton3)

# Button 4
$PasteButton4 = New-Object System.Windows.Forms.Button 

$PasteButton4.Text = “Ticket - VM for Followup”
$PasteButton4Value = "Left a voicemail for followup with client."

$PasteButton4DrawingPoint = New-Object System.Drawing.Point 
$PasteButton4DrawingPoint.X = 13 
$PasteButton4DrawingPoint.Y = 100
$PasteButton4.TabIndex = 3
$PasteButton4.Name = “PasteButton4” 
$PasteButton4.Size = $System_Drawing_Size 
$PasteButton4.UseVisualStyleBackColor = $True
$PasteButton4.Location = $PasteButton4DrawingPoint
$PasteButton4.DataBindings.DefaultDataSourceUpdateMode = 0 
$PasteButton4.add_Click({"$PasteButton4Value" | clip.exe})
$PasterForm.Controls.Add($PasteButton4)

# Button 5
$PasteButton5 = New-Object System.Windows.Forms.Button 

$PasteButton5.Text = “Ticket - Email for Followup”
$PasteButton5Value = "Left an email for followup with client."

$PasteButton5DrawingPoint = New-Object System.Drawing.Point 
$PasteButton5DrawingPoint.X = 13 
$PasteButton5DrawingPoint.Y = 130
$PasteButton5.TabIndex = 4
$PasteButton5.Name = “PasteButton5” 
$PasteButton5.Size = $System_Drawing_Size 
$PasteButton5.UseVisualStyleBackColor = $True
$PasteButton5.Location = $PasteButton5DrawingPoint
$PasteButton5.DataBindings.DefaultDataSourceUpdateMode = 0 
$PasteButton5.add_Click({"$PasteButton5Value" | clip.exe})
$PasterForm.Controls.Add($PasteButton5)

# Button 6
$PasteButton6 = New-Object System.Windows.Forms.Button 

$PasteButton6.Text = "Quickpart - Callback"
$PasteButton6Value = "Hey 

I've received your ticket on this issue, can you please give me a call when you have 10-20 minutes of free time to look at this?

780-669-6007 - Ask for Dylan.

Thanks!"


$PasteButton6DrawingPoint = New-Object System.Drawing.Point 
$PasteButton6DrawingPoint.X = 13 
$PasteButton6DrawingPoint.Y = 160
$PasteButton6.TabIndex = 5
$PasteButton6.Name = “PasteButton6” 
$PasteButton6.Size = $System_Drawing_Size 
$PasteButton6.UseVisualStyleBackColor = $True
$PasteButton6.Location = $PasteButton6DrawingPoint
$PasteButton6.DataBindings.DefaultDataSourceUpdateMode = 0 
$PasteButton6.add_Click({"$PasteButton6Value" | clip.exe})
$PasterForm.Controls.Add($PasteButton6)

# Button 7
$PasteButton7 = New-Object System.Windows.Forms.Button 

$PasteButton7.Text = “Quickpart - Followup"
$PasteButton7Value = "Hey 

Just following up to see if this issue is still occurring for you as I haven't heard back yet.

Thanks!"


$PasteButton7DrawingPoint = New-Object System.Drawing.Point 
$PasteButton7DrawingPoint.X = 13 
$PasteButton7DrawingPoint.Y = 190
$PasteButton7.TabIndex = 6
$PasteButton7.Name = “PasteButton7” 
$PasteButton7.Size = $System_Drawing_Size 
$PasteButton7.UseVisualStyleBackColor = $True
$PasteButton7.Location = $PasteButton7DrawingPoint
$PasteButton7.DataBindings.DefaultDataSourceUpdateMode = 0 
$PasteButton7.add_Click({"$PasteButton7Value" | clip.exe})
$PasterForm.Controls.Add($PasteButton7)

# Button 8
$PasteButton8 = New-Object System.Windows.Forms.Button 

$PasteButton8.Text = “Button 8”
$PasteButton8Value = "test"

$PasteButton8DrawingPoint = New-Object System.Drawing.Point 
$PasteButton8DrawingPoint.X = 13 
$PasteButton8DrawingPoint.Y = 220
$PasteButton8.TabIndex = 7
$PasteButton8.Name = “PasteButton8” 
$PasteButton8.Size = $System_Drawing_Size 
$PasteButton8.UseVisualStyleBackColor = $True
$PasteButton8.Location = $PasteButton8DrawingPoint
$PasteButton8.DataBindings.DefaultDataSourceUpdateMode = 0 
$PasteButton8.add_Click({"$PasteButton8Value" | clip.exe})
$PasterForm.Controls.Add($PasteButton8)

# ================================================================================



$InitialFormWindowState = $PasterForm.WindowState 

$PasterForm.add_Load($OnLoadForm_StateCorrection) 

$PasterForm.ShowDialog()| Out-Null

} #End Function

#Call the Function 
GenerateForm 