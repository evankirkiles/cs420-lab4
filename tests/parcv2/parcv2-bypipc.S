//=========================================================================
// parcv2-waw.S
//=========================================================================

#include "parc-macros.h"

        TEST_PARC_BEGIN

        //--------------------------------------------------------------------
        // Basic tests
        //--------------------------------------------------------------------

        TEST_LD_OP( lb, 0, tdata_0, 0xffffffef )
        TEST_LD_OP( lb, 1, tdata_0, 0xffffffbe )
        TEST_LD_OP( lb, 2, tdata_0, 0xffffffad )
        TEST_LD_OP( lb, 3, tdata_0, 0xffffffde )

        // TEST_LD_OP( lb, 4, tdata_0, 0x00000001 )
        // TEST_LD_OP( lb, 5, tdata_0, 0xffffffef )
        // TEST_LD_OP( lb, 6, tdata_0, 0xffffffcd )
        // TEST_LD_OP( lb, 7, tdata_0, 0xffffffab )

        TEST_PARC_END

        //--------------------------------------------------------------------
        // Test data
        //--------------------------------------------------------------------

        .data
        .align 4

tdata_0: .word 0xdeadbeef
tdata_1: .word 0xabcdef01
tdata_2: .word 0x0ff00ff0
