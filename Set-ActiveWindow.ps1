function Set-ActiveWindow{

    param(
        [string] $WindowTitle="Terminal.Launcher.App"
    )
    [void](New-Object -ComObject WScript.Shell).AppActivate($WindowTitle)
    return "Window changed to $WindowTitle"
}
Set-ActiveWindow $args[0]