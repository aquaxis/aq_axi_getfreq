/*
 * Copyright (C)2014-2017 AQUAXIS TECHNOLOGY.
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
module aq_axi_getfreq_ctrl
  (
   input         RST_N,

   input         AQ_LOCAL_CLK,
   input         AQ_LOCAL_CS,
   input         AQ_LOCAL_RNW,
   output        AQ_LOCAL_ACK,
   input [31:0]  AQ_LOCAL_ADDR,
   input [3:0]   AQ_LOCAL_BE,
   input [31:0]  AQ_LOCAL_WDATA,
   output [31:0] AQ_LOCAL_RDATA,

  input         EXT_CLK,
  
   output [31:0] DEBUG
);

   localparam A_STATUS     = 8'h00;
   localparam A_FREQ       = 8'h04;
   localparam A_TESTDATA   = 8'h24;
   localparam A_DEBUG      = 8'h28;

   wire          wr_ena, rd_ena, wr_ack;
   reg           rd_ack;
   reg [31:0]    reg_rdata;

   assign wr_ena = (AQ_LOCAL_CS & ~AQ_LOCAL_RNW)?1'b1:1'b0;
   assign rd_ena = (AQ_LOCAL_CS &  AQ_LOCAL_RNW)?1'b1:1'b0;
   assign wr_ack = wr_ena;

   reg           reg_master_reset;
  reg [31:0]  reg_freq_count;
  reg [31:0]  reg_test;

   // Write Register
   always @(posedge AQ_LOCAL_CLK or negedge RST_N) begin
      if(!RST_N) begin
         reg_master_reset   <= 1'b0;
         reg_test <= 32'd0;
      end else begin
         if(wr_ena) begin
            case(AQ_LOCAL_ADDR[7:0] & 8'hFC)
              A_STATUS: begin
                 reg_master_reset <= AQ_LOCAL_WDATA[31];
              end
              A_TESTDATA: begin
                 reg_test <= AQ_LOCAL_WDATA[31:0];
              end
              default: begin
              end
            endcase
         end
      end
   end

   // Read Register
   always @(posedge AQ_LOCAL_CLK or negedge RST_N) begin
      if(!RST_N) begin
         reg_rdata[31:0] <= 32'd0;
         rd_ack <= 1'b0;
      end else begin
         rd_ack <= rd_ena;
         if(rd_ena) begin
            case(AQ_LOCAL_ADDR[7:0] & 8'hFC)
              A_STATUS: begin
                 reg_rdata[31:0] <= {reg_master_reset, 31'd0};
              end
              A_FREQ: begin
                 reg_rdata[31:0] <= {1'b0, reg_freq_count[31:1]};
              end
              A_TESTDATA: begin
                 reg_rdata[31:0] <= reg_test[31:0];
              end
              default: begin
                 reg_rdata[31:0] <= 32'd0;
              end
            endcase
         end else begin
            reg_rdata[31:0] <= 32'd0;
         end
      end
   end

   assign AQ_LOCAL_ACK         = (wr_ack | rd_ack);
   assign AQ_LOCAL_RDATA[31:0] = reg_rdata[31:0];

  reg [31:0] reg_100m_count;
  wire detect_freq;

`define DETECT_COUNT 32'd100000000

  always @(posedge AQ_LOCAL_CLK) begin
    if(reg_master_reset) begin
      reg_100m_count <= 32'd0;
    end else begin
      if(reg_100m_count < `DETECT_COUNT) begin
        reg_100m_count <= reg_100m_count +1;
      end
    end
  end
  assign detect_freq = (reg_100m_count >=`DETECT_COUNT)?1'b1:1'b0;

  always @(posedge EXT_CLK) begin
    if(reg_master_reset) begin
      reg_freq_count <= 64'd0;
    end else begin
      if(!detect_freq) begin
        reg_freq_count <= reg_freq_count +1;
      end
    end
  end

endmodule
