
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

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

_0x3:
	.DB  0x31,0x32,0x33,0x41,0x34,0x35,0x36,0x42
	.DB  0x37,0x38,0x39,0x43,0x2A,0x30,0x23,0x44
_0x4:
	.DB  0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38
	.DB  0x39,0x2A,0x30,0x23
_0x5:
	.DB  0x3A,0x0,0x3B,0x0,0x39,0x0,0x0,0x3A
	.DB  0x0,0x3B,0x0,0x39,0x0,0x1,0x3A,0x0
	.DB  0x3B,0x0,0x39,0x0,0x2,0x3A,0x0,0x3B
	.DB  0x0,0x39,0x0,0x3
_0x6:
	.DB  0x3A,0x0,0x3B,0x0,0x39,0x0,0x4,0x3A
	.DB  0x0,0x3B,0x0,0x39,0x0,0x5,0x3A,0x0
	.DB  0x3B,0x0,0x39,0x0,0x6,0x3A,0x0,0x3B
	.DB  0x0,0x39,0x0,0x7
_0x0:
	.DB  0x4B,0x65,0x79,0x20,0x50,0x72,0x65,0x73
	.DB  0x73,0x65,0x64,0x3A,0x0,0x46,0x31,0x0
	.DB  0x46,0x32,0x0,0x46,0x33,0x0,0x46,0x34
	.DB  0x0,0x4D,0x61,0x74,0x72,0x69,0x78,0x20
	.DB  0x4B,0x65,0x79,0x70,0x61,0x64,0x0,0x52
	.DB  0x65,0x61,0x64,0x79,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x10
	.DW  _keypadTable_2
	.DW  _0x3*2

	.DW  0x1C
	.DW  _rowPins
	.DW  _0x5*2

	.DW  0x1C
	.DW  _colPins
	.DW  _0x6*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
	.ORG 0x260

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;#include "KeyPad.h"
;
;char keypadTable_2[4][4] =
;{
;    {'1','2','3','A'},
;    {'4','5','6','B'},
;    {'7','8','9','C'},
;    {'*','0','#','D'}
;};

	.DSEG
;
;char keypadTable_1[4][3] =
;{
;    {'1','2','3'},
;    {'4','5','6'},
;    {'7','8','9'},
;    {'*','0','#'}
;};
;
;pinConfig rowPins[4] =
;{
;    {&DDRA, &PORTA, &PINA, 0},
;    {&DDRA, &PORTA, &PINA, 1},
;    {&DDRA, &PORTA, &PINA, 2},
;    {&DDRA, &PORTA, &PINA, 3}
;};
;
;pinConfig colPins[4] =
;{
;    {&DDRA, &PORTA, &PINA, 4},
;    {&DDRA, &PORTA, &PINA, 5},
;    {&DDRA, &PORTA, &PINA, 6},
;    {&DDRA, &PORTA, &PINA, 7}
;};
;
;MatrixKeypad_t keypad1;
;MatrixKeypad_t keypad2;
;
;void onKeyPressed(char key)
; 0000 002A {

	.CSEG
_onKeyPressed:
; .FSTART _onKeyPressed
; 0000 002B     lcd_clear();
	ST   -Y,R26
;	key -> Y+0
	RCALL _lcd_clear
; 0000 002C     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 002D     lcd_putsf("Key Pressed:");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 002E     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 002F 
; 0000 0030     if(key == 'A')       lcd_putsf("F1");
	LD   R26,Y
	CPI  R26,LOW(0x41)
	BRNE _0x7
	__POINTW2FN _0x0,13
	CALL _lcd_putsf
; 0000 0031     else if(key == 'B')  lcd_putsf("F2");
	RJMP _0x8
_0x7:
	LD   R26,Y
	CPI  R26,LOW(0x42)
	BRNE _0x9
	__POINTW2FN _0x0,16
	RCALL _lcd_putsf
; 0000 0032     else if(key == 'C')  lcd_putsf("F3");
	RJMP _0xA
_0x9:
	LD   R26,Y
	CPI  R26,LOW(0x43)
	BRNE _0xB
	__POINTW2FN _0x0,19
	RCALL _lcd_putsf
; 0000 0033     else if(key == 'D')  lcd_putsf("F4");
	RJMP _0xC
_0xB:
	LD   R26,Y
	CPI  R26,LOW(0x44)
	BRNE _0xD
	__POINTW2FN _0x0,22
	RCALL _lcd_putsf
; 0000 0034     else
	RJMP _0xE
_0xD:
; 0000 0035      lcd_putchar(key);
	LD   R26,Y
	RCALL _lcd_putchar
; 0000 0036 
; 0000 0037 }
_0xE:
_0xC:
_0xA:
_0x8:
	JMP  _0x2020001
; .FEND
;
;void main(void) {
; 0000 0039 void main(void) {
_main:
; .FSTART _main
; 0000 003A 
; 0000 003B 
; 0000 003C     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 003D 
; 0000 003E     lcd_clear();
	RCALL _lcd_clear
; 0000 003F 
; 0000 0040     lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0041     lcd_putsf("Matrix Keypad");
	__POINTW2FN _0x0,25
	RCALL _lcd_putsf
; 0000 0042     lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0043     lcd_putsf("Ready");
	__POINTW2FN _0x0,39
	RCALL _lcd_putsf
; 0000 0044     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0045 
; 0000 0046     MatrixKeypad_Init(&keypad2, 4, 4, rowPins, colPins, (const unsigned char*)keypadTable_2, onKeyPressed);
	LDI  R30,LOW(_keypad2)
	LDI  R31,HIGH(_keypad2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(_rowPins)
	LDI  R31,HIGH(_rowPins)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_colPins)
	LDI  R31,HIGH(_colPins)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_keypadTable_2)
	LDI  R31,HIGH(_keypadTable_2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_onKeyPressed)
	LDI  R27,HIGH(_onKeyPressed)
	RCALL _MatrixKeypad_Init
; 0000 0047 
; 0000 0048     SetCallback_MatrixKeypad(&keypad2,onKeyPressed);
	LDI  R30,LOW(_keypad2)
	LDI  R31,HIGH(_keypad2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_onKeyPressed)
	LDI  R27,HIGH(_onKeyPressed)
	RCALL _SetCallback_MatrixKeypad
; 0000 0049 
; 0000 004A     while (1) {
_0xF:
; 0000 004B 
; 0000 004C         MatrixKeypad_ISR(&keypad2);
	LDI  R26,LOW(_keypad2)
	LDI  R27,HIGH(_keypad2)
	RCALL _MatrixKeypad_ISR
; 0000 004D     }
	RJMP _0xF
; 0000 004E }
_0x12:
	RJMP _0x12
; .FEND
;#include "KeyPad.h"
;
;#define DEBOUNCE_TICKS 3
;#define REPEAT_START   50
;#define REPEAT_NEXT    20
;
;void MatrixKeypad_Init(MatrixKeypad_t* keypad,
; 0001 0008                        uint8_t rows,
; 0001 0009                        uint8_t cols,
; 0001 000A                        pinConfig* rowPins,
; 0001 000B                        pinConfig* colPins,
; 0001 000C                        const char* lookupTable,
; 0001 000D                        void (*callback)(char))
; 0001 000E {

	.CSEG
_MatrixKeypad_Init:
; .FSTART _MatrixKeypad_Init
; 0001 000F     uint8_t i;
; 0001 0010     keypad->rowCount = rows;
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*keypad -> Y+11
;	rows -> Y+10
;	cols -> Y+9
;	*rowPins -> Y+7
;	*colPins -> Y+5
;	*lookupTable -> Y+3
;	*callback -> Y+1
;	i -> R17
	LDD  R30,Y+10
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ST   X,R30
; 0001 0011     keypad->colCount = cols;
	LDD  R30,Y+9
	__PUTB1SNS 11,1
; 0001 0012     keypad->rowPins = rowPins;
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	__PUTW1SNS 11,2
; 0001 0013     keypad->colPins = colPins;
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	__PUTW1SNS 11,4
; 0001 0014     keypad->lookupTable = lookupTable;
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	__PUTW1SNS 11,6
; 0001 0015     keypad->onKeyPressed = callback;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	__PUTW1SNS 11,8
; 0001 0016     keypad->onKeyRepeat = 0;
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,10
	RCALL SUBOPT_0x0
; 0001 0017     keypad->lastKey = 0;
	ADIW R26,12
	LDI  R30,LOW(0)
	ST   X,R30
; 0001 0018     keypad->debounceCounter = 0;
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,13
	RCALL SUBOPT_0x0
; 0001 0019     keypad->repeatCounter = 0;
	RCALL SUBOPT_0x1
; 0001 001A 
; 0001 001B     for (i = 0; i < rows; i++) {
	LDI  R17,LOW(0)
_0x20004:
	LDD  R30,Y+10
	CP   R17,R30
	BRSH _0x20005
; 0001 001C         *rowPins[i].DDR  |= (1 << rowPins[i].pinNumber);
	RCALL SUBOPT_0x2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x3
	POP  R26
	POP  R27
	ST   X,R30
; 0001 001D         *rowPins[i].PORT |= (1 << rowPins[i].pinNumber);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x4
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x3
	POP  R26
	POP  R27
	ST   X,R30
; 0001 001E     }
	SUBI R17,-1
	RJMP _0x20004
_0x20005:
; 0001 001F 
; 0001 0020     for (i = 0; i < cols; i++) {
	LDI  R17,LOW(0)
_0x20007:
	LDD  R30,Y+9
	CP   R17,R30
	BRSH _0x20008
; 0001 0021         *colPins[i].DDR  &= ~(1 << colPins[i].pinNumber);
	RCALL SUBOPT_0x5
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	PUSH R31
	PUSH R30
	LD   R24,Z
	RCALL SUBOPT_0x6
	AND  R30,R24
	POP  R26
	POP  R27
	ST   X,R30
; 0001 0022         *colPins[i].PORT |=  (1 << colPins[i].pinNumber);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x4
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x3
	POP  R26
	POP  R27
	ST   X,R30
; 0001 0023     }
	SUBI R17,-1
	RJMP _0x20007
_0x20008:
; 0001 0024 }
	LDD  R17,Y+0
	ADIW R28,13
	RET
; .FEND
;
;void MatrixKeypad_ISR(MatrixKeypad_t* keypad)
; 0001 0027 {
_MatrixKeypad_ISR:
; .FSTART _MatrixKeypad_ISR
; 0001 0028     char detectedKey = 0;
; 0001 0029     uint8_t r, c;
; 0001 002A 
; 0001 002B     for (r = 0; r < keypad->rowCount; r++)
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	*keypad -> Y+4
;	detectedKey -> R17
;	r -> R16
;	c -> R19
	LDI  R17,0
	LDI  R16,LOW(0)
_0x2000A:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X
	CP   R16,R30
	BRLO PC+2
	RJMP _0x2000B
; 0001 002C     {
; 0001 002D         *keypad->rowPins[r].PORT &= ~(1 << keypad->rowPins[r].pinNumber);
	RCALL SUBOPT_0x7
	MOVW R24,R30
	LD   R18,Z
	RCALL SUBOPT_0x6
	AND  R30,R18
	MOVW R26,R24
	ST   X,R30
; 0001 002E 
; 0001 002F         for (c = 0; c < keypad->colCount; c++)
	LDI  R19,LOW(0)
_0x2000D:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+1
	CP   R19,R30
	BRSH _0x2000E
; 0001 0030         {
; 0001 0031             if (((*keypad->colPins[c].PIN) & (1 << keypad->colPins[c].pinNumber)) == 0)
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Z+4
	LDD  R27,Z+5
	MOV  R30,R19
	LDI  R31,0
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R0,R30
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,4
	CALL __GETW1P
	RCALL SUBOPT_0x8
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R18
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x2000F
; 0001 0032             {
; 0001 0033                 detectedKey = keypad->lookupTable[r * keypad->colCount + c];
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__GETWRZ 22,23,6
	MOV  R26,R16
	CLR  R27
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+1
	LDI  R31,0
	CALL __MULW12
	MOVW R26,R30
	MOV  R30,R19
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	LD   R17,X
; 0001 0034                 break;
	RJMP _0x2000E
; 0001 0035             }
; 0001 0036         }
_0x2000F:
	SUBI R19,-1
	RJMP _0x2000D
_0x2000E:
; 0001 0037 
; 0001 0038         *keypad->rowPins[r].PORT |= (1 << keypad->rowPins[r].pinNumber);
	RCALL SUBOPT_0x7
	MOVW R24,R30
	RCALL SUBOPT_0x8
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R18
	MOVW R26,R24
	ST   X,R30
; 0001 0039         if (detectedKey) break;
	CPI  R17,0
	BRNE _0x2000B
; 0001 003A     }
	SUBI R16,-1
	RJMP _0x2000A
_0x2000B:
; 0001 003B 
; 0001 003C     if (detectedKey)
	CPI  R17,0
	BRNE PC+2
	RJMP _0x20011
; 0001 003D     {
; 0001 003E         if (detectedKey != keypad->lastKey)
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R30,Z+12
	CP   R30,R17
	BREQ _0x20012
; 0001 003F         {
; 0001 0040             keypad->debounceCounter++;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,13
	RCALL SUBOPT_0x9
; 0001 0041             if (keypad->debounceCounter >= DEBOUNCE_TICKS)
	LDD  R26,Z+13
	LDD  R27,Z+14
	SBIW R26,3
	BRLO _0x20013
; 0001 0042             {
; 0001 0043                 keypad->lastKey = detectedKey;
	MOV  R30,R17
	__PUTB1SNS 4,12
; 0001 0044                 keypad->debounceCounter = 0;
	RCALL SUBOPT_0xA
; 0001 0045                 keypad->repeatCounter = 0;
	RCALL SUBOPT_0x1
; 0001 0046                 if (keypad->onKeyPressed) keypad->onKeyPressed(detectedKey);
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,8
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x20014
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__GETWRZ 0,1,8
	MOV  R26,R17
	MOVW R30,R0
	ICALL
; 0001 0047             }
_0x20014:
; 0001 0048         } else
_0x20013:
	RJMP _0x20015
_0x20012:
; 0001 0049         {
; 0001 004A             keypad->debounceCounter = 0;
	RCALL SUBOPT_0xA
; 0001 004B             keypad->repeatCounter++;
	ADIW R26,15
	RCALL SUBOPT_0x9
; 0001 004C             if (keypad->repeatCounter == REPEAT_START ||
; 0001 004D                 (keypad->repeatCounter > REPEAT_START &&
; 0001 004E                  (keypad->repeatCounter - REPEAT_START) % REPEAT_NEXT == 0))
	LDD  R26,Z+15
	LDD  R27,Z+16
	SBIW R26,50
	BREQ _0x20017
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Z+15
	LDD  R27,Z+16
	SBIW R26,51
	BRLO _0x20018
	LDD  R26,Z+15
	LDD  R27,Z+16
	SBIW R26,50
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __MODW21U
	SBIW R30,0
	BREQ _0x20017
_0x20018:
	RJMP _0x20016
_0x20017:
; 0001 004F             {
; 0001 0050                 if (keypad->onKeyRepeat) keypad->onKeyRepeat(detectedKey);
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,10
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2001B
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__GETWRZ 0,1,10
	MOV  R26,R17
	MOVW R30,R0
	ICALL
; 0001 0051             }
_0x2001B:
; 0001 0052         }
_0x20016:
_0x20015:
; 0001 0053     } else
	RJMP _0x2001C
_0x20011:
; 0001 0054     {
; 0001 0055         keypad->lastKey = 0;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,12
	LDI  R30,LOW(0)
	ST   X,R30
; 0001 0056         keypad->debounceCounter = 0;
	RCALL SUBOPT_0xA
; 0001 0057         keypad->repeatCounter = 0;
	RCALL SUBOPT_0x1
; 0001 0058     }
_0x2001C:
; 0001 0059 }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;
;void SetCallback_MatrixKeypad(MatrixKeypad_t* keypad, void (*callback)(char))
; 0001 005C {
_SetCallback_MatrixKeypad:
; .FSTART _SetCallback_MatrixKeypad
; 0001 005D     keypad->onKeyPressed = callback;
	ST   -Y,R27
	ST   -Y,R26
;	*keypad -> Y+2
;	*callback -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	__PUTW1SNS 2,8
; 0001 005E }
	ADIW R28,4
	RET
; .FEND
;
;void SetRepeatCallback_MatrixKeypad(MatrixKeypad_t* keypad, void (*callback)(char))
; 0001 0061 {
; 0001 0062     keypad->onKeyRepeat = callback;
;	*keypad -> Y+2
;	*callback -> Y+0
; 0001 0063 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 2
	SBI  0x18,2
	__DELAY_USB 2
	CBI  0x18,2
	__DELAY_USB 2
	RJMP _0x2020001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 17
	RJMP _0x2020001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0xB
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0xB
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2020001
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2020001
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x200000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xC
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
_keypadTable_2:
	.BYTE 0x10
_rowPins:
	.BYTE 0x1C
_colPins:
	.BYTE 0x1C
_keypad2:
	.BYTE 0x11
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ADIW R26,15
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	MOV  R30,R17
	LDI  R31,0
	__GETWRS 22,23,7
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R0,R30
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	LD   R24,Z
	MOVW R30,R0
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,6
	LD   R30,X
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	MOV  R30,R17
	LDI  R31,0
	__GETWRS 22,23,5
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R0,R30
	MOVW R26,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	MOVW R30,R0
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,6
	LD   R30,X
	LDI  R26,LOW(1)
	CALL __LSLB12
	COM  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Z+2
	LDD  R27,Z+3
	MOV  R30,R16
	LDI  R31,0
	MOVW R22,R26
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __MULW12U
	MOVW R0,R30
	MOVW R26,R22
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LD   R18,Z
	MOVW R30,R0
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,6
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,13
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
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

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
