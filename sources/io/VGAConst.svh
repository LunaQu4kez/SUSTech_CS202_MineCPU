`define INFO_WID  7:0
`define VGA_ADDR  11:0  // 96*32
`define COLOR_WID 4:0
// chars
`define CHAR_128 128'h00000018180000000000001818000000  // up: a point       down: a point
`define CHAR_129 128'h0000001818000000ffffffffffffffff  // up: a point       down: color block
`define CHAR_130 128'h0000001818000000003c787070783c00  // up: a point       down: right-pacman
`define CHAR_131 128'h0000001818000000000042667e7e3c00  // up: a point       down: up-pacman
`define CHAR_132 128'h0000001818000000003c1e0e0e1e3c00  // up: a point       down: left-pacman
`define CHAR_133 128'h0000001818000000003c7e7e66420000  // up: a point       down: down-pacman
`define CHAR_134 128'h0000001818000000003c7e7e7e7e3c00  // up: a point       down: circle-pacman
`define CHAR_135 128'h0000001818000000003c7e5a7e7e5a00  // up: a point       down: ghost

`define CHAR_136 128'hffffffffffffffff0000001818000000  // up: color block   down: a point
`define CHAR_137 128'hffffffffffffffffffffffffffffffff  // up: color block   down: color block
`define CHAR_138 128'hffffffffffffffff003c787070783c00  // up: color block   down: right-pacman
`define CHAR_139 128'hffffffffffffffff000042667e7e3c00  // up: color block   down: up-pacman
`define CHAR_140 128'hffffffffffffffff003c1e0e0e1e3c00  // up: color block   down: left-pacman
`define CHAR_141 128'hffffffffffffffff003c7e7e66420000  // up: color block   down: down-pacman
`define CHAR_142 128'hffffffffffffffff003c7e7e7e7e3c00  // up: color block   down: circle-pacman
`define CHAR_143 128'hffffffffffffffff003c7e5a7e7e5a00  // up: color block   down: ghost

`define CHAR_144 128'h003c787070783c000000001818000000  // up: right-pacman  down: a point
`define CHAR_145 128'h003c787070783c00ffffffffffffffff  // up: right-pacman  down: color block
`define CHAR_146 128'h003c787070783c00003c7e5a7e7e5a00  // up: right-pacman  down: ghost
`define CHAR_147 128'h000042667e7e3c000000001818000000  // up: up-pacman     down: a point
`define CHAR_148 128'h000042667e7e3c00ffffffffffffffff  // up: up-pacman     down: color block
`define CHAR_149 128'h000042667e7e3c00003c7e5a7e7e5a00  // up: up-pacman     down: ghost
`define CHAR_150 128'h003c1e0e0e1e3c000000001818000000  // up: left-pacman   down: a point
`define CHAR_151 128'h003c1e0e0e1e3c00ffffffffffffffff  // up: left-pacman   down: color block
`define CHAR_152 128'h003c1e0e0e1e3c00003c7e5a7e7e5a00  // up: left-pacman   down: ghost
`define CHAR_153 128'h003c7e7e664200000000001818000000  // up: down-pacman   down: a point
`define CHAR_154 128'h003c7e7e66420000ffffffffffffffff  // up: down-pacman   down: color block
`define CHAR_155 128'h003c7e7e66420000003c7e5a7e7e5a00  // up: down-pacman   down: ghost
`define CHAR_156 128'h003c7e7e7e7e3c000000001818000000  // up: circle-pacman down: a point
`define CHAR_157 128'h003c7e7e7e7e3c00ffffffffffffffff  // up: circle-pacman down: color block
`define CHAR_158 128'h003c7e7e7e7e3c00003c7e5a7e7e5a00  // up: circle-pacman down: ghost

`define CHAR_159 128'h003c7e5a7e7e5a000000001818000000  // up: ghost         down: a point
`define CHAR_160 128'h003c7e5a7e7e5a00ffffffffffffffff  // up: ghost         down: color block
`define CHAR_161 128'h003c7e5a7e7e5a00003c787070783c00  // up: ghost         down: right-pacman
`define CHAR_162 128'h003c7e5a7e7e5a00000042667e7e3c00  // up: ghost         down: up-pacman
`define CHAR_163 128'h003c7e5a7e7e5a00003c1e0e0e1e3c00  // up: ghost         down: left-pacman
`define CHAR_164 128'h003c7e5a7e7e5a00003c7e7e66420000  // up: ghost         down: down-pacman
`define CHAR_165 128'h003c7e5a7e7e5a00003c7e7e7e7e3c00  // up: ghost         down: circle-pacman
`define CHAR_166 128'h003c7e5a7e7e5a00003c7e5a7e7e5a00  // up: ghost         down: ghost

