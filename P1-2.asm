   #    Find George Possibly Incognito in a Crowd
#
#
# This routine finds an exact match of George's face (possibly incognito)
# in a crowd.
#
# 10-11-2015                               John Pratt

.data
Array:  .alloc 1024

.text

FindGeorge: addi  $1, $0, Array  # point to array base
            swi   588            # generate crowd

            # your code goes here
            addi  $1, $0, -4     # i = -1
            addi  $2, $0, 64     # (constant) = 16 (it's a waste of dynamic
                                 # calls to do this every loop iteration)
            addi  $3, $0, 8      # (constant2) = 8 (same reason as above, will be used when calling srlv)
            addi  $4, $0, 4      # (constant3) = 4 (used when shifting inside array element)

            # note - we precalculate the max value for i's of interest
            # this is based on the fact that faces can't hang off the picture
Outer:      addi  $1, $1, 4      # i++
            slti  $5, $1, 3384   # i < 846 (precalculated - explained above loop header)
            beq   $5, $0, End    # if i >= 847, end loop
            
            # check col
            div   $1, $2
            mfhi  $5             # col = i % 16
            slti  $5, $5, 14     # col < 14
            beq   $5, $0, Outer  # our i is off, so we have to skip this i

            addi  $5, $0, -1     # j = -1
Inner:      addi  $5, $5, 1      # j++
            slti  $6, $5, 4      # j < 4
            beq   $6, $0, Outer  # if j >= 4, go back to outer loop   
                  
            # first we'll make sure we're on the top-left of a blue or black hat      
            # get ready to call Shift (this isn't the best example of how Shift works - refer to where we test if the hat stripe is correct)
            addi  $6, $0, 0      # how many elements in CrowdInts we have to shift
            addi  $7, $0, 4      # k - used in modulus (how many 'pixels' in CrowdInts to shift)
            jal   Shift

            # other code for pixels to test

Shift:      add   $6, $1, $6     # place = i + shift
            lw    $6, Array($6)  # tmp = CrowdInts(place)
            add   $7, $7, $5     # j-shift = j + k
            div   $7, $4
            mfhi  $7             # j-shift = (j + k) % 4
            mul   $s, $t
            
            jr    $31            # return to subroutine caller

            

End:        






            ### The following are temporary (replace them).
            ### They are included to show how to use swi 552 and 553.
            addi  $2, $0, 160    # mark the 160th pixel
            swi   552            # with this swi

            addi  $2, $0, 161    # mark the 161th pixel
            swi   552            # with this swi

            addi  $2, $0, 300    # always guess the 300th pixel
            ### The above instructions are temporary (replace them).

            swi   553            # submit answer and check
            jr    $31            # return to caller
