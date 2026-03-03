/*** asmMult.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Kristian Binauhan"  

.align   /* realign so that next mem allocations are on word boundaries */
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */

.global packed_Value,a_Multiplicand,b_Multiplier,a_Sign,b_Sign,prod_Is_Neg,a_Abs,b_Abs,abs_Product,final_Product
.type packed_Value,%gnu_unique_object
.type a_Multiplicand,%gnu_unique_object
.type b_Multiplier,%gnu_unique_object
.type a_Sign,%gnu_unique_object
.type b_Sign,%gnu_unique_object
.type prod_Is_Neg,%gnu_unique_object
.type a_Abs,%gnu_unique_object
.type b_Abs,%gnu_unique_object
.type abs_Product,%gnu_unique_object
.type final_Product,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmMult gets called, you must set
 * them to 0 at the start of your code!
 */
packed_Value:    .word     0  
a_Multiplicand:  .word     0  
b_Multiplier:    .word     0  
a_Sign:          .word     0  
b_Sign:          .word     0 
prod_Is_Neg:     .word     0  
a_Abs:           .word     0  
b_Abs:           .word     0 
abs_Product:     .word     0
final_Product:   .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmMult
function description:
     output = asmMult ()
     
where:
     output: 
     
     function description: See Lab Instructions
     
     notes:
        None
          
********************************************************************/    
.global asmMult
.type asmMult,%function
asmMult:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    /* Store value of R0 into packed_Value */
    LDR R1, =packed_Value
    STR R0, [R1]
    
    /* A */
    MOV R2, R0 /* Copies value of R0 to R2 */
    ASR R2, R2, 16 /* Shifts upper 16 bits to lower 16 bits, sign extension */
    
    LDR R1, =a_Multiplicand
    STR R2, [R1] /* Stores value of R2 into a_Multiplicand */
    
    LSR R4, R2, 31 /* Isolates MSB to get either 0 or 1 */
    LDR R1, =a_Sign
    STR R4, [R1]
    
    CMP R2, 0
    NEGMI R2, R2 /* Checks if value is negative, then finds absolute value */
    LDR R1, =a_Abs
    STR R2, [R1]
    
    /* B */
    MOV R3, R0 /* Copies value of R0 to R3 */
    LSL R3, R3, 16 /* Clears the upper 16 bits */
    ASR R3, R3, 16 /* Shifts it back into the lower 16 bits, sign extension*/
    
    LDR R1, =b_Multiplier
    STR R3, [R1] /* Stores value of R3 into b_Multiplier */
    
    LSR R5, R3, 31 /* Isolates MSB to get either 0 or 1 */
    LDR R1, =b_Sign
    STR R5, [R1]
    
    CMP R3, 0
    NEGMI R3, R3 /* Checks if value is negative, then finds absolute value */
    LDR R1, =a_Abs
    STR R3, [R1]
    
    /* Find prod_Is_Neg through multiplication (successive addition method) */
    MOV R6, 0 /* set product to 0 */
    CMP R5, 0
    ADDEQ R6, R6, R4 /* if multiplier (b_Sign) = 0, product = product + multiplicand (a_Sign) */
    LDR R1, =prod_Is_Neg
    STR R6, [R1]
    
    /* Shift-and-Add Multiplication */
    MOV R0, R2 /* multiplicand - copy value of a_Abs to R0 */
    MOV R1, R3 /* multiplier - copy value of b_Abs to R1 */
    MOV R7, 0 /* set product to 0 (will use R6 later) */
    
    B loop
    
loop:
    CMP R1, 0
    BEQ multiplier_is_zero
    
    AND R3, R1, 1 /* isolate LSB of multiplier */
    CMP R3, 1 /* checks if LSB is one, branches if so */
    BEQ lsb_is_one
    
    B shift
    
lsb_is_one:
    ADD R7, R7, R0 /* product = product + multiplicand */
    B shift
    
shift:
    LSL R0, R0, 1 /* multiplicand << 1 */
    LSR R1, R1, 1  /* multiplier >> 1 */
    B loop
    
multiplier_is_zero:
    LDR R2, =abs_Product
    STR R7, [R2]
    
    CMP R6, 1 /* check prod_Is_Neg */
    NEGEQ R7, R7 /* converts to negative if true */
    
    LDR R2, =final_Product
    STR R7, [R2]
    
    MOV R0, R7
    
    B done
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 

    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    pop {r4-r11,LR}

    mov pc, lr	 /* asmMult return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




