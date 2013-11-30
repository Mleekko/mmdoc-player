#include <Color.au3>
#include <Array.au3>

HotKeySet("^!{F10}", "Terminate")
HotKeySet("^!{F6}", "Startit")
HotKeySet("^!{F7}", "SkipDeckConfirm")
HotKeySet("^!{F8}", "FindFreeSpot")


Func Terminate()
    Exit 0
 EndFunc   ;==>Terminate
 

Global $COLOR_DIFF = 10


Global $BTN_START_FIGHT[2] = [1075, 664]
Global $BTN_DECK_OK[2] = [292, 431]
Global $BTN_DECK_OK_ENABLED = 0x376266


Global $BTN_END_TURN[2] = [700, 100]
Global $BTN_END_TURN_ENABLED = 0xBA3918

Global $BTN_END_GAME[2] = [1054, 550]
Global $BTN_END_GAME_ENABLED = 0x10282E


Global $HERO[2] = [400, 400]
; POW, MAGIC, FORTUNE
Global $HERO_STATS_DEFAULT[3] = [2, 0, 1]; Inferno
;Global $HERO_STATS_DEFAULT[3] = [2, 1, 1]; Necro
Global $DESIRED_STATS[3] = [6, 1, 1]; Inferno
Global $HERO_STATS[3] = [0, 0, 0]


Global $BTN_ADD_POW[2] = [400, 240]
Global $BTN_ADD_MAG[2] = [400, 280]
Global $BTN_ADD_FOR[2] = [400, 320]
Global $BTN_TAKE_CARD[2] = [400, 360]

Global $BTN_ADD_STAT[3] = [ $BTN_ADD_POW, $BTN_ADD_MAG, $BTN_ADD_FOR ]
Global $STATS_STEPS[4] = [0, 1, 0, 1] 
Global $STATS_STEPS_SIZE = 4
Global $STATS_STEPS_CURRENT = 0

; 4 rows, 2 lines, x coord + y coord, color
;Wild cat deck -  Global $TROOP_SPOT[4][2][3] = [ [  [555, 283, 0x9BFB54], [664, 282, 0x407F37]  ], [  [549, 382, 0x73FB54], [662, 382, 0x5FF159]  ], [  [543, 489, 0x53C949], [661, 489, 0x5ED55A]  ], [  [537, 606, 0x57D651], [658, 606, 0x54D84F]  ] ]
Global $TROOP_SPOT[4][2][3] = [ [  [555, 283, 0x5BE956], [664, 282, 0x3C7E3C]  ], [  [549, 382, 0x54E94D], [662, 382, 0x59EB52]  ], [  [543, 489, 0x4FC74A], [661, 489, 0x50C74C]  ], [  [537, 606, 0x65E760], [658, 606, 0x56DA51]  ] ]
Global $TROOP_SPOT_ALT[4][2][3] = [ [  [555, 283, 0x5BE956], [664, 282, 0x3C7E3C]  ], [  [549, 382, 0x54E94D], [662, 382, 0x59EB52]  ], [  [543, 489, 0x4FC74A], [661, 489, 0x50C74C]  ], [  [537, 606, 0x4ED048], [658, 606, 0x56DA51]  ] ]

; 4 rows, 2 lines, x coord + y coord
Global $ENEMY[4][2][2] = [ [  [885, 246], [987, 248]  ], [  [885, 336], [1000, 340]  ], [  [895, 440], [1000, 440]  ], [  [900, 550], [1010, 560]  ] ]
Global $ENEMY_HERO[2] = [1200, 400]



Global $BTN_CLOSE_ACTION[2] = [486, 169]


Global $BTN_GOT_LEVEL[2] = [864, 620]
Global $BTN_GOT_LEVEL_ENABLED = 0x3F9DB5

Global $BTN_DAYLY_REWARD[2] = [979, 707]
Global $BTN_DAYLY_REWARD_ENABLED = 0x182808


Global $GREEN_CARD_OUTLINE = 0x4DDA45 ; For grey BG
;Global $GREEN_CARD_OUTLINE = 0x89F746 ; Works as DEFAULT
;Global $GREEN_CARD_OUTLINE = 0xAEFB1F  ; Inferno
Global $GREEN_CARD_OUTLINE2 = 0x33CC28
Global $GREEN_FOR_ATTACK = 0x43A640

Global $DROP_CARD_BAR[3] = [486, 162, 0x181B18]
Global $DROP_POS_1[2] = [360, 350]
Global $DROP_POS_2[2] = [465, 350]

; -1
Global $UNIT_ORDER[8][2] = [ [1, 1], [2, 2], [3, 1], [4, 2], [1, 2], [2, 1], [3, 2], [4, 1] ]


Func IsSameColor($first, $second)
   Local $rgb1 = _ColorGetRGB($first)
   Local $rgb2 = _ColorGetRGB($second)
   If (Abs($rgb1[0] - $rgb2[0]) < $COLOR_DIFF) And (Abs($rgb1[1] - $rgb2[1]) < $COLOR_DIFF) And (Abs($rgb1[2] - $rgb2[2]) < $COLOR_DIFF) Then
        Return 1
   Else
        Return 0
   EndIf
EndFunc

Func DoClick( ByRef $pos)
   Sleep(200)
   MouseMove($pos[0], $pos[1], 15)
   Sleep(300)
   
   MouseDown ( "left" )
   Sleep(200)
   MouseUp("left")
   
   Sleep(200)
EndFunc

Func ClickQuick( ByRef $pos)
   Sleep(50)
   MouseMove($pos[0], $pos[1], 7)
   Sleep(100)
   
   MouseDown ( "left" )
   Sleep(100)
   MouseUp("left")
   
   Sleep(100)
EndFunc

;~ Func ClickQuick( ByRef $pos)
;~    Sleep(20)
;~    MouseMove($pos[0], $pos[1], 4)
;~    Sleep(50)
;~    
;~    MouseDown ( "left" )
;~    Sleep(75)
;~    MouseUp("left")
;~    
;~    Sleep(50)
;~ EndFunc

Func Increase($stat) 
   If $HERO_STATS[$stat] < $DESIRED_STATS[$stat] Then
	  DoClick($BTN_ADD_STAT[$stat])
	  $HERO_STATS[$stat] = $HERO_STATS[$stat] + 1
	  ConsoleWrite ( "Increased " & $stat & " Cur: " & _ArrayToString($HERO_STATS, ",") & @CRLF)
	  Return 1
   EndIf
   
   Return 0
EndFunc



Func UseHero()
   DoClick($HERO)
   
   Local $didIt = 0
   
   If $STATS_STEPS_CURRENT < $STATS_STEPS_SIZE Then ; try to increase stats in predefined order
	  $didIt = Increase($STATS_STEPS[$STATS_STEPS_CURRENT])
	  $STATS_STEPS_CURRENT = $STATS_STEPS_CURRENT + 1
   EndIf
   ; If the order is finished, or the stat is already at required level - do the usual way - go through stats starting from POW
   
   If $didIt Then
	  ; We did the step
   ElseIf Increase(0) Then
	  ; POW++
   ElseIf Increase(1) Then
	  ; MAGIC++
   ElseIf Increase(2) Then 
	  ; FORTUNE++
   Else
	  DoClick($BTN_TAKE_CARD)
	  ClickQuick($BTN_ADD_POW)
   EndIf
  
EndFunc

Func FindFreeSpot()
   
   For $k = 0 To 7
	  Local $i = $UNIT_ORDER[$k][0] - 1
	  Local $j = $UNIT_ORDER[$k][1] - 1
      Local $newCoords[2] = [$TROOP_SPOT[$i][$j][0], $TROOP_SPOT[$i][$j][1] - 30]
	  
	  $coll = PixelGetColor($TROOP_SPOT[$i][$j][0], $TROOP_SPOT[$i][$j][1])
	  ConsoleWrite ( "Color at TROOP_SPOT[" & $i & "][" & $j & "] = " & Hex($coll) & @CRLF)

	  ConsoleWrite ( "Match? " & IsSameColor($coll, $TROOP_SPOT[$i][$j][2]) & @CRLF)

	  Local $greenOutline = PixelSearch($TROOP_SPOT[$i][$j][0] - 3, $TROOP_SPOT[$i][$j][1] - 3 , $TROOP_SPOT[$i][$j][0] + 3, $TROOP_SPOT[$i][$j][1] + 3, $TROOP_SPOT[$i][$j][2], 20)
	  
	  If Not @error Then
		 ConsoleWrite ( "Match!!! " & @CRLF)

		 
		 Return $newCoords
	  ElseIf Not $TROOP_SPOT[$i][$j][2] = $TROOP_SPOT_ALT[$i][$j][2] Then
		 ConsoleWrite ( "Alternative $TROOP_SPOT search @" & $i & "," & $j & @CRLF)
		 
		 $greenOutline = PixelSearch($TROOP_SPOT_ALT[$i][$j][0] - 3, $TROOP_SPOT_ALT[$i][$j][1] - 3 , $TROOP_SPOT_ALT[$i][$j][0] + 3, $TROOP_SPOT_ALT[$i][$j][1] + 3, $TROOP_SPOT_ALT[$i][$j][2], 20)
		 
		 If Not @error Then
			ConsoleWrite ( "Alternative Match!!! " & @CRLF)
		
			Return $newCoords
	     EndIf
	  EndIf
   Next
 	
	Local $zero[2] = [0, 0]
	Return $zero;
   
EndFunc


Func PlaceTroop()
   Local $greenOutline = PixelSearch(485, 596, 26, 587, $GREEN_CARD_OUTLINE, 55)
  ; Local $greenOutline = PixelSearch(26, 753, 485, 755, $GREEN_CARD_OUTLINE, 55) ; Trying for Inferno
   
   If @error Then
	  ConsoleWrite ( "Looking for $GREEN_CARD_OUTLINE2" & @CRLF)
	  $greenOutline = PixelSearch(485, 596, 26, 587, $GREEN_CARD_OUTLINE2, 55)
	 ; $greenOutline = PixelSearch(26, 753, 485, 755, $GREEN_CARD_OUTLINE2, 55)
   EndIf
   
   
   If Not @error Then
	  ConsoleWrite ( "Found green at " & $greenOutline[0] & ", " & $greenOutline[1] )
	  Local $newCoords[2] = [$greenOutline[0] - 5, $greenOutline[1] + 50]
	  ;Local $newCoords[2] = [$greenOutline[0] - 5, $greenOutline[1] - 50]
	  DoClick($newCoords)
	  
	  Sleep(1500)
	  
	  Local $free =  FindFreeSpot()
	  
	  If $free[0] = 0 Then
		 DoClick($BTN_CLOSE_ACTION)
		 Sleep(1000)
		 Return 0
	  EndIf
	  
	  DoClick($free)
	  Sleep(2000)
	  ; Drop a card if necessary
	  Local $dropColor = PixelGetColor($DROP_CARD_BAR[0], $DROP_CARD_BAR[1])
	  Local $isDrop = IsSameColor($DROP_CARD_BAR[2], $dropColor)
	  
	  If $isDrop = 1 Then
		 ConsoleWrite ( "DROPPING CARD ONCE" )
		 DoClick($DROP_POS_1)
		 Sleep(1000)
		 
		 ;once more to be sure
		 $dropColor = PixelGetColor($DROP_CARD_BAR[0], $DROP_CARD_BAR[1])
		 $isDrop = IsSameColor($DROP_CARD_BAR[2], $dropColor)
		 If $isDrop = 1 Then
			DoClick($DROP_POS_2)
			Sleep(1000)
		 EndIf
		 
		 Return 0
	  EndIf
	  
	  Return 1
	EndIf
	
	Return 0
EndFunc

Func PlaceTroops()
   While PlaceTroop()
   WEnd
EndFunc

Func Att($rowNum)
 
   Local $rear[2] = [$ENEMY[$rowNum][1][0], $ENEMY[$rowNum][1][1]]
   Local $front[2] = [$ENEMY[$rowNum][0][0], $ENEMY[$rowNum][0][1]]
   
   ; Two times to make sure click happened
   
;~    ClickQuick($ENEMY_HERO)
;~    ClickQuick($front)
;~    ClickQuick($front)
;~    ClickQuick($rear)

   

   ClickQuick($front)   
   ClickQuick($rear)
   ClickQuick($ENEMY_HERO)

   
EndFunc


Func Attack()

   For $i = 0 To 3
	   For $j = 0 To 1
    	    Local $greenOutline = PixelSearch($TROOP_SPOT[$i][$j][0] - 20, $TROOP_SPOT[$i][$j][1] - 25 , $TROOP_SPOT[$i][$j][0] + 20, $TROOP_SPOT[$i][$j][1], $GREEN_FOR_ATTACK, 30)
			If Not @error Then
			   ConsoleWrite ( "Can attack !!! " & @CRLF)
			   Local $newCoords[2] = [$TROOP_SPOT[$i][$j][0], $TROOP_SPOT[$i][$j][1] - 35]
			   
			   ClickQuick($newCoords)
			   Att($i)
			   ClickQuick($BTN_CLOSE_ACTION)
			EndIf

	   Next
	Next
   
EndFunc

Func IsMyTurn() 
	Local $color = PixelGetColor($BTN_END_TURN[0], $BTN_END_TURN[1])
	Local $myTurn = IsSameColor($BTN_END_TURN_ENABLED, $color)
	
	Return $myTurn
EndFunc
 
 

Func IsGameEnded() 
	Local $color = PixelGetColor($BTN_END_GAME[0], $BTN_END_GAME[1])
	Local $myTurn = IsSameColor($BTN_END_GAME_ENABLED, $color)
	
	Return $myTurn
 EndFunc
 
 Func IsNewLevel() 
	Local $color = PixelGetColor($BTN_GOT_LEVEL[0], $BTN_GOT_LEVEL[1])
	Local $myTurn = IsSameColor($BTN_GOT_LEVEL_ENABLED, $color)
	
	Return $myTurn
 EndFunc
 
  Func IsDaylyPrize() 
	Local $color = PixelGetColor($BTN_DAYLY_REWARD[0], $BTN_DAYLY_REWARD[1])
	Local $myTurn = IsSameColor($BTN_DAYLY_REWARD_ENABLED, $color)
	
	Return $myTurn
 EndFunc
 
Global $SKIP_DECK_ONCE = 0

Func SkipDeckConfirm()
   $SKIP_DECK_ONCE = 1
EndFunc
 
 Func IsConfirmDeck() 
	
	If $SKIP_DECK_ONCE = 1 Then
	  $SKIP_DECK_ONCE = 0
	  Local $input = InputBox("Hello", "Please enter power, magic, fortune", _ArrayToString($HERO_STATS_DEFAULT, ","));
	  Local $stats = StringSplit($input, ",")
	  
	  $HERO_STATS[0] = Number($stats[1])
	  $HERO_STATS[1] = Number($stats[2])
	  $HERO_STATS[2] = Number($stats[3])
	  
	  ConsoleWrite ( "Got $input: " & $input & " became " & _ArrayToString($HERO_STATS, ",") & @CRLF)
	  Return 1
    EndIf
	
	Local $color = PixelGetColor($BTN_DECK_OK[0], $BTN_DECK_OK[1])
	Local $myTurn = IsSameColor($BTN_DECK_OK_ENABLED, $color)
	
	Return $myTurn
EndFunc

 
Func Startit()
   ConsoleWrite ( "Started" & @CRLF)
   While 1
	  Sleep(1000)
	  $STATS_STEPS_CURRENT = 0
	  $HERO_STATS = $HERO_STATS_DEFAULT
		DoClick($BTN_START_FIGHT)
		Sleep(1000)
		DoClick($BTN_START_FIGHT)
			 
	    Sleep(5000)
		
	     Local $gotLevel = IsNewLevel()
		  
		 If $gotLevel = 1 Then
			 DoClick($BTN_GOT_LEVEL)
			 
			 Sleep(5000)
			 
			 ContinueLoop
		  EndIf
		  
		  Local $daily = IsDaylyPrize()
		  
		 If $daily = 1 Then
			 DoClick($BTN_DAYLY_REWARD)
			 
			 Sleep(5000)
			 
			 ContinueLoop
		  EndIf
	  
	   While IsConfirmDeck() = 0
		  ConsoleWrite ( "Waiting for deck OK.." & @CRLF )
		  Sleep (2000)
		  
	      Local $gameEnded3 = IsGameEnded()
		  
		  If $gameEnded3 = 1 Then
			 DoClick($BTN_END_GAME)
			 
			 Sleep(5000)
			 
			 ContinueLoop 2
		  EndIf
	   WEnd
	  
	   DoClick($BTN_DECK_OK)
	   
	   While 1
		  
		  Local $gameEnded = IsGameEnded()
		  
		  If $gameEnded = 1 Then
			 DoClick($BTN_END_GAME)
			 
			 Sleep(5000)
			 
			 ContinueLoop 2
		  EndIf
		  
		  Local $gotLevel2 = IsNewLevel()
		  
		 If $gotLevel2 = 1 Then
			 DoClick($BTN_GOT_LEVEL)
			 
			 Sleep(5000)
			 
			 ContinueLoop 2
		  EndIf
		  

		  
		  Local $myTurn = IsMyTurn()
		  
		  While $myTurn = 0
			    ConsoleWrite ( "Not my turn. Sleeping.." & @CRLF )
			   Sleep(2000)
			   
			   Local $gameEnded2 = IsGameEnded()
	   
				If $gameEnded2 = 1 Then
				   Sleep(5000)
				   ContinueLoop 2
				EndIf
			 
			   
			   $myTurn = IsMyTurn()
		  WEnd
		  Sleep(1000)
		  
		  UseHero()
		  Sleep(1000)
		  PlaceTroops()
		  Sleep(1000)
		  Attack()
		  Sleep(500)
		  PlaceTroops()
		  Sleep(500)
		  ClickQuick($BTN_END_TURN)
		  Sleep(1000)
		  
	   WEnd
   WEnd
	
	
 EndFunc   ;==>Start
 
 WinMove("Might & Magic : Duel of Champions", "", 0, 0)
 ;Size:	1382, 806 - laptop
 ;Size: 1381, 806 - desktop
 
 ;;;; Body of program would go here ;;;;
While 1
    Sleep(100)
WEnd
;;;;;;;;
