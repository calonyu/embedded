.section ".text.uart"

.extern clk_setup
.extern umain

.globl _start
_start:
	b reset
	.rept 6
	b debug
	.endr

debug:
	b .

reset:
	# set the cpu to SVC32 mode, disable fiq and irq
	msr cpsr_c, #(0x13 | 0xC0)

	# init SVC mode stack pointer
	ldr sp, =0xFFF
	bic sp, sp, #0x7		@ align sp to 8

	# disable watchdog
	ldr r1, =0x53000000		@WTCON
	mov r0, #0x0
	str r0, [r1]

#ifdef DEBUG_LEDS
	bl config_leds			@ Just used for debug
#endif

	bl clk_setup
	bl umain
	b .		@ stop there


/* code below for debug */
#ifdef DEBUG_LEDS
.include "debug.S"
#endif /* DEBUG_LEDS */

.end
