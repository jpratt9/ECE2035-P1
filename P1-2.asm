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
            addi  $3, $0, -1        # row
RowLoop:    addi  $3, $3, 1         # row++
            slti  $5, $3, 58        # tmp = (row < 58)
            beq   $5, $0, ColLoop   # if (row >= 58), skip to next column
            sll   $2, $3, 6         # index
            add   $2, $2, $1        # index = col + 64 * row

            # check that pixel is not background color
            lbu   $4, Array($2)     # pixel = Array(index)
            slti  $5, $4, 9         # tmp = pixel < 9 (face colored)
            beq   $5, $0, RowLoop   # if (pixel >= 9), skip to next pixel

            # check that pixel is either blue or black (for correct hat color)
            addi  $5, $0, 3         # check for blue
            beq   $4, $5, Move
            addi  $5, $0, 8         # check for black
            beq   $4, $5, Move
            j     Wrong
            
            # All we know from here is that we're on top of the hat.
            # From here, we need to get to a reference point. I picked the 
            # bottom-left of the hat.

            
Move:       beq   $1, $0, Down      # skip to going down to prevent going out of 
                                    # bounds
            
            # Firstly, we need to get to the far-left point in the current row
            # (on the hat).
Left:       addi  $3, $3, -1        # location left of pixel
            lbu   $4, Array($3)     # load left pixel
            slti  $5, $4, 9         # tmp = (left pixel < 9)
            bne   $5, $0, Left      # if (left pixel < 9), keep going left
            addi  $3, $3, 1         # This algo is bound to take us off the hat,
                                    # so we'll need to adjust the final location

DownLeft:   addi  $3, $3, 63        # location down-left of pixel
            lbu   $4, Array($3)     # load down-left of pixel
            slti  $5, $4, 9         # tmp = (down-left pixel < 9)
            bne   $5, $0, DownLeft  # if (left pixel < 9), keep going down-left
            addi  $3, $3, -63       # This algo is bound to take us off the hat,
                                    # so we'll need to adjust the final location

Down:       addi  $3, $3, 64        # location below pixel
            lbu   $4, Array($3)     # load below pixel
            slti  $5, $4, 9         # tmp = (below pixel < 9)
            bne   $5, $0, Down      # if (below pixel < 9), keep going down
            addi  $3, $3, -64       # This algo is bound to take us off the hat,
                                    # so we'll need to adjust the final location




            lbu   $4, Array($3)
            addi  $2, $3, 0
            swi   552


      
            


            ### The following are temporary (replace them).
            ### They are included to show how to use swi 552 and 553.
            #addi  $2, $0, 160       # mark the 160th pixel
            #swi   552               # with this swi
   
            #addi  $2, $0, 161       # mark the 161th pixel
            #swi   552               # with this swi

            #addi    $2, $0, 300     # always guess the 300th pixel
            ### The above instructions are temporary (replace them).


  
End:        swi   553               # submit answer and check
            jr    $31               # return to caller

Wrong:      addi  $2, $2, 11
            j     RowLoop
