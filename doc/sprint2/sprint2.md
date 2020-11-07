# Sprint 2 Planning Meeting 

## Meeting Goal
Discuss what user stories we want to implement for sprint 2, break them down into tasks, assign them to team members. 

## Attendees
- Devanshi Parekh
- Rashida Kapadia
- Maunica Toleti
- Zhi Hua Lim 
- Jenny Quach
- Anmole Bajwa

## Team Capacity
Total capacity: 6 hours/day
Number of days in sprint: 10
Number of team members: 6
Using focus factor (F.F. - 0.6 - 0.8): 0.7
Team capacity = 6*4*10*0.7 = 252 hours

## Sprint Goals
- Create solo trivia game  play with 10 randomized questions 
- Update profile page with more user info 
- Create a settings page to view app info and edit user email, phone number or change user password 
- Allow user to log out of the app 
- Create a ACS history page to view the details of the user’s last 10 points transaction 
- Fix bugs and new design changes from sprint 1: validation for forms, adding first and last name of the user, moving email to settings page.

## Spikes
1. Trivia
    - Deciding on how to implement the trivia using “State” class 
    - Breaking Trivia into sub-tasks and coordination among them

2. Figuring out how to use the flutter session variables worked and how to retrieve info from it

3. Connecting the frontend and backend
    - Flutter has a lot of issues with Null exceptions with vague messages. It’s difficult to debug.
    
## User Stories and Breakdown of Tasks
1. [UN-45] As a new user, I should be immediately alerted when I update the profile page with incorrect email or birthday format.
    - Validation error should up up immediately while editing profile page - Rashida  

2. [UN-46] As a new user, I should be immediately alerted when I fail to sign up due to using an existing email or username.
    - Validation error should up up immediately while signing up/logging in - Maunica  

3. [UN 11] As a user, I want to be able to play trivia alone so that I can increase my A.C.S while improving upon my sports knowledge and analytical skills.
    - Insert trivia questions in the DB - Jenny
    - Main trivia web page - Devanshi
    - Solo trivia webpage - Anmole
    - API to get questions from DB - Jenny
    - Frontend to backend connection - Maunica 
    - API to update ACS score - Zhi Hua


4. [UN-47] As a user, I should be able to view my history of ACS score based on the points that I earned/lost while playing trivia
    - Create the webpage to view ACS history - Devanshi
    - Store ACS changes in DB - Zhi Hua
    - API to get ACS  - Zhi Hua

5. [UN-50] As a user, I should be authenticated with a session that allows the state of my page to remain when I'm logged in and I may stay in the app until I log out
    - Flutter session - Jenny

6. [UN-41] As a user, I want to be able to modify general settings of the app
    - Functionality to log out of app - Jenny
    - Create backend APIs to allow user to change password and contact info - Zhi Hua
    - Settings Webpage - Rashida
    - Frontend pages to allow user to change their password, phone number and email - Rashida
