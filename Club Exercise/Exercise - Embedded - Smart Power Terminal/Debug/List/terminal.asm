
;CodeVisionAVR C Compiler V3.10 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 11,059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _menu=R4
	.DEF _menu_msb=R5
	.DEF __lcd_x=R7
	.DEF __lcd_y=R6
	.DEF __lcd_maxx=R9

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
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x0:
	.DB  0x45,0x6D,0x62,0x65,0x64,0x64,0x65,0x64
	.DB  0x45,0x78,0x65,0x72,0x63,0x69,0x73,0x65
	.DB  0x0,0x53,0x69,0x6C,0x61,0x68,0x6B,0x61
	.DB  0x6E,0x20,0x50,0x69,0x6C,0x69,0x68,0x20
	.DB  0x54,0x65,0x72,0x6D,0x69,0x6E,0x61,0x6C
	.DB  0x0,0x54,0x65,0x72,0x6D,0x69,0x6E,0x61
	.DB  0x6C,0x20,0x31,0x0,0x31,0x2E,0x50,0x49
	.DB  0x52,0x20,0x32,0x2E,0x54,0x20,0x33,0x2E
	.DB  0x43,0x48,0x59,0x0,0x54,0x65,0x72,0x6D
	.DB  0x69,0x6E,0x61,0x6C,0x20,0x32,0x0,0x54
	.DB  0x65,0x72,0x6D,0x69,0x6E,0x61,0x6C,0x20
	.DB  0x33,0x0,0x54,0x65,0x72,0x6D,0x69,0x6E
	.DB  0x61,0x6C,0x20,0x34,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R26,__SRAM_START
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
	.ORG 0x160

	.CSEG
;/*******************************************************
;Project : Exercise - Embedded Division - Smart Power Terminal
;Date    : 13/06/2014
;Author  : Rafi Kurnia Putra
;Company : Universitas Indonesia
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 11,059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdlib.h>
;#include <stdbool.h>
;#include <delay.h>
;#include <alcd.h>
;
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;#define t1on  PORTB.0 = 1;
;#define t1off PORTB.0 = 0;
;#define t2on  PORTB.1 = 1;
;#define t2off PORTB.1 = 0;
;#define t3on  PORTB.2 = 1;
;#define t3off PORTB.2 = 0;
;#define t4on  PORTB.3 = 1;
;#define t4off PORTB.3 = 0;
;
;int state[4] = {0}, menu = 0;
;
;void port_setup()
; 0000 0023 {

	.CSEG
_port_setup:
; .FSTART _port_setup
; 0000 0024 	DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0025 	PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0026 
; 0000 0027 	DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 0028 	PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0029 
; 0000 002A 	DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 002B 	PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 002C 
; 0000 002D 	DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 002E 	PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 002F }
	RET
; .FEND
;
;void misc_setup()
; 0000 0032 {
_misc_setup:
; .FSTART _misc_setup
; 0000 0033 	TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0034 	TCNT0=0x00;
	OUT  0x32,R30
; 0000 0035 	OCR0=0x00;
	OUT  0x3C,R30
; 0000 0036 	TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0037 	TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0038 	TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0039 	TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 003A 	ICR1H=0x00;
	OUT  0x27,R30
; 0000 003B 	ICR1L=0x00;
	OUT  0x26,R30
; 0000 003C 	OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 003D 	OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 003E 	OCR1BH=0x00;
	OUT  0x29,R30
; 0000 003F 	OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0040 	ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0041 	TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0042 	TCNT2=0x00;
	OUT  0x24,R30
; 0000 0043 	OCR2=0x00;
	OUT  0x23,R30
; 0000 0044 	TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0045 	MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0046 	MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0047 	UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0048 	ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0049 	ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 004A 	ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 004B 	SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 004C 	SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 004D 	TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 004E }
	RET
; .FEND
;
;void cek_reset()
; 0000 0051 {
_cek_reset:
; .FSTART _cek_reset
; 0000 0052 	if (MCUCSR & (1<<PORF)) MCUCSR&=~((1<<JTRF) | (1<<WDRF) | (1<<BORF) | (1<<EXTRF) | (1<<PORF));
	IN   R30,0x34
	SBRC R30,0
	RJMP _0xB7
; 0000 0053 	else if (MCUCSR & (1<<EXTRF)) MCUCSR&=~((1<<JTRF) | (1<<WDRF) | (1<<BORF) | (1<<EXTRF) | (1<<PORF));
	IN   R30,0x34
	SBRC R30,1
	RJMP _0xB7
; 0000 0054 	else if (MCUCSR & (1<<BORF)) MCUCSR&=~((1<<JTRF) | (1<<WDRF) | (1<<BORF) | (1<<EXTRF) | (1<<PORF));
	IN   R30,0x34
	SBRC R30,2
	RJMP _0xB7
; 0000 0055 	else if (MCUCSR & (1<<WDRF)) MCUCSR&=~((1<<JTRF) | (1<<WDRF) | (1<<BORF) | (1<<EXTRF) | (1<<PORF));
	IN   R30,0x34
	SBRC R30,3
	RJMP _0xB7
; 0000 0056 	else if (MCUCSR & (1<<JTRF)) MCUCSR&=~((1<<JTRF) | (1<<WDRF) | (1<<BORF) | (1<<EXTRF) | (1<<PORF));
	IN   R30,0x34
	SBRS R30,4
	RJMP _0xB
_0xB7:
	IN   R30,0x34
	ANDI R30,LOW(0xE0)
	OUT  0x34,R30
; 0000 0057 }
_0xB:
	RET
; .FEND
;
;unsigned int baca_sensor(unsigned char adc_input)
; 0000 005A {
_baca_sensor:
; .FSTART _baca_sensor
; 0000 005B 	ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 005C 	delay_us(10);
	__DELAY_USB 37
; 0000 005D 	ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 005E 	while ((ADCSRA & (1<<ADIF))==0);
_0xC:
	SBIS 0x6,4
	RJMP _0xC
; 0000 005F 	ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0060 	return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x20A0001
; 0000 0061 }
; .FEND
;
;bool cek_pir()
; 0000 0064 {
_cek_pir:
; .FSTART _cek_pir
; 0000 0065 	if (PINB.4 == 1) return true;
	SBIC 0x16,4
	RJMP _0x20A0004
; 0000 0066 	else return false;
	RJMP _0x20A0003
; 0000 0067 }
; .FEND
;
;bool cek_suhu()
; 0000 006A {
_cek_suhu:
; .FSTART _cek_suhu
; 0000 006B 	if (baca_sensor(0) > 512) return true;
	CALL SUBOPT_0x0
	BRSH _0x20A0004
; 0000 006C 	else return false;
	RJMP _0x20A0003
; 0000 006D }
; .FEND
;
;bool cek_cahaya()
; 0000 0070 {
_cek_cahaya:
; .FSTART _cek_cahaya
; 0000 0071 	if (baca_sensor(0) > 512) return true;
	CALL SUBOPT_0x0
	BRLO _0x13
_0x20A0004:
	LDI  R30,LOW(1)
	RET
; 0000 0072 	else return false;
_0x13:
_0x20A0003:
	LDI  R30,LOW(0)
	RET
; 0000 0073 }
	RET
; .FEND
;
;int baca_keypad()
; 0000 0076 {
_baca_keypad:
; .FSTART _baca_keypad
; 0000 0077 	while(1)
_0x15:
; 0000 0078 	{
; 0000 0079 		PORTD.4=0;
	CBI  0x12,4
; 0000 007A 		delay_ms(10);
	CALL SUBOPT_0x1
; 0000 007B 		if      (PIND.0==0){return 1;}
	SBIC 0x10,0
	RJMP _0x1A
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
; 0000 007C 		else if (PIND.1==0){return 2;}
_0x1A:
	SBIC 0x10,1
	RJMP _0x1C
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET
; 0000 007D 		else if (PIND.2==0){return 3;}
_0x1C:
	SBIC 0x10,2
	RJMP _0x1E
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RET
; 0000 007E 
; 0000 007F 		PORTD.4=1; PORTD.5=0;
_0x1E:
	SBI  0x12,4
	CBI  0x12,5
; 0000 0080 		delay_ms(10);
	CALL SUBOPT_0x1
; 0000 0081 		if      (PIND.0==0){return 4;}
	SBIC 0x10,0
	RJMP _0x23
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RET
; 0000 0082 		//else if (PIND.1==0){return 5;}
; 0000 0083 		//else if (PIND.2==0){return 6;}
; 0000 0084 
; 0000 0085 		PORTD.5=1; //PORTD.6=0;
_0x23:
	SBI  0x12,5
; 0000 0086 		//delay_ms(10);
; 0000 0087 		//if      (PIND.0==0){return 7;}
; 0000 0088 		//else if (PIND.1==0){return 8;}
; 0000 0089 		//else if (PIND.2==0){return 9;}
; 0000 008A 
; 0000 008B 		/*PORTD.6=1;*/ PORTD.7=0;
	CBI  0x12,7
; 0000 008C 		delay_ms(10);
	CALL SUBOPT_0x1
; 0000 008D 		if      (PIND.1==0){return 0;}
	SBIC 0x10,1
	RJMP _0x28
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0000 008E 
; 0000 008F 		PORTD.7=1;
_0x28:
	SBI  0x12,7
; 0000 0090 		delay_ms(10);
	CALL SUBOPT_0x1
; 0000 0091 	}
	RJMP _0x15
; 0000 0092 }
; .FEND
;
;void gui()
; 0000 0095 {
_gui:
; .FSTART _gui
; 0000 0096 	int pilih=0;
; 0000 0097 
; 0000 0098 	if (menu==0)
	ST   -Y,R17
	ST   -Y,R16
;	pilih -> R16,R17
	__GETWRN 16,17,0
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x2B
; 0000 0099 	{
; 0000 009A 		lcd_clear();
	CALL SUBOPT_0x2
; 0000 009B 		lcd_gotoxy(0,0);
; 0000 009C 		lcd_putsf("EmbeddedExercise");
	__POINTW2FN _0x0,0
	CALL SUBOPT_0x3
; 0000 009D 		lcd_gotoxy(0,1);
; 0000 009E 		lcd_putsf("Silahkan Pilih Terminal");
	__POINTW2FN _0x0,17
	CALL SUBOPT_0x4
; 0000 009F 		pilih=baca_keypad();
; 0000 00A0 		if (pilih != 0) menu=pilih;
	BREQ _0x2C
	MOVW R4,R16
; 0000 00A1 	}
_0x2C:
; 0000 00A2 	else if (menu==1)
	RJMP _0x2D
_0x2B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x2E
; 0000 00A3 	{
; 0000 00A4 		lcd_clear();
	CALL SUBOPT_0x2
; 0000 00A5 		lcd_gotoxy(0,0);
; 0000 00A6 		lcd_putsf("Terminal 1");
	__POINTW2FN _0x0,41
	CALL SUBOPT_0x3
; 0000 00A7 		lcd_gotoxy(0,1);
; 0000 00A8 		lcd_putsf("1.PIR 2.T 3.CHY");
	CALL SUBOPT_0x5
; 0000 00A9 		pilih = baca_keypad();
; 0000 00AA 		if (pilih != 0) state[0] = pilih;
	BREQ _0x2F
	__PUTWMRN _state,0,16,17
; 0000 00AB 		else menu=0;
	RJMP _0x30
_0x2F:
	CLR  R4
	CLR  R5
; 0000 00AC 	}
_0x30:
; 0000 00AD 	else if (menu==2)
	RJMP _0x31
_0x2E:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x32
; 0000 00AE 	{
; 0000 00AF 		lcd_clear();
	CALL SUBOPT_0x2
; 0000 00B0 		lcd_gotoxy(0,0);
; 0000 00B1 		lcd_putsf("Terminal 2");
	__POINTW2FN _0x0,68
	CALL SUBOPT_0x3
; 0000 00B2 		lcd_gotoxy(0,1);
; 0000 00B3 		lcd_putsf("1.PIR 2.T 3.CHY");
	CALL SUBOPT_0x5
; 0000 00B4 		pilih = baca_keypad();
; 0000 00B5 		if (pilih != 0) state[1] = pilih;
	BREQ _0x33
	__POINTW1MN _state,2
	ST   Z,R16
	STD  Z+1,R17
; 0000 00B6 		else menu=0;
	RJMP _0x34
_0x33:
	CLR  R4
	CLR  R5
; 0000 00B7 	}
_0x34:
; 0000 00B8 	else if (menu==3)
	RJMP _0x35
_0x32:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x36
; 0000 00B9 	{
; 0000 00BA 		lcd_clear();
	CALL SUBOPT_0x2
; 0000 00BB 		lcd_gotoxy(0,0);
; 0000 00BC 		lcd_putsf("Terminal 3");
	__POINTW2FN _0x0,79
	CALL SUBOPT_0x3
; 0000 00BD 		lcd_gotoxy(0,1);
; 0000 00BE 		lcd_putsf("1.PIR 2.T 3.CHY");
	CALL SUBOPT_0x5
; 0000 00BF 		pilih = baca_keypad();
; 0000 00C0 		if (pilih != 0) state[2] = pilih;
	BREQ _0x37
	__POINTW1MN _state,4
	ST   Z,R16
	STD  Z+1,R17
; 0000 00C1 		else menu=0;
	RJMP _0x38
_0x37:
	CLR  R4
	CLR  R5
; 0000 00C2 	}
_0x38:
; 0000 00C3 	else if (menu==4)
	RJMP _0x39
_0x36:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x3A
; 0000 00C4 	{
; 0000 00C5 		lcd_clear();
	CALL SUBOPT_0x2
; 0000 00C6 		lcd_gotoxy(0,0);
; 0000 00C7 		lcd_putsf("Terminal 4");
	__POINTW2FN _0x0,90
	CALL SUBOPT_0x3
; 0000 00C8 		lcd_gotoxy(0,1);
; 0000 00C9 		lcd_putsf("1.PIR 2.T 3.CHY");
	CALL SUBOPT_0x5
; 0000 00CA 		pilih = baca_keypad();
; 0000 00CB 		if (pilih != 0) state[3] = pilih;
	BREQ _0x3B
	__POINTW1MN _state,6
	ST   Z,R16
	STD  Z+1,R17
; 0000 00CC 		else menu=0;
	RJMP _0x3C
_0x3B:
	CLR  R4
	CLR  R5
; 0000 00CD 	}
_0x3C:
; 0000 00CE }
_0x3A:
_0x39:
_0x35:
_0x31:
_0x2D:
	RJMP _0x20A0002
; .FEND
;
;void program_utama()
; 0000 00D1 {
_program_utama:
; .FSTART _program_utama
; 0000 00D2     int i;
; 0000 00D3 	while(1)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
_0x3D:
; 0000 00D4 	{
; 0000 00D5 		gui();
	RCALL _gui
; 0000 00D6 		for (i=0;i<4;i++)
	__GETWRN 16,17,0
_0x41:
	__CPWRN 16,17,4
	BRLT PC+2
	RJMP _0x42
; 0000 00D7 		{
; 0000 00D8 			switch(state[i])
	MOVW R30,R16
	LDI  R26,LOW(_state)
	LDI  R27,HIGH(_state)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
; 0000 00D9 			{
; 0000 00DA 			case 0:
	SBIW R30,0
	BRNE _0x46
; 0000 00DB 				switch(i)
	MOVW R30,R16
; 0000 00DC 				{
; 0000 00DD 				case 0:
	SBIW R30,0
	BRNE _0x4A
; 0000 00DE 					t1off;
	CBI  0x18,0
; 0000 00DF 					break;
	RJMP _0x49
; 0000 00E0 				case 1:
_0x4A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4D
; 0000 00E1 					t2off;
	CBI  0x18,1
; 0000 00E2 					break;
	RJMP _0x49
; 0000 00E3 				case 2:
_0x4D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x50
; 0000 00E4 					t3off;
	CBI  0x18,2
; 0000 00E5 					break;
	RJMP _0x49
; 0000 00E6 				case 3:
_0x50:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x49
; 0000 00E7 					t4off;
	CBI  0x18,3
; 0000 00E8 					break;
; 0000 00E9 				}
_0x49:
; 0000 00EA 				break;
	RJMP _0x45
; 0000 00EB 			case 1:
_0x46:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x56
; 0000 00EC 				switch(i)
	MOVW R30,R16
; 0000 00ED 				{
; 0000 00EE 				case 0:
	SBIW R30,0
	BRNE _0x5A
; 0000 00EF 					if (cek_pir()) t1on;
	RCALL _cek_pir
	CPI  R30,0
	BREQ _0x5B
	SBI  0x18,0
; 0000 00F0 					else t1off;
	RJMP _0x5E
_0x5B:
	CBI  0x18,0
; 0000 00F1 					break;
_0x5E:
	RJMP _0x59
; 0000 00F2 				case 1:
_0x5A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x61
; 0000 00F3 					if (cek_pir()) t2on;
	RCALL _cek_pir
	CPI  R30,0
	BREQ _0x62
	SBI  0x18,1
; 0000 00F4 					else t2off;
	RJMP _0x65
_0x62:
	CBI  0x18,1
; 0000 00F5 					break;
_0x65:
	RJMP _0x59
; 0000 00F6 				case 2:
_0x61:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x68
; 0000 00F7 					if (cek_pir()) t3on;
	RCALL _cek_pir
	CPI  R30,0
	BREQ _0x69
	SBI  0x18,2
; 0000 00F8 					else t3off;
	RJMP _0x6C
_0x69:
	CBI  0x18,2
; 0000 00F9 					break;
_0x6C:
	RJMP _0x59
; 0000 00FA 				case 3:
_0x68:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x59
; 0000 00FB 					if (cek_pir()) t4on;
	RCALL _cek_pir
	CPI  R30,0
	BREQ _0x70
	SBI  0x18,3
; 0000 00FC 					else t4off;
	RJMP _0x73
_0x70:
	CBI  0x18,3
; 0000 00FD 					break;
_0x73:
; 0000 00FE 				}
_0x59:
; 0000 00FF 				break;
	RJMP _0x45
; 0000 0100 			case 2:
_0x56:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x76
; 0000 0101 				switch(i)
	MOVW R30,R16
; 0000 0102 				{
; 0000 0103 				case 0:
	SBIW R30,0
	BRNE _0x7A
; 0000 0104 					if (cek_suhu()) t1on;
	RCALL _cek_suhu
	CPI  R30,0
	BREQ _0x7B
	SBI  0x18,0
; 0000 0105 					else t1off;
	RJMP _0x7E
_0x7B:
	CBI  0x18,0
; 0000 0106 					break;
_0x7E:
	RJMP _0x79
; 0000 0107 				case 1:
_0x7A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x81
; 0000 0108 					if (cek_suhu()) t2on;
	RCALL _cek_suhu
	CPI  R30,0
	BREQ _0x82
	SBI  0x18,1
; 0000 0109 					else t2off;
	RJMP _0x85
_0x82:
	CBI  0x18,1
; 0000 010A 					break;
_0x85:
	RJMP _0x79
; 0000 010B 				case 2:
_0x81:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x88
; 0000 010C 					if (cek_suhu()) t3on;
	RCALL _cek_suhu
	CPI  R30,0
	BREQ _0x89
	SBI  0x18,2
; 0000 010D 					else t3off;
	RJMP _0x8C
_0x89:
	CBI  0x18,2
; 0000 010E 					break;
_0x8C:
	RJMP _0x79
; 0000 010F 				case 3:
_0x88:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x79
; 0000 0110 					if (cek_suhu()) t4on;
	RCALL _cek_suhu
	CPI  R30,0
	BREQ _0x90
	SBI  0x18,3
; 0000 0111 					else t4off;
	RJMP _0x93
_0x90:
	CBI  0x18,3
; 0000 0112 					break;
_0x93:
; 0000 0113 				}
_0x79:
; 0000 0114 				break;
	RJMP _0x45
; 0000 0115 			case 3:
_0x76:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x45
; 0000 0116 				switch(i)
	MOVW R30,R16
; 0000 0117 				{
; 0000 0118 				case 0:
	SBIW R30,0
	BRNE _0x9A
; 0000 0119 					if (cek_cahaya()) t1on;
	RCALL _cek_cahaya
	CPI  R30,0
	BREQ _0x9B
	SBI  0x18,0
; 0000 011A 					else t1off;
	RJMP _0x9E
_0x9B:
	CBI  0x18,0
; 0000 011B 					break;
_0x9E:
	RJMP _0x99
; 0000 011C 				case 1:
_0x9A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xA1
; 0000 011D 					if (cek_cahaya()) t2on;
	RCALL _cek_cahaya
	CPI  R30,0
	BREQ _0xA2
	SBI  0x18,1
; 0000 011E 					else t2off;
	RJMP _0xA5
_0xA2:
	CBI  0x18,1
; 0000 011F 					break;
_0xA5:
	RJMP _0x99
; 0000 0120 				case 2:
_0xA1:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA8
; 0000 0121 					if (cek_cahaya()) t3on;
	RCALL _cek_cahaya
	CPI  R30,0
	BREQ _0xA9
	SBI  0x18,2
; 0000 0122 					else t3off;
	RJMP _0xAC
_0xA9:
	CBI  0x18,2
; 0000 0123 					break;
_0xAC:
	RJMP _0x99
; 0000 0124 				case 3:
_0xA8:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x99
; 0000 0125 					if (cek_cahaya()) t4on;
	RCALL _cek_cahaya
	CPI  R30,0
	BREQ _0xB0
	SBI  0x18,3
; 0000 0126 					else t4off;
	RJMP _0xB3
_0xB0:
	CBI  0x18,3
; 0000 0127 					break;
_0xB3:
; 0000 0128 				}
_0x99:
; 0000 0129 				break;
; 0000 012A 			}
_0x45:
; 0000 012B 		}
	__ADDWRN 16,17,1
	RJMP _0x41
_0x42:
; 0000 012C 	}
	RJMP _0x3D
; 0000 012D }
_0x20A0002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void main(void)
; 0000 0130 {
_main:
; .FSTART _main
; 0000 0131 	port_setup();
	RCALL _port_setup
; 0000 0132 	misc_setup();
	RCALL _misc_setup
; 0000 0133 	cek_reset();
	RCALL _cek_reset
; 0000 0134 	lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0135 	program_utama();
	RCALL _program_utama
; 0000 0136 }
_0xB6:
	RJMP _0xB6
; .FEND

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 18
	SBI  0x15,2
	__DELAY_USB 18
	CBI  0x15,2
	__DELAY_USB 18
	RJMP _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 184
	RJMP _0x20A0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R7,Y+1
	LDD  R6,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x6
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	MOV  R6,R30
	MOV  R7,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020005
	CP   R7,R9
	BRLO _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R6
	MOV  R26,R6
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020007
	RJMP _0x20A0001
_0x2020007:
_0x2020004:
	INC  R7
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20A0001
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x202000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x202000B
_0x202000D:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LDD  R9,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
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
_0x20A0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_state:
	.BYTE 0x8
__seed_G100:
	.BYTE 0x4
__base_y_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(0)
	CALL _baca_sensor
	CPI  R30,LOW(0x201)
	LDI  R26,HIGH(0x201)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3:
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4:
	CALL _lcd_putsf
	CALL _baca_keypad
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	__POINTW2FN _0x0,52
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 276
	RET


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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

;END OF CODE MARKER
__END_OF_CODE:
