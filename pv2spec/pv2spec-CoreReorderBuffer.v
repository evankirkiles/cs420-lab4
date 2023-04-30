//=========================================================================
// 5-Stage PARC Scoreboard
//=========================================================================

`ifndef PARC_CORE_REORDERBUFFER_V
`define PARC_CORE_REORDERBUFFER_V

module parc_CoreReorderBuffer #( parameter N = 16 ) // Number of ROB entries
(
  input         clk,
  input         reset,

  input         rob_alloc_req_val,
  output        rob_alloc_req_rdy,
  input  [ 4:0] rob_alloc_req_preg,
  
  output [ $clog2(N)-1:0] rob_alloc_resp_slot,

  input         rob_fill_val,
  input  [ $clog2(N)-1:0] rob_fill_slot,

  output        rob_commit_wen,
  output [ $clog2(N)-1:0] rob_commit_slot,
  output [ 4:0] rob_commit_rf_waddr,

  input         rob_alloc_req_spec,
  input         rob_branch_res_val,
  input         rob_branch_res_taken,
  input  [ $clog2(N)-1:0] rob_branch_res_slot
);

  // Head and tail pointers
  reg [$clog2(N)-1:0] head_ptr;
  reg [$clog2(N)-1:0] tail_ptr; 

  // Arrays of registers for ROB
  reg [N-1:0] valid; // make this a 16-bit register so we can use reduction operator
  reg        pending  [N-1:0];
  reg        spec     [N-1:0];
  reg [4:0]  preg     [N-1:0];

  // Resetting pending / physical register
  genvar r;
  generate
  for (r = 0; r < N; r = r + 1)
  begin: rob_entry
    always @(posedge clk) begin
      if (reset) begin
        valid[r]   <= 1'b0;
        pending[r] <= 1'b0;
        spec[r]    <= 1'b0;
        preg[r]    <= 5'b0;
      end
    end
  end
  endgenerate

  // Register updating
  always @(posedge clk) begin
    if (reset) begin
      head_ptr    <= {$clog2(N){1'b0}};
      tail_ptr    <= {$clog2(N){1'b0}};
    end else begin

      // Allocation (create entries for registers)
      if (rob_alloc_req_val && rob_alloc_req_rdy) begin
        valid[tail_ptr]   <= 1'b1;
        pending[tail_ptr] <= 1'b1;
        spec[tail_ptr]    <= rob_alloc_req_spec;
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

      // Speculation (invalidate ROB data in I stage if branch is taken)
      if (rob_branch_res_val && spec[rob_branch_res_slot]) begin
        if (rob_branch_res_taken) begin
          // de-allocate the most recently allocated ROB entry
          valid[rob_branch_res_slot] <= 1'b0;
          tail_ptr <= tail_ptr - 1;
        end
      end

    end
  end

  // Output signals
  assign rob_alloc_req_rdy = !(&valid);
  assign rob_alloc_resp_slot = tail_ptr;
  assign rob_commit_wen = valid[head_ptr] && !pending[head_ptr];
  assign rob_commit_rf_waddr = preg[head_ptr];
  assign rob_commit_slot = head_ptr;

endmodule

`endif

