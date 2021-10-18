; 不显示托盘图标
; #NoTrayIcon

; 添加当前状态判断
; 解决问题：重命名文件夹和输入链接时，←和→被覆盖，导致移动光标出问题

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
    ; F1 as the hotkey to suspend and resume q-dir_ahk
    F1::
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
    !End::
    Send, {LControl Down}
    Send, {2 Down}
    Send, {2 Up}
    Send, {LControl Up}
Return

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
End::
    Send, {LControl Down}
    Send, {q Down}
    Send, {q Up}
    Send, {LControl Up}
Return

; CTRL+Num+, autosize columns
#If WinActive("ahk_exe Q-Dir_x64.exe") and (state = "Normal")
PgDn::
    Send, {LControl Down}
    Send, {NumpadAdd Down}
    Send, {NumpadAdd Up}
    Send, {LControl Up}
Return
