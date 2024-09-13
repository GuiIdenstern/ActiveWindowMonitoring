#Перейти в папку, где расположен скрипт
#Split-Path -Path $PSCommandPath -Parent | Set-Location

#Возвращает активное окно (фокус) - код с инета
function Get-ForegroundWindow{
    Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class Tricks {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
}
"@

    $a = [tricks]::GetForegroundWindow()

    get-process | Where-Object { $_.mainwindowhandle -eq $a }
}

#Переключает фокус на окно с указанным заголовком
function Set-ActiveWindow{

    param(
        [string] $WindowTitle="Terminal.Launcher.App"
    )
    [void](New-Object -ComObject WScript.Shell).AppActivate($WindowTitle)
    return "Window changed to $WindowTitle"
}

function Start-ActiveWindowMonitoring{
    param(
        [string] $Hidingwindow="BL_SplashScreenForm",
        [string] $ActivatingWindow="Terminal.Launcher.App"
    )

    $LastWindow=$ActivatingWindow
    $TimerCycle=1
    $TimerBeforeActiveWindowLaunch=5

    while ($true){
        
        $currentwindow=(Get-ForegroundWindow).MainWindowTitle
        if ($currentwindow -ne $LastWindow){
            Write-Host "Active window changed to: `t`t$currentwindow"

            if($currentwindow -eq $Hidingwindow)
            {
                $Windows=(Get-Process|Where-Object{$_.MainWindowTitle}).MainWindowTitle


                if($Windows -contains $ActivatingWindow){
                    Write-Host "Active window $HidingWindow is imposter, and will be changed to $ActivatingWindow after $TimerBeforeActiveWindowLaunch seconds"
                    Start-Sleep $TimerBeforeActiveWindowLaunch

                    #Нужно открыть новое окно, чтобы оно забрало фокус, иначе переключение фокуса не сработает
                    start-process pwsh -ArgumentList "-c .\set-activewindow $ActivatingWindow"
                }
                else {
                    Write-Host "$ActivatingWindow is not availible"
                }
            }
        }
        $LastWindow=$currentwindow

        Start-Sleep $TimerCycle
    }
}

Start-ActiveWindowMonitoring