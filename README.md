# Garrascript
Right after you've downloaded the script from <a href="https://raw.githubusercontent.com/MrGarri/Garrascript/master/garrascript.sh" target="_blank">here</a> (right-click on the link and select 'Save link as...' option), open a terminal
emulator, navigate to the location the script is and execute the following command:

    chmod +x garrascript.sh
        

### Usage

    ./garrascript FILENAME [SUBROUTINE]
    
The file must be specified without the extension, just by its name. By default, the script will compile the file and execute the emulator. However, you can specify the name of a subroutine to just compile and execute that specific subroutine without executing or compiling the rest of the file.

Here are also some special options you may find useful:

*   *-h, --help:* Shows help text.<br> 
*   *--version:* Shows actual version of the script.<br>
*   *--update:* Auto-updates the script to the latest version.<br>
*   *--stats:* Shows executing stats of this script.<br>
*    *--install:* Downloads and installs all emulator files.

**Execution example**

The following command will compile the file and launch the emulator with the necessary files.

    ./garrascript.sh <filename> 
    
If you want to compile and execute only a subroutine, execute the following command:

    ./garrrascript.sh <filename> <subroutine_name>
