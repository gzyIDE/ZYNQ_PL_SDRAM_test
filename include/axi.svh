/*
* <axi.svh>
* AXI Parameter
* 
* Copyright (c) 2023 Yosuke Ide <gizaneko@outlook.jp>
* 
* This software is released under the MIT License.
* http://opensource.org/licenses/mit-license.php
*/

`ifndef _AXI_SVH_INCLUDED_
`define _AXI_SVH_INCLUDED_

//***** AXI3 parameters
`define AXI3_LEN_W      4

`define AXI3_SIZE_W     3
typedef enum logic [`AXI3_SIZE_W-1:0] {
  SIZE_1B     = 3'b000,
  SIZE_2B     = 3'b001,
  SIZE_4B     = 3'b010,
  SIZE_8B     = 3'b011,
  SIZE_16B    = 3'b100,
  SIZE_32B    = 3'b101,
  SIZE_64B    = 3'b110,
  SIZE_128B   = 3'b111
} axi3_size_t;

`define AXI3_BST_W      2
typedef enum logic [`AXI3_BST_W-1:0] {
  BST_FIXED = 2'b00,
  BST_INCR  = 2'b01,
  BST_WRAP  = 2'b10,
  RESERVED  = 2'b11
} axi3_bst_t;

`define AXI3_RESP_W     2
typedef enum logic [`AXI3_RESP_W-1:0] {
  RESP_OKAY   = 2'b00,
  RESP_EXOKAY = 2'b01,
  RESP_SLVERR = 2'b10,
  RESP_DECERR = 2'b11
} axi3_resp_t;


`endif // _AXI_SVH_INCLUDED_
