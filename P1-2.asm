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

            addi  $6, $0, 3
            addi  $7, $0, 8
            addi  $8, $0, 2
            addi  $9, $0, 5
            addi  $10,$0, 7

            # incrementation of row and col were calculated based on
            # several trials of each with all combinations of values ranging
            # from 3 to 6
            addi  $1, $0, 1        # col_i = 2
ColLoop:    addi  $1, $1, 4         # col+=4
            addi  $3, $0, -5        # row_i = 0
RowLoop:    addi  $3, $3, 5         # row+=5
            slti  $5, $3, 60        # tmp = (row < 58)
            beq   $5, $0, ColLoop   # if (row >= 58), skip to next column
            sll   $2, $3, 6         # index
            add   $2, $2, $1        # index = col + 64 * row
            # swi   552


            # prototype code for linear indexing, not (row,col) -> index
            #addi  $2, $0, -6
            #addi  $2, $2, 6
            #srl   $1, $2, 

            # check that pixel is not background color
            lbu   $4, Array($2)     # pixel = Array(index)
            slti  $5, $4, 9         # tmp = pixel < 9 (face colored)
            beq   $5, $0, RowLoop   # if (pixel >= 9), skip to next pixel

            
            # All we know from here is that we're on top of the hat.
            # From here, we need to get to a reference point. I picked the 
            # bottom-left of the hat.

            # swi   552

            beq   $4, $6, Left        # if the hat is Blue, start moving to 
                                      # reference point
            bne   $4, $7, RowLoop     # if it wasn't blue or black, wrong face

            #swi   552
            
            # The following code (up to but not including "Stripes")
            # will move our index to that of the bottom left of the hat
            # (because this is the simplest reference point to get to).
# Move:       beq   $1, $0, Down      # skip to going down to prevent going out of 
                                    # bounds
            
            # Firstly, we need to get to the far-left point in the current row
            # (on the hat).
Left:       addi  $2, $2, -1        # location left of pixel
            lbu   $4, Array($2)     # load left pixel
            slti  $5, $4, 9         # tmp = (left pixel < 9)
            bne   $5, $0, Left      # if (left pixel < 9), keep going left
            addi  $2, $2, 1         # This algo is bound to take us off the hat,
                                    # so we'll need to adjust the final location

DownLeft:   addi  $2, $2, 63        # location down-left of pixel
            lbu   $4, Array($2)     # load down-left of pixel
            slti  $5, $4, 9         # tmp = (down-left pixel < 9)
            bne   $5, $0, DownLeft  # if (left pixel < 9), keep going down-left
            addi  $2, $2, -63       # This algo is bound to take us off the hat,
                                    # so we'll need to adjust the final location

Down:       addi  $2, $2, 64        # location below pixel
            lbu   $4, Array($2)     # load below pixel
            slti  $5, $4, 9         # tmp = (below pixel < 9)
            bne   $5, $0, Down      # if (below pixel < 9), keep going down
            addi  $2, $2, -64       # This algo is bound to take us off the hat,
                                    # so we'll need to adjust the final location

            # swi   552

            # stripe check (before checking hat color, because the majority of
            # hats are blue or black)
Stripe:     addi  $4, $2, -61
            addi  $5, $0, 1
            lbu   $4, Array($4)
            bne   $4, $5, RowLoop

HatColor:   lbu   $4, Array($2)
            beq   $4, $6, Blue
            bne   $4, $7, RowLoop   # if it wasn't blue or black, wrong face

Black:      addi  $4, $2, 65        # glasses
            lbu   $4, Array($4)
            bne   $4, $6, RowLoop

            addi  $4, $2, 259       # moustache
            lbu   $4, Array($4)
            bne   $4, $7, RowLoop

            addi  $4, $2, 450       # shirt
            lbu   $4, Array($4)
            bne   $4, $7, RowLoop

            addi  $4, $2, 129       # skin
            lbu   $4, Array($4)
            bne   $4, $9, RowLoop

            j     End               # make sure we don't accidentally 
                                    # execute Blue code

Blue:       addi  $4, $2, 66        # eyes
            lbu   $4, Array($4)
            bne   $4, $10,RowLoop

            addi  $4, $2, 259       # mouth
            lbu   $4, Array($4)
            bne   $4, $8, RowLoop

            addi  $4, $2, 450       # shirt
            lbu   $4, Array($4)
            bne   $4, $6, RowLoop

            addi  $4, $2, 65        # skin
            lbu   $4, Array($4)
            bne   $4, $9, RowLoop

End:        addi  $2, $2, -251
            swi   553               # submit answer and check
            jr    $31               # return to caller
