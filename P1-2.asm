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

            lbu   $2, 0($1)
            lbu   $3, 1($1)
            lbu   $4, 2($1)
            lbu   $5, 3($1)

            # your code goes here
            addi  $1, $1, -1     # i = -1

            # note - we precalculate the max value for i's of interest
            # this is based on the fact that faces can't hang off the picture
Outer:      addi  $1, $1, 1      # i++
            slti  $4, $1, 3384   # i < 846 (precalculated - explained above loop header)
            beq   $4, $0, End    # if i >= 847, end loop
            
            # check col
            #rem   $4, $1, $2     # col = i % 16     
            slti  $4, $4, 14     # col < 14
            beq   $4, $0, Outer  # our i is off, so we have to skip this i

            

            

End:        jr    $31            # return to caller






            ### The following are temporary (replace them).
            ### They are included to show how to use swi 552 and 553.
            addi  $2, $0, 160    # mark the 160th pixel
            swi   552            # with this swi

            addi  $2, $0, 161    # mark the 161th pixel
            swi   552            # with this swi

            addi  $2, $0, 300    # always guess the 300th pixel
            ### The above instructions are temporary (replace them).

            swi   553            # submit answer and check
                        
