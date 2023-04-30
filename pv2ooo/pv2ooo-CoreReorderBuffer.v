//=========================================================================
// 5-Stage PARC Scoreboard
//=========================================================================

`ifndef PARC_CORE_REORDERBUFFER_V
`define PARC_CORE_REORDERBUFFER_V

module parc_CoreReorderBuffer
(
  input         clk,
  input         reset,

  input         rob_alloc_req_val,
  output        rob_alloc_req_rdy,
  input  [ 4:0] rob_alloc_req_preg,
  
  output [ 3:0] rob_alloc_resp_slot,

  input         rob_fill_val,
  input  [ 3:0] rob_fill_slot,

  output        rob_commit_wen,
  output [ 3:0] rob_commit_slot,
  output [ 4:0] rob_commit_rf_waddr
);

  // Head and tail pointers
  reg [3:0] head_ptr;
  reg [3:0] tail_ptr; 

  // Arrays of registers for ROB
  reg [15:0] valid; // make this a 16-bit register so we can use reduction operator
  reg        pending  [15:0];
  reg [4:0]  preg     [15:0];

  // Resetting pending / physical register
  genvar r;
  generate
  for (r = 0; r < 16; r = r + 1)
  begin: rob_entry
    always @(posedge clk) begin
      if (reset) begin
        valid[r]   <= 1'b0;
        pending[r] <= 1'b0;
        preg[r]    <= 5'b0;
      end
    end
  end
  endgenerate

  // Register updating
  always @(posedge clk) begin
    if (reset) begin
      head_ptr    <= 4'b0;
      tail_ptr    <= 4'b0;
    end else begin

      // Allocation (create entries for registers)
      if (rob_alloc_req_val && rob_alloc_req_rdy) begin
        valid[tail_ptr]   <= 1'b1;
        pending[tail_ptr] <= 1'b1;
        preg[tail_ptr]    <= rob_alloc_req_preg;
        tail_ptr          <= tail_ptr + 1;
      end
      
      // Fill (mark entries as ready to commit)
      if (rob_fill_val) begin
        pending[rob_fill_slot] <= 1'b0;
      end
      
      // Commit (write rob_data entries to register file)
      if (rob_commit_wen) begin
        valid[head_ptr] <= 1'b0;
        head_ptr <= head_ptr + 1;
      end

    end
  end

  // Output signals
  assign rob_alloc_req_rdy = !(&valid);
  assign rob_alloc_resp_slot = tail_ptr;
  assign rob_commit_wen = !pending[head_ptr] && valid[head_ptr];
  assign rob_commit_rf_waddr = preg[head_ptr];
  assign rob_commit_slot = head_ptr;

endmodule

`endif

