#!/usr/bin/awk -f 
   {
      system("wget  ftp://ftp.fu-berlin.de/pub/misc/movies/database/" $1);
      system("gunzip " $1);
   }

 
