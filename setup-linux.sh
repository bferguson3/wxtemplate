# wxWidgets Linux setup script by Ravbug (github.com/ravbug)
# This script will set up wxWidgets for use on your Linux computer. 

# Modify this variable if wxWidgets is not located in this repository
# change it to the path where wxWidgets is located
WXROOT=wxWidgets
dflag=""

# function that prints an error message and stops the script
# $1 = what failed
exitWithMessage(){
	echo -e "\n\e[101m$1\e[49m\e[91m failed with errors. Check the above output, correct the errors, and re-run this script.\e[39m";
	exit 1;
}

echoStatus(){
	echo -e "\e[45m$1:\e[49m $2"
}


# get the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" ;
cd $DIR;

# run autogen.sh
cd $WXROOT
echoStatus "autogen" "Running autogen.sh"
success=0;
./autogen.sh && success=1;

# check success
if [ $success = 0 ]; then
	exitWithMessage "autogen.sh"
fi

# run configure
# make the build directory
mkdir -p build/linux;
cd build/linux;

echoStatus "configure" "Running configure script with flags $WXFLAGS"
# run the configure script
success=0;

if [[ "$Dynamic" -eq 0 ]]; then
	dflag=--disable-shared
fi

../../configure --enable-unicode $dflag $WXFLAGS && success=1

# check success
if [ $success = 0 ]; then
	exitWithMessage "configure"
fi

# start make
threads=$(nproc);

echoStatus "make" "Starting silent make on $threads processes...";

# build the library (only print errors)
success=0
make -j$threads --silent && success=1

# check success
if [ $success = 0 ]; then
	exitWithMessage "make"
fi

# test the installed library
echo -e "\e[45mwx-config:\e[49m Currently installed wxWidgets version is \e[44m$(wx-config --version)\e[49m";

#echo "Running ldconfig to configure the dynamic linker runtime bindings, please enter the administrator password if prompted."
#sudo /sbin/ldconfig /usr/local/lib;

echo -e "\e[92msetup-linux is complete!\e[39m"

# set the directory back to the original script directory
cd $DIR;
