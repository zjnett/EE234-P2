.text
.global main

.equ LED_DATA, 0x41210000
.equ SW_DATA, 0x41220000
.equ PWM_EN0, 0x43C00000
.equ PWM_EN1, 0x43C00010
.equ PWM_EN2, 0x43C00020
.equ PWM_EN3, 0x43C00030
.equ PWM_EN4, 0x43C00040
.equ PWM_EN5, 0x43C00050
.equ PWM_PERIOD0, 0x43C00004
.equ PWM_PERIOD1, 0x43C00014
.equ PWM_PERIOD2, 0x43C00024
.equ PWM_PERIOD3, 0x43C00034
.equ PWM_PERIOD4, 0x43C00044
.equ PWM_PERIOD5, 0x43C00054
.equ PWM_WIDTH, 0x43C00008
.equ PWM_WIDTH, 0x43C00018
.equ PWM_WIDTH, 0x43C00028
.equ PWM_WIDTH, 0x43C00038
.equ PWM_WIDTH, 0x43C00048
.equ PWM_WIDTH, 0x43C00058

main:
	loop:
		bl disable_pwm_channel
		bl enable_pwm_channel
		bl set_pwm_window
		bl set_pwm_duty
	b loop

enable_pwm_channel: @r0 = which channel (top 3 bits), @r1 = PWM
	ldr r2,=SW_DATA
	ldr r0,[r2] @ load switches into r0
	and r0,#1110000000000 @ mask all but top 3 of r0
	lsr r0,#10 @ shift right 10
	cmp r0,#7
	bge lr @ branch if not 0 <= # <= 6
	cmp r0,#1
		ldr r1,=PWM_EN0
		str #1,[r1]
	cmp r0,#2
		ldr r1,=PWM_EN1
		str #1,[r1]
	cmp r0,#3
		ldr r1,=PWM_EN2
		str #1,[r1]
	cmp r0,#4
		ldr r1,=PWM_EN3
		str #1,[r1]
	cmp r0,#5
		ldr r1,=PWM_EN4
		str #1,[r1]
	cmp r0,#6
		ldr r1,=PWM_EN5
		str #1,[r1]
	bx lr

disable_pwm_channel: @r0 = which channel to disable (top 3 bits)
	ldr r2,=SW_DATA
	ldr r0,[r2] @ load switches into r0
	and r0,#1110000000000 @ mask all but top 3 of r0
	lsr r0,#10 @ shift right 10
	cmp r0,#0
	bge lr @ branch if not 0
	ldr r1,=PWM_EN0
	str #0,[r1]
	ldr r1,=PWM_EN1
	str #0,[r1]
	ldr r1,=PWM_EN2
	str #0,[r1]
	ldr r1,=PWM_EN3
	str #0,[r1]
	ldr r1,=PWM_EN4
	str #0,[r1]
	ldr r1,=PWM_EN5
	str #0,[r1]
	bx lr

set_pwm_window: @ r1 is window
	@ window should be maximum of possible switches - 2^32 bit
	@ value based on scaled pwm duty value
	ldr r1,=PWM_WIDTH0
	str #0x100000000,[r1]
	ldr r1,=PWM_WIDTH1
	str #0x100000000,[r1]
	ldr r1,=PWM_WIDTH2
	str #0x100000000,[r1]
	ldr r1,=PWM_WIDTH3
	str #0x100000000,[r1]
	ldr r1,=PWM_WIDTH4
	str #0x100000000,[r1]
	ldr r1,=PWM_WIDTH5
	str #0x100000000,[r1]
	bx lr

set_pwm_duty: @ r2/r0 is duty
	ldr r2,=SW_DATA
	ldr r0,[r2] @ load switches into r0
	and r0,#000111111111 @ mask only top 3 switches
	lsl r0,#23 @ bit shift left 23 (9-bit -> 32-bit num)
	ldr r1,=PWM_PERIOD0
	str r0,[r1]
	ldr r1,=PWM_PERIOD1
	str r0,[r1]
	ldr r1,=PWM_PERIOD2
	str r0,[r1]
	ldr r1,=PWM_PERIOD3
	str r0,[r1]
	ldr r1,=PWM_PERIOD4
	str r0,[r1]
	ldr r1,=PWM_PERIOD5
	str r0,[r1]
	bx lr

.end
