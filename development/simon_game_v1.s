.data
sentence: .string "Enter 0 to exit or 1 to play again \n"
sequence:  .byte 0,0,0,0
count:     .word 4
red:    .word 0xff0000
green:  .word 0x00ff00
blue:   .word 0x0000ff
yellow: .word 0xffff00
black: .word 0x0

# 0 = (0,0) top left - red - UP 
# 1 = (1, 1) bottom right - blue - DOWN
# 2 = (0, 1) bottom left - yellow - LEFT
# 3 = (1, 0) top right - green - RIGHT

.globl main
.text


main:
    
    
    # turn off LED's
    li a0, 0x0
    li a1, 0
    li a2, 0
    call setLED # (0, 0)
    
    li a1, 1
    call setLED # (1, 0)
    
    li a2, 1
    call setLED # (1, 1)
    
    li a1, 0
    call setLED # (0, 1)
    
    # TODO: Before we deal with the LEDs, we need to generate a random
    # sequence of numbers that we will use to indicate the button/LED
    # to light up. For example, we can have 0 for UP, 1 for DOWN, 2 for
    # LEFT, and 3 for RIGHT. Store the sequence in memory. We provided 
    # a declaration above that you can use if you want.
    # HINT: Use the rand function provided to generate each number

    # Generate random numbers using rand function and store in sequence
    la t4, sequence
    li a0, 4
    call rand     # call rand function to generate a random number
    sw a0, 0(t4)  # store in first byte of sequence
    li a0, 4
    call rand
    sw a0, 4(t4)  
    li a0, 4
    call rand
    sw a0, 8(t4)  
    li a0, 4
    call rand
    sw a0, 12(t4) 

   
    # TODO: Now read the sequence and replay it on the LEDs. You will
    # need to use the delay function to ensure that the LEDs light up 
    # slowly. In general, for each number in the sequence you should:
    # 1. Figure out the corresponding LED location and colour
    # 2. Light up the appropriate LED (with the colour)
    # 2. Wait for a short delay (e.g. 500 ms)
    # 3. Turn off the LED (i.e. set it to black)
    # 4. Wait for a short delay (e.g. 1000 ms) before repeating
    
    li s5, 0 # loop over each element in the sequence
    li t6, 4
    la t4, sequence
    
    loop: 
        beq s5, t6, done
        lw t5, 0(t4) # load the element from the sequence
        addi t4, t4, 4
        addi s5, s5, 1 # increment the loop counter
        # determine the LED location and colour based on the sequence element
        determine:
            beq t5, zero, case_red # 0, (0,0)
            li s1, 1
            beq t5, s1, case_blue # 1 (1, 1)
            li s1, 2
            beq t5, s1, case_yellow # 2 (1, 0)
            li s1, 3
            beq t5, s1, case_green # 3 (0, 1)

        case_red:
            li a0, 0xff0000 # colour red
            li a1, 0
            li a2, 0
            call setLED
            li a0, 500
            call delay
            
            li a0, 0x0 # turn off LED
            li a1, 0
            li a2, 0
            call setLED
            li a0, 500
            call delay
            
            j loop
        
        case_blue:
            li a0, 0x0000ff # colour blue
            li a1, 1
            li a2, 1
            call setLED
            li a0, 500
            call delay
            
            li a0, 0x0 # turn off LED
            li a1, 1
            li a2, 1
            call setLED
            li a0, 500
            call delay
            
            j loop
        
        case_yellow:
            li a0, 0xffff00 # colour yellow
            li a1, 0
            li a2, 1
            call setLED # (0, 1)
            li a0, 500
            call delay
            
            li a0, 0x0 # turn off LED
            li a1, 0
            li a2, 1
            call setLED
            li a0, 500
            call delay
            
            j loop  
            
        case_green:
            li a0, 0x00ff00 # colour green
            li a1, 1
            li a2, 0
            call setLED # (1, 0)
            li a0, 500
            call delay
            
            li a0, 0x0 # turn off LED
            li a1, 1
            li a2, 0
            call setLED
            li a0, 500
            call delay
            
            j loop
              
    done:
        nop

        
    # TODO: Read through the sequence again and check for user input
    # using pollDpad. For each number in the sequence, check the d-pad
    # input and compare it against the sequence. If the input does not
    # match, display some indication of error on the LEDs and exit. 
    # Otherwise, keep checking the rest of the sequence and display 
    # some indication of success once you reach the end.
    
    li s5, 0
    li t6, 4
    la t4, sequence
    checkLoop:
        
        beq s5, t6, right
        lw t5, 0(t4) # load the element from the sequence
        call pollDpad
        mv s2, a0
        bne s2, t5, wrong
        addi t4, t4, 4
        addi s5, s5, 1 # increment the loop counter
    
        # determine the LED location and colour based on the sequence element
        check:
            beq s2, zero, is_red # 0, (0,0)
            li s1, 1
            beq s2, s1, is_blue # 1 (1, 1)
            li s1, 2
            beq s2, s1, is_yellow # 2 (0,1)
            li s1, 3
            beq s2, s1, is_green # 3 (1,0)

        is_red:
            li a0, 0x00ffffff
            li a1, 0
            li a2, 0
            call setLED
            li a0, 250
            call delay
            
            li a0, 0x0 # turn off LED
            li a1, 0
            li a2, 0
            call setLED
            
            j checkLoop
        
        is_blue:
            li a0, 0x00ffffff
            li a1, 1
            li a2, 1
            call setLED
            li a0, 250
            call delay
            
            li a0, 0x0 # turn off LED
            li a1, 1
            li a2, 1
            call setLED
            
            j checkLoop
        
        is_yellow:
            li a0, 0x00ffffff
            li a1, 0
            li a2, 1
            call setLED # (0, 1)
            li a0, 250
            call delay
            
            li a0, 0x0 # turn off LED
            li a1, 0
            li a2, 1
            call setLED
            
            j checkLoop  
            
        is_green:
            li a0, 0x00ffffff
            li a1, 1
            li a2, 0
            call setLED # (1, 0)
            li a0, 250
            call delay
            
            li a0, 0x0 # turn off LED
            li a1, 1
            li a2, 0
            call setLED
            
   
            j checkLoop

    wrong:
        li a0, 0xff00ff # display purple for WRONG
        li a1, 0
        li a2, 0
        call setLED
        li a1, 1
        call setLED # (1, 0)
    
        li a2, 1
        call setLED # (1, 1)
    
        li a1, 0
        call setLED # (0, 1)
        j prompt
    right:
        li a0, 0x00ffffff # display white for SUCCESS
        li a1, 0
        li a2, 0
        call setLED
        li a1, 1
        call setLED # (1, 0)
    
        li a2, 1
        call setLED # (1, 1)
    
        li a1, 0
        call setLED # (0, 1)
        j prompt
    
    # Ask if the user wishes to play again and either loop back to
    # start a new round or terminate, based on their input.
    prompt:
        la a0, sentence
        li a7, 4
        ecall
        call readInt
    
        beq a0, zero, exit
        j main
        
exit:
    li a7, 10
    ecall
    
 
    
# --- HELPER FUNCTIONS ---
# Feel free to use (or modify) them however you see fit
     
# Takes in the number of milliseconds to wait (in a0) before returning
delay:
    mv t0, a0
    li a7, 30
    ecall
    mv t1, a0
delayLoop:
    ecall
    sub t2, a0, t1
    bgez t2, delayIfEnd
    addi t2, t2, -1
delayIfEnd:
    bltu t2, t0, delayLoop
    jr ra

# Takes in a number in a0, and returns a (sort of) random number from 0 to
# this number (exclusive)
rand:
    # define constants for the LCG formula
    li a7, 30 # get current time = random seed
    ecall
    
    mv s11, a0
    
    li s10, 12499 # a = 12499
    li s9, 12345 # b = 12345
    li s8, 289287 # M = 289287782193
    
    # x1 = (a*x0 + b)MODm
    mul s10, s10, s11 # s10 = a*x0
    add s10, s10, s9 # s10 = a*x0+b
    remu s10, s10, s8
    
    # compute scaled result
    
    li s6, 4
    remu a0, s10, s6
    
    ret
    
# Takes in an RGB color in a0, an x-coordinate in a1, and a y-coordinate
# in a2. Then it sets the led at (x, y) to the given color.
setLED:
    li t1, LED_MATRIX_0_WIDTH
    mul t0, a2, t1
    add t0, t0, a1
    li t1, 4
    mul t0, t0, t1
    li t1, LED_MATRIX_0_BASE
    add t0, t1, t0
    sw a0, (0)t0
    jr ra
    
# Polls the d-pad input until a button is pressed, then returns a number
# representing the button that was pressed in a0.
# The possible return values are:
# 0: UP
# 1: DOWN
# 2: LEFT
# 3: RIGHT
pollDpad:
    mv a0, zero
    li t1, 4
pollLoop:
    bge a0, t1, pollLoopEnd
    li t2, D_PAD_0_BASE
    slli t3, a0, 2
    add t2, t2, t3
    lw t3, (0)t2
    bnez t3, pollRelease
    addi a0, a0, 1
    j pollLoop
pollLoopEnd:
    j pollDpad
pollRelease:
    lw t3, (0)t2
    bnez t3, pollRelease
pollExit:
    jr ra

readInt:
    addi sp, sp, -12
    li a0, 0
    mv a1, sp
    li a2, 12
    li a7, 63
    ecall
    li a1, 1
    add a2, sp, a0
    addi a2, a2, -2
    mv a0, zero
parse:
    blt a2, sp, parseEnd
    lb a7, 0(a2)
    addi a7, a7, -48
    li a3, 9
    bltu a3, a7, error
    mul a7, a7, a1
    add a0, a0, a7
    li a3, 10
    mul a1, a1, a3
    addi a2, a2, -1
    j parse
parseEnd:
    addi sp, sp, 12
    ret

error:
    li a7, 93
    li a0, 1
    ecall
    
    li x3, 1024
    li x4, 512
    sub x6, x3, x4
    li x1, 256
    li x2, 128
    sub x7, x1, x2
    sub x5, x7, x6
    ecall
