Add-Type -TypeDefinition @'
namespace Win32
{
    public static class WindowFunctions
    {
        [System.Runtime.InteropServices.DllImport("User32.dll", EntryPoint="ShowWindow")]
        public static extern bool ShowWindow(System.IntPtr hWnd, int nCmdShow);
    }
}
'@

# Minimize the PowerShell Window
[Win32.WindowFunctions]::ShowWindow((Get-Process | Where-Object { $_.MainWindowTitle -like "*Windows PowerShell*" } | Select-Object -ExpandProperty MainWindowHandle -First 1), 6) | Out-Null