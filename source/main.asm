; mode7demo - GBA color demo using Mode 7.
; Copyright (c) 2020 Michelle-Marie Schiller

format binary as 'gba'

	include '../lib/header.asm'
	include '../lib/memory.inc'
	include '../lib/mmio.inc'

.main:
	; copy bitmap to EWRAM
	adr     r0, .dma_config1
	ldmia   r0, {r0-r3}
	stmia   r0, {r1-r3}

	; wait for VBLANK
	mov     r1, MMIO
.loop_vblank_wait1:
	ldrh    r0, [r1, DISPSTAT]
	ands    r0, 1
	beq     .loop_vblank_wait1

.loop_vblank_wait2:
	ldrh    r0, [r1, DISPSTAT]
	ands    r0, 1
	bne     .loop_vblank_wait2
		
	; set up DMA0
	adr     r0, .dma_config2
	ldmia   r0, {r0-r3}
	stmia   r0, {r1-r3}
		
	; set up Mode 7
	adr     r0, .lcd_config
	ldmia   r0, {r0-r1}
	strh    r1, [r0]
		
	; copy sync routine to IWRAM
	adr     r0, .dma_config3
	ldmia   r0, {r0-r3}
	stmia   r0, {r1-r3}

	; set VCOUNT comparison value
	mov     r4, MMIO
	mov     r5, 0xE300
	strh    r5, [r4, DISPSTAT]

	mov     r6, r2

	; set up r0-r3 for bitmap transfer
	adr     r0, .dma_config4
	ldmia   r0, {r0-r3}
		
	bx      r6

.loop_vcount_coincidence:
	ldrh    r5, [r4, DISPSTAT]
	ands    r5, 4
	beq     .loop_vcount_coincidence
		
	; TODO: time this properly
	mov     r7, 0x0100
	orr     r7, 0x0038
		
.loop_synchronization:
	subs    r7, 1
	bne     .loop_synchronization
		
	; start DMA3
	stmia   r0, {r1-r3}
		
	nop
	nop
		
	b       .loop_vcount_coincidence

.dma_config1:
	dw      MMIO + DMA3SAD, ROM + .img, EWRAM, 0x84004B00

.dma_config2:
	dw      MMIO + DMA0SAD, IWRAM, IWRAM, 0xA3400088

.dma_config3:
	dw      MMIO + DMA3SAD, ROM + .loop_vcount_coincidence, IWRAM + 4, 0x84000011

.dma_config4:
	dw      MMIO + DMA3SAD, EWRAM, PRAM, 0x80409600

.lcd_config:
	dw      MMIO + DISPCNT, 0x0407

.img:
	file    'serena.img.bin'
