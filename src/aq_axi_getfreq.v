/*
 * Copyright (C)2014-2018 AQUAXIS TECHNOLOGY.
 *  Don't remove this header.
 * When you use this source, there is a need to inherit this header.
 *
 * License
 *  For no commercial -
 *   License:     The Open Software License 3.0
 *   License URI: http://www.opensource.org/licenses/OSL-3.0
 *
 *  For commmercial -
 *   License:     AQUAXIS License 1.0
 *   License URI: http://www.aquaxis.com/licenses
 *
 * For further information please contact.
 *	URI:    http://www.aquaxis.com/
 *	E-Mail: info(at)aquaxis.com
 */
module aq_axi_getfreq
  (
   // --------------------------------------------------
   // AXI4 Lite Interface
   // --------------------------------------------------
   // Reset, Clock
   input         S_AXI_ARESETN,
   input         S_AXI_ACLK,

   // Write Address Channel
   input [15:0]  S_AXI_AWADDR,
   input [3:0]   S_AXI_AWCACHE,
   input [2:0]   S_AXI_AWPROT,
   input         S_AXI_AWVALID,
   output        S_AXI_AWREADY,

   // Write Data Channel
   input [31:0]  S_AXI_WDATA,
   input [3:0]   S_AXI_WSTRB,
   input         S_AXI_WVALID,
   output        S_AXI_WREADY,

   // Write Response Channel
   output        S_AXI_BVALID,
   input         S_AXI_BREADY,
   output [1:0]  S_AXI_BRESP,

   // Read Address Channel
   input [15:0]  S_AXI_ARADDR,
   input [3:0]   S_AXI_ARCACHE,
   input [2:0]   S_AXI_ARPROT,
   input         S_AXI_ARVALID,
   output        S_AXI_ARREADY,

   // Read Data Channel
   output [31:0] S_AXI_RDATA,
   output [1:0]  S_AXI_RRESP,
   output        S_AXI_RVALID,
   input         S_AXI_RREADY,

   // --------------------------------------------------
   // Control Signal
   // --------------------------------------------------
   input         EXT_CLK,

   output [31:0] DEBUG
   );

   wire [31:0]   debug_ls, debug_slave, debug_ctl, debug_master;

   wire          aq_local_clk;
   wire          aq_local_cs;
   wire          aq_local_rnw;
   wire          aq_local_ack;
   wire [15:0]   aq_local_addr;
   wire [3:0]    aq_local_be;
   wire [31:0]   aq_local_wdata;
   wire [31:0]   aq_local_rdata;

   // AXI Lite Slave Interface
   aq_axi_getfreq_ls u_aq_axi_getfreq_ls
     (
      // AXI4 Lite Interface
      .ARESETN        ( S_AXI_ARESETN  ),
      .ACLK           ( S_AXI_ACLK     ),

      // Write Address Channel
      .S_AXI_AWADDR   ( S_AXI_AWADDR   ),
      .S_AXI_AWCACHE  ( S_AXI_AWCACHE  ),
      .S_AXI_AWPROT   ( S_AXI_AWPROT   ),
      .S_AXI_AWVALID  ( S_AXI_AWVALID  ),
      .S_AXI_AWREADY  ( S_AXI_AWREADY  ),

      // Write Data Channel
      .S_AXI_WDATA    ( S_AXI_WDATA    ),
      .S_AXI_WSTRB    ( S_AXI_WSTRB    ),
      .S_AXI_WVALID   ( S_AXI_WVALID   ),
      .S_AXI_WREADY   ( S_AXI_WREADY   ),

      // Write Response Channel
      .S_AXI_BVALID   ( S_AXI_BVALID   ),
      .S_AXI_BREADY   ( S_AXI_BREADY   ),
      .S_AXI_BRESP    ( S_AXI_BRESP    ),

      // Read Address Channel
      .S_AXI_ARADDR   ( S_AXI_ARADDR   ),
      .S_AXI_ARCACHE  ( S_AXI_ARCACHE  ),
      .S_AXI_ARPROT   ( S_AXI_ARPROT   ),
      .S_AXI_ARVALID  ( S_AXI_ARVALID  ),
      .S_AXI_ARREADY  ( S_AXI_ARREADY  ),

      // Read Data Channel
      .S_AXI_RDATA    ( S_AXI_RDATA    ),
      .S_AXI_RRESP    ( S_AXI_RRESP    ),
      .S_AXI_RVALID   ( S_AXI_RVALID   ),
      .S_AXI_RREADY   ( S_AXI_RREADY   ),

      // Local Interface
      .AQ_LOCAL_CLK   ( aq_local_clk   ),
      .AQ_LOCAL_CS    ( aq_local_cs    ),
      .AQ_LOCAL_RNW   ( aq_local_rnw   ),
      .AQ_LOCAL_ACK   ( aq_local_ack   ),
      .AQ_LOCAL_ADDR  ( aq_local_addr  ),
      .AQ_LOCAL_BE    ( aq_local_be    ),
      .AQ_LOCAL_WDATA ( aq_local_wdata ),
      .AQ_LOCAL_RDATA ( aq_local_rdata ),

      .DEBUG          ( debug_ls       )
      );

   // Control(Local Register)
   aq_axi_getfreq_ctrl u_aq_axi_getfreq_ctrl
     (
      .RST_N          ( S_AXI_ARESETN    ),

      .AQ_LOCAL_CLK   ( aq_local_clk     ),
      .AQ_LOCAL_CS    ( aq_local_cs      ),
      .AQ_LOCAL_RNW   ( aq_local_rnw     ),
      .AQ_LOCAL_ACK   ( aq_local_ack     ),
      .AQ_LOCAL_ADDR  ( aq_local_addr    ),
      .AQ_LOCAL_BE    ( aq_local_be      ),
      .AQ_LOCAL_WDATA ( aq_local_wdata   ),
      .AQ_LOCAL_RDATA ( aq_local_rdata   ),

      .EXT_CLK        ( EXT_CLK          ),

      .DEBUG          ( debug_ctl        )
    );

    assign DEBUG[31:0] = debug_ls;
endmodule
