::most basic ass bat file to launch the program, by lokachop
@echo off
echo egpdesigner2, by lokachop
love %CD% --console && (
    echo ran properly!
) || (
    echo love2d doesnt seem to be installed, please refer to the instructions in https://github.com/lokachop/egpdesigner2
    pause
)