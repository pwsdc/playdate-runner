# Playdate Runner

A runner style game created for the Playdate. This is intended as a proof of concept to show the potential of Playdate development in the club.

## How to Play

Avoid obstacles for as long as possible. Press Up to jump, Down to duck, A to shoot, and B to pause the game. High scores can be reset by pressing Up and B on the title screen.

## Contributions

All contributions are welcome. See *Issues* for work that needs done.

## Setting up a Playdate Dev Environment

The following will set up the Playdate SDK for use with VS Code. You can use this to develop the game or simply to play it through the simulator. Instructions are provided for Windows and Linux.

### Download and Extract Playdate SDK

Download the Playdate SDK from [here](https://play.date/dev/). On Windows, run the executable. On Linux, extract the compressed archive, then open a terminal and run ```sudo ./setup.sh```. Remember the place the SDK is extracted to.

### Set up Path Variables

You will need to ensure your path is set up correctly. Where *YOUR_SDK_PATH* is mentioned, replace it with the path to your SDK, such as ```/home/paul/PlaydateSDK-2.5.0``` or ```C:\Users\Paul\Documents\PlaydateSDK```.

#### Linux

Create a file in your /etc/profile.d directory, such as custom.sh (the name does not matter but it must be an "sh" file). Add the following lines:

```
export PLAYDATE_SDK_PATH=YOUR_SDK_PATH
export PATH=YOUR_SDK_PATH/bin:$PATH
```

#### Windows

- Type "Path" into the start menu and click the entry that says "Edit the system environment variables".
- Under "User variables", add YOUR_SDK_PATH\bin to the "Path" variable.
- Create a new variable under "User variables" called "PLAYDATE_SDK_PATH", and set its value to YOUR_SDK_PATH.

Test that your path is set up properly by running ```pdc``` in the terminal. You may need to reopen your terminal or log out/log in for the changes to apply.

At this point, try running the Playdate Simulator to ensure it works. If it doesn't open, run ```PlaydateSimulator``` in the terminal to see the error message. On Linux, if it says "PlaydateSimulator: error while loading shared libraries: libwebkit2gtk-4.0.so.37", install webkit2gtk4.0 through your package manager, such as ```sudo dnf install webkit2gtk4.0```.

### Download VS Code

- Download and install VS Code from [here](https://code.visualstudio.com/).

### Download Lua and Git

#### Linux

- Install Lua and Git through your package manager, such as ```sudo dnf install lua git```.

#### Windows

- Download Lua from [here](https://luabinaries.sourceforge.net/download.html), choose the file that looks like "lua-5.4.2_Win64_bin.zip" (version number may be different). Extract it and add the folder to your "Path" variable.
- Download and install Git from [here](https://git-scm.com/download/win). The default options are fine except for the text editor, choose VS Code.

### Final Setup

- In VS Code, install the Playdate extension [here](https://marketplace.visualstudio.com/items?itemName=Orta.playdate).
- Clone the repo and open it in VS Code. If all went well, press Start Debugging (default key is F5) to run the game!
