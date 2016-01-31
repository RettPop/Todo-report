#!/bin/sh
FILES=$(find ./ -name *.java -exec grep -l "TODO" {} \;)
FILESCOUNT=0
LINESSCOUNT=0
COMMONOUT=""
OUTFILE=todo.lines #$1
echo "" > $OUTFILE 
for f in $FILES
do
	((LINESCOUNT+=$(grep "TODO" $f | wc -l)))
	echo "===============================================" >> $OUTFILE
	echo "File: $f" >> $OUTFILE
	echo "===============================================" >> $OUTFILE
	grep -C 3 -n "TODO" $f >> $OUTFILE
	((FILESCOUNT+=1))
done
echo "Lines found $LINESCOUNT\n$(cat todo.lines)" > $OUTFILE
echo "Files found $FILESCOUNT\n$(cat todo.lines)" > $OUTFILE
echo "\n$(cat todo.lines)" > $OUTFILE

echo "Files found $FILESCOUNT"
echo "Lines found $LINESCOUNT"
