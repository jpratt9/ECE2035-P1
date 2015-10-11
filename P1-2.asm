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
            addi  $2, $0, -4     # i = -1
            addi  $3, $0, 64     # (constant) = 16 (it's a waste of dynamic
                                 # calls to do this every loop iteration)

Outer:      addi  $2, $2, 4      # i++
            slti  $4, $2, 4096   # i < 1024
            beq   $4, $0, End    # if i >= 1024, end loop

            div   $2, $3
            mflo  $4             # row = i / 16
            mfhi  $5             # col = i % 16
            slti  $4, $4, 53     # row < 53
            slti  $5, $5, 14     # col < 14
            and   $4, $4, $5     # (row < 53) && (col < 14)
            beq   $4, $0, Outer  # our i is off, so we have to skip this i


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
