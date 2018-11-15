#SingleInstance,Force
#Persistent
#NoEnv
#InstallKeybdHook
#installmousehook
#winactivateforce
#KeyHistory 0
; #NoTrayIcon
ListLines, Off
SendMode Input
SetWorkingDir %A_ScriptDir%
SetControlDelay, -1
SetKeyDelay, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0 
SetWinDelay, -1
SetBatchLines -1
Process, Priority,, High
SetTitleMatchMode, 2
FileEncoding,UTF-8
OnExit, GuiClose
OnMessage(0x4a, "Receive_WM_COPYDATA")

Receive_WM_COPYDATA(wParam, lParam)
{
	global
    refineInt++
    GuiControl,,N번사용,오늘 외래어를 %refineInt%번 쓰셨어요!
    return true
}

RunWait, %COMSPEC% /c "taskkill /im AHK.exe",,Hide UseErrorLevel

refineInt:=0
Loop, Read, 순화 기록.txt
{
	if SubStr(A_Now,1,8) = SubStr(A_LoopReadLine,1,8)
		refineInt++
}

string:=""
arr:={}

Gui,Add,Text,,CapsLock으로 외래어 순화 비활성화
Gui,Add,GroupBox,w200 h60,설정
Gui,Add,Checkbox,xp+10 yp+15 vAutoChange Checked0,자동 순화
; AutoChange:=1
Gui,Add,Text,y+40 w200 vN번사용,오늘 외래어를 %refineInt%번 쓰셨어요!
Gui,Add,Button,x0 y110 w300 h30 vReload gReload,변경한 설정 적용
Gui,Add,StatusBar
SB_SetParts(150,150)
Gui,Show,w300 h160,우리말 지킴이
gosub Reload
gosub check
return

~*CapsLock::
check:
KeyWait, CapsLock
str:=!GetKeyState("CapsLock","T") ? "외래어 순화 중!" : ""
SB_SetText(str)
SB_SetText("자동 순화: "(AutoChange?"활성화":"비활성화"),2)
return

GuiClose:
Run, %COMSPEC% /c "taskkill /im AHK.exe",,Hide UseErrorLevel
exitapp
return

Reload:
Gui,Submit,NoHide
GuiControl,Disabled,Reload
gosub executeMake
Run, AHK.exe execute.ahk,%A_ScriptDir%,Hide UseErrorLevel
SB_SetText("설정 적용 완료")
GuiControl,Enabled,Reload
return


executeMake:
string:=""
list:=[]
Loop, Read, automatic msg.txt
{
	if (SubStr(A_LoopReadLine,1,1)="#") or A_LoopReadLine=""
		Continue
	a:=A_Index
	RegExMatch(A_LoopReadLine,"""(.*?)"" (\w+) (.*)",s)
	if list.HasKey(s1)
		continue
	list.Push(s1)
	sep:=(s2="sep")?"":"*"
	if s2="alert"
		AutoChange:=0
	if !AutoChange
		string:=string "`n"+":"sep "?b0C:"한글_영어(한글분해(s1)) "::`n"
				. "Send_WM_COPYDATA("""1 """,""우리말 지킴이"")`n"
				. "sleep 80`n"
				; . "대기:=대기+1`n"
				; . "if 대기=1`n{`n"
				. "script("""s1 ""","""s3  """)`nSoundBeep 750 250`n"
				; . "대기:=대기-1`n
				. "return"
		; string:=string "`n"+":?b0:"한글_영어(한글분해(s1)) "::{bs " 한글길이(s1) "}"s3
		; string:=string "`n"+":?b0:"한글_영어(한글분해(s1)) "::`nSendInput {bs " 한글길이_(s1) "}"s3 "`nscript("""s1 ""","""s3  """)`nreturn"
	; :*?b0:~~::
	if AutoChange
		string:=string "`n"+":"sep "?b0C:"한글_영어(한글분해(s1)) "::`n"
				. "Send_WM_COPYDATA("""1 """,""우리말 지킴이"")`n"
				. "sleep 80`n"
				. "SendInput {bs " 한글길이(s1) "}"s3 "`n"
				; . "대기:=대기+1`n"
				; . "if 대기=1`n{`n"
				. "script("""s1 ""","""s3  """)`n"
				; . "대기:=대기-1`n
				. "return"
		; string:=string "`n"+":*?b0:"한글_영어(한글분해(s1)) "::{bs " 한글길이(s1) "}"s3
		; string:=string "`n"+":*?b0:"한글_영어(한글분해(s1)) "::`nSendInput {bs " 한글길이_(s1) "}"s3 "`nscript("""s1 ""","""s3  """)`nreturn"
}

FileDelete, execute.ahk
FileAppend,
(
#SingleInstance,Force
#Persistent
#NoEnv
#InstallKeybdHook
#installmousehook
#winactivateforce
#KeyHistory 0
#NoTrayIcon
ListLines, Off
SendMode Input
SetWorkingDir %A_ScriptDir%
SetControlDelay, -1
SetKeyDelay, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0 
SetWinDelay, -1
SetBatchLines -1
Process, Priority,, High
SetTitleMatchMode, 3
FileEncoding,UTF-8
StringCaseSense, On
DetectHiddenWindows, On

#If, ! GetKeyState("CapsLock","T")
%string%
return

script(s1:="",s3:="")
{
	ToolTip, `%s1`%->`%s3`%
	SetTimer,RemoveTooltip,3000
	FileAppend,`%A_Now`% `%s1`%->`%s3`%``n,순화 기록.txt
}
RemoveTooltip:
SetTimer,RemoveTooltip,Off
ToolTip
return

Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle)
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize) 
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize) 
    TimeOutTime = 2000
    SendMessage, 0x4a, 0, &CopyDataStruct,, `%TargetScriptTitle`%,,,, `%TimeOutTime`%
    return ErrorLevel
}
),execute.ahk
return


한글길이_(입력)
{
	return (StrLen(입력))
}
한글길이(입력)
{
	len:=StrLen(입력)
	a:=StrLen(한글분해(SubStr(입력,0)))
	return len+a-1
}

한글_영어(입력)
{
	static arrJongSungEng := ["","r","R","rt"
		,"s","sw","sg","e","f","fr","fa","fq"
		,"ft","fx","fv","fg","a","q","qt","t"
		,"T","Q","W","E","d","w","c","z","x","v","g"]
	static 종성:=["","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ"
		,"ㄹ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ"
		,"ㅁ","ㅂ","ㅄ","ㅅ","ㅆ","ㅃ","ㅉ","ㄸ","ㅇ","ㅈ","ㅊ"
		,"ㅋ","ㅌ","ㅍ","ㅎ"]
	static arrJungSungEng := ["k","o","i","O"
		,"j","p","u","P","h","hk","ho","hl"
		,"y","n","nj","np","nl","b","m","ml"
		,"l"]
	static 중성:=["ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ"
		,"ㅕ","ㅖ","ㅗ","ㅘ","ㅙ","ㅚ"
		,"ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ"
		,"ㅡ","ㅢ","ㅣ"]
	str:=""
	Loop, Parse, 입력
	{
		str:=str arrJongSungEng[isElement(종성,A_LoopField)] arrJungSungEng[isElement(중성,A_LoopField)]
	}
	return str
}



isElement(obj,ele)
{
for i,e in obj
	if IsObject(e)&&IsObject(ele)
	{
		return=0
		loop % e.MaxIndex()
			if e[A_Index]=ele[A_Index]
				return++
		if return=% e.MaxIndex()
			return i
	}
	else if e=%ele%
		return i
return false
}

한글분해(입력)
{
	static 초성:=["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ"
			,"ㅅ","ㅆ","ㅇ" ,"ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
	static 중성:=["ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ"
			,"ㅕ","ㅖ","ㅗ","ㅘ","ㅙ","ㅚ"
			,"ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ"
			,"ㅡ","ㅢ","ㅣ"]
	static 종성:=["","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ"
			,"ㄹ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ"
			,"ㅁ","ㅂ","ㅄ","ㅅ","ㅆ","ㅇ","ㅈ","ㅊ"
			,"ㅋ","ㅌ","ㅍ","ㅎ"]
	글자:={}
	Loop,Parse,입력
		글자.push(A_LoopField)
	for i,e in 글자
	{
		b:=Asc(e)-44032
		if (b>11172)||(b<0)
		{
			b+=44032
			result.=Chr(b) A_Space
			Continue
		}
		;유니코드 한글 조합 = 초성*588 + 중성*28 + 종성 + 0xAC00<-가 ,한글시작위치
		c1 := b / (21 * 28)
		c2 := Mod(b,21 * 28) / 28
		c3 := Mod(Mod(b,21 * 28),28)
		toInt(c1),toInt(c2),toInt(c3)
		loop 3
			c%A_INDEX%:=c%A_INDEX%+1
		result.=초성[c1] 중성[c2] 종성[c3]
	}
	return result
}
toInt(ByRef i)
{
	return i:=RegExReplace(i,"\.(\d+)")
}

