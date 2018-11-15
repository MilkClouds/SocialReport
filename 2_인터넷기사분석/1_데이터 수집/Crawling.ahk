#SingleInstance, off
#Persistent
#Noenv
#KeyHistory 0
#InstallKeybdHook
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
FileEncoding, UTF-8
SetTitleMatchMode, 2
OnExit("GuiClose")

FileCreateDir, testdata

IniRead,AgentList,agents.ini,agents
Agents:=StrSplit(StrReplace(AgentList,"=실행중"),"`n")
Agents:=Agents.Length()?Agents:[0], AG:={}
for i,e in Agents
	AG[e]:=i

temp:=0
while ++temp
	if !AG.HasKey(temp)
	{
		ThisAgent:=temp
		IniWrite,실행중,agents.ini,agents,% temp
		break
	}

OutDebug("Agent Launched - No.",ThisAgent)

; WinHttpFunc()
; WinHttp.SetProxy(2,"localhost:8888")

url:="https://news.joins.com/article/"
chunk:=500

IniRead, num, agents.ini, num, % ThisAgent, 0
if num=0
	IniRead, num, agents.ini, num, 1, 0
	num:=num-(ThisAgent-1)*chunk
	; GuiClose()

while num--
{
	res:=WinHttpFunc(url . num)
	; if !InStr(res,"<meta property=""article:section"" content=""라이프"" />")
		; continue
	NotExist:=1
	if found:=!InStr(res, "<div class=""error"">")
	; if found:=(!InStr(res, "<div class=""error"">")) && InStr(res,"|라이프")
		if NotExist:=!FileExist("testdata\"num ".html")
			FileAppend,% res,testdata\%num%.html
	OutDebug("Downloaded:",num,(found?"(valid)":""),(NotExist?"":"(EXIST)"))
	if A_Index>=%chunk%
	; if A_Index=1
		break
}

goto GuiClose

GuiClose:
GuiClose()
Exitapp

GuiClose() {
	global ThisAgent
	IniDelete,agents.ini,agents,% ThisAgent
	ExitApp
}

OutDebug(r*) {
	global ThisAgent
	aa:="[" ThisAgent "] "
	for i,e in r
		aa.=e " "
	msg:=substr(aa,1,-1)
	OutputDebug, % msg
	return 1
}