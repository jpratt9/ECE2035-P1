/*  <your name goes here>

This program finds George (possibly incognito) in a crowd. */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
   int CrowdInts[1024];
   int NumInts, Location=0;
   int Load_Mem(char *, int *);

   if (argc != 2) {
     printf("usage: ./P1-1 valuefile\n");
     exit(1);
   }
   NumInts = Load_Mem(argv[1], CrowdInts);
   if (NumInts != 1024) {
      printf("valuefiles must contain 1024 entries\n");
      exit(1);
   }
   
   /* your code goes here. */
   int i, j;
   int tmp;
   int row, col;
   bool found;
   for(i = 0; i < 1024; i++) {
      found = false;
      //once row > 52 or column >
      row = i / 16;
      col = i % 16;
      /* row and col max values calculated to prevent going out of bounds */
      if (row < 53 && col < 14) {
         for (j = 0; j < 4; j++) {

            /* shift line to pixel of interest */
            tmp = CrowdInts[i] >> 8*(3-j);
            /* remove everything except pixel of interest */
            tmp = tmp & 0xF;

            /* only found if our pixel is blue or black */
            found = (tmp == 3) || (tmp == 8);

            /* check if pixel in (,) is white: */
            /* the i-shift is precalculated given all possible values of j and 
               where the white pixel is in relation to the blue/black pixel */
            tmp = CrowdInts[i + 16 + j/3];
            /* the j-shift is precalculated given all possible values of j and 
               where the white pixel will be inside the "line" given the value 
               of j */
            tmp = tmp >> ((j + 1) % 3 - place / 3);
            /* now again we get rid of everything but the pixel of interest */
            tmp = tmp & 0xF;

            /* "found" now includes whether this other pixel was white */
            found = found && (tmp == 1);
            
            if (found) {
               /* pixel (hat) is blue */
               if (tmp == 3) {
                  
               }
               /* pixel (hat) is black */
               else if (tmp == 8) {
                  
               }
            }
         }
      }
   }

   printf("The rightmost pixel at the top of George's hat is located at: %4d.\n", Location);
   exit(0);
}

/* This routine loads in up to 1024 newline delimited integers from
a named file in the local directory. The values are placed in the
passed integer array. The number of input integers is returned. */

int Load_Mem(char *InputFileName, int IntArray[]) {
   int	N, Addr, Value, NumVals;
   FILE	*FP;

   FP = fopen(InputFileName, "r");
   if (FP == NULL) {
      printf("%s could not be opened; check the filename\n", InputFileName);
      return 0;
   } else {
      for (N=0; N < 1024; N++) {
         NumVals = fscanf(FP, "%d: %d", &Addr, &Value);
         if (NumVals == 2)
            IntArray[N] = Value;
         else
            break;
      }
      fclose(FP);
      return N;
   }
}
