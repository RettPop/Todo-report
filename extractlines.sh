#!/bin/sh

# check if no params
if [[ -z $6 ]]; then
	echo "Report wanted text (TODO) from files under the current directory to specified file."
	echo "Wrong or absent parameters. Usage:\n$0 -t|--text <text regexp to look for> -m|--filemask <files mask> -o|--outfile <write result to name>"
	exit 2 
fi

for i in "$@"
do
	case $i in
		-t|--text)
			LOOKFORTEXT="$2"
			shift # past argument=value
			;;
		-m|--filemask)
			INFILESMASK="$2"
			shift # past argument=value
			;;
		-o|--outfile)
			OUTFILE="$2"
			shift # past argument=value
			;;
		--default)
			DEFAULT=YES
			shift # past argument with no value
			;;
		*)
			# unknown option
			;;
	esac
done

FILESCOUNT=0
LINESSCOUNT=0
#LOOKFORTEXT=$2
#OUTFILE=$1
#INFILESMASK=$3
echo "$LOOKFORTEXT"
echo "$OUTFILE"
echo "$INFILESMASK"
FILES=$(find ./ -name $INFILESMASK -exec grep -l $LOOKFORTEXT {} \;)
echo "" > $OUTFILE 

for f in $FILES
do
	# calculating files and entries
	((FILESCOUNT+=1))
	((LINESCOUNT+=$(grep $LOOKFORTEXT $f | wc -l)))

	#
	echo "===============================================" >> $OUTFILE
	echo "File: $f" >> $OUTFILE
	echo "===============================================" >> $OUTFILE
	grep -C 3 -n $LOOKFORTEXT $f >> $OUTFILE
done

echo "Lines found $LINESCOUNT\n$(cat $OUTFILE)" > $OUTFILE
echo "Files found $FILESCOUNT\n$(cat $OUTFILE)" > $OUTFILE
echo "\n$(cat $OUTFILE)" > $OUTFILE

echo "Files found $FILESCOUNT"
echo "Lines found $LINESCOUNT"
