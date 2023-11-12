# John Cage Tribute

A tribute to avant grade musician John Cage

## Getting Started

This is the mobile part of the John Cage Tribute project. This is V3 of the team working on this.
Big thanks to all the contributions the previous teams put into this, as they helped greatly to understand where to start.

The structure of the app is important to how the app should be read. Each type of flutter file is put into its corresponding folder, denoting what to expect in those files.
There are 7 folders inside the 'lib' folder:
## [/APIfunctions](lib/APIfunctions)
APIfunctions contain the separated out API calls that will be made to the server. There is an 'api_globals.dart' file that contains the functions by most, if not all, the other API functions.
Each API route is split into its own file, each of which contain a class that houses all of the endpoints that will be communicated with.
### concertAPI
Has the endpoints that are related to the concerts. They all call the '/api/concerts' endpoint and its extensions. Concerts are the recordings themselves.
### groupsAPI
Has the endpoints that are related to the groups. They all call the '/api/groups' endpoint and its extensions. Groups refers to the 'sessions' that one can schedule.
### userAPI
Has the endpoints that are related to the users. They all call the '/api/users' endpoint and its extensions. Users are...well...users.
## [/components](lib/components)
components contain the smaller UI elements used throughout the app. It contains some smaller widgets, as well as all of the drawers.
### audio_wavepainter
This is the waveforms that can be seen when recording on the maestro or performer screens. Fairly barebones.
### concert_card
This displays the information related each concert, such as the title, maestro, and tags.
### concert_filter
This is the drawer seen on the concerts screen. It lets the user filter the concerts by a date range. Uses the ConcertManager.
### concert_filter_tags
Unused. Holdover from when we were going to have a list of tags that a user can filter by.
### group_card
This has the schedule cards seen on the schedule screen. Has both kinds of cards seen on this screen.
### group_filter
This is the drawer seen on the schedule screen. It lets the user filter when they want to schedule a session. Uses the ScheduleManager.
### profile_drawer
This is the drawer seen on every major screen in the top left. This lets a user login or register, or visit their profile.
### textfields
Has the textfields seen on the profile and login/register screens. Leftover from when I was going to use the same kind of format for every textfield but decided it wasn't that useful.
### tooltips
Has the tooltips seen on the profile and login/register screens. Used to help give notes on what kind of information is required when loggin in and registering.
## [/managers](lib/managers)
managers contains the classes that will "control" some of the major components. They contain the major functions that those components will be using, moving the rsponsibilities away from the components themselves, leaving just the UI in them.
### concert_search_manager
Manages the concert_filter. Holds the dates that can be filtered by, as well as houses the date picker.
### concert_tags_manager
Unused. Holdover from when we were going to have a list of tags that a user can filter by.
### nav_bar_manager
Manages the state of the bottom navigation bar. Can be expanded to include more buttons on the bottom.
### schedule_manager
Manages the group_filter. Same functionality as the concert_search_manager.
## [/models](lib/models)
models contains the major objects used within the project, those being users, groups, and concerts. They house the data that can be displayed to the users of the app.
## [/routes](lib/routes)
routes contains one route file that houses all of the navigation between different screens. It also controls what data is sent to each screen, if there is any.
## [/screens](lib/screens)
screens contains each major(and minor) screen that the user will visit using the app. Here is the flow of what each screen is and where each screen leads:
### skeleton
This is the main screen that has most of the logic for navigation in the app. It allows for the navigation of most other screens. This houses the bottom nav bar that leads to three other screens.
### home
The home screen is the screen that greats the user when they first start up the app. It has a small paragraph about the app, who worked on it and a little information about John Cage himself.
### concerts
This screen is where a user can see all past recorded concerts. There is an 'upcoming concert' card that leads to the next concert that will be recorded. Leads to that grops' info screen
### individual_group
This is the information screen regarding a group. This is where a user can join the session, whether by actually performing or just listening.
### maestro, performer, and listener
All three screens has the same or similar functionality. They all connect to the socket of their namesake. Maestro is the person that actually controls the recording, by starting and stopping it at their leisure.
Performers can only connect or leave. They will be started once the maestro starts. Listeners can only listen. Each one looks very similar and has the same functionalities (generally).
### individual_concert
This is the information screen regarding the concerts themselves. They also allow the users to play the concert that they click on. They can also choose to download the concert.
### schedule
This is the screen where a user can actually schedule their own session to make their own concert. Leads to the add_group screen, as well as individual_group. Uses group card and has the group_filter.
### add_group
Lets the user actually create their own concert. User inputs title, can choose the mixing method (which is dynamically loaded with an API request to the server), and have a description and tags.
Once they hit the "Create" button, they must either log in to create it or reinput their password to confirm they are logged in. These lead to the register and login screens.

Also on the skeleton is the profile drawer, which can be reached from every screen. This is where the user can log in, register, or view their profile if they are already logged in.
### login
Screen that lets the user log in. Can also take the user to the register screen. If they forgot their password, they can choose to reset it here too.
### forgot_password
Lets user reset their password by entering their email. If the user's email is not found in the database, the user is notified immediately.
### register
Lets the user register for an account with us. Users are only required to put in their email, a username, and password. Once they are registered, they are also automatically logged in.
### user_profile
Once a user logs in, the profile drawer changes to let the user visit their profile. Again, pretty barebones but easy to add more fields if/when more are added. Also displays a "profile picture" as a placeholder for if that is added.
This leads to the "edit profile" screen using the update profile button. There was also a change password screen but that functionality was not added.
### edit_profile
Lets the user edit their profile. Users can only update their username. (Going through the hastle of changing emails is not worth it at the moment, and there is nothing else that can be changed :P)
### error_screen
In case something goes wrong with the route navigiation, this screen is there to notify the user of that and not scare them with the red screen of death.
### groups_screen
Unused. Holdover from when the groups weren't fully fleshed out uet. Similar style as the concerts screen, but would have led to any groups that the user had joined.
## [/utils](lib/utils)
utils contain the general utilities that don't fit into the definition of models or managers. These are classes that are used by other classes that sorta interface with existing libraries.
Player and recorder both interface with the "flutter_sound" plugin. They contain the functions that would be involved with the player and recorder functionality.
Socket interfaces with the "WebSocketChannel." Is actually an abstract class that is implemented into the three socket variants. Each variant is labeled "socket___" to signify which socket endpoint it connects to.
Utils also has all of the global variables used throughout the project. One major part of it is the textstyles. This allows for the same, or similar, styles to be used through the app, ensuring that everything is uniform.
The rest of the variables are general purpose and not noteworthy. Utils also has the major colors used. Same purpose as the textstyles, but also allow for expansion if a user wants to switch between light and dark mode version of the app.
Concert_player is separate from the player and recorder because it uses a different library called "just_audio," which is what we use to play back the concerts. This can be changed to just use flutter_sound in the future but this wasn't a priority.
