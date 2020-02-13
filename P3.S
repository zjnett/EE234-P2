.text
.global main

@ NOT DONE

.equ LED_DATA, 0x41210000
.equ SW_DATA, 0x41220000

main:
	loop:
		ldr r0,=0x00000020 @ load # of cycles in each PWM window
		ldr r1,=0x00000001 @ load # of high cycles in window
		bl soft_pwm
	b loop

soft_pwm:
	sub r2,r0,r1 @ place r0 - r1 into r2
	@ turn LED on for number of delay cycles
	b led_on_counter
	@ turn LED off for remainder of cycles, r0-r1
	b led_off_counter
	bx lr

led_on_counter:
	mov r4,r1 @ backup r1 to r4
	bl led0_on
	mov r1,r4 @ restore r1
	subs r1,r1,#1
	bne led_on_counter
	bx lr

led_off_counter:
	mov r5,r2 @ backup r2 to r5
	bl led0_off
	mov r2,r5 @ restore r2 from r5
	subs r2,r2,#1
	bne led_off_counter
	bx lr

led0_on:
	ldr r1, =LED_DATA
	ldr r0, [r1]	@get current value
	orr r0,r0,#1	@set the first bit (don't affect other bits)
	str r0, [r1]	@write back to LED_DATA
	bx lr		@return from subroutine

led0_off:
	ldr r1, =LED_DATA
	ldr r0, [r1]	@get current value
	mov r0,#0	@set the first bit (don't affect other bits)
	str r0, [r1]	@write back to LED_DATA
	bx lr		@return from subroutine

led0_toggle:
	ldr r1, =LED_DATA
	ldr r0, [r1]	@get current value
	eor r0,r0,#1
	str r0, [r1]	@write back to LED_DATA
	bx lr		@return from subroutine

.end
