#    Find George Possibly Incognito In a Crowd
#
#
# This routine finds an exact match of George's face (possibly incognito) 
# in a crowd.
#
# 10-12-2015                               John Pratt

.data
Array:   .alloc 1024

.text

FindGeorge: addi  $1, $0, Array
            swi   588

            # your code goes here
            addi  $1, $1, -1     # i = -1
Loop:       addi  $1, $1, 1      # i++





            ### The following are temporary (replace them).
            ### They are included to show how to use swi 552 and 553.
            addi  $2, $0, 160    # mark the 160th pixel
            swi   552            # with this swi
            addi  $2, $0, 161    # mark the 161th pixel
            swi   552            # with this swi
            addi  $2, $0, 300    # always guess 300th pixel
            ### The above instructions are temporary (replace them).
            swi   553            # submit answer and check
            jr    $31            # return to caller