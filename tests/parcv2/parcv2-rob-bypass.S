//=========================================================================
// parcv2-rob-bypass.S
//=========================================================================

#include "parc-macros.h"

        TEST_PARC_BEGIN

        //-----------------------------------------------------------------
        // ROB Bypass Testing
        //-----------------------------------------------------------------

        // prepare operands 
        li $2, 2;
        li $3, 8;
        // perform operations
        divu $6, $3, $2;
        mul $5, $2, $6; // is stalled because of the operand $6 dependency
        addu $7, $2, $3; // no data dependency, so doesn't stall (fills first)
        addiu $8, $7, 1;
        addiu $9, $7, 2; // this instruction bypasses $7 from the ROB (src0_byp_mux_sel == 101)
        // wait for everything to commit
        nop;
        nop;
        nop;
        nop;
        nop;
        nop;
        nop;
        nop;
        nop;
        nop;
        nop;
        nop;
        // ensure that register 9 is correct
        TEST_CHECK_EQ( $9, 12 )

        TEST_PARC_END

