//=========================================================================
// parcv2-i2o2.S
//=========================================================================

#include "parc-macros.h"

        TEST_PARC_BEGIN

        //-----------------------------------------------------------------
        // I2O2 Error test (Part 1)
        //-----------------------------------------------------------------

        // prepare operands 
        li $2, 2;
        li $3, 8;
        // perform operations
        divu $6, $3, $2;
        mul $5, $2, $6; // is stalled because of the operand $6 dependency
        addu $5, $2, $3; // no data dependency, so doesn't stall (commits first)
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

