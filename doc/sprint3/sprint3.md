# Sprint 3 Planning Meeting 

## Meeting Goal
Discuss what user stories we want to implement for sprint 3, break them down into tasks, assign them to team members. 

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
- Create multiplayer trivia game, and invite another user play with the same game with the 10 randomized questions
- Allow the invited user to join the same game
- Send notifications to a user that has been invited to play the game
- Send notifications of game results when both players have finished the game
- Allow users to play upto 5 games a day.
- Update ACS and its history of each user after they play the game.
- Implement ‘The Zone’ where users can view their posts as well as other users’ posts.
- Allow users to search for specific posts in ‘The Zone’ based on their title.
- Allow users to edit and delete their own posts.
- Allow users to agree or disagree to posts made by other users.
- Allow users to comment on a post. They can also edit and delete their comments.
- Fix bugs and new design changes from sprint 2: validation for birthday range, ensure ACS does not go below 100 and above 1100, initialize ACS to 200 when a new user signs up, fix null errors with navigation.


## Spikes
1. Trivia
   - Refactoring solo player trivia for multiplayer trivia
2. Connecting the frontend and backend
   - Flutter has a lot of issues with Null exceptions with vague messages when we try to call and get data from the backend. It is also very difficult and time consuming to debug. 

    
## User Stories and Breakdown of Tasks
1. [UN-12] As a user, I want to be able to play trivia head to head with other users so that I can increase my A.C.S. by competing with them.  
   - API and DB commands to Check/Update Daily trivia plays -  Zhi Hua  
   - Multiplayer trivia result page (frontend) - Jenny  
   - API and DB to Create, Store, retrieve game invite and game results  -  Zhi Hua  
   - Get list of questions for trivia  -  Zhi Hua  
   - Generalize solo trivia for multiplayer frontend - Jenny  
  
2. [UN-105] As a user, I should be able to search of an opponent to play against for multiplayer trivia.  
   - API and DB to Search for opponents to challenge - Zhi Hua
   - Frontend to Search for opponents to challenge - Jenny

3. [UN-114] As a user, I should get a notification when challenged by another user, or when someone accepts my challenge. 
   - Backend Add, Mark Read, Delete, List Notifications - Zhi Hua
   - Frontend see & delete notifications - Jenny

4. [UN-8] As a user, I want to be able to browse and create basketball posts in the zone.  
   - Frontend - implement The Zone UI - Rashida
   - Backend & DB - Add, edit and delete the post in the db - Anmole

5. [UN-10] As a user, I want to give feedback on other users' posts in the zone by commenting so I can be more engaged and involved in the community.  
    - Backend & DB - Add, edit and delete the comments of posts in the db - Maunica
    - Front-end: Allow users to add and delete comments to the posts - Devanshi

6. [UN-26] As a user, I want to give feedback on other users' posts in the open court by agreeing/disagreeing so I can be more engaged and involved in the community.  
   - Frontend - Rashida
   - Backend - Anmole

7. [UN-103] As a user, I want to be able to search for posts by a category in the zone
   - Backend & DB - collect posts from db and send them to front end - Maunica
   - Front-end: Add search bar and display filtered posts - Devanshi

8. [UN-109] Sprint 2 bugs  
   - Sign up birthday range - Maunica
   - ACS history range - Maunica
   - ACS History UI - Devanshi
   - Null errors with navigation - Rashida

