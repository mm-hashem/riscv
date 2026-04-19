// See LICENSE for license details.

#ifndef _ENV_PHYSICAL_SINGLE_CORE_H
#define _ENV_PHYSICAL_SINGLE_CORE_H

//-----------------------------------------------------------------------
// Pass/Fail Macro
//-----------------------------------------------------------------------

#define RVTEST_PASS \
        li a0, 0;  \
        ret;

#define TESTNUM s1
#define RVTEST_FAIL          \
        addi a0, TESTNUM, 0; \
        ret;

//-----------------------------------------------------------------------
// Data Section Macro
//-----------------------------------------------------------------------

#define RVTEST_DATA_BEGIN .align 4;
#define RVTEST_DATA_END .align 4;

#endif
