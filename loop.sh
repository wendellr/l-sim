#!/bin/sh

a=1

until [ $a -ge 100 ]
do
   perl l-sim.pl
   a=`expr $a + 1`
done

