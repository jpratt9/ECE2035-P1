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
            addi  $3, $0, 4      # (constant2) = 4 (used when shifting inside array element)
            addi  $9, $0, -1     # (contant3) = -1 ()

            # note - we precalculate the max value for i's of interest
            # this is based on the fact that faces can't hang off the picture
Outer:      addi  $1, $1, 4      # i++
            slti  $4, $1, 3384   # i < 846 (precalculated - explained above loop header)
            beq   $4, $0, End    # if i >= 847, end loop
            
            # check col
            div   $1, $2
            mfhi  $4             # col = i % 16
            slti  $4, $4, 14     # col < 14
            beq   $4, $0, Outer  # our i is off, so we have to skip this i

            addi  $4, $0, -1     # j = -1
Inner:      addi  $4, $4, 1      # j++
            slti  $5, $4, 4      # j < 4
            beq   $5, $0, Outer  # if j >= 4, go back to outer loop   
                  
            # first we'll make sure we're on the top-left of a blue or black hat      
            # get ready to call Shift (this isn't the best example of how Shift works - refer to where we test if the hat stripe is correct)
            # general formula:
            # poi = ( CrowdInts[i + (k * 16) + l * (j == m)] >> (8 * ((j + n) % 4)) ) & 0xF
            # found = found && (poi == p)
            # poi : pixel of interest
            # if m == -1, we're telling the program not to check the value of j there
            # found : whether we still think we've found George's face
            # p : color of interest
            addi  $5, $0, 0      # k - row shift
            addi  $6, $0, 1      # l - positive or negative shift
            addi  $7, $0, -1     # m - -1, so we're not checking j against anything
            addi  $8, $0, 4      # n - we won't be shifting j at all here
            jal   Shift

            addi  $6, $0, 8      
            beq   $6, $5, Black  # if tmp is black, go to black code
            addi  $6, $0, 3
            bne   $6, $5, Inner  # if tmp is neither black nor blue, skip this pixel

            # begin blue code
Blue:       # START HERE
            jal   Shift



Black:      



            # other code for pixels to test

Shift:      sllv  $5, $1, 6     # (k * 16)

            lw    $5, Array($5)  # tmp = CrowdInts(place)
            add   $6, $6, $     # j-shift = j + k
            div   $6, $3
            mfhi  $6             # j-shift = (j + k) % 4
            sll   $6, $6, 3      # j-shift = 8 * ((j + k) % 4))
            srlv  $5, $5, $6     # tmp = CrowdInts(place) >> j-shift
            andi  $5, $5, 0xF    # (remove everything except pixel of interest)
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
