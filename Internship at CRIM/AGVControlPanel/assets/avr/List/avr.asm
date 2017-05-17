
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega2560
;Program type             : Application
;Clock frequency          : 11,059200 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 4096 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega2560
	#pragma AVRPART MEMORY PROG_FLASH 262144
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 8703
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x200

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU RAMPZ=0x3B
	.EQU EIND=0x3C
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x74
	.EQU XMCRB=0x75
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0200
	.EQU __SRAM_END=0x21FF
	.EQU __DSTACK_SIZE=0x1000
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index0=R4
	.DEF _rx_rd_index0=R3
	.DEF _serial0Available=R6
	.DEF _rx_wr_index1=R5
	.DEF _rx_rd_index1=R8
	.DEF _serial1Available=R7
	.DEF _i=R9
	.DEF _count=R11
	.DEF _afterReset=R13

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_ovf_isr
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer4_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x1
_0x4:
	.DB  0x1
_0x5:
	.DB  0x1
_0x6:
	.DB  0xB
_0x7:
	.DB  0x57
_0x8:
	.DB  0x3
_0x9:
	.DB  0x1
_0x4F:
	.DB  0x3C,0x74,0x69,0x74,0x6C,0x65,0x3E,0x41
	.DB  0x47,0x56,0x3C,0x2F,0x74,0x69,0x74,0x6C
	.DB  0x65,0x3E,0x3C,0x68,0x31,0x3E,0x41,0x47
	.DB  0x56,0x20,0x50,0x72,0x6F,0x6A,0x65,0x63
	.DB  0x74,0x3C,0x2F,0x68,0x31,0x3E,0x3C,0x68
	.DB  0x32,0x3E,0x43,0x6C,0x69,0x65,0x6E,0x74
	.DB  0x20,0x23,0x31,0x3C,0x2F,0x68,0x32,0x3E
	.DB  0x3C,0x62,0x75,0x74,0x74,0x6F,0x6E,0x3E
	.DB  0x54,0x65,0x73,0x74,0x20,0x42,0x75,0x74
	.DB  0x74,0x6F,0x6E,0x20,0x31,0x3C,0x2F,0x62
	.DB  0x75,0x74,0x74,0x6F,0x6E,0x3E,0x0
_0x72:
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x2B,0x49,0x50,0x44,0x2C,0x0,0x55,0x50
	.DB  0x44,0x41,0x54,0x45,0x0,0x4F,0x4B,0x0
	.DB  0x41,0x54,0x2B,0x43,0x49,0x50,0x4D,0x55
	.DB  0x58,0x3D,0x31,0xD,0xA,0x0,0x41,0x54
	.DB  0x2B,0x43,0x49,0x50,0x53,0x45,0x52,0x56
	.DB  0x45,0x52,0x3D,0x31,0x2C,0x38,0x30,0xD
	.DB  0xA,0x0,0x4E,0x4F,0x0,0x53,0x54,0x41
	.DB  0x54,0x55,0x53,0x0,0x41,0x54,0x2B,0x43
	.DB  0x49,0x50,0x53,0x54,0x41,0x52,0x54,0x3D
	.DB  0x34,0x2C,0x22,0x54,0x43,0x50,0x22,0x2C
	.DB  0x22,0x31,0x39,0x32,0x2E,0x31,0x36,0x38
	.DB  0x2E,0x30,0x2E,0x32,0x35,0x30,0x22,0x2C
	.DB  0x38,0x30,0xD,0xA,0x0,0x41,0x54,0x2B
	.DB  0x43,0x49,0x50,0x53,0x45,0x4E,0x44,0x3D
	.DB  0x34,0x2C,0x33,0x33,0xD,0xA,0x0,0x47
	.DB  0x45,0x54,0x20,0x2F,0x41,0x47,0x56,0x2F
	.DB  0x73,0x65,0x74,0x41,0x6C,0x6C,0x2F,0x25
	.DB  0x64,0x2F,0x25,0x64,0x2F,0x25,0x64,0x2F
	.DB  0x25,0x64,0x2F,0x25,0x64,0x2F,0x25,0x64
	.DB  0x2F,0x25,0x64,0xD,0xA,0x0,0x52,0x45
	.DB  0x53,0x45,0x54,0x53,0x0,0x41,0x54,0x2B
	.DB  0x52,0x53,0x54,0xD,0xA,0x0,0x74,0x65
	.DB  0x73,0x74,0x0,0x63,0x6D,0x64,0x3D,0x0
	.DB  0x4F,0x46,0x46,0x0,0x4F,0x4E,0x0,0xD
	.DB  0xA,0xA,0x25,0x64,0x20,0x42,0x59,0x54
	.DB  0x45,0x20,0x4F,0x46,0x20,0x44,0x41,0x54
	.DB  0x41,0x20,0x46,0x52,0x4F,0x4D,0x20,0x43
	.DB  0x48,0x41,0x4E,0x4E,0x45,0x4C,0x20,0x25
	.DB  0x64,0xD,0xA,0x0,0xD,0xA,0x2F,0x2A
	.DB  0x2A,0x2A,0x42,0x45,0x47,0x49,0x4E,0x4E
	.DB  0x49,0x4E,0x47,0x20,0x4F,0x46,0x20,0x54
	.DB  0x48,0x45,0x20,0x44,0x41,0x54,0x41,0x2A
	.DB  0x2A,0x2A,0x2F,0xD,0xA,0x0,0xD,0xA
	.DB  0x2F,0x2A,0x2A,0x2A,0x45,0x4E,0x44,0x20
	.DB  0x4F,0x46,0x20,0x54,0x48,0x45,0x20,0x44
	.DB  0x41,0x54,0x41,0x2A,0x2A,0x2A,0x2F,0xD
	.DB  0xA,0x0,0x41,0x54,0x2B,0x43,0x49,0x50
	.DB  0x53,0x45,0x4E,0x44,0x3D,0x25,0x64,0x2C
	.DB  0x25,0x64,0xD,0xA,0x0,0x25,0x73,0xD
	.DB  0xA,0x0,0x41,0x54,0x2B,0x43,0x49,0x50
	.DB  0x43,0x4C,0x4F,0x53,0x45,0x3D,0x25,0x64
	.DB  0xD,0xA,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _connected
	.DW  _0x4*2

	.DW  0x01
	.DW  _motor
	.DW  _0x5*2

	.DW  0x01
	.DW  _signals
	.DW  _0x6*2

	.DW  0x01
	.DW  _battery
	.DW  _0x7*2

	.DW  0x01
	.DW  _position
	.DW  _0x8*2

	.DW  0x01
	.DW  _usartOutput
	.DW  _0x9*2

	.DW  0x06
	.DW  _0x30
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x30+6
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x5A
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x5A+6
	.DW  _0x0*2

	.DW  0x05
	.DW  _0x5A+12
	.DW  _0x0*2+179

	.DW  0x05
	.DW  _0x5A+17
	.DW  _0x0*2+179

	.DW  0x04
	.DW  0x0B
	.DW  _0x72*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRA,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

	OUT  EIND,R24

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x1200

	.CSEG
;/*****************************************************
;Project : AGV Project - ESP8266
;Version : 1.0
;Date    : 07/07/2015
;Author  : Rafi Kurnia Putra
;Company : Universitas Indonesia
;Comments: + Filter data
;          + USART0(esp8266) and USART1(debug) are usable
;          + Timer to Interrupt Routine
;
;Chip type               : ATmega2560
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 4096
;*****************************************************/
;
;#include <mega2560.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <stdio.h>
;#include <stdbool.h>
;#include <stdlib.h>
;#include <string.h>
;#include <alcd.h>
;#include <delay.h>
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;//Untuk menggunakan printf untuk lebih dari 1 usart
;#define _ALTERNATE_PUTCHAR_
;#define CUSTOM_BUFFER_SIZE 2048     //ukuran buffer untuk tampung data sebelum diproses
;#define USART0 0
;#define USART1 1
;
;#define IPADDR 192.168.0.250
;
;// USART0 Receiver buffer -> sedikit modifikasi nama variable
;#define RX_BUFFER_SIZE0 32
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0,rx_rd_index0,serial0Available;
;#else
;unsigned int rx_wr_index0,rx_rd_index0,serial0Available;
;#endif
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;// USART1 Receiver buffer
;#define RX_BUFFER_SIZE1 32
;#if RX_BUFFER_SIZE1 <= 256
;unsigned char rx_wr_index1,rx_rd_index1,serial1Available;
;#else
;unsigned int rx_wr_index1,rx_rd_index1,serial1Available;
;#endif
;char rx_buffer1[RX_BUFFER_SIZE1];
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// This flag is set on USART1 Receiver buffer overflow
;bit rx_buffer_overflow1;
;
;// Global Variables
;int i,count=0,afterReset=0;
;
;// Status Attributes
;const int id=1;

	.DSEG
;bool connected=1;
;bool motor=1;
;int signals=11;
;int battery=87;
;int position=3;
;bool obstacle=0;
;
;//variable untuk menentukan output usart yang akan dituju
;//harus diubah setiap mengganti output
;unsigned char usartOutput = USART1;
;bool busy = false;
;bool setting = false;
;
;void toggleLed();
;void updateConnection();
;void sendStatus();
;void resetModule();
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 0076 {

	.CSEG
_usart0_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0077     char status,data;
; 0000 0078     status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 0079     data=UDR0;
	LDS  R16,198
; 0000 007A     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0xA
; 0000 007B     {
; 0000 007C         rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 007D         #if RX_BUFFER_SIZE0 == 256
; 0000 007E         // special case for receiver buffer size=256
; 0000 007F         if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 0080         #else
; 0000 0081         if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(32)
	CP   R30,R4
	BRNE _0xB
	CLR  R4
; 0000 0082         if (++serial0Available == RX_BUFFER_SIZE0)
_0xB:
	INC  R6
	LDI  R30,LOW(32)
	CP   R30,R6
	BRNE _0xC
; 0000 0083         {
; 0000 0084             serial0Available=0;
	CLR  R6
; 0000 0085             rx_buffer_overflow0=1;
	SBI  0x1E,0
; 0000 0086         }
; 0000 0087         #endif
; 0000 0088     }
_0xC:
; 0000 0089 }
_0xA:
	RJMP _0x71
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0090 {
_getchar:
; 0000 0091     char data;
; 0000 0092     while (serial0Available==0);
	ST   -Y,R17
;	data -> R17
_0xF:
	TST  R6
	BREQ _0xF
; 0000 0093     data=rx_buffer0[rx_rd_index0++];
	MOV  R30,R3
	INC  R3
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 0094     #if RX_BUFFER_SIZE0 != 256
; 0000 0095     if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDI  R30,LOW(32)
	CP   R30,R3
	BRNE _0x12
	CLR  R3
; 0000 0096     #endif
; 0000 0097     #asm("cli")
_0x12:
	cli
; 0000 0098     --serial0Available;
	DEC  R6
; 0000 0099     #asm("sei")
	sei
; 0000 009A     return data;
	MOV  R30,R17
	RJMP _0x20C0005
; 0000 009B }
;#pragma used-
;#endif
;
;//Putchar custom, untuk diintegrasikan dengan printf
;void putchar(char c)
; 0000 00A1 {
_putchar:
; 0000 00A2     switch (usartOutput)
	ST   -Y,R26
;	c -> Y+0
	LDS  R30,_usartOutput
	LDI  R31,0
; 0000 00A3     {
; 0000 00A4         case USART0: // the output will be directed to USART0
	SBIW R30,0
	BRNE _0x16
; 0000 00A5             while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
_0x17:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x17
; 0000 00A6             UDR0=c;
	LD   R30,Y
	STS  198,R30
; 0000 00A7             break;
	RJMP _0x15
; 0000 00A8 
; 0000 00A9         case USART1: // the output will be directed to USART1
_0x16:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x15
; 0000 00AA             while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
_0x1B:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x1B
; 0000 00AB             UDR1=c;
	LD   R30,Y
	STS  206,R30
; 0000 00AC             break;
; 0000 00AD     }
_0x15:
; 0000 00AE }
	RJMP _0x20C0006
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 00B2 {
_usart1_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00B3     char status,data;
; 0000 00B4     status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,200
; 0000 00B5     data=UDR1;
	LDS  R16,206
; 0000 00B6     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x1E
; 0000 00B7     {
; 0000 00B8         rx_buffer1[rx_wr_index1++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 00B9         #if RX_BUFFER_SIZE1 == 256
; 0000 00BA         // special case for receiver buffer size=256
; 0000 00BB         if (++rx_counter1 == 0) rx_buffer_overflow1=1;
; 0000 00BC         #else
; 0000 00BD         if (rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
	LDI  R30,LOW(32)
	CP   R30,R5
	BRNE _0x1F
	CLR  R5
; 0000 00BE         if (++serial1Available == RX_BUFFER_SIZE1)
_0x1F:
	INC  R7
	LDI  R30,LOW(32)
	CP   R30,R7
	BRNE _0x20
; 0000 00BF         {
; 0000 00C0             serial1Available=0;
	CLR  R7
; 0000 00C1             rx_buffer_overflow1=1;
	SBI  0x1E,1
; 0000 00C2         }
; 0000 00C3         #endif
; 0000 00C4     }
_0x20:
; 0000 00C5 }
_0x1E:
_0x71:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;// Get a character from the USART1 Receiver buffer
;#pragma used+
;char getchar1(void)
; 0000 00CA {
_getchar1:
; 0000 00CB     char data;
; 0000 00CC     while (serial1Available==0);
	ST   -Y,R17
;	data -> R17
_0x23:
	TST  R7
	BREQ _0x23
; 0000 00CD     data=rx_buffer1[rx_rd_index1++];
	MOV  R30,R8
	INC  R8
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	LD   R17,Z
; 0000 00CE     #if RX_BUFFER_SIZE1 != 256
; 0000 00CF     if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
	LDI  R30,LOW(32)
	CP   R30,R8
	BRNE _0x26
	CLR  R8
; 0000 00D0     #endif
; 0000 00D1     #asm("cli")
_0x26:
	cli
; 0000 00D2     --serial1Available;
	DEC  R7
; 0000 00D3     #asm("sei")
	sei
; 0000 00D4     return data;
	MOV  R30,R17
	RJMP _0x20C0005
; 0000 00D5 }
;#pragma used-
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 00DB {
_putchar1:
; 0000 00DC     while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
	ST   -Y,R26
;	c -> Y+0
_0x27:
	LDS  R30,200
	ANDI R30,LOW(0x20)
	BREQ _0x27
; 0000 00DD     UDR1=c;
	LD   R30,Y
	STS  206,R30
; 0000 00DE }
_0x20C0006:
	ADIW R28,1
	RET
;#pragma used-
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 00E3 {
_timer1_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00E4     // Reinitialize Timer1 value
; 0000 00E5     TCNT1H=0xABA1 >> 8;
	LDI  R30,LOW(171)
	STS  133,R30
; 0000 00E6     TCNT1L=0xABA1 & 0xff;
	LDI  R30,LOW(161)
	STS  132,R30
; 0000 00E7     //timer untuk counting jeda waktu setelah data diterima sebelum diproses
; 0000 00E8 
; 0000 00E9     afterReset++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 13,14,30,31
; 0000 00EA 
; 0000 00EB     if (afterReset>10) resetModule();
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R13
	CPC  R31,R14
	BRGE _0x2A
	RCALL _resetModule
; 0000 00EC 
; 0000 00ED     toggleLed();
_0x2A:
	RCALL _toggleLed
; 0000 00EE     updateConnection();
	RCALL _updateConnection
; 0000 00EF 
; 0000 00F0 
; 0000 00F1 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Timer3 overflow interrupt service routine
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0000 00F5 {
_timer3_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00F6     // Reinitialize Timer3 value
; 0000 00F7     TCNT3H=0x2D0F >> 8;
	LDI  R30,LOW(45)
	STS  149,R30
; 0000 00F8     TCNT3L=0x2D0F & 0xff;
	LDI  R30,LOW(15)
	STS  148,R30
; 0000 00F9 
; 0000 00FA 
; 0000 00FB     sendStatus();
	RCALL _sendStatus
; 0000 00FC }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Timer4 overflow interrupt service routine
;interrupt [TIM4_OVF] void timer4_ovf_isr(void)
; 0000 0100 {
_timer4_ovf_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0101     // Reinitialize Timer4 value
; 0000 0102     TCNT3H=0xDDDD >> 8;
	LDI  R30,LOW(221)
	STS  149,R30
; 0000 0103     TCNT3L=0xDDDD & 0xff;
	STS  148,R30
; 0000 0104 
; 0000 0105     count++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
; 0000 0106 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;void initAll()
; 0000 0109 {
_initAll:
; 0000 010A     // Crystal Oscillator division factor: 1
; 0000 010B     #pragma optsize-
; 0000 010C     CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 010D     CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 010E     #ifdef _OPTIMIZE_SIZE_
; 0000 010F     #pragma optsize+
; 0000 0110     #endif
; 0000 0111 
; 0000 0112     // Input/Output Ports initialization
; 0000 0113     // Port A initialization
; 0000 0114     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0115     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0116     PORTA=0x00;
	OUT  0x2,R30
; 0000 0117     DDRA=0x00;
	OUT  0x1,R30
; 0000 0118 
; 0000 0119     // Port B initialization
; 0000 011A     // Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 011B     // State7=0 State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 011C     PORTB=0x00;
	OUT  0x5,R30
; 0000 011D     DDRB=0x80;
	LDI  R30,LOW(128)
	OUT  0x4,R30
; 0000 011E 
; 0000 011F     // Port C initialization
; 0000 0120     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0121     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0122     PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0123     DDRC=0x00;
	OUT  0x7,R30
; 0000 0124 
; 0000 0125     // Port D initialization
; 0000 0126     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0127     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0128     PORTD=0x00;
	OUT  0xB,R30
; 0000 0129     DDRD=0x00;
	OUT  0xA,R30
; 0000 012A 
; 0000 012B     // Port E initialization
; 0000 012C     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 012D     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 012E     PORTE=0x00;
	OUT  0xE,R30
; 0000 012F     DDRE=0x00;
	OUT  0xD,R30
; 0000 0130 
; 0000 0131     // Port F initialization
; 0000 0132     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0133     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0134     PORTF=0x00;
	OUT  0x11,R30
; 0000 0135     DDRF=0x00;
	OUT  0x10,R30
; 0000 0136 
; 0000 0137     // Port G initialization
; 0000 0138     // Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0139     // State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 013A     PORTG=0x00;
	OUT  0x14,R30
; 0000 013B     DDRG=0x00;
	OUT  0x13,R30
; 0000 013C 
; 0000 013D     // Port H initialization
; 0000 013E     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 013F     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0140     PORTH=0x00;
	STS  258,R30
; 0000 0141     DDRH=0x00;
	STS  257,R30
; 0000 0142 
; 0000 0143     // Port J initialization
; 0000 0144     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0145     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0146     PORTJ=0x00;
	STS  261,R30
; 0000 0147     DDRJ=0x00;
	STS  260,R30
; 0000 0148 
; 0000 0149     // Port K initialization
; 0000 014A     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 014B     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 014C     PORTK=0x00;
	STS  264,R30
; 0000 014D     DDRK=0x00;
	STS  263,R30
; 0000 014E 
; 0000 014F     // Port L initialization
; 0000 0150     // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0151     // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0152     PORTL=0x00;
	STS  267,R30
; 0000 0153     DDRL=0xFF;
	LDI  R30,LOW(255)
	STS  266,R30
; 0000 0154 
; 0000 0155     // Timer/Counter 0 initialization
; 0000 0156     // Clock source: System Clock
; 0000 0157     // Clock value: Timer 0 Stopped
; 0000 0158     // Mode: Normal top=0xFF
; 0000 0159     // OC0A output: Disconnected
; 0000 015A     // OC0B output: Disconnected
; 0000 015B     TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 015C     TCCR0B=0x00;
	OUT  0x25,R30
; 0000 015D     TCNT0=0x00;
	OUT  0x26,R30
; 0000 015E     OCR0A=0x00;
	OUT  0x27,R30
; 0000 015F     OCR0B=0x00;
	OUT  0x28,R30
; 0000 0160 
; 0000 0161    // Timer/Counter 1 initialization
; 0000 0162     // Clock source: System Clock
; 0000 0163     // Clock value: 10,800 kHz
; 0000 0164     // Mode: Normal top=0xFFFF
; 0000 0165     // OC1A output: Discon.
; 0000 0166     // OC1B output: Discon.
; 0000 0167     // OC1C output: Discon.
; 0000 0168     // Noise Canceler: Off
; 0000 0169     // Input Capture on Falling Edge
; 0000 016A     // Timer1 Overflow Interrupt: On
; 0000 016B     // Input Capture Interrupt: Off
; 0000 016C     // Compare A Match Interrupt: Off
; 0000 016D     // Compare B Match Interrupt: Off
; 0000 016E     // Compare C Match Interrupt: Off
; 0000 016F     TCCR1A=0x00;
	STS  128,R30
; 0000 0170     TCCR1B=0x05;
	LDI  R30,LOW(5)
	STS  129,R30
; 0000 0171     TCNT1H=0xAB;
	LDI  R30,LOW(171)
	STS  133,R30
; 0000 0172     TCNT1L=0xA1;
	LDI  R30,LOW(161)
	STS  132,R30
; 0000 0173     ICR1H=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
; 0000 0174     ICR1L=0x00;
	STS  134,R30
; 0000 0175     OCR1AH=0x00;
	STS  137,R30
; 0000 0176     OCR1AL=0x00;
	STS  136,R30
; 0000 0177     OCR1BH=0x00;
	STS  139,R30
; 0000 0178     OCR1BL=0x00;
	STS  138,R30
; 0000 0179     OCR1CH=0x00;
	STS  141,R30
; 0000 017A     OCR1CL=0x00;
	STS  140,R30
; 0000 017B 
; 0000 017C     // Timer/Counter 2 initialization
; 0000 017D     // Clock source: System Clock
; 0000 017E     // Clock value: Timer2 Stopped
; 0000 017F     // Mode: Normal top=0xFF
; 0000 0180     // OC2A output: Disconnected
; 0000 0181     // OC2B output: Disconnected
; 0000 0182     ASSR=0x00;
	STS  182,R30
; 0000 0183     TCCR2A=0x00;
	STS  176,R30
; 0000 0184     TCCR2B=0x00;
	STS  177,R30
; 0000 0185     TCNT2=0x00;
	STS  178,R30
; 0000 0186     OCR2A=0x00;
	STS  179,R30
; 0000 0187     OCR2B=0x00;
	STS  180,R30
; 0000 0188 
; 0000 0189     // Timer/Counter 3 initialization
; 0000 018A     // Clock source: System Clock
; 0000 018B     // Clock value: 10,800 kHz
; 0000 018C     // Mode: Normal top=0xFFFF
; 0000 018D     // OC3A output: Discon.
; 0000 018E     // OC3B output: Discon.
; 0000 018F     // OC3C output: Discon.
; 0000 0190     // Noise Canceler: Off
; 0000 0191     // Input Capture on Falling Edge
; 0000 0192     // Timer3 Overflow Interrupt: On
; 0000 0193     // Input Capture Interrupt: Off
; 0000 0194     // Compare A Match Interrupt: Off
; 0000 0195     // Compare B Match Interrupt: Off
; 0000 0196     // Compare C Match Interrupt: Off
; 0000 0197     TCCR3A=0x00;
	STS  144,R30
; 0000 0198     TCCR3B=0x05;
	LDI  R30,LOW(5)
	STS  145,R30
; 0000 0199     TCNT3H=0x2D;
	LDI  R30,LOW(45)
	STS  149,R30
; 0000 019A     TCNT3L=0x0F;
	LDI  R30,LOW(15)
	STS  148,R30
; 0000 019B     ICR3H=0x00;
	LDI  R30,LOW(0)
	STS  151,R30
; 0000 019C     ICR3L=0x00;
	STS  150,R30
; 0000 019D     OCR3AH=0x00;
	STS  153,R30
; 0000 019E     OCR3AL=0x00;
	STS  152,R30
; 0000 019F     OCR3BH=0x00;
	STS  155,R30
; 0000 01A0     OCR3BL=0x00;
	STS  154,R30
; 0000 01A1     OCR3CH=0x00;
	STS  157,R30
; 0000 01A2     OCR3CL=0x00;
	STS  156,R30
; 0000 01A3 
; 0000 01A4     // Timer/Counter 4 initialization
; 0000 01A5     // Clock source: System Clock
; 0000 01A6     // Clock value: Timer4 Stopped
; 0000 01A7     // Mode: Normal top=0xFFFF
; 0000 01A8     // OC4A output: Discon.
; 0000 01A9     // OC4B output: Discon.
; 0000 01AA     // OC4C output: Discon.
; 0000 01AB     // Noise Canceler: Off
; 0000 01AC     // Input Capture on Falling Edge
; 0000 01AD     // Timer4 Overflow Interrupt: Off
; 0000 01AE     // Input Capture Interrupt: Off
; 0000 01AF     // Compare A Match Interrupt: Off
; 0000 01B0     // Compare B Match Interrupt: Off
; 0000 01B1     // Compare C Match Interrupt: Off
; 0000 01B2     TCCR4A=0x00;
	STS  160,R30
; 0000 01B3     TCCR4B=0x05;
	LDI  R30,LOW(5)
	STS  161,R30
; 0000 01B4     TCNT4H=0xD2;
	LDI  R30,LOW(210)
	STS  165,R30
; 0000 01B5     TCNT4L=0x3A;
	LDI  R30,LOW(58)
	STS  164,R30
; 0000 01B6     ICR4H=0x00;
	LDI  R30,LOW(0)
	STS  167,R30
; 0000 01B7     ICR4L=0x00;
	STS  166,R30
; 0000 01B8     OCR4AH=0x00;
	STS  169,R30
; 0000 01B9     OCR4AL=0x00;
	STS  168,R30
; 0000 01BA     OCR4BH=0x00;
	STS  171,R30
; 0000 01BB     OCR4BL=0x00;
	STS  170,R30
; 0000 01BC     OCR4CH=0x00;
	STS  173,R30
; 0000 01BD     OCR4CL=0x00;
	STS  172,R30
; 0000 01BE 
; 0000 01BF     // Timer/Counter 5 initialization
; 0000 01C0     // Clock source: System Clock
; 0000 01C1     // Clock value: Timer5 Stopped
; 0000 01C2     // Mode: Normal top=0xFFFF
; 0000 01C3     // OC5A output: Discon.
; 0000 01C4     // OC5B output: Discon.
; 0000 01C5     // OC5C output: Discon.
; 0000 01C6     // Noise Canceler: Off
; 0000 01C7     // Input Capture on Falling Edge
; 0000 01C8     // Timer5 Overflow Interrupt: Off
; 0000 01C9     // Input Capture Interrupt: Off
; 0000 01CA     // Compare A Match Interrupt: Off
; 0000 01CB     // Compare B Match Interrupt: Off
; 0000 01CC     // Compare C Match Interrupt: Off
; 0000 01CD     TCCR5A=0x00;
	STS  288,R30
; 0000 01CE     TCCR5B=0x00;
	STS  289,R30
; 0000 01CF     TCNT5H=0x00;
	STS  293,R30
; 0000 01D0     TCNT5L=0x00;
	STS  292,R30
; 0000 01D1     ICR5H=0x00;
	STS  295,R30
; 0000 01D2     ICR5L=0x00;
	STS  294,R30
; 0000 01D3     OCR5AH=0x00;
	STS  297,R30
; 0000 01D4     OCR5AL=0x00;
	STS  296,R30
; 0000 01D5     OCR5BH=0x00;
	STS  299,R30
; 0000 01D6     OCR5BL=0x00;
	STS  298,R30
; 0000 01D7     OCR5CH=0x00;
	STS  301,R30
; 0000 01D8     OCR5CL=0x00;
	STS  300,R30
; 0000 01D9 
; 0000 01DA     // External Interrupt(s) initialization
; 0000 01DB     // INT0: Off
; 0000 01DC     // INT1: Off
; 0000 01DD     // INT2: Off
; 0000 01DE     // INT3: Off
; 0000 01DF     // INT4: Off
; 0000 01E0     // INT5: Off
; 0000 01E1     // INT6: Off
; 0000 01E2     // INT7: Off
; 0000 01E3     EICRA=0x00;
	STS  105,R30
; 0000 01E4     EICRB=0x00;
	STS  106,R30
; 0000 01E5     EIMSK=0x00;
	OUT  0x1D,R30
; 0000 01E6     // PCINT0 interrupt: Off
; 0000 01E7     // PCINT1 interrupt: Off
; 0000 01E8     // PCINT2 interrupt: Off
; 0000 01E9     // PCINT3 interrupt: Off
; 0000 01EA     // PCINT4 interrupt: Off
; 0000 01EB     // PCINT5 interrupt: Off
; 0000 01EC     // PCINT6 interrupt: Off
; 0000 01ED     // PCINT7 interrupt: Off
; 0000 01EE     // PCINT8 interrupt: Off
; 0000 01EF     // PCINT9 interrupt: Off
; 0000 01F0     // PCINT10 interrupt: Off
; 0000 01F1     // PCINT11 interrupt: Off
; 0000 01F2     // PCINT12 interrupt: Off
; 0000 01F3     // PCINT13 interrupt: Off
; 0000 01F4     // PCINT14 interrupt: Off
; 0000 01F5     // PCINT15 interrupt: Off
; 0000 01F6     // PCINT16 interrupt: Off
; 0000 01F7     // PCINT17 interrupt: Off
; 0000 01F8     // PCINT18 interrupt: Off
; 0000 01F9     // PCINT19 interrupt: Off
; 0000 01FA     // PCINT20 interrupt: Off
; 0000 01FB     // PCINT21 interrupt: Off
; 0000 01FC     // PCINT22 interrupt: Off
; 0000 01FD     // PCINT23 interrupt: Off
; 0000 01FE     PCMSK0=0x00;
	STS  107,R30
; 0000 01FF     PCMSK1=0x00;
	STS  108,R30
; 0000 0200     PCMSK2=0x00;
	STS  109,R30
; 0000 0201     PCICR=0x00;
	STS  104,R30
; 0000 0202 
; 0000 0203     // Timer/Counter 0 Interrupt(s) initialization
; 0000 0204     TIMSK0=0x00;
	STS  110,R30
; 0000 0205 
; 0000 0206     // Timer/Counter 1 Interrupt(s) initialization
; 0000 0207     TIMSK1=0x01;
	LDI  R30,LOW(1)
	STS  111,R30
; 0000 0208 
; 0000 0209     // Timer/Counter 2 Interrupt(s) initialization
; 0000 020A     TIMSK2=0x00;
	LDI  R30,LOW(0)
	STS  112,R30
; 0000 020B 
; 0000 020C     // Timer/Counter 3 Interrupt(s) initialization
; 0000 020D     TIMSK3=0x01;
	LDI  R30,LOW(1)
	STS  113,R30
; 0000 020E 
; 0000 020F     // Timer/Counter 4 Interrupt(s) initialization
; 0000 0210     TIMSK4=0x01;
	STS  114,R30
; 0000 0211 
; 0000 0212     // Timer/Counter 5 Interrupt(s) initialization
; 0000 0213     TIMSK5=0x00;
	LDI  R30,LOW(0)
	STS  115,R30
; 0000 0214 
; 0000 0215     // USART0 initialization
; 0000 0216     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0217     // USART0 Receiver: On
; 0000 0218     // USART0 Transmitter: On
; 0000 0219     // USART0 Mode: Asynchronous
; 0000 021A     // USART0 Baud Rate: 9600
; 0000 021B     UCSR0A=0x00;
	STS  192,R30
; 0000 021C     UCSR0B=0x98;
	LDI  R30,LOW(152)
	STS  193,R30
; 0000 021D     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 021E     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 021F     UBRR0L=0x47;
	LDI  R30,LOW(71)
	STS  196,R30
; 0000 0220 
; 0000 0221     // USART1 initialization
; 0000 0222     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0223     // USART1 Receiver: On
; 0000 0224     // USART1 Transmitter: On
; 0000 0225     // USART1 Mode: Asynchronous
; 0000 0226     // USART1 Baud Rate: 9600
; 0000 0227     UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  200,R30
; 0000 0228     UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  201,R30
; 0000 0229     UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  202,R30
; 0000 022A     UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  205,R30
; 0000 022B     UBRR1L=0x47;
	LDI  R30,LOW(71)
	STS  204,R30
; 0000 022C 
; 0000 022D     // USART2 initialization
; 0000 022E     // USART2 disabled
; 0000 022F     UCSR2B=0x00;
	LDI  R30,LOW(0)
	STS  209,R30
; 0000 0230 
; 0000 0231     // USART3 initialization
; 0000 0232     // USART3 disabled
; 0000 0233     UCSR3B=0x00;
	STS  305,R30
; 0000 0234 
; 0000 0235     // Analog Comparator initialization
; 0000 0236     // Analog Comparator: Off
; 0000 0237     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0238     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0239     ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 023A     DIDR1=0x00;
	STS  127,R30
; 0000 023B 
; 0000 023C     // ADC initialization
; 0000 023D     // ADC disabled
; 0000 023E     ADCSRA=0x00;
	STS  122,R30
; 0000 023F 
; 0000 0240     // SPI initialization
; 0000 0241     // SPI disabled
; 0000 0242     SPCR=0x00;
	OUT  0x2C,R30
; 0000 0243 
; 0000 0244     // TWI initialization
; 0000 0245     // TWI disabled
; 0000 0246     TWCR=0x00;
	STS  188,R30
; 0000 0247 
; 0000 0248     // Alphanumeric LCD initialization
; 0000 0249     // Connections are specified in the
; 0000 024A     // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 024B     // RS - PORTJ Bit 0
; 0000 024C     // RD - PORTJ Bit 1
; 0000 024D     // EN - PORTJ Bit 2
; 0000 024E     // D4 - PORTJ Bit 4
; 0000 024F     // D5 - PORTJ Bit 5
; 0000 0250     // D6 - PORTJ Bit 6
; 0000 0251     // D7 - PORTJ Bit 7
; 0000 0252     // Characters/line: 20
; 0000 0253     lcd_init(20);
	LDI  R26,LOW(20)
	CALL _lcd_init
; 0000 0254 
; 0000 0255     // Global enable interrupts
; 0000 0256     #asm("sei")
	sei
; 0000 0257 }
	RET
;
;/**
;* Mencari substring pada suatu string
;*
;* @param str1 : char buffer tempat substring akan dicari
;* @param str2 : substring yang ingin dicari dari suatu string/char buffer
;*
;* @return true jika ketemu, false jika tidak
;*/
;bool isFound(char *str1,char *str2)
; 0000 0262 {
_isFound:
; 0000 0263     if (strstr(str1,str2)) return true;
	ST   -Y,R27
	ST   -Y,R26
;	*str1 -> Y+2
;	*str2 -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _strstr
	SBIW R30,0
	BREQ _0x2B
	LDI  R30,LOW(1)
	JMP  _0x20C0004
; 0000 0264     else return false;
_0x2B:
	LDI  R30,LOW(0)
	JMP  _0x20C0004
; 0000 0265 }
;
;/**
;* Memperoleh index char setelah substring yang dicari pada array char
;*
;* @param str1 : char buffer tempat substring akan dicari
;* @param str2 : substring yang ingin dicari dari suatu string/char buffer
;*
;* @return nilai index jika substring ada, -1 jika tidak
;*/
;int getIndexAfterward(char * str1 , char * str2)
; 0000 0270 {
_getIndexAfterward:
; 0000 0271     if (strstr(str1,str2)) return ((strstr(str1,str2) - str1) + strlen(str2));
	ST   -Y,R27
	ST   -Y,R26
;	*str1 -> Y+2
;	*str2 -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _strstr
	SBIW R30,0
	BREQ _0x2D
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _strstr
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SUB  R30,R26
	SBC  R31,R27
	PUSH R31
	PUSH R30
	LD   R26,Y
	LDD  R27,Y+1
	CALL _strlen
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	JMP  _0x20C0004
; 0000 0272     else return -1;
_0x2D:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	JMP  _0x20C0004
; 0000 0273 }
;
;/**
;* char to integer
;*
;* @param word : satu karakter saja, angka
;* @return angka dalam integer
;*/
;int toInt(char word)
; 0000 027C {
_toInt:
; 0000 027D     return (word - '0');
	ST   -Y,R26
;	word -> Y+0
	LD   R30,Y
	LDI  R31,0
	SBIW R30,48
	JMP  _0x20C0001
; 0000 027E }
;
;/**
;* memperoleh ukuran pesan yang masuk
;*
;* @param word : satu karakter saja, angka
;* @return angka dalam integer, kalo gada -1
;*/
;int getDataSize(char * buf)
; 0000 0287 {
_getDataSize:
; 0000 0288     //data yang masuk akan mendapatkan +IPD sebagai headernya
; 0000 0289     if (isFound(buf,"+IPD,"))
	ST   -Y,R27
	ST   -Y,R26
;	*buf -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x30,0
	RCALL _isFound
	CPI  R30,0
	BRNE PC+3
	JMP _0x2F
; 0000 028A     {
; 0000 028B         int indexConnectionId = getIndexAfterward(buf,"+IPD,");
; 0000 028C         int ribuan, ratusan, puluhan, satuan, total, offset=1;
; 0000 028D         char dataSize[4];
; 0000 028E 
; 0000 028F         //formatnya adalah seperti ini
; 0000 0290         //+IPD,1,123:
; 0000 0291         //1 adalah koneksi dari channel 1
; 0000 0292         //123 artinya 123 byte.
; 0000 0293         //untuk mengetahui besarnya ukuran, digunakan offset dari lokasi header
; 0000 0294         do
	SBIW R28,18
	LDI  R30,LOW(1)
	STD  Y+4,R30
	LDI  R30,LOW(0)
	STD  Y+5,R30
;	*buf -> Y+18
;	indexConnectionId -> Y+16
;	ribuan -> Y+14
;	ratusan -> Y+12
;	puluhan -> Y+10
;	satuan -> Y+8
;	total -> Y+6
;	offset -> Y+4
;	dataSize -> Y+0
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x30,6
	RCALL _getIndexAfterward
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x32:
; 0000 0295         {
; 0000 0296             offset++;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0297             dataSize[offset-2] = buf[indexConnectionId+offset];
	SBIW R30,2
	MOVW R26,R28
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0298         }
; 0000 0299         while (dataSize[offset-2] != ':'); //berhenti sebelum tanda titik 2
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,2
	MOVW R26,R28
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x3A)
	BRNE _0x32
; 0000 029A 
; 0000 029B         //dari besar offset dapat diketahui jumlah digit data yang masuk
; 0000 029C         if (offset==6)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,6
	BRNE _0x34
; 0000 029D         {
; 0000 029E             ribuan =  toInt(dataSize[0]) * 1000;
	LD   R26,Y
	RCALL _toInt
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 029F             ratusan = toInt(dataSize[1]) * 100;
	LDD  R26,Y+1
	RCALL _toInt
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 02A0             puluhan = toInt(dataSize[2]) * 10;
	LDD  R26,Y+2
	RCALL _toInt
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 02A1             satuan = toInt(dataSize[3]);
	LDD  R26,Y+3
	RCALL _toInt
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 02A2             total = ribuan+ratusan+puluhan+satuan;
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x6E
; 0000 02A3         }
; 0000 02A4         else if (offset==5)
_0x34:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,5
	BRNE _0x36
; 0000 02A5         {
; 0000 02A6             ratusan = toInt(dataSize[0]) * 100;
	LD   R26,Y
	RCALL _toInt
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 02A7             puluhan = toInt(dataSize[1]) * 10;
	LDD  R26,Y+1
	RCALL _toInt
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 02A8             satuan = toInt(dataSize[2]);
	LDD  R26,Y+2
	RCALL _toInt
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 02A9             total = ratusan+puluhan+satuan;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x6E
; 0000 02AA         }
; 0000 02AB         else if (offset==4)
_0x36:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,4
	BRNE _0x38
; 0000 02AC         {
; 0000 02AD             puluhan = toInt(dataSize[0]) * 10;
	LD   R26,Y
	RCALL _toInt
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 02AE             satuan = toInt(dataSize[1]);
	LDD  R26,Y+1
	RCALL _toInt
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 02AF             total = puluhan+satuan;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x6E
; 0000 02B0         }
; 0000 02B1         else if (offset==3)
_0x38:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,3
	BRNE _0x3A
; 0000 02B2         {
; 0000 02B3             satuan = toInt(dataSize[0]);
	LD   R26,Y
	RCALL _toInt
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 02B4             total = satuan;
_0x6E:
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 02B5         }
; 0000 02B6         return total;
_0x3A:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R28,18
	JMP  _0x20C0003
; 0000 02B7     }
; 0000 02B8     else return -1;
_0x2F:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	JMP  _0x20C0003
; 0000 02B9 }

	.DSEG
_0x30:
	.BYTE 0xC
;
;/* belum kepake
;bool sendAndWait(char * command , char * response, int timeout, bool debug)
;{
;    char data[CUSTOM_BUFFER_SIZE];
;    bool received = true;
;
;    usartOutput = USART0;
;    printf("%s\r\n",command);
;
;    while(1)
;    {
;        if (serial0Available)
;        {
;            data[i] = getchar();
;            if (debug)
;            {
;                usartOutput = USART1;
;                putchar1(data[i]);
;            }
;            received = true;
;            count = 0;
;            i++;
;        }
;
;        if ((count>=timeout) && (received))
;        {
;            received = false;
;
;            for (j=i;j<CUSTOM_BUFFER_SIZE;j++)
;            {
;                data[j]=NULL;
;            }
;
;            i=0;
;
;            if (isFound(data,response))
;            {
;                if (debug)
;                {
;                    usartOutput = USART1;
;                    printf("Response Matched");
;                }
;                return true;
;            }
;            else
;            {
;                if (debug)
;                {
;                    usartOutput = USART1;
;                    printf("Response Mismatched");
;                }
;                return false;
;            }
;        }
;    }
;}
;*/
;
;/**
;* Clear Buffer
;* mengembalikan semua index ke 0, dan mereset semua nilai pada buffernya jadi null
;*/
;void clearBuffer()
; 0000 02FA {

	.CSEG
_clearBuffer:
; 0000 02FB     unsigned char temp;
; 0000 02FC     for (temp=0;temp<RX_BUFFER_SIZE0; temp++) rx_buffer0[temp]=NULL;
	ST   -Y,R17
;	temp -> R17
	LDI  R17,LOW(0)
_0x3D:
	CPI  R17,32
	BRSH _0x3E
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	SUBI R17,-1
	RJMP _0x3D
_0x3E:
; 0000 02FD for (temp=0;temp<32; temp++) rx_buffer1[temp]=0;
	LDI  R17,LOW(0)
_0x40:
	CPI  R17,32
	BRSH _0x41
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	SUBI R17,-1
	RJMP _0x40
_0x41:
; 0000 02FE rx_wr_index0=0;
	CLR  R4
; 0000 02FF     rx_rd_index0=0;
	CLR  R3
; 0000 0300     serial0Available=0;
	CLR  R6
; 0000 0301     rx_wr_index1=0;
	CLR  R5
; 0000 0302     rx_rd_index1=0;
	CLR  R8
; 0000 0303     serial1Available=0;
	CLR  R7
; 0000 0304 }
_0x20C0005:
	LD   R17,Y+
	RET
;
;void toggleLed()
; 0000 0307 {
_toggleLed:
; 0000 0308     //PORTL ^= 1 << 7;
; 0000 0309 }
	RET
;
;void updateConnection()
; 0000 030C {
_updateConnection:
; 0000 030D     lcd_clear();
	CALL _lcd_clear
; 0000 030E     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 030F     lcd_putsf("UPDATE");
	__POINTW2FN _0x0,6
	CALL _lcd_putsf
; 0000 0310     if (!busy && afterReset>1)
	LDS  R30,_busy
	CPI  R30,0
	BRNE _0x43
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R13
	CPC  R31,R14
	BRLT _0x44
_0x43:
	RJMP _0x42
_0x44:
; 0000 0311     {
; 0000 0312         battery++;
	LDI  R26,LOW(_battery)
	LDI  R27,HIGH(_battery)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0313         if (battery > 100)  battery=0;
	LDS  R26,_battery
	LDS  R27,_battery+1
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLT _0x45
	LDI  R30,LOW(0)
	STS  _battery,R30
	STS  _battery+1,R30
; 0000 0314 
; 0000 0315         lcd_gotoxy(7,1);
_0x45:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0316         lcd_putsf("OK");
	__POINTW2FN _0x0,13
	CALL _lcd_putsf
; 0000 0317 
; 0000 0318         setting = true;
	LDI  R30,LOW(1)
	STS  _setting,R30
; 0000 0319         usartOutput=USART0;
	LDI  R30,LOW(0)
	STS  _usartOutput,R30
; 0000 031A         printf("AT+CIPMUX=1\r\n");
	__POINTW1FN _0x0,16
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 031B         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 031C         printf("AT+CIPSERVER=1,80\r\n");
	__POINTW1FN _0x0,30
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 031D         delay_ms(250);
	LDI  R26,LOW(250)
	LDI  R27,0
	CALL _delay_ms
; 0000 031E         setting = false;
	LDI  R30,LOW(0)
	STS  _setting,R30
; 0000 031F     }
; 0000 0320     else
	RJMP _0x46
_0x42:
; 0000 0321     {
; 0000 0322         lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0323         lcd_putsf("NO");
	__POINTW2FN _0x0,50
	CALL _lcd_putsf
; 0000 0324     }
_0x46:
; 0000 0325 }
	RET
;
;void sendStatus()
; 0000 0328 {
_sendStatus:
; 0000 0329     lcd_clear();
	CALL _lcd_clear
; 0000 032A     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 032B     lcd_putsf("STATUS");
	__POINTW2FN _0x0,53
	CALL _lcd_putsf
; 0000 032C     if (!setting && afterReset>1)
	LDS  R30,_setting
	CPI  R30,0
	BRNE _0x48
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R13
	CPC  R31,R14
	BRLT _0x49
_0x48:
	RJMP _0x47
_0x49:
; 0000 032D    {
; 0000 032E         lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 032F         lcd_putsf("OK");
	__POINTW2FN _0x0,13
	CALL _lcd_putsf
; 0000 0330         busy = true;
	LDI  R30,LOW(1)
	STS  _busy,R30
; 0000 0331         usartOutput=USART0;
	LDI  R30,LOW(0)
	STS  _usartOutput,R30
; 0000 0332         printf("AT+CIPSTART=4,\"TCP\",\"192.168.0.250\",80\r\n");
	__POINTW1FN _0x0,60
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 0333         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0334         printf("AT+CIPSEND=4,33\r\n");
	__POINTW1FN _0x0,101
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 0335         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0336         printf("GET /AGV/setAll/%d/%d/%d/%d/%d/%d/%d\r\n",id,connected,motor,signals,battery,position,obstacle);
	__POINTW1FN _0x0,119
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x1
	CALL __PUTPARD1
	LDS  R30,_connected
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_motor
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_signals
	LDS  R31,_signals+1
	CALL __CWD1
	CALL __PUTPARD1
	LDS  R30,_battery
	LDS  R31,_battery+1
	CALL __CWD1
	CALL __PUTPARD1
	LDS  R30,_position
	LDS  R31,_position+1
	CALL __CWD1
	CALL __PUTPARD1
	LDS  R30,_obstacle
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,28
	CALL _printf
	ADIW R28,30
; 0000 0337         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0338         busy = false;
	LDI  R30,LOW(0)
	STS  _busy,R30
; 0000 0339    }
; 0000 033A    else
	RJMP _0x4A
_0x47:
; 0000 033B    {
; 0000 033C       lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 033D         lcd_putsf("NO");
	__POINTW2FN _0x0,50
	CALL _lcd_putsf
; 0000 033E    }
_0x4A:
; 0000 033F }
	RET
;
;void resetModule()
; 0000 0342 {
_resetModule:
; 0000 0343     afterReset=0;
	CLR  R13
	CLR  R14
; 0000 0344     lcd_clear();
	CALL _lcd_clear
; 0000 0345     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0346     lcd_putsf("RESETS");
	__POINTW2FN _0x0,158
	CALL _lcd_putsf
; 0000 0347     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0348     if (!setting && !busy)
	LDS  R30,_setting
	CPI  R30,0
	BRNE _0x4C
	LDS  R30,_busy
	CPI  R30,0
	BREQ _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
; 0000 0349    {
; 0000 034A         lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 034B         lcd_putsf("OK");
	__POINTW2FN _0x0,13
	CALL _lcd_putsf
; 0000 034C         usartOutput=USART0;
	LDI  R30,LOW(0)
	STS  _usartOutput,R30
; 0000 034D         printf("AT+RST\r\n");
	__POINTW1FN _0x0,165
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 034E    }
; 0000 034F    else
	RJMP _0x4E
_0x4B:
; 0000 0350    {
; 0000 0351         lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0352         lcd_putsf("NO");
	__POINTW2FN _0x0,50
	CALL _lcd_putsf
; 0000 0353    }
_0x4E:
; 0000 0354 }
	RET
;
;void main(void)
; 0000 0357 {
_main:
; 0000 0358     bool received = false, debug=false;
; 0000 0359     char data[CUSTOM_BUFFER_SIZE];
; 0000 035A     int indexConnectionId, indexCommand, connectionId, command, incomingSize, offset, len;
; 0000 035B 
; 0000 035C     //contoh data yang akan dikirim ke client, kalau ada yang ngirim data ke ESP8266 nya
; 0000 035D     char send[] = "<title>AGV</title><h1>AGV Project</h1><h2>Client #1</h2><button>Test Button 1</button>";
; 0000 035E 
; 0000 035F     initAll();
	SBIW R28,63
	SBIW R28,34
	SUBI R29,8
	LDI  R24,87
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x4F*2)
	LDI  R31,HIGH(_0x4F*2)
	CALL __INITLOCB
;	received -> R17
;	debug -> R16
;	data -> Y+97
;	indexConnectionId -> R18,R19
;	indexCommand -> R20,R21
;	connectionId -> Y+95
;	command -> Y+93
;	incomingSize -> Y+91
;	offset -> Y+89
;	len -> Y+87
;	send -> Y+0
	LDI  R17,0
	LDI  R16,0
	RCALL _initAll
; 0000 0360 
; 0000 0361     lcd_putsf("test");
	__POINTW2FN _0x0,174
	CALL _lcd_putsf
; 0000 0362     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0363     lcd_putsf("test");
	__POINTW2FN _0x0,174
	CALL _lcd_putsf
; 0000 0364     lcd_gotoxy(0,2);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
; 0000 0365     lcd_putsf("test");
	__POINTW2FN _0x0,174
	CALL _lcd_putsf
; 0000 0366     lcd_gotoxy(0,3);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _lcd_gotoxy
; 0000 0367     lcd_putsf("test");
	__POINTW2FN _0x0,174
	CALL _lcd_putsf
; 0000 0368 
; 0000 0369    // usartOutput=USART0;
; 0000 036A    // printf("AT+CIPSTART=4,\"TCP\",\"192.168.0.250\",80\r\n");
; 0000 036B    // delay_ms(300);
; 0000 036C 
; 0000 036D     while(1)
_0x50:
; 0000 036E     {
; 0000 036F         //lcd_gotoxy(0,3);
; 0000 0370         //itoa(afterReset,lcd);
; 0000 0371         //lcd_puts(lcd);
; 0000 0372 
; 0000 0373         //setiap menerima input tidak akan terperangkap dalam close loop di dalam if ini,
; 0000 0374         //meskipun menggunakan while juga sama, jadi pakai if saja
; 0000 0375         if (serial0Available)
	TST  R6
	BREQ _0x53
; 0000 0376         {
; 0000 0377             busy = true;
	LDI  R30,LOW(1)
	STS  _busy,R30
; 0000 0378             received = true;
	LDI  R17,LOW(1)
; 0000 0379             count = 0;
	CLR  R11
	CLR  R12
; 0000 037A 
; 0000 037B             //Selama dapat command dari luar (USART1),
; 0000 037C             //output respon ESP8266 di USART0 akan di verbose ke USART1 lagi
; 0000 037D             if (debug)
	CPI  R16,0
	BREQ _0x54
; 0000 037E             {
; 0000 037F                 usartOutput = USART1;
	STS  _usartOutput,R30
; 0000 0380                 putchar1(getchar());
	RCALL _getchar
	MOV  R26,R30
	RCALL _putchar1
; 0000 0381             }
; 0000 0382             //jika command bukan dari luar, respon dari ESP8266 akan dianggap sebagai input
; 0000 0383             //dan disimpan di buffer
; 0000 0384             else
	RJMP _0x55
_0x54:
; 0000 0385             {
; 0000 0386                 usartOutput = USART0;
	LDI  R30,LOW(0)
	STS  _usartOutput,R30
; 0000 0387                 data[i] = getchar();
	__GETW1R 9,10
	MOVW R26,R28
	SUBI R26,LOW(-(97))
	SBCI R27,HIGH(-(97))
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0388                 i++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 9,10,30,31
; 0000 0389             }
_0x55:
; 0000 038A         }
; 0000 038B 
; 0000 038C         //Setelah tidak ada input dalam beberapa saat, akan masuk ke if ini
; 0000 038D         //agar data dapat diproses
; 0000 038E         if ((count>0) && (received) && (!debug))
_0x53:
	CLR  R0
	CP   R0,R11
	CPC  R0,R12
	BRGE _0x57
	CPI  R17,0
	BREQ _0x57
	CPI  R16,0
	BREQ _0x58
_0x57:
	RJMP _0x56
_0x58:
; 0000 038F         {
; 0000 0390             //data sudah di custom buffer, reset internal buffer ke null
; 0000 0391             clearBuffer();
	RCALL _clearBuffer
; 0000 0392             busy = false;
	LDI  R30,LOW(0)
	STS  _busy,R30
; 0000 0393             received = false;
	LDI  R17,LOW(0)
; 0000 0394 
; 0000 0395             i=0;
	CLR  R9
	CLR  R10
; 0000 0396             if (isFound(data,"+IPD,"))
	MOVW R30,R28
	SUBI R30,LOW(-(97))
	SBCI R31,HIGH(-(97))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x5A,0
	RCALL _isFound
	CPI  R30,0
	BRNE PC+3
	JMP _0x59
; 0000 0397             {
; 0000 0398                 usartOutput = USART1;
	LDI  R30,LOW(1)
	STS  _usartOutput,R30
; 0000 0399                 indexConnectionId = getIndexAfterward(data,"+IPD,");
	MOVW R30,R28
	SUBI R30,LOW(-(97))
	SBCI R31,HIGH(-(97))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x5A,6
	RCALL _getIndexAfterward
	MOVW R18,R30
; 0000 039A                 connectionId =  toInt(data[indexConnectionId]);
	MOVW R26,R28
	SUBI R26,LOW(-(97))
	SBCI R27,HIGH(-(97))
	ADD  R26,R18
	ADC  R27,R19
	LD   R26,X
	RCALL _toInt
	__PUTW1SX 95
; 0000 039B 
; 0000 039C                 incomingSize = getDataSize(data);
	MOVW R26,R28
	SUBI R26,LOW(-(97))
	SBCI R27,HIGH(-(97))
	RCALL _getDataSize
	__PUTW1SX 91
; 0000 039D 
; 0000 039E                 //contoh command sederhana, custom tergantung dari web nya
; 0000 039F                 if (isFound(data,"cmd="))
	MOVW R30,R28
	SUBI R30,LOW(-(97))
	SBCI R31,HIGH(-(97))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x5A,12
	RCALL _isFound
	CPI  R30,0
	BREQ _0x5B
; 0000 03A0                 {
; 0000 03A1                     indexCommand = getIndexAfterward(data,"cmd=");
	MOVW R30,R28
	SUBI R30,LOW(-(97))
	SBCI R31,HIGH(-(97))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x5A,17
	RCALL _getIndexAfterward
	MOVW R20,R30
; 0000 03A2                     command = toInt(data[indexCommand]);
	MOVW R26,R28
	SUBI R26,LOW(-(97))
	SBCI R27,HIGH(-(97))
	ADD  R26,R20
	ADC  R27,R21
	LD   R26,X
	RCALL _toInt
	__PUTW1SX 93
; 0000 03A3 
; 0000 03A4 
; 0000 03A5 
; 0000 03A6 
; 0000 03A7                     if (command == 0)
	SBIW R30,0
	BRNE _0x5C
; 0000 03A8                     {
; 0000 03A9                         lcd_clear();
	CALL _lcd_clear
; 0000 03AA                         lcd_putsf("OFF");
	__POINTW2FN _0x0,184
	CALL _lcd_putsf
; 0000 03AB                         motor = 0;
	LDI  R30,LOW(0)
	STS  _motor,R30
; 0000 03AC                         PORTL = 0x00;
	RJMP _0x6F
; 0000 03AD                     }
; 0000 03AE                     else if (command == 1)
_0x5C:
	__GETW2SX 93
	SBIW R26,1
	BRNE _0x5E
; 0000 03AF                     {
; 0000 03B0                         lcd_clear();
	CALL _lcd_clear
; 0000 03B1                         lcd_putsf("ON");
	__POINTW2FN _0x0,188
	CALL _lcd_putsf
; 0000 03B2                         motor = 1;
	LDI  R30,LOW(1)
	STS  _motor,R30
; 0000 03B3                         PORTL = 0xff;
	LDI  R30,LOW(255)
_0x6F:
	STS  267,R30
; 0000 03B4                     }
; 0000 03B5 
; 0000 03B6                     clearBuffer();  //jaga2, clear lagi aja
_0x5E:
	RCALL _clearBuffer
; 0000 03B7                 }
; 0000 03B8                 else
	RJMP _0x5F
_0x5B:
; 0000 03B9                 {
; 0000 03BA                     printf("\r\n\n%d BYTE OF DATA FROM CHANNEL %d\r\n",incomingSize,connectionId);
	__POINTW1FN _0x0,191
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 93
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1SX 101
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	RCALL _printf
	ADIW R28,10
; 0000 03BB 
; 0000 03BC                     if (incomingSize>999) offset = 6;
	__GETW2SX 91
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRLT _0x60
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0x70
; 0000 03BD                     else if (incomingSize>99) offset = 5;
_0x60:
	__GETW2SX 91
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x62
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0x70
; 0000 03BE                     else if (incomingSize>9) offset = 4;
_0x62:
	__GETW2SX 91
	SBIW R26,10
	BRLT _0x64
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP _0x70
; 0000 03BF                     else offset = 3;
_0x64:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
_0x70:
	__PUTW1SX 89
; 0000 03C0 
; 0000 03C1                     printf("\r\n/***BEGINNING OF THE DATA***/\r\n");
	__POINTW1FN _0x0,228
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 03C2 
; 0000 03C3                     do
_0x67:
; 0000 03C4                     {
; 0000 03C5                         offset++;
	MOVW R26,R28
	SUBI R26,LOW(-(89))
	SBCI R27,HIGH(-(89))
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 03C6                         putchar1(data[indexConnectionId+offset]);
	__GETW1SX 89
	ADD  R30,R18
	ADC  R31,R19
	MOVW R26,R28
	SUBI R26,LOW(-(97))
	SBCI R27,HIGH(-(97))
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _putchar1
; 0000 03C7                     }
; 0000 03C8                     while (offset<incomingSize+3);
	__GETW1SX 91
	ADIW R30,3
	__GETW2SX 89
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x67
; 0000 03C9 
; 0000 03CA                     printf("\r\n/***END OF THE DATA***/\r\n");
	__POINTW1FN _0x0,262
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 03CB 
; 0000 03CC                     len = strlen(send);
	MOVW R26,R28
	CALL _strlen
	__PUTW1SX 87
; 0000 03CD 
; 0000 03CE                     usartOutput=USART0;
	LDI  R30,LOW(0)
	STS  _usartOutput,R30
; 0000 03CF 
; 0000 03D0                     //untuk kirim balik data
; 0000 03D1                     printf("AT+CIPSEND=%d,%d\r\n",connectionId,len);
	__POINTW1FN _0x0,290
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 97
	CALL __CWD1
	CALL __PUTPARD1
	__GETW1SX 93
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	RCALL _printf
	ADIW R28,10
; 0000 03D2                     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 03D3                     printf("%s\r\n",send);
	__POINTW1FN _0x0,309
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
; 0000 03D4                     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 03D5                 }
_0x5F:
; 0000 03D6 
; 0000 03D7                 //setelah terjadi koneksi, tutup koneksi dengan AT+CIPCLOSE
; 0000 03D8                 usartOutput=USART0;
	LDI  R30,LOW(0)
	STS  _usartOutput,R30
; 0000 03D9                 printf("AT+CIPCLOSE=%d\r\n",connectionId);
	__POINTW1FN _0x0,314
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 97
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
; 0000 03DA                 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 03DB                 printf("AT+CIPCLOSE=%d\r\n",connectionId);
	__POINTW1FN _0x0,314
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 97
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
; 0000 03DC                 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 03DD             }
; 0000 03DE         }
_0x59:
; 0000 03DF 
; 0000 03E0         //jika sebelumnya ada data dari luar (USART1), kembalikan flag ke default (matikan debug mode)
; 0000 03E1         if ((count>0) && (received) && (debug))
_0x56:
	CLR  R0
	CP   R0,R11
	CPC  R0,R12
	BRGE _0x6A
	CPI  R17,0
	BREQ _0x6A
	CPI  R16,0
	BRNE _0x6B
_0x6A:
	RJMP _0x69
_0x6B:
; 0000 03E2         {
; 0000 03E3             debug = false;
	LDI  R16,LOW(0)
; 0000 03E4             usartOutput=USART0;
	LDI  R30,LOW(0)
	STS  _usartOutput,R30
; 0000 03E5         }
; 0000 03E6 
; 0000 03E7         //jika terdapat input dari luar (USART1), aktifkan debug
; 0000 03E8         if(serial1Available)
_0x69:
	TST  R7
	BREQ _0x6C
; 0000 03E9         {
; 0000 03EA             debug = true;
	LDI  R16,LOW(1)
; 0000 03EB             usartOutput=USART0;
	LDI  R30,LOW(0)
	STS  _usartOutput,R30
; 0000 03EC             putchar(getchar1());
	RCALL _getchar1
	MOV  R26,R30
	RCALL _putchar
; 0000 03ED         }
; 0000 03EE     }
_0x6C:
	RJMP _0x50
; 0000 03EF }
_0x6D:
	RJMP _0x6D

	.DSEG
_0x5A:
	.BYTE 0x16
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_put_usart_G100:
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	CALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	JMP  _0x20C0002
__print_G100:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Z+4
	ST   -Y,R26
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG

	.DSEG

	.CSEG

	.CSEG
_strlen:
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
_strstr:
	ST   -Y,R27
	ST   -Y,R26
    ldd  r26,y+2
    ldd  r27,y+3
    movw r24,r26
strstr0:
    ld   r30,y
    ldd  r31,y+1
strstr1:
    ld   r23,z+
    tst  r23
    brne strstr2
    movw r30,r24
    rjmp strstr3
strstr2:
    ld   r22,x+
    cp   r22,r23
    breq strstr1
    adiw r24,1
    movw r26,r24
    tst  r22
    brne strstr0
    clr  r30
    clr  r31
strstr3:
_0x20C0004:
	ADIW R28,4
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G103:
	ST   -Y,R26
	LDS  R30,261
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	STS  261,R30
	__DELAY_USB 7
	LDS  R30,261
	ORI  R30,4
	STS  261,R30
	__DELAY_USB 18
	LDS  R30,261
	ANDI R30,0xFB
	STS  261,R30
	__DELAY_USB 18
	RJMP _0x20C0001
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
	__DELAY_USB 184
	RJMP _0x20C0001
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0003:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2060005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2060004
_0x2060005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2060007
	RJMP _0x20C0001
_0x2060007:
_0x2060004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	LDS  R30,261
	ORI  R30,1
	STS  261,R30
	LD   R26,Y
	RCALL __lcd_write_data
	LDS  R30,261
	ANDI R30,0xFE
	STS  261,R30
	RJMP _0x20C0001
_lcd_putsf:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x206000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x206000B
_0x206000D:
	LDD  R17,Y+0
_0x20C0002:
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	LDS  R30,260
	ORI  R30,LOW(0xF0)
	STS  260,R30
	LDS  R30,260
	ORI  R30,4
	STS  260,R30
	LDS  R30,260
	ORI  R30,1
	STS  260,R30
	LDS  R30,260
	ORI  R30,2
	STS  260,R30
	LDS  R30,261
	ANDI R30,0xFB
	STS  261,R30
	LDS  R30,261
	ANDI R30,0xFE
	STS  261,R30
	LDS  R30,261
	ANDI R30,0xFD
	STS  261,R30
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G103
	__DELAY_USW 276
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G103
	__DELAY_USW 276
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G103
	__DELAY_USW 276
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G103
	__DELAY_USW 276
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.DSEG
_rx_buffer0:
	.BYTE 0x20
_rx_buffer1:
	.BYTE 0x20
_connected:
	.BYTE 0x1
_motor:
	.BYTE 0x1
_signals:
	.BYTE 0x2
_battery:
	.BYTE 0x2
_position:
	.BYTE 0x2
_obstacle:
	.BYTE 0x1
_usartOutput:
	.BYTE 0x1
_busy:
	.BYTE 0x1
_setting:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
