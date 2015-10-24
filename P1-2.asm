#    Find George Possibly Incognito in a Crowd
#
#
# This routine finds an exact match of George's face (possibly incognito)
# in a crowd.
#
# 10-11-2015                               John Pratt

.data
Array:      .alloc 1024

.text

FindGeorge: addi  $1, $0, Array     # point to array base
            swi   588               # generate crowd

            # We're going to move down columns rather than across rows
            # That way, if we find a face that isn't right we can skip down a 
            # few rows, and when we get to the bottom, we can skip to the next
            # column.
            addi  $1, $0, -1        # col
ColLoop:    addi  $1, $1, 1         # col++
            addi  $2, $0, -1        # row
RowLoop:    addi  $2, $2, 1         # row++
            slti  $5, $2, 58        # tmp = (row < 58)
            beq   $5, $0, ColLoop   # if (row >= 58), skip to next column
            sll   $3, $


      
            ### The following are temporary (replace them).
            ### They are included to show how to use swi 552 and 553.
            addi  $2, $0, 160       # mark the 160th pixel
            swi   552               # with this swi
   
            addi  $2, $0, 161       # mark the 161th pixel
            swi   552               # with this swi

            addi    $2, $0, 300     # always guess the 300th pixel
            ### The above instructions are temporary (replace them).

End:        swi   553               # submit answer and check
            jr    $31               # return to caller
