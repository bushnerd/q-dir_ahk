; 不显示托盘图标
; #NoTrayIcon

; 添加当前状态判断
; 解决问题：重命名文件夹和输入链接时，←和→被覆盖，导致移动光标出问题

; 无法获取当前的键盘布局，是84键，104键盘，笔记本布局
; 根据主机名来判断当前的键盘布局
currentComputerName := A_ComputerName

state := "Normal"

#If WinActive("ahk_exe Q-Dir_x64.exe") and (state = "Normal")
    ;注意，此处加~表示保留原有功能
    ~F2::state := "Rename"
Return

#If WinActive("ahk_exe Q-Dir_x64.exe") and (state = "Rename")
    ~Esc::state := "Normal"
Return

#If WinActive("ahk_exe Q-Dir_x64.exe") and (state = "Rename")
    ~Enter::state := "Normal"
Return

#IfWinActive ahk_exe Q-Dir_x64.exe
    ; Alt+PrintScreen as the hotkey to suspend and resume q-dir_ahk
    !PrintScreen::
        Suspend
        Pause,,1
    Return

    #If WinActive("ahk_exe Q-Dir_x64.exe") and (state = "Normal")
        ; 返回上一层级
    Left::
        ; Send BackSpace; 这种方式不行，不知道为什么
        ; 采用下面的方式就可以
        Send {BackSpace down}{BackSpace up}
    Return

    #If WinActive("ahk_exe Q-Dir_x64.exe") and (state = "Normal")
        ; 回车，即打开文件夹或文件
    Right::
        Send {Enter}
    Return

    #If WinActive("ahk_exe Q-Dir_x64.exe") and (state = "Normal")
        ; switch to left up panel
    ; 使用ctrl无法正常工作, 改用alt更加顺手
    !Up::
        Send, {LControl Down}
        Send, {1 Down}
        Send, {1 Up}
        Send, {LControl Up}
    Return

    ; switch to right up panel
    #If WinActive("ahk_exe Q-Dir_x64.exe") and (state = "Normal")
    if (currentComputerName = "P14") {
        !+Shift::
            Send, {LControl Down}
            Send, {2 Down}
            Send, {2 Up}
            Send, {LControl Up}
        Return
    } else {
        !End::
            Send, {LControl Down}
            Send, {2 Down}
            Send, {2 Up}
            Send, {LControl Up}
        Return
    }

; switch to left down panel
#If WinActive("ahk_exe Q-Dir_x64.exe") and (state = "Normal")
!Down::
Send, {LControl Down}
Send, {3 Down}
Send, {3 Up}
Send, {LControl Up}
Return

; switch to right down panel
#If WinActive("ahk_exe Q-Dir_x64.exe") and (state = "Normal")
    !Right::
    Send, {LControl Down}
    Send, {4 Down}
    Send, {4 Up}
    Send, {LControl Up}
Return

; Ctrl+q, menu Quick-links
#If WinActive("ahk_exe Q-Dir_x64.exe") and (state = "Normal")
    if (currentComputerName = "P14") {
        RShift::
            Send, {LControl Down}
            Send, {q Down}
            Send, {q Up}
            Send, {LControl Up}
        Return
    } else {
        End::
            Send, {LControl Down}
            Send, {q Down}
            Send, {q Up}
            Send, {LControl Up}
        Return
    }

; CTRL+Num+, autosize columns
#If WinActive("ahk_exe Q-Dir_x64.exe") and (state = "Normal")
    if (currentComputerName = "P14") {
        /::
            Send, {LControl Down}
            Send, {NumpadAdd Down}
            Send, {NumpadAdd Up}
            Send, {LControl Up}
        Return
    } else {
        !PgDn:: 
            Send, {LControl Down}
            Send, {NumpadAdd Down}
            Send, {NumpadAdd Up}
            Send, {LControl Up}
        Return
    }

; Simulate an event that clicking on the search box of TIM.exe.
#If WinActive("ahk_exe TIM.EXE")
^F::
    if (currentComputerName = "P14") {
        ControlClick, x200 y80, ahk_exe TIM.EXE,, Left, 1
    } else {
        ControlClick, x123 y53, ahk_exe TIM.EXE,, Left, 1
    }
Return

; Simulate an event that clicking on the search box of OneMessage.exe.
#If WinActive("ahk_exe OneMessage.exe")
    ^F::
    if (currentComputerName = "P14") {
        ControlClick, x200 y50, ahk_exe OneMessage.exe,, Left, 1
    } else {
        ControlClick, x100 y45, ahk_exe OneMessage.exe,, Left, 1
    }
Return

; Simulate an event that close the window
#If WinActive("ahk_exe OneMessage.exe")
ESC::
Send, {LAlt Down}
Send, {F4 Down}
Send, {F4 Up}
Send, {LAlt Up}
Return

; Check if MuMuPlayer.exe is the active window
#If WinActive("ahk_exe MuMuPlayer.exe")
    ; Map right mouse button (RButton) to send Esc key
    RButton::Send {Esc}
Return

; VSCode with VSCode Vim Extension
; code.exe
; Simulate an event that switch input method between en/cn in QQpinyin or sogoupinyin
; TODO:Insert模式下，退出到Normal正常，但是从Visual模式下退出时不应该再发送Shift按键，但是没有办法判断
; #If WinActive("ahk_exe code.exe")
; ~Esc::
;     Send, {LShift Down}
;     Send, {LShift Up}
; Return

#If WinActive("ahk_exe Obsidian.exe") or ("ahk_exe code.exe")
    ^Space::#Space
Return

!R::
if WinActive("ahk_exe Telegram.exe") {
	WinClose , ahk_exe Telegram.exe
} else {
	run "D:\scoop\apps\telegram\current\Telegram.exe"
}
return

; 这里会影响Esc键在其他程序中的使用，按代码来看，应该只有Telegram.exe活动的时候才对Esc做了映射的
; if WinActive("ahk_exe Telegram.exe") 
; Esc::
; 	WinClose , ahk_exe Telegram.exe
; Return

; 针对Q-dir做的研究，后面可以继续扩展到Microsoft Terminal
; 按下 Alt+1 隐藏窗口或将窗口调到最前面
; !1::
; #IfWinExist, ahk_exe Q-Dir_x64.exe
;     if WinExist("ahk_exe Q-Dir_x64.exe") {
;         if WinActive("ahk_exe Q-Dir_x64.exe") {
;             WinHide
;         } else {
;             WinActivate
;             WinShow
;         }
;     } else {
;         Run, "D:\Programs\Q-Dir\Q-Dir_x64.exe"
;     }
; #IfWinExist
; return

; 按下 Alt+1 隐藏窗口
; !1::
; if WinExist("ahk_exe Q-Dir_x64.exe") {
;     WinHide , ahk_exe Q-Dir_x64.exe
; }
; return

; ; 按下 Alt+2 恢复窗口
; !2::
;     WinShow , ahk_exe Q-Dir_x64.exe
; return
