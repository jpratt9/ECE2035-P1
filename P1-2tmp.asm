#    Find George Possibly Incognito In a Crowd
#
#
# This routine finds an exact match of George's face (possibly incognito) 
# in a crowd.
#
# 10-12-2015                               John Pratt

.data
Array:  .alloc 1024

.text

FindGeorge: addi  $1, $0, Array  # point to array base
            swi   588            # generate crowd

            # your code goes here
            addi  $2, $0, 0
            addi  $3, $1, 3383      # Max value of i :
                                    # Calculated based on fact that faces cannot hang
                                    # off bottom or right.
            addi  $4, $0, 64        # row/col "size" - used to find current row/col
            addi  $5, $0, 53        # max column to prevent hanging off of edge
            addi  $6, $0, 3         # blue
            addi  $7, $0, 8         # black
            addi  $8, $0, 

            addi  $1, $1, 1         # i = 1 b/c the earliest we can have a topleft of hat is i = 2
Loop:       addi  $1, $1, 1         # i++
            beq   $1, $3, End       # if i = i_max, exit loop
            div   $1, $4        
            mfhi  $6                # col = i % 64
            beq   $6, $5, ColHigh   # we can skip a bunch of i's if we hit the right-edge
            lbu   $6, 0($1)
            beq   
Blue:       


            j     Loop




    
            
End:        swi   553               # submit answer and check
            jr    $31               # return to caller

ColHigh:    addi  $1, $1, 8         # we skip to the next row if our col is too high
            j     Loop


            ### The following are temporary (replace them).
            ### They are included to show how to use swi 552 and 553.
            addi  $2, $0, 160       # mark the 160th pixel
            swi   552               # with this swi
            addi  $2, $0, 161       # mark the 161th pixel
            swi   552               # with this swi
            addi  $2, $0, 300       # always guess 300th pixel
            ### The above instructions are temporary (replace them).