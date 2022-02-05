# egpdesigner2
A [love2d](https://love2d.org/) tool to export user-drawn images to [wiremod](https://github.com/wiremod/wire) E2 EGP code


# HOW TO INSTALL
Install love2d from [here](https://love2d.org/#download)

Download the whole repo as zip and run "run.bat"


# HOW TO CHANGE THE BACKGROUND IMAGE
Open the folder named "res" and replace "image.png" with a 512x512 png image

# CONTROLS
## globals

w & s: Advance & deadvance currently selected object

r: Go to select mode

f: Go to addmode

t (if polygon selected): Go to polydraw mode

space: Go back to select mode

middleclick: Drag camera around

## selectmode
leftclick: Select object, DOESNT work on text

## addmode
leftclick: Adds an object with currently the selected object type to the currently selected id

## polydraw
e & q: advance/deadvance currently selected polygon

leftclick add polygon point


# FAQ
Why does run.bat say "love2d doesnt seem to be installed, please refer to the instructions in https://github.com/lokachop/egpdesigner2"?
- You probably dont have love2d installed, which you can download [here](https://love2d.org/#download), otherwise love2d isnt on PATH

Why does my EGP go offscreen?
- You probably used an image bigger than 512x512 as the background, or you drew off the border

Why doesn't it let me export/save?
- You probably didnt give your file a name, just type something in the text entry below the main viewport

Why doesn't loading work?
- You either made a typo or my loader broke, check the console for more info


If you encounter any unlisted problems, feel free to message me over discord (Lokachop#5862)


