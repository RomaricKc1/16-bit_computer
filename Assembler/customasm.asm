#bits 16

#subruledef reg {
    r0  =>  0x0
    r1  =>  0x1
    r2  =>  0x2
    r3  =>  0x3
    r4  =>  0x4
    r5  =>  0x5
}

; STORE OPCODES
op_sta = 0xd
op_stb = 0xe
op_stc = 0xf
op_std = 0x10
op_ste = 0x11



; LOAD OPCODES
op_lda = 0x1
op_ldb = 0x2
op_ldc = 0x3
op_ldd = 0x4
op_lde = 0x5

op_ldi = 0x18
op_ldii = 0x19


; ARITH OPCODES
op_add = 0x9
op_sub = 0xa
op_mult = 0xb
op_div = 0xc


; CTRL FLOW
op_jump = 0x15
op_jumpc = 0x16
op_jumpz = 0x17


; ROUTINES
op_push = 0x7
op_pop = 0x8
op_peek = 0x13
op_poke = 0x14
op_ssp = 0x1c
op_bl = 0x1e
op_ret = 0x1d


; MISCS
op_mout = 0x1a
op_mov = 0x1b
op_nop = 0x1f

op_curs = 0x12
op_disp = 0x6

; rules for the ISA : 
;  00000   000  0000  0000
;   OP          ADDR
; mult r3, r4  => 01011   000   0011  0100
#ruledef {


    ; ARITH OPCODES (4)
    add  {rd:reg}, {rs:reg} => op_add`5  @ 0`3 @ rd`4 @ rs`4
    sub  {rd:reg}, {rs:reg} => op_sub`5  @ 0`3 @ rd`4 @ rs`4
    mult {rd:reg}, {rs:reg} => op_mult`5 @ 0`3 @ rd`4 @ rs`4
    div  {rd:reg}, {rs:reg} => op_div`5  @ 0`3 @ rd`4 @ rs`4


    ; LOAD OPCODES (8)
    lda {address} => op_lda`5 @ address`11
    ldb {address} => op_ldb`5 @ address`11
    ldc {address} => op_ldc`5 @ address`11
    ldd {address} => op_ldd`5 @ address`11
    lde {address} => op_lde`5 @ address`11

    ldi  {literal} => op_ldi`5  @ literal`11
    ldii {literal} => op_ldii`5 @ literal`11
    

    ; STORE OPCODES (6)
    sta {address} => op_sta`5 @ address`11
    stb {address} => op_stb`5 @ address`11
    stc {address} => op_stc`5 @ address`11
    std {address} => op_std`5 @ address`11
    ste {address} => op_ste`5 @ address`11


    ; CTRL FLOW (3)
    jump  {address} => op_jump`5  @ address`11
    jumpc {address} => op_jumpc`5 @ address`11
    jumpz {address} => op_jumpz`5 @ address`11


    ; ROUTINES (7)
    push {rs:reg} => op_push`5 @ 0`3 @ 0`4 @ rs`4
    pop  {rd:reg} => op_pop`5  @ 0`3 @ 0`4 @ rd`4
    poke {literal}, {rs:reg} => op_poke`5 @ 0`3 @ literal`4 @ rs`4
    peek {literal}, {rd:reg} => op_peek`5 @ 0`3 @ literal`4 @ rd`4

    ssp {literal} => op_ssp`5 @ literal`11
    bl  {address}  => op_bl`5 @ address`11

    ret => op_ret`5 @ 0`11


    ; MISCS (3)
    mout  {address} => op_mout`5  @ address`11

    mov  {rd:reg}, {rs:reg} => op_mov`5  @ 0`3 @ rd`4 @ rs`4

    nop => op_nop`5 @ 0`11
	
	curs {literal_x}, {literal_y} => op_curs`5 @ 0`3 @ literal_x`5 @ literal_y`3
    disp {address} => op_disp`5 @ address`11




}

; Program here
; example
foo:
	sub r3, r4
	nop
