#IfWinActive ahk_class ATL:00000001401A5900
; F1 as the hotkey to suspend and resume q-dir_ahk
F1::
    Suspend
Pause,,1
Return

#IfWinActive ahk_class ATL:00000001401A5900
; 返回上一层级
Left::
    ; Send BackSpace; 这种方式不行，不知道为什么
    ; 采用下面的方式就可以
    Send {BackSpace down}{BackSpace up}
Return

#IfWinActive ahk_class ATL:00000001401A5900
; 回车，即打开文件夹或文件
Right::
    Send {Enter}
Return
; TODO:重命名文件夹和输入链接时，←和→被覆盖，导致移动光标出问题

#IfWinActive ahk_class ATL:00000001401A5900
; switch to left up panel
; 使用ctrl无法正常工作, 改用alt更加顺手
!Up::
    Send, {LControl Down}
    Send, {1 Down}
    Send, {1 Up}
    Send, {LControl Up}
Return

; switch to right up panel
#IfWinActive ahk_class ATL:00000001401A5900
!End::
    Send, {LControl Down}
    Send, {2 Down}
    Send, {2 Up}
    Send, {LControl Up}
Return

; switch to left down panel
#IfWinActive ahk_class ATL:00000001401A5900
!Down::
    Send, {LControl Down}
    Send, {3 Down}
    Send, {3 Up}
    Send, {LControl Up}
Return

; switch to right down panel
#IfWinActive ahk_class ATL:00000001401A5900
!Right::
    Send, {LControl Down}
    Send, {4 Down}
    Send, {4 Up}
    Send, {LControl Up}
Return

; Ctrl+q, menu Quick-links
#IfWinActive ahk_class ATL:00000001401A5900
End::
    Send, {LControl Down}
    Send, {q Down}
    Send, {q Up}
    Send, {LControl Up}
Return
