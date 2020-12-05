# Sprint 4 Planning Meeting 

## Meeting Goal
Discuss what user stories we want to implement for sprint 4, break them down into tasks, assign them to team members. We decided that our team will complete 41 story points for this sprint.  
  
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
- Implement ‘Debate’ where users can submit responses for daily questions, rate others and view results for your group, view results for the previous debate topic and also be able to view ongoing responses for the current debate topic and previous debate  as well as other users’ posts.  
- Receive notifications when debate results are available and when a daily question is available.  
- Allow users to view the Picks of the previous season under ‘Picks and Predictions’.  
- Allow users to search for specific posts in ‘The Zone’ based on their title.  
- Allow users to edit comments on a post.   
- Fix a lot of bugs that were accumulated since previous sprints such as Null errors on page navigation, fixing UI to allow users to agree or disagree to posts made by other users, UI for viewing timestamp and several others as mentioned in ‘User Stories and breakdown of tasks’ (and in JIRA).  


## Spikes
1. Debate
   - The timeline and critical path: Our debate’s functionality and flow is dependent on the days. So all the different components are heavily dependent on each other. We’d have to wait for day 1 and day 2 features to be implemented inorder to display day 3 features (viewing results) 
    
## User Stories and Breakdown of Tasks
1. [UN-163] As a user, I want to view the daily question according to my tier.  
   - Page - Maunica
   - Client Request - Maunica
   - Server API & DB - Maunica  
  
2. [UN-169] As a user, I want to view ongoing debate topics for my tier and all other tiers.   
   - Frontend Page - Anmole
   - Client Request - Devanshi 
   - Backend - Jenny
    
3. [UN-170] As a user, I want to see my debate analysis result for the last answered debate question.  
   - Frontend Page - Anmole
   - Client Request - Devanshi 
   - Backend - Jenny
  
4. [UN-171] As a user, when the debate analysis comes in, I can a see notification leading me to see the score and rating of my last analysis
   - Frontend - Jenny
   - Backend/DB - Zhi Hua
  
5. [UN-172] As a user, I want to receive notifications when a new question is available
   - Frontend - Jenny
   - Backend - Zhi Hua
  
6. [UN-164] As a user, I want to vote responses of other users in different groups by using a sliding scale metric
   - Frontend - Anmole
   - Client Request - Jenny
   - Backend - Jacob

7. Other issues
   - Import list of daily questions - Jenny
   - [UN-158] As a user, I want to navigate to the main page of debate to view different options such as answering, responding and viewing my results - Rashida
   - [UN-161] As a user, I want to submit my response to the daily debate topic - Maunica
   - [UN-173] As a user, I want to earn participation marks by responding to other submissions - Zhi Hua
   - [UN-174] As a user, I should be placed into small 3 man groups so I can compare my answers with others. - Maunica
   - [UN-178] As a user, I want to view the picks of the previous season. - Rashida
  
8. [UN-147] Sprint 3 bugs    
   - As a user, I should be able to edit my own posts in The Zone - Maunica
   - As a user, I should be able to delete my own posts in The Zone - Maunica
   - As a user, I want to be able edit my comments in the zone - Devanshi
   - Null errors with navigation - Rashida
   - ACS History UI - Devanshi 
   - As a user, I should be able to search for a post by providing a title - Devanshi
   - Update Number of posts for every user when deleted - Anmole
   - As a user, I want to be able to undo my selection of the agree or disagree button to a post so that I can undo my vote in case I clicked on it by mistake. - Maunica
   - Daily counts should automatically reset when it is a new day. - Zhi Hua
   - Timestamp update in The Zone - Rashida
   - Update Number of posts for every user when deleted- Anmole
