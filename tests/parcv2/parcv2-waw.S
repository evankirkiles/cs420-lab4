//=========================================================================
// parcv2-waw.S
//=========================================================================

#include "parc-macros.h"

        TEST_PARC_BEGIN

        //-----------------------------------------------------------------
        // WAW scenario
        //-----------------------------------------------------------------

        // prepare operands 
        li $2, 2;
        li $3, 8;
        // perform operations
        divu $6, $3, $2;
        mul $5, $2, $6; // is stalled because of the operand $6 dependency
        // now give ample time for the multiply to finish
        nop;
        nop;
        nop;
        nop;
        nop;
        nop;
        nop;
        nop;
        nop;
        // perform the add once we know multiply is done (WAW solved!)
        addu $5, $2, $3;
        // wait for mul and add to commit
        nop;
        nop;
        nop;
        nop;
        nop;
        nop;
        // register $5 SHOULD be result of add, not of multiply (fails in I2O2)
        TEST_CHECK_EQ( $5, 10 )

        TEST_PARC_END

