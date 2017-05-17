; ------------------------------------------------------
; Lynxmotion Visual Sequencer SSC-32 'Export' Program
; Sequencer SSC-32 project : Robusta
; Date : 16/04/2015 08:02:52
; ------------------------------------------------------
; Format : Basic Atom 24/28 IDE <= V02.2.1.1 or Pro IDE + SSC-32 with GP Sequencer
; Original filename : Robusta.bas
; Communication with SSC-32 : BotBoard V1 => Pin 15
; ------------------------------------------------------

; The associated Robusta.EEP file
; Contains 48 Sequences

SSC32   con p15

pause 500

; Run PLayer 0 on SeQuence 0 with Speed Multiplyer = 100%
; at IndeX 0 (step 0) with a PAuse between index/step = 0 ms
	serout SSC32,i38400,["PL0 SQ0 SM100 IX0 PA0", 13]
