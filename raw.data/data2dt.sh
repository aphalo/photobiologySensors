#!/bin/bash
for f
do
cp $f $f.old
rm $f
sed s/[\.]data/.dt/g $f.old > $f
done