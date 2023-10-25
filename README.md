# john_cage_tribute

A tribute to avant grade musician John Cage

## Getting Started

This is the mobile part of the John Cage Tribute project. This is V3 of the team working on this.
Big thanks to all the contributions the previous teams put into this, as they helped greatly to understand where to start.

The structure of the app is important to how the app should be read. Each type of flutter file is put into its corresponding folder, denoting what to expect in those files.
There are 5 major folders inside the 'lib' folder:
APIfunctions contain the separated out API calls that will be made to the server. There is an 'api_globals.dart' fiel that contains the functions by most, if not all, the other API functions.
Each API route is split into its own file, each of which contain a class that houses all of the endpoints that will be communicated with.

components contain the smaller UI elements used throughout the app. It contains some smaller widgets, as well as all of the drawers.

routes contains one route file that houses all of the navigation between different screens.

screens contains each major(and minor) screen that the user will visit using the app. The main screen that will greet users and provide a form of navigation is 'skeleton_screen.dart.'
The skeleton will help the use to navigate to the three main screens while also maintaining not rebuilding the bottom app bar everytime. It also contains all of the drawers and major utilities.
The three main screens are the home, concerts, and schedule screens. Each have their own drawer found within the skeleton. The needed utilities are passed to each screen as needed.
All other screens can be reached either from drawers or from API components, such as concerts or schedules.
The home screen is where the user starts. It is the screen that automatically comes up on app open.

utils are the utilities used (mostly) by the components. There are a few exceptions to this, such as the 'user', 'group', and 'concert.' These are used on their respective screens. User is used almost everywhere.
It also has some of the managers of the components and helps communication between the screens and the components, especially since they are split between the skeleton and actual screens.
The global utils are also put into this folder. These contain some of the standard sizes for font and icons, as well as decorations used throughout.
There are also the standard colors used in the app. It defines the major colors by name, and it defines where each color should be used.
