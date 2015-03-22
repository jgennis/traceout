// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Taken from the Go 1.4 runtime/sys_linux_amd.s

#include "textflag.h"

// func now() (sec int64, nsec int32)
TEXT github·com∕google∕traceout∕usertrace·now(SB),NOSPLIT,$16
	// Be careful. We're calling a function with gcc calling convention here.
	// We're guaranteed 128 bytes on entry, and we've taken 16, and the
	// call uses another 8.
	// That leaves 104 for the gettime code to use. Hope that's enough!
	MOVQ	runtime·__vdso_clock_gettime_sym(SB), AX
	CMPQ	AX, $0
	JEQ	fallback_gtod
	MOVL	$1, DI // CLOCK_MONOTONIC
	LEAQ	0(SP), SI
	CALL	AX
	MOVQ	0(SP), AX	// sec
	MOVQ	8(SP), DX	// nsec
	MOVQ	AX, sec+0(FP)
	MOVL	DX, nsec+8(FP)
	RET
fallback_gtod:
	LEAQ	0(SP), DI
	MOVQ	$0, SI
	MOVQ	runtime·__vdso_gettimeofday_sym(SB), AX
	CALL	AX
	MOVQ	0(SP), AX	// sec
	MOVL	8(SP), DX	// usec
	IMULQ	$1000, DX
	MOVQ	AX, sec+0(FP)
	MOVL	DX, nsec+8(FP)
	RET


