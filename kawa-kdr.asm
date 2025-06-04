; ------------------------------------------------------------------------
; Compiled by MSX-BACON from kawa-kdr.bas
; ------------------------------------------------------------------------
; 
WORK_H_TIMI                     = 0X0FD9F
WORK_H_ERRO                     = 0X0FFB1
WORK_HIMEM                      = 0X0FC4A
WORK_MAXFIL                     = 0X0F85F
WORK_TXTTAB                     = 0X0F676
WORK_VARTAB                     = 0X0F6C2
WORK_USRTAB                     = 0X0F39A
BIOS_NEWSTT                     = 0X04601
FILE_INFO_SIZE                  = 37 + 3 * 16
BLIB_INIT_NCALBAS               = 0X0404E
BIOS_SYNTAX_ERROR               = 0X4055
BIOS_CALSLT                     = 0X001C
BIOS_ENASLT                     = 0X0024
WORK_MAINROM                    = 0XFCC1
WORK_BLIBSLOT                   = 0XF3D3
SIGNATURE                       = 0X4010
WORK_GRPACX                     = 0XFCB7
WORK_GRPACY                     = 0XFCB9
WORK_ROMVER                     = 0X0002D
BIOS_CHGMOD                     = 0X0005F
BIOS_CHGMODP                    = 0X001B5
BIOS_EXTROM                     = 0X0015F
BLIB_WIDTH                      = 0X0403C
BIOS_ERAFNK                     = 0X000CC
BIOS_CLS                        = 0X000C3
WORK_DAC                        = 0X0F7F6
WORK_VALTYP                     = 0X0F663
BIOS_FRCDBL                     = 0X0303A
BIOS_POSIT                      = 0X000C6
WORK_CSRY                       = 0X0F3DC
WORK_CSRX                       = 0X0F3DD
WORK_CSRSW                      = 0X0FCA9
WORK_PRTFLG                     = 0X0F416
BIOS_FRCINT                     = 0X02F8A
BLIB_FILE_PUTS                  = 0X040ED
WORK_PTRFIL                     = 0X0F864
BIOS_VMOVFM                     = 0X02F08
BIOS_RND                        = 0X02BDF
BIOS_MAF                        = 0X02C4D
BIOS_DECMUL                     = 0X027E6
BIOS_DECADD                     = 0X0269A
BIOS_VMOVAM                     = 0X02EEF
BIOS_XDCOMP                     = 0X02F5C
BIOS_GTSTCK                     = 0X00D5
BIOS_ICOMP                      = 0X02F4D
BIOS_DECSUB                     = 0X0268C
WORK_ARG                        = 0X0F847
BIOS_FCOMP                      = 0X02F21
BIOS_RDVRM                      = 0X004A
BIOS_NRDVRM                     = 0X0174
WORK_SCRMOD                     = 0XFCAF
BIOS_ERRHAND                    = 0X0406F
WORK_FILTAB                     = 0XF860
WORK_ERRFLG                     = 0X0F414
; BSAVE header -----------------------------------------------------------
        DEFB        0xfe
        DEFW        start_address
        DEFW        end_address
        DEFW        start_address
        ORG         0X8010
START_ADDRESS:
        LD          HL, 0X8001
        LD          [WORK_TXTTAB], HL
        LD          HL, 0
        LD          [0X8001], HL
        LD          [0X8002], HL
        LD          HL, [WORK_USRTAB + 0]
        LD          [SVARI_USR0_BACKUP], HL
        LD          HL, HEAP_START
        LD          [WORK_VARTAB], HL
        LD          HL, _BASIC_START
        CALL        BIOS_NEWSTT
_BASIC_START_RET:
        LD          HL, [SVARI_USR0_BACKUP]
        LD          [WORK_USRTAB + 0], HL
        LD          A, 1
        LD          [WORK_MAXFIL], A
        LD          SP, [WORK_HIMEM]
        CALL        CHECK_BLIB
        JP          NZ, BIOS_SYNTAX_ERROR
        LD          IX, BLIB_INIT_NCALBAS
        CALL        CALL_BLIB
        LD          HL, WORK_H_TIMI
        LD          DE, H_TIMI_BACKUP
        LD          BC, 5
        LDIR        
        DI          
        CALL        SETUP_H_TIMI
        LD          DE, PROGRAM_START
        JP          PROGRAM_RUN
SETUP_H_TIMI:
        LD          HL, H_TIMI_HANDLER
        LD          [WORK_H_TIMI + 1], HL
        LD          A, 0XC3
        LD          [WORK_H_TIMI], A
        RET         
SETUP_H_ERRO:
        LD          HL, WORK_H_ERRO
        LD          DE, H_ERRO_BACKUP
        LD          BC, 5
        LDIR        
        LD          HL, H_ERRO_HANDLER
        LD          [WORK_H_ERRO + 1], HL
        LD          A, 0XC3
        LD          [WORK_H_ERRO], A
        RET         
JP_HL:
        JP          HL
_BASIC_START:
        DEFB        ':', 0xCD, 0xB7, 0xEF, 0x11, ':', 0x97, 0xDD, 0xEF, 0x0C
        DEFW        _BASIC_START_RET
        DEFB        ':', 'A', 0xEF, 0xDD, '(', 0x11, ')', 0x00
PROGRAM_START:
LINE_10:
        LD          HL, 1
        LD          A, [WORK_ROMVER]
        OR          A, A
        LD          A, L
        JR          NZ, _PT0
        CALL        BIOS_CHGMOD
        JR          _PT1
_PT0:
        LD          IX, BIOS_CHGMODP
        CALL        BIOS_EXTROM
        EI          
_PT1:
        LD          HL, 32
        LD          IX, BLIB_WIDTH
        CALL        CALL_BLIB
        CALL        BIOS_ERAFNK
        XOR         A, A
        CALL        BIOS_CLS
        LD          HL, VARD_X
        PUSH        HL
        LD          HL, 15
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
LINE_20:
        LD          HL, VARD_X
        LD          DE, WORK_DAC
        LD          BC, 8
        LDIR        
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          H, L
        INC         H
        LD          A, 6
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_1
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
LINE_30:
        LD          HL, 1
        LD          A, 2
        LD          [WORK_VALTYP], A
        LD          [WORK_DAC + 2], HL
        CALL        BIOS_FRCDBL
        CALL        BIOS_RND
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 32
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECMUL
        LD          A, 8
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          H, L
        INC         H
        LD          A, 24
        LD          L, A
        CALL        BIOS_POSIT
        XOR         A, A
        LD          [WORK_PRTFLG], A
        LD          H, A
        LD          L, A
        LD          [WORK_PTRFIL], HL
        LD          HL, STR_3
        CALL        PUTS
        LD          HL, STR_2
        CALL        PUTS
LINE_35:
        LD          HL, VARD_I
        PUSH        HL
        LD          HL, 0
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, SVARD_I_FOR_END
        PUSH        HL
        LD          HL, 50
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, SVARD_I_FOR_STEP
        EX          DE, HL
        LD          HL, CONST_4110000000000000
        CALL        LD_DE_DOUBLE_REAL
        LD          HL, _PT3
        LD          [SVARD_I_LABEL], HL
        JR          _PT2
_PT3:
        LD          A, 8
        LD          [WORK_VALTYP], A
        LD          HL, VARD_I
        CALL        BIOS_VMOVFM
        LD          HL, SVARD_I_FOR_STEP
        CALL        BIOS_VMOVAM
        CALL        BIOS_DECADD
        LD          HL, WORK_DAC
        LD          DE, VARD_I
        LD          BC, 8
        LDIR        
        LD          HL, SVARD_I_FOR_END
        CALL        BIOS_VMOVAM
        LD          A, [SVARD_I_FOR_STEP]
        RLCA        
        JR          C, _PT4
        CALL        BIOS_XDCOMP
        DEC         A
        JR          NZ, _PT5
        RET         
_PT4:
        CALL        BIOS_XDCOMP
        INC         A
        RET         Z
_PT5:
        POP         HL
_PT2:
        LD          HL, [SVARD_I_LABEL]
        CALL        JP_HL
LINE_36:
        LD          HL, VARD_X
        PUSH        HL
        CALL        PUSH_DOUBLE_REAL_HL
        XOR         A, A
        CALL        BIOS_GTSTCK
        LD          L, A
        LD          H, 0
        EX          DE, HL
        LD          HL, 3
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECSUB
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        XOR         A, A
        CALL        BIOS_GTSTCK
        LD          L, A
        LD          H, 0
        EX          DE, HL
        LD          HL, 7
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        LD          H, A
        LD          L, A
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECADD
        LD          HL, WORK_DAC
        POP         DE
        CALL        LD_DE_DOUBLE_REAL
LINE_39:
        LD          HL, VARD_X
        CALL        LD_ARG_DOUBLE_REAL
        LD          HL, 6144
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_DECADD
        LD          HL, WORK_DAC
        CALL        PUSH_DOUBLE_REAL_HL
        LD          HL, 160
        LD          [WORK_DAC + 2], HL
        LD          A, 2
        LD          [WORK_VALTYP], A
        CALL        BIOS_FRCDBL
        CALL        BIOS_MAF
        CALL        POP_DOUBLE_REAL_DAC
        CALL        BIOS_DECADD
        LD          HL, WORK_DAC
        CALL        CONVERT_TO_INTEGER_FROM_DOUBLE_REAL
        LD          A, [WORK_SCRMOD]
        CP          A, 5
        JR          NC, _PT8
        CALL        BIOS_RDVRM
        LD          L, A
        LD          H, 0
        JR          _PT9
_PT8:
        CALL        BIOS_NRDVRM
        LD          L, A
        LD          H, 0
_PT9:
        EX          DE, HL
        LD          HL, 32
        CALL        BIOS_ICOMP
        AND         A, 1
        DEC         A
        CPL         
        LD          H, A
        LD          L, A
        LD          A, L
        OR          A, H
        JP          Z, _PT7
        JP          program_termination
        JP          _PT6
_PT7:
_PT6:
LINE_40:
        JP          LINE_20
PROGRAM_TERMINATION:
        CALL        SUB_TERMINATION
        LD          SP, [WORK_HIMEM]
        LD          HL, _BASIC_END
        JP          BIOS_NEWSTT
SUB_TERMINATION:
        XOR         A, A
        LD          [WORK_MAXFIL], A
        LD          HL, [WORK_HIMEM]
        LD          DE, 267
        SBC         HL, DE
        LD          [WORK_FILTAB], HL
        LD          L, E
        LD          H, D
        INC         DE
        INC         DE
        LD          [HL], E
        INC         HL
        CALL        RESTORE_H_ERRO
        CALL        RESTORE_H_TIMI
        LD          HL, 0X8001
        LD          [WORK_TXTTAB], HL
        RET         
_BASIC_END:
        DEFB        ':', 0x92, ':', 0x94, ':', 0x81, 0x00
ERR_RETURN_WITHOUT_GOSUB:
        LD          E, 3
        JP          BIOS_ERRHAND
CHECK_BLIB:
        LD          A, [WORK_BLIBSLOT]
        LD          H, 0X40
        CALL        BIOS_ENASLT
        LD          BC, 8
        LD          HL, SIGNATURE
        LD          DE, SIGNATURE_REF
_CHECK_BLIB_LOOP:
        LD          A, [DE]
        INC         DE
        CPI         
        JR          NZ, _CHECK_BLIB_EXIT
        JP          PE, _CHECK_BLIB_LOOP
_CHECK_BLIB_EXIT:
        PUSH        AF
        LD          A, [WORK_MAINROM]
        LD          H, 0X40
        CALL        BIOS_ENASLT
        EI          
        POP         AF
        RET         
SIGNATURE_REF:
        DEFB        "BACONLIB"
CALL_BLIB:
        LD          IY, [WORK_BLIBSLOT - 1]
        CALL        BIOS_CALSLT
        EI          
        RET         
LD_DE_DOUBLE_REAL:
        LD          BC, 8
        LDIR        
        RET         
PUTS:
        LD          B, [HL]
        INC         B
        DEC         B
        RET         Z
_PUTS_LOOP:
        INC         HL
        LD          A, [HL]
        RST         0X18
        DJNZ        _PUTS_LOOP
        RET         
FREE_STRING:
        LD          DE, HEAP_START
        RST         0X20
        RET         C
        LD          DE, [HEAP_NEXT]
        RST         0X20
        RET         NC
        LD          C, [HL]
        LD          B, 0
        INC         BC
        JP          FREE_HEAP
FREE_HEAP:
        PUSH        HL
        ADD         HL, BC
        LD          [HEAP_MOVE_SIZE], BC
        LD          [HEAP_REMAP_ADDRESS], HL
        EX          DE, HL
        LD          HL, [HEAP_NEXT]
        SBC         HL, DE
        LD          C, L
        LD          B, H
        POP         HL
        EX          DE, HL
        LD          A, C
        OR          A, B
        JR          Z, _FREE_HEAP_LOOP0
        LDIR        
_FREE_HEAP_LOOP0:
        LD          [HEAP_NEXT], DE
        LD          HL, VARS_AREA_START
_FREE_HEAP_LOOP1:
        LD          DE, VARSA_AREA_END
        RST         0X20
        JR          NC, _FREE_HEAP_LOOP1_END
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        HL
        LD          HL, [HEAP_REMAP_ADDRESS]
        EX          DE, HL
        RST         0X20
        JR          C, _FREE_HEAP_LOOP1_NEXT
        LD          DE, [HEAP_MOVE_SIZE]
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        DEC         HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        PUSH        HL
_FREE_HEAP_LOOP1_NEXT:
        POP         HL
        INC         HL
        JR          _FREE_HEAP_LOOP1
_FREE_HEAP_LOOP1_END:
        LD          HL, VARSA_AREA_START
_FREE_HEAP_LOOP2:
        LD          DE, VARSA_AREA_END
        RST         0X20
        RET         NC
        LD          E, [HL]
        LD          A, E
        INC         HL
        LD          D, [HL]
        OR          A, D
        INC         HL
        JR          Z, _FREE_HEAP_LOOP2
        PUSH        HL
        EX          DE, HL
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        LD          C, [HL]
        INC         HL
        LD          B, 0
        ADD         HL, BC
        ADD         HL, BC
        EX          DE, HL
        SBC         HL, BC
        SBC         HL, BC
        RR          H
        RR          L
        LD          C, L
        LD          B, H
        EX          DE, HL
_FREE_HEAP_SARRAY_ELEMENTS:
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        HL
        LD          HL, [HEAP_REMAP_ADDRESS]
        EX          DE, HL
        RST         0X20
        JR          C, _FREE_HEAP_LOOP2_NEXT
        LD          DE, [HEAP_MOVE_SIZE]
        SBC         HL, DE
        POP         DE
        EX          DE, HL
        DEC         HL
        LD          [HL], E
        INC         HL
        LD          [HL], D
        PUSH        HL
_FREE_HEAP_LOOP2_NEXT:
        POP         HL
        INC         HL
        DEC         BC
        LD          A, C
        OR          A, B
        JR          NZ, _FREE_HEAP_SARRAY_ELEMENTS
        POP         HL
        JR          _FREE_HEAP_LOOP2
PUSH_DOUBLE_REAL_HL:
        POP         BC
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        PUSH        DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        PUSH        DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        INC         HL
        PUSH        DE
        LD          E, [HL]
        INC         HL
        LD          D, [HL]
        PUSH        DE
        PUSH        BC
        RET         
POP_DOUBLE_REAL_DAC:
        POP         BC
        POP         HL
        LD          [WORK_DAC+6], HL
        POP         HL
        LD          [WORK_DAC+4], HL
        POP         HL
        LD          [WORK_DAC+2], HL
        POP         HL
        LD          [WORK_DAC+0], HL
        LD          A, 8
        LD          [WORK_VALTYP], A
        PUSH        BC
        RET         
LD_ARG_DOUBLE_REAL:
        LD          DE, WORK_ARG
        LD          BC, 8
        LDIR        
        RET         
LD_DAC_DOUBLE_REAL:
        LD          DE, WORK_DAC
        LD          BC, 8
        LD          A, C
        LD          [WORK_VALTYP], A
        LDIR        
        RET         
CONVERT_TO_INTEGER:
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        RET         
CONVERT_TO_INTEGER_FROM_DOUBLE_REAL:
        CALL        LD_DAC_DOUBLE_REAL
        LD          BC, 0X3245
        LD          DE, 0X8076
        CALL        BIOS_FCOMP
        INC         A
        JR          Z, CONVERT_TO_INTEGER
        LD          HL, CONST_45327680
        CALL        LD_ARG_DOUBLE_REAL
        CALL        BIOS_DECSUB
        CALL        BIOS_FRCINT
        LD          HL, [WORK_DAC + 2]
        LD          A, H
        XOR         A, 0X80
        LD          H, A
        RET         
PROGRAM_RUN:
        LD          HL, HEAP_START
        LD          [HEAP_NEXT], HL
        LD          SP, [WORK_HIMEM]
        LD          HL, ERR_RETURN_WITHOUT_GOSUB
        PUSH        HL
        PUSH        DE
        LD          DE, 256
        XOR         A, A
        LD          HL, [WORK_HIMEM]
        SBC         HL, DE
        LD          [HEAP_END], HL
        DI          
        CALL        SETUP_H_ERRO
        EI          
        LD          HL, VAR_AREA_START
        LD          DE, VAR_AREA_START + 1
        LD          BC, VARSA_AREA_END - VAR_AREA_START - 1
        LD          [HL], 0
        LDIR        
        RET         
; H.TIMI PROCESS -----------------
H_TIMI_HANDLER:
        JP          H_TIMI_BACKUP
RESTORE_H_TIMI:
        DI          
        LD          HL, H_TIMI_BACKUP
        LD          DE, WORK_H_TIMI
        LD          BC, 5
        LDIR        
        EI          
        RET         
RESTORE_H_ERRO:
        DI          
        LD          HL, H_ERRO_BACKUP
        LD          DE, WORK_H_ERRO
        LD          BC, 5
        LDIR        
        EI          
_CODE_RET:
        RET         
H_ERRO_HANDLER:
        PUSH        HL
        PUSH        DE
        PUSH        BC
        CALL        RESTORE_H_TIMI
        CALL        RESTORE_H_ERRO
        CALL        SUB_TERMINATION
        POP         BC
        POP         DE
        POP         HL
        JP          WORK_H_ERRO
CONST_45327680:
        DEFB        0X45, 0X32, 0X76, 0X80
CONST_4110000000000000:
        DEFB        0X41, 0X10, 0X00, 0X00, 0X00, 0X00, 0X00, 0X00
STR_0:
        DEFB        0X00
STR_1:
        DEFB        0X01, 0X4F
STR_2:
        DEFB        0X02, 0X0D, 0X0A
STR_3:
        DEFB        0X01, 0X2A
HEAP_NEXT:
        DEFW        0
HEAP_END:
        DEFW        0
HEAP_MOVE_SIZE:
        DEFW        0
HEAP_REMAP_ADDRESS:
        DEFW        0
VAR_AREA_START:
SVARD_I_FOR_END:
        DEFW        0, 0, 0, 0
SVARD_I_FOR_STEP:
        DEFW        0, 0, 0, 0
SVARD_I_LABEL:
        DEFW        0
SVARI_USR0_BACKUP:
        DEFW        0
VARD_I:
        DEFW        0, 0, 0, 0
VARD_X:
        DEFW        0, 0, 0, 0
VAR_AREA_END:
VARS_AREA_START:
VARS_AREA_END:
VARA_AREA_START:
VARA_AREA_END:
VARSA_AREA_START:
VARSA_AREA_END:
H_TIMI_BACKUP:
        DEFB        0, 0, 0, 0, 0
H_ERRO_BACKUP:
        DEFB        0, 0, 0, 0, 0
HEAP_START:
END_ADDRESS:
