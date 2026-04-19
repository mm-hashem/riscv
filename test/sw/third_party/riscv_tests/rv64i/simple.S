# See LICENSE for license details.

#*****************************************************************************
# simple.S
#-----------------------------------------------------------------------------
#
# This is the most basic self checking test. If your simulator does not
# pass thiss then there is little chance that it will pass any of the
# more complicated self checking tests.
#

#include "riscv_test.h"
#include "test_headers.h"
#include "test_macros.h"

.section .text.main
.align 2
.globl main
main:
  STORE_RA_SP_DATA
  
  li TESTNUM, 1;

  TEST_PASSFAIL

.end