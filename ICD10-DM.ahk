#InstallKeybdHook
CoordMode, Mouse, Window
#Persistent
#UseHook
SetTitleMatchMode, 2
SetKeyDelay, 30
return

; For Debugging Purposes
#Space::
WinGetTitle, Title, A
ListVars
Pause
return

#ifWinActive, Chart Reports - 
#Space::
NumPadAdd::
Click, 668, 150, 2 ; Open Top Result
WinWaitActive, Chart -, , 10 ; Timeout 10 seconds
if (ErrorLevel = 0) {
    CitrixSleep()
    WinGetPos,,,winwidth,winheight,A
    ImageSearch, FoundX, FoundY, 0, 112, %winwidth%, %winheight%, *n50 NewDocument.png
    if (ErrorLevel = 0) {
        Click, %FoundX%, %FoundY%, 2
        WinWaitActive, Update Chart -, , 10 ; Timeout 10 seconds 
        if (ErrorLevel = 0) {
            CitrixSleep()
            Send zI{Enter}
            WinWaitActive, Update - ; no timeout needed
            if (ErrorLevel = 0) {
                CitrixSleep()
                Send +{F8}
                CitrixSleep()
                Click, 847, 401
                WinWaitActive, Update Problems -
                if (ErrorLevel = 0) {
                SoundPlay, *64
                }
            }
        }
    }
}
return
  
#ifWinActive, Update Problems -  

#Space::
NumPadAdd::
CloseUpdateProblems()
SendQuicktext()
EndUpdate()
return
 
 
#ifWinActive, Update  -  

#ifWinActive ; End of Window Specific Hotkeys.

CitrixSleep(){
Sleep, 500
}
return

CloseUpdateProblems(){
WinGetPos,,,winwidth,winheight,A
xpos := winwidth - 120
ypos := winheight -26
click, %xpos%, %ypos%, 2
WinWaitNotActive, Update Problems -
CitrixSleep()
}
return

SendQuicktext(){
 Send +{F8}
Citrixsleep()
Click, 300, 500
Send `;icddm{Enter 2}.icd10prob{Enter 2}
CitrixSleep()
}
return

EndUpdate(){
Send ^e
WinWaitActive, End Update - 
CitrixSleep()
Send !o
WinWaitActive, Chart -, , 10
if (ErrorLevel = 0) {
    CitrixSleep()
    WinGetPos,,,winwidth,winheight
    ImageSearch, FoundX, FoundY, 0, 0, %winwidth%, %winheight%, *n50 ChartReports.png
    if (ErrorLevel = 0) {
        Click, %FoundX%, %FoundY%
        WinWaitActive, Chart Reports -
        Citrixsleep()
        Click, 573, 527 ; Search
        Sleep, 3000
        SoundPlay, *64
    }
    }
}
return