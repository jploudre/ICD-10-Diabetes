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
 
F1::PatternHotKey(".->ChangeProblemtoICD10(E11.21 DM, TYPE 2, W/ NEPHROPATHY|*FCN_DIABETES RENAL")
F2::PatternHotKey(".->ChangeProblemtoICD10(E11.22 DM, TYPE 2, W/ CKD|*FCN_DIABETES RENAL")
F3::PatternHotKey(".->ChangeProblemtoICD10(E11.319 DM, TYPE 2, W/ RETINOPATHY, UNSPEC W/O MACULAR EDEMA|*FCN-DIABETES OPHTH")
F4::PatternHotKey(".->ChangeProblemtoICD10(E11.359  DM, TYPE 2, W/ RETINOPATHY PROLIFERATIVE W/O MACULAR EDEMA|*FCN-DIABETES OPHTH")
F5::PatternHotKey(".->ChangeProblemtoICD10(E11.329 DM, TYPE 2, W/ RETINOPATHY NONPROLIFERATIVE, W/O MACULAR EDEMA|*FCN-DIABETES OPHTH")
F6::PatternHotKey(".->ChangeProblemtoICD10(E11.36 DM, TYPE 2, W/ CATARACT|*FCN-DIABETES OPHTH")
F7::PatternHotKey(".->ChangeProblemtoICD10(E11.42 DM, TYPE 2, W/ POLYNEUROPATHY|*FCN_DIABETES NEURO")
F8::PatternHotKey(".->ChangeProblemtoICD10(E11.43 DM, TYPE 2, W/ PERIPHERAL AUTONOMIC NEUROPATHY|*FCN_DIABETES NEURO")
F9::PatternHotKey(".->ChangeProblemtoICD10(E11.51 DM, TYPE 2, W/ PERIPHERAL ANGIOPATHY OR PAD|*FCN_DIABETES PERIPHERAL CIRC")
F10::PatternHotKey(".->ChangeProblemtoICD10(E11.59 DM, TYPE 2, W/ OTHER CIRCULATORY COMPL|*FCN_DIABETES PERIPHERAL CIRC")
F11::PatternHotKey(".->ChangeProblemtoICD10(E11.621 DM, TYPE 2, W/ FOOT ULCER|*FCN_DIABETES ULCER")
F12::PatternHotKey(".->ChangeProblemtoICD10(E11.622 DM, TYPE 2, W/ OTHER SKIN ULCER|E11.622|*FCN_DIABETES ULCER")
 
#ifWinActive, Update  -  
#Space::
NumPadAdd::
SendQuicktext()
EndUpdate()
return
#ifWinActive ; End of Window Specific Hotkeys.
;############################################

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


ChangeProblemtoICD10(DescriptionandList){
StringSplit, SearchTerms, DescriptionandList, "|"
Send !c
WinWaitActive,  Edit Problem, ,4
    if (ErrorLevel = 0) {
        CitrixSleep()
        Click, 566, 132, 2
        CitrixSleep()
        Click, 570, 281, 5
    }
}
return


; Downloaded Functions
;############################################

Clip(Text="", Reselect="") ; http://www.autohotkey.com/forum/viewtopic.php?p=467710 , modified August 2012
{
	Static BackUpClip, Stored, LastClip
	If (A_ThisLabel = A_ThisFunc) {
		If (Clipboard == LastClip)
			Clipboard := BackUpClip
		BackUpClip := LastClip := Stored := ""
	} Else {
		If !Stored {
			Stored := True
			BackUpClip := ClipboardAll
		} Else
			SetTimer, %A_ThisFunc%, Off
		LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount
		If (Text = "") {
			Send, ^c
			ClipWait, LongCopy ? 0.5 : 0.25
		} Else {
			Clipboard := LastClip := Text
			ClipWait, 10
			Send, ^v
		}
		SetTimer, %A_ThisFunc%, -700
		If (Text = "")
			Return LastClip := Clipboard
		Else If (ReSelect = True) or (Reselect and (StrLen(Text) < 3000)) {
			Sleep 30
			StringReplace, Text, Text, `r, , All
			SendInput, % "{Shift Down}{Left " StrLen(Text) "}{Shift Up}"
		}
	}
	Return
	Clip:
	Return Clip()
}

; http://www.autohotkey.com/board/topic/66855-patternhotkey-map-shortlong-keypress-patterns-to-anything/?hl=%2Bpatternhotkey
; Usage : hotkey::PatternHotKey("command1", ["command2", "command3", length(integer), period(float)])
;     where commands match one of the following formats:
;         "pattern:keys"                  ; Maps pattern to send keys
;         "pattern->label"                ; Maps pattern to label (GoSub)
;         "pattern->function()"           ; Maps pattern to function myfunction with
;                                           no parameter
;         "pattern->function(value)"      ; Maps pattern to function myfunction with
;                                           the first parameter equal to 'value'
;         and patterns match the following formats:
;             '.' or '0' represents a short press
;             '-' or '_' represents a long press of any length
;             '?' represents any press
PatternHotKey(arguments*)
{
    period = 0.2
    length = 1
    for index, argument in arguments
    {
        if argument is float
            period := argument, continue
        if argument is integer
            length := argument, continue
        separator := InStr(argument, ":", 1) - 1
        if ( separator >= 0 )
        {
            pattern   := SubStr(argument, 1, separator)
            command    = Send
            parameter := SubStr(argument, separator + 2)
        }
        else
        {
            separator := InStr(argument, "->", 1) - 1
            if ( separator >= 0 )
            {
                pattern := SubStr(argument, 1, separator)

                call := Trim(SubStr(argument, separator + 3))
                parenthesis := InStr(call, "(", 1, separator) - 1
                if ( parenthesis >= 0 )
                {
                    command   := SubStr(call, 1, parenthesis)
                    parameter := Trim(SubStr(call, parenthesis + 1), "()"" `t")
                }
                else
                {
                    command    = GoSub
                    parameter := call
                }
            }
            else
                continue
        }

        if ( Asc(pattern) = Asc("~") )
            pattern := SubStr(pattern, 2)
        else
        {
            StringReplace, pattern, pattern, ., 0, All
            StringReplace, pattern, pattern, -, [1-9A-Z], All
            StringReplace, pattern, pattern, _, [1-9A-Z], All
            StringReplace, pattern, pattern, ?, [0-9A-Z], All
            pattern := "^" . pattern . "$"
            if ( length < separator )
                length := separator
        }

        patterns%index%   := pattern
        commands%index%   := command
        parameters%index% := parameter
    }
    keypress := KeyPressPattern(length, period)
    Loop %index%
    {
        pattern   := patterns%A_Index%
        command   := commands%A_Index%
        parameter := parameters%A_Index%

        if ( pattern && RegExMatch(keypress, pattern) )
        {
            if ( command = "Send" )
                Send % parameter
            else if ( command = "GoSub" and IsLabel(parameter) )
                gosub, %parameter%
            else if ( IsFunc(command) )
                %command%(parameter)
        }
    }
}

KeyPressPattern(length = 2, period = 0.2)
{
    key := RegExReplace(A_ThisHotKey, "[\*\~\$\#\+\!\^]")
    IfInString, key, %A_Space%
        StringTrimLeft, key, key, % InStr(key, A_Space, 1)
    if key in Alt,Ctrl,Shift,Win
        modifiers := "{L" key "}{R" key "}"
    current = 0
    loop
    {
        KeyWait %key%, T%period%
        if ( ! ErrorLevel )
        {
            pattern .= current < 10
                       ? current
                       : Chr(55 + ( current > 36 ? 36 : current ))
            current = 0
        }
        else
            current++
        if ( StrLen(pattern) >= length )
            return pattern
        if ( ! ErrorLevel )
        {
            if ( key in Capslock, LButton, MButton, RButton or Asc(A_ThisHotkey) = Asc("$") )
            {
                KeyWait, %key%, T%period% D
                if ( ErrorLevel )
                    return pattern
            }
            else
            {
                Input,, T%period% L1 V,{%key%}%modifiers%
                if ( ErrorLevel = "Timeout" )
                    return pattern
                else if ( ErrorLevel = "Max" )
                    return
                else if ( ErrorLevel = "NewInput" )
                    return
            }
        }
    }
}
