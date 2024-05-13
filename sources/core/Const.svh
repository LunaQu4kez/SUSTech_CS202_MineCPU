// Bus Widths
`define DATA_WID    31:0
`define FUNC3_WID   14:12
`define FUNC7_WID   31:25
`define REGS_WID     4:0
`define OP_WID       6:0
`define ALUOP_WID    3:0
`define ALUSRC_WID   1:0
`define BRUOP_WID    2:0
`define FW_WID       1:0
`define CTRL_WID    16:0
`define EX_CTRL_WID  9:0
`define MEM_CTRL_WID 4:0
`define WB_CTRL_WID  1:0
`define LDST_WID     2:0
`define LED_WID      7:0
`define SWCH_WID     7:0
`define BHT_WID      1:0
`define MUL_WID     63:0
// Opcode
`define ART_LOG_OP 7'b0110011  // R type
`define ART_IMM_OP 7'b0010011  // I type
`define LOAD_OP    7'b0000011  // I type
`define STORE_OP   7'b0100011  // S type for sb, sh, sw, I type for sd
`define BRANCH_OP  7'b1100011  // B type (SB type)
`define JALR_OP    7'b1100111  // I type
`define JAL_OP     7'b1101111  // J type (UJ type)
`define LUI_OP     7'b0110111  // U type
`define AUIPC_OP   7'b0010111  // U type
`define ECALL_OP   7'b1110011  // I type
`define SRET_OP    7'b0001000
// ALU Control lines
`define ALU_AND    4'b0000
`define ALU_OR     4'b0001
`define ALU_XOR    4'b0010
`define ALU_ADD    4'b0011
`define ALU_SUB    4'b0100
`define ALU_SLL    4'b0101
`define ALU_SRL    4'b0110
`define ALU_SRA    4'b0111
`define ALU_SLT    4'b1000
`define ALU_SLTU   4'b1001
`define ALU_MUL    4'b1010
`define ALU_MULH   4'b1011 
`define ALU_MULHSU 4'b1100 
`define ALU_MULHU  4'b1101
`define ALU_DIV    4'b1110 
`define ALU_REM    4'b1111 
// Funct3 list
`define ADD_FUNC3    3'b000
`define SLL_FUNC3    3'b001
`define SLT_FUNC3    3'b010
`define SLTU_FUNC3   3'b011
`define XOR_FUNC3    3'b100
`define SRL_FUNC3    3'b101
`define OR_FUNC3     3'b110
`define AND_FUNC3    3'b111
`define MUL_FUNC3    3'b000 
`define MULH_FUNC3   3'b001 
`define MULHSU_FUNC3 3'b010 
`define MULHU_FUNC3  3'b011
`define DIV_FUNC3    3'b100 
`define REM_FUNC3    3'b110  
`define BEQ_FUNC3    3'b000
`define BNE_FUNC3    3'b001
`define BLT_FUNC3    3'b100
`define BGE_FUNC3    3'b101
`define BLTU_FUNC3   3'b110
`define BGEU_FUNC3   3'b111
`define LB_FUNC3     3'b000
`define LH_FUNC3     3'b001
`define LW_FUNC3     3'b010
`define LBU_FUNC3    3'b100
`define LHU_FUNC3    3'b101
`define SB_FUNC3     3'b000
`define SH_FUNC3     3'b001
`define SW_FUNC3     3'b010
// Branch Control lines
`define BRU_NOP    3'b000
`define BRU_EQ     3'b001
`define BRU_NE     3'b010
`define BRU_LT     3'b011
`define BRU_GE     3'b100
`define BRU_LTU    3'b101
`define BRU_GEU    3'b110
`define BRU_JMP    3'b111
// Load Store op
`define LB_OP      3'b000
`define LH_OP      3'b001
`define LW_OP      3'b010
`define LBU_OP     3'b011
`define LHU_OP     3'b100
`define SB_OP      3'b101
`define SH_OP      3'b110
`define SW_OP      3'b111
// Address and gp register
`define MMIO_ADDR  32'hffffff00
`define STAK_ADDR  32'h00007ffc
`define EXCP_ADDR  32'h1c090000
// VGA
`define INFO_WID   7:0
`define INFO_NUM   0:3071  // 96*32
`define COLOR_WID  3:0
`define VGA_ADDR  11:0
`define H_SYNC_PULSE 11'd128
`define H_BACK_PORCH 11'd88
`define H_ACTIVE_TIME 11'd800
`define H_FRONT_PORCH 11'd40
`define H_LINE_PERIOD 11'd1056
`define V_SYNC_PULSE 11'd4
`define V_BACK_PORCH 11'd23
`define V_ACTIVE_TIME 11'd60
`define V_FRONT_PORCH 11'd1
`define V_FRAME_PERIOD 11'd623
// VGA color
`define BLACK_R 4'h0
`define BLACK_G 4'h0
`define BLACK_B 4'h0
`define WHITH_R 4'hf
`define WHITH_G 4'hf
`define WHITH_B 4'hf
`define YELLOW_R 4'hf
`define YELLOW_G 4'he
`define YELLOW_B 4'h8
`define RED_R 4'hf
`define RED_G 4'h6
`define RED_B 4'h4
`define PINK_R 4'hf
`define PINK_G 4'hc
`define PINK_B 4'hc
`define ORANGE_R 4'hf
`define ORANGE_G 4'ha
`define ORANGE_B 4'h4
`define LBLUE_R 4'hb
`define LBLUE_G 4'he
`define LBLUE_B 4'hE
`define DBLUE_R 4'h5
`define DBLUE_G 4'h7
`define DBLUE_B 4'he
// Keyboard related
`define KBPIN_WID  7:0
`define KBCODE_WID 4:0 
// UART related
`define BPS_CNT 868
`define MAX_DATA 32'h7ffffffc
`define MAX_IDLE 16'hffff
// VGA chars
`define CHAR_0   128'h00000000000000000000000000000000  // left of a point
`define CHAR_1   128'h00000000000000010100000000000000  // left of a point
`define CHAR_2   128'h00000000000000808000000000000000  // right of a point
`define CHAR_3   128'h071f3f7f7fffffffffffff7f7f3f1f07  // left of a circle
`define CHAR_4   128'he0f8fcfefefffffffffffffefefcf8e0  // right of a circle
`define CHAR_5   128'he0f8fcf8f0e0c08080c0e0f0f8fcf8e0  // right mouth
`define CHAR_6   128'h071f3f1f0f0703010103070f1f3f1f07  // left mouth
`define CHAR_7   128'h0000207078fcfeffffffff7f7f3f1f07  // left of up mouth
`define CHAR_8   128'h0000040e1e3f7ffffffffffefefcf8e0  // right of up mouth
`define CHAR_9   128'h071f3f7f7ffffffffffefc7870200000  // left of down mouth
`define CHAR_10   128'he0f8fcfefeffffffff7f3f1e0e040000  // right of down mouth
`define CHAR_11  128'h030f3f3f7f67677f7f7f7f7f7f666644  // left of ghost
`define CHAR_12  128'hc0f0fcfcfee6e6fefefefefefe666622  // right of ghost

`define CHAR_32  128'hffffffffffffffffffffffffffffffff  // 0x20: (space)
`define CHAR_33  128'h00000010383838101010100010000000  // 0x21: !
`define CHAR_34  128'h00000028282800000000000000000000  // 0x22: "
`define CHAR_35  128'h00000024247e242424247e2424000000  // 0x23: #
`define CHAR_36  128'h0000107c929090701c1212927c100000  // 0x24: $
`define CHAR_37  128'h00000044a44808101020242a44000000  // 0x25: %
`define CHAR_38  128'h0000003048484830528a84847a000000  // 0x26: &
`define CHAR_39  128'h00000010101000000000000000000000  // 0x27: '
`define CHAR_40  128'h00000408081010101010101008080400  // 0x28: (
`define CHAR_41  128'h00004020201010101010101020204000  // 0x29: )
`define CHAR_42  128'h00000000000010543854100000000000  // 0x2a: *
`define CHAR_43  128'h00000000000010107c10100000000000  // 0x2b: +
`define CHAR_44  128'h00000000000000000000001818081000  // 0x2c: ,
`define CHAR_45  128'h00000000000000007c00000000000000  // 0x2d: -
`define CHAR_46  128'h00000000000000000000001818000000  // 0x2e: .
`define CHAR_47  128'h00000404080808101010202020404000  // 0x2f: /

`define CHAR_48  128'h0000003c4242464a526242423c000000  // 0x30: 0
`define CHAR_49  128'h0000000818280808080808083e000000  // 0x31: 1
`define CHAR_50  128'h0000003c42020204081020407e000000  // 0x32: 2
`define CHAR_51  128'h0000003c4202021c020202423c000000  // 0x33: 3
`define CHAR_52  128'h0000000c1414242444447e0404000000  // 0x34: 4
`define CHAR_53  128'h0000007e4040407c020202423c000000  // 0x35: 5
`define CHAR_54  128'h0000003c4240407c424242423c000000  // 0x36: 6
`define CHAR_55  128'h0000007e020204040408080808000000  // 0x37: 7
`define CHAR_56  128'h0000003c4242423c424242423c000000  // 0x38: 8
`define CHAR_57  128'h0000003c424242423e0202423c000000  // 0x39: 9
`define CHAR_58  128'h00000000000018180000001818000000  // 0x3a: :
`define CHAR_59  128'h00000000000018180000001818081000  // 0x3b: ;
`define CHAR_60  128'h00000000000408102010040800000000  // 0x3c: <
`define CHAR_61  128'h000000000000007c007c000000000000  // 0x3d: =
`define CHAR_62  128'h00000000002010080408102000000000  // 0x3e: >
`define CHAR_63  128'h0000003c424202040808080008000000  // 0x3f: ?

`define CHAR_64  128'h0000003844829aaaaaaab680403c0000  // 0x40: @
`define CHAR_65  128'h0000001010282844447c828282000000  // 0x41: A
`define CHAR_66  128'h000000fc828282fc82828282fc000000  // 0x42: B
`define CHAR_67  128'h0000003c42808080808080423c000000  // 0x43: C
`define CHAR_68  128'h000000f88482828282828284f8000000  // 0x44: D
`define CHAR_69  128'h000000fe808080fc80808080fe000000  // 0x45: E
`define CHAR_70  128'h000000fe808080fc8080808080000000  // 0x46: F
`define CHAR_71  128'h0000003c428080808e8282423e000000  // 0x47: G
`define CHAR_72  128'h00000082828282fe8282828282000000  // 0x48: H
`define CHAR_73  128'h000000fe1010101010101010fe000000  // 0x49: I
`define CHAR_74  128'h00000002020202020282824438000000  // 0x4a: J
`define CHAR_75  128'h000000828498a0c0a090888482000000  // 0x4b: K
`define CHAR_76  128'h000000808080808080808080fe000000  // 0x4c: L
`define CHAR_77  128'h00000082c6c6aa928282828282000000  // 0x4d: M
`define CHAR_78  128'h00000082c2c2a292928a868682000000  // 0x4e: N
`define CHAR_79  128'h00000038448282828282824438000000  // 0x4f: O

`define CHAR_80  128'h000000fc82828282fc80808080000000  // 0x50: P
`define CHAR_81  128'h000000384482828282828a443a000000  // 0x51: Q
`define CHAR_82  128'h000000fc82828282fc90888482000000  // 0x52: R
`define CHAR_83  128'h0000007c828080700c0202827c000000  // 0x53: S
`define CHAR_84  128'h000000fe101010101010101010000000  // 0x54: T
`define CHAR_85  128'h00000082828282828282824438000000  // 0x55: U
`define CHAR_86  128'h00000082824444442828281010000000  // 0x56: V
`define CHAR_87  128'h00000092929292aaaaaa444444000000  // 0x57: W
`define CHAR_88  128'h00000082444428102844448282000000  // 0x58: X
`define CHAR_89  128'h00000082824444282810101010000000  // 0x59: Y
`define CHAR_90  128'h000000fe0204081010204080fe000000  // 0x5a: Z
`define CHAR_91  128'h00001c10101010101010101010101c00  // 0x5b: [
`define CHAR_92  128'h00004040202020101010080808040400  // 0x5c: '\'
`define CHAR_93  128'h00007010101010101010101010107000  // 0x5d: ]
`define CHAR_94  128'h00000010284400000000000000000000  // 0x5e: ^
`define CHAR_95  128'h000000000000000000000000000000fe  // 0x5f: _

`define CHAR_96  128'h00000020100800000000000000000000  // 0x60: `
`define CHAR_97  128'h0000000000003c02023e42423e000000  // 0x61: a
`define CHAR_98  128'h0000004040407c42424242427c000000  // 0x62: b
`define CHAR_99  128'h0000000000003c42404040423c000000  // 0x63: c
`define CHAR_100 128'h0000000202023e42424242423e000000  // 0x64: d
`define CHAR_101 128'h0000000000003c42427e40423c000000  // 0x65: e
`define CHAR_102 128'h0000000e10107e101010101010000000  // 0x66: f
`define CHAR_103 128'h0000000000003e42424242423e02023c  // 0x67: g
`define CHAR_104 128'h0000004040405c624242424242000000  // 0x68: h
`define CHAR_105 128'h0000000800007808080808087e000000  // 0x69: i
`define CHAR_106 128'h0000000400007c040404040404040478  // 0x6a: j
`define CHAR_107 128'h000000404040424c5060504846000000  // 0x6b: k
`define CHAR_108 128'h0000007010101010101010100e000000  // 0x6c: l
`define CHAR_109 128'h000000000000ec929292929292000000  // 0x6d: m
`define CHAR_110 128'h0000000000005c624242424242000000  // 0x6e: n
`define CHAR_111 128'h0000000000003c42424242423c000000  // 0x6f: o

`define CHAR_112 128'h0000000000007c42424242427c404040  // 0x30: p
`define CHAR_113 128'h0000000000003e42424242423e020202  // 0x31: q
`define CHAR_114 128'h0000000000005c624040404040000000  // 0x32: r
`define CHAR_115 128'h0000000000003c42403c02423c000000  // 0x33: s
`define CHAR_116 128'h0000001010107e10101010100e000000  // 0x34: t
`define CHAR_117 128'h0000000000004242424242463a000000  // 0x35: u
`define CHAR_118 128'h00000000000082824444282810000000  // 0x36: v
`define CHAR_119 128'h000000000000929292aaaa4444000000  // 0x37: w
`define CHAR_120 128'h00000000000082442810824482000000  // 0x38: x
`define CHAR_121 128'h000000000000828244442828101020c0  // 0x39: y
`define CHAR_122 128'h0000000000007e02041820407e000000  // 0x3a: z
`define CHAR_123 128'h00000c10101010102010101010100c00  // 0x3b: {
`define CHAR_124 128'h00001010101010101010101010101000  // 0x3c: |
`define CHAR_125 128'h00006010101010100810101010106000  // 0x3d: }
`define CHAR_126 128'h0000000000000060920c000000000000  // 0x3e: ~
// Seg 7 tube constant
`define SEG_FREQ 200000      // 500Hz
`define SEG0 8'b1111_1100    // Display '0'
`define SEG1 8'b0110_0000    // Display '1'
`define SEG2 8'b1101_1010    // Display '2'
`define SEG3 8'b1111_0010    // Display '3'
`define SEG4 8'b0110_0110    // Display '4'
`define SEG5 8'b1011_0110    // Display '5'
`define SEG6 8'b1011_1110    // Display '6'
`define SEG7 8'b1110_0000    // Display '7'
`define SEG8 8'b1111_1110    // Display '8'
`define SEG9 8'b1111_0110    // Display '9'
`define SEGA 8'b1110_1110    // Display 'A'
`define SEGB 8'b0011_1110    // Display 'B'
`define SEGC 8'b1001_1100    // Display 'C'
`define SEGD 8'b0111_1010    // Display 'D'
`define SEGE 8'b1001_1110    // Display 'E'
`define SEGF 8'b1000_1110    // Display 'F'

`define IN0 4'b0000      // Encode of '0'
`define IN1 4'b0001      // Encode of '1'
`define IN2 4'b0010      // Encode of '2'
`define IN3 4'b0011      // Encode of '3'
`define IN4 4'b0100      // Encode of '4'
`define IN5 4'b0101      // Encode of '5'
`define IN6 4'b0110      // Encode of '6'
`define IN7 4'b0111      // Encode of '7'
`define IN8 4'b1000      // Encode of '8'
`define IN9 4'b1001      // Encode of '9'
`define INA 4'b1010      // Encode of 'A'
`define INB 4'b1011      // Encode of 'B'
`define INC 4'b1100      // Encode of 'C'
`define IND 4'b1101      // Encode of 'D'
`define INE 4'b1110      // Encode of 'E'
`define INF 4'b1111      // Encode of 'F'
