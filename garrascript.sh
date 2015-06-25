#!/bin/bash

VERSION=0.5
SELF=$(basename $0)
UPDATE_BASE=https://raw.githubusercontent.com/MrGarri/Garrascript/master/garrascript.sh
FILES=https://raw.githubusercontent.com/MrGarri/Garrascript/master/Files/88k_Linux_Static.tar.gz

source .garrastats 2> /dev/null

function download {

	wget --quiet --output-document=$1 $2 &

	while [[ $(ps | grep -c "wget") -gt 0 ]]
		do
			echo -ne "Downloading files.  \r"
			sleep 0.5
			echo -ne "Downloading files.. \r"
			sleep 0.5
			echo -ne "Downloading files...\r"
			sleep 0.5
	done

	printf "\rDone!                    \n"

}

function inst {

	download 88k_Linux_Static.tar.gz $FILES
	echo "Copying files..."
	tar -zxf 88k_Linux_Static.tar.gz
	mv EM88110/* .
	if [[ $? != 0 ]]
		then
			printf "\nAn unexpected error occured while copying the files. Please try again later\n\n"
			exit 1
	fi
	rm -r EM88110 && rm 88k_Linux_Static.tar.gz
	echo "Done!"
	if [[ $1 != true ]]
		then
			echo "Do you want to install the 88110 emulator? [Y/n]"
			read input
	fi
	if [[ $1 == true || $input == "Y" || $input == "y" || $input == "" ]]
		then
			printf "Just follow the instructions...\n\n"
			sudo ./INSTALL
			if [[ $? != 0 ]]
				then
					printf "\nAn unexpected error occured while installing the emulator. Please try again later\n\n"
					exit 1
			fi
			printf "\nProcess completed! Run again this script to compile and execute a program.\n\n"
			printf "To view how this script works, run $0 -h or $0 --help\n\n"
			exit 0
		else
			exit 0
	fi
}

if [[ $1 == "--help" || $1 == "-h" || $1 == "" ]]
	then
		printf "\nCompiles .ens files using 88110 emulator and executes them.\n\n"
		echo "Usage: garrascript.sh NAME [SUBROUTINE]"
			printf "\tName:\t\tname of the file without extension.\n"
			printf "\tSubroutine:\tname of the subroutine. Using this command only compiles the given subroutine.\n\n"

		echo "Special options:"
			printf "\t-h, --help: Shows this help text.\n"
			printf "\t--version: Shows current version of the script.\n"
			printf "\t--stats: Shows executing stats of this script.\n"
			printf "\t--update: Auto-updates the script to the latest version.\n"
			printf "\t--install: Downloads and installs all emulator files.\n"

		printf "\n\nYou can ask my cat now how this script works\n\n"
		exit 0

elif [[ $1 == "--version" ]]
	then
		printf "\nGarraScript version $VERSION.\n"
		printf "Last updated on $(date -r $SELF).\n\n"
		exit 0

elif [[ $1 == "--stats" ]]
	then
		printf "\nCorrect executions:\t\t$SUCCESSFUL_EXEC\n"
		printf "Wrong executions:\t\t$WRONG_EXEC\n\n"
		exit 0

elif [[ $1 == "--update" ]]
	then
		# Download new version
		download $0.tmp $UPDATE_BASE
		# Copy over modes from old version
		OCTAL_MODE=$(stat -c '%a' $0)
		chmod $OCTAL_MODE $0.tmp
		# Overwrite old file with new
		mv -f $0.tmp $0

		if [[ $? == 0 ]]
			then
				NEWVER=$(head garrascript.sh | grep "VERSION=" | sed 's/[^0-9.]//g')
				if [[ $NEWVER != $VERSION ]]
					then
						echo "Succesfully updated to version $NEWVER!"
					else
						echo "No updates found."
				fi
				exit 0
			else
				echo "There was an error performing the update, please try again later. Exit code: $?"
				exit 1
		fi
elif [[ $1 == "--install" ]]
	then
		inst true
elif [[ ! -e 88110e || ! -e 88110ins || ! -e em88110 || ! -e INSTALL || ! -e serie || ! -e paralelo ]]
	then
		echo "One or more files are not in the current directory. Do you want to download them? [Y/n]"
		read input
		if [[ $input == "Y" || $input == "y" || $input == "" ]]
			then
				inst false
		else
			exit 0
		fi

# Main program.

else
	if [[ $2 ]]
		then
			./88110e -e $2 -o $1.bin $1.ens
		else
			./88110e -o $1.bin $1.ens
	fi

	if [[ $? == 0 ]]
		then
			./em88110 -c serie $1.bin
			CORRECT=true
	fi

	if [[ $CORRECT == true ]]
		then
			printf "\nThanks for using GarraScript, $USER!\n\n"
			((SUCCESSFUL_EXEC++))
			WRONG_EXEC_ROW=0
		else
			if [[ $WRONG_EXEC_ROW -gt 8 ]]
				then
					printf "\n\nOH GODDAMNIT $USER JESUS CHRIST JUST FIX IT ALREADY FOR FUCKS SAKE!\n\n"
				else
					printf "\n\nWe're sorry, $USER, but an unexpected error ocurred while executing. Check your commands and try again!\n\n"
			fi
			((WRONG_EXEC++))
			((WRONG_EXEC_ROW++))
	fi

	printf "SUCCESSFUL_EXEC=$SUCCESSFUL_EXEC\nWRONG_EXEC=$WRONG_EXEC\nWRONG_EXEC_ROW=$WRONG_EXEC_ROW\n" > .garrastats
fi
