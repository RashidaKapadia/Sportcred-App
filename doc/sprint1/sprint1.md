# Sprint 1 Planning Meeting 

## Meeting Goal
Discuss what user stories we want to implement for sprint 1, break them down into tasks, assign them to team members. 

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
- Implement the frontend and backend for login, signup, home and profile pages.
- Implement navigation bar
- Implement navigation between the pages
- Connect backend, database and frontend

## Spikes
1. Implementing and connecting the session to keep track of which user is logged in currently.
    - We can use a global variable to store the username of the current user.
    - We can try to learn how to use flutter’s session package.
2. Connecting the frontend and backend.
    - Learn how to transfer data between the frontend and backend.
    - We can learn how to use flutter’s http package to send requests and data to the backend.
    
## User Stories and Breakdown of Tasks
1. As a registered SportCred user, I want to be able to login in so that I can continue to build my ACS score and participate in the basketball fan community. (Login Page)
    - Login page (Frontend) - Anmole  
    - Session check - Jenny  
    - Login API Endpoint (Backend) - Jenny  
    - Fetch login information from database - Anmole    

2. As a sports fan, I want to be able to sign up for SportCred and participate in sports debates, and other activities to build my knowledge and ACS score for basketball. (Signup Page)
    - Signup web page (Frontend) - Maunica  
    - Session Creation - Jenny  
    - Signup API Endpoint (Backend) - Zhi Hua  
    - Create Node for User data in the database - Maunica    

3. As a user, I want to be able to set up my profile with some basic information about me and my status so other sports fans can know more about me. (Profile Page)
    - Profile web page (Frontend) - Rashida  
    - Fetch/update profile information through API (Backend) - Devanshi   
    - Fetch/update profile information in database - Devanshi  

4. As a user, I should easily be able to navigate to the open court, trivia, picks, and predictions, and debate activities through the starting homepage or return back to the homepage if need be. (Homepage)
    - Create the homepage template (Frontend) - Rashida
    - Add navigation bar at the bottom (Frontend) - Zhi Hua


