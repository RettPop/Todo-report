#!/bin/sh

# check if no params
if [[ -z $6 ]]; then
	echo "Report wanted text (TODO) from files under the current directory to specified file."
	echo "Wrong or absent parameters. Usage:\n$0 -t|--text <text regexp to look for> -m|--filemask <files mask> -o|--outfile <write result to name> -d|--rootdir <search files in>"
	exit 2 
fi

for i in "$@"
do
	case $i in
		-t|--text)
			LOOKFORTEXT="$2"
			shift # past argument=value
			shift # past argument=value
			;;
		-m|--filemask)
			INFILESMASK="$2"
			shift # past argument=value
			shift # past argument=value
			;;
		-o|--outfile)
			OUTFILE="$2"
			shift # past argument=value
			shift # past argument=value
			;;
		-d|--rootdir)
			PARENTDIR="$2"
			shift # past argument=value
			shift # past argument=value
			;;
		*)
			# unknown option
			;;
	esac
done

FILESCOUNT=0
LINESSCOUNT=0
TMPFILE="/tmp/$(basename $0).$$.tmp"
#PARENTDIR=$2
#LOOKFORTEXT=$1
#OUTFILE=$4
#INFILESMASK=$3
#echo "$LOOKFORTEXT"
#echo "$OUTFILE"
#echo "$INFILESMASK"
#echo "$PARENTDIR"

echo "find $PARENTDIR -name \"$INFILESMASK\" -exec grep -l $LOOKFORTEXT {} \;)"
FILES=$(find $PARENTDIR -name "$INFILESMASK" -exec grep -l $LOOKFORTEXT {} \;)

for f in $FILES
do
	# calculating files and entries
	((FILESCOUNT+=1))
	((LINESCOUNT+=$(grep $LOOKFORTEXT $f | wc -l)))

	#
	echo "===============================================" >> $TMPFILE
	echo "File: $f" >> $TMPFILE
	echo "===============================================" >> $TMPFILE
	grep -C 3 -n $LOOKFORTEXT $f >> $TMPFILE
done

echo "Lines found $LINESCOUNT\n$(cat $TMPFILE)" > $TMPFILE
echo "Files found $FILESCOUNT\n$(cat $TMPFILE)" > $TMPFILE
echo "\n$(cat $TMPFILE)" > $TMPFILE

cat $TMPFILE > $OUTFILE
rm $TMPFILE

#echo "Files found $FILESCOUNT"
#echo "Lines found $LINESCOUNT"
