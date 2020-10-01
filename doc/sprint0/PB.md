
# Product Backlog

## Note: 

#### Format of the following product backlog is:
> [App Component]  
>
>[Priority][Point Estimate]: [User Story]  
>
>[Criteria of Satisfaction] 

#### For Priority, 
 > \* represents Low Priority  
 > ** represents Medium Priority   
 > *** represents High Priority  

For the __Point Estimate__, we defined __*1 to be easy*__ and __*10 to be hard.*__

---

## Sign Up/Login

__*** 7: As a sports fan, I want to be able to sign up for SportCred and participate in sports debates, and other activities to build my knowledge and ACS score for basketball.__  

Tech needed: frontend, API, backend session check, DB storage

Given an email, password, and some of my basic demographics I can register for the app. When my registration is successful, I should be logged into the app and directed to the homepage, or otherwise be shown an error message.

(Optional) After signing up for the first time, the user will be given a short brief on the app and what is ACS and rankings.


__*** 7: As a registered SportCred user, I want to be able to login in so that I can continue to build my ACS score and participate in the basketball fan community.__  

Tech needed: frontend, API, backend session check, DB storage

Given an email and password when I try to login, I should be able to proceed into the app if my credentials are correct, otherwise, be notified with an error message and given an option to change my password or register if need be.

---

## Profile

__*** 5: As a user, I want to be able to set up my profile with some basic information about me and my status so other sports fans can know more about me.__ 

Tech needed: frontend, API, DB updates

When the user navigates to their profile page, they will be able to change their "current status" and  "about" information through some edit function/icon. After the user confirms their changes, their profile should be updated to reflect the new changes.


__*** 7: As a user, I want to be able to view my ACS score, rank and score history in my profile to know how I am progressing in my sports knowledge.__

Tech needed: frontend, API, DB lookup

When the user navigates to their profile page, their ACS score and rank will be displayed. When the user clicks on their ACS score, their score history will be displayed, showing "X" most recent score changes with the date and running current score at the time.

(Optional) When the user clicks on their rank (or icon near it), they can view a list of ranks and their descriptions.

--- 

## The Zone

__*** 2: As a user, I should easily be able to navigate to the open court, trivia, picks, and predictions, and debate activities through the starting homepage or return back to the homepage if need be.__

Tech needed: frontend

Given that the user just loaded the app, when the user is logged (manually, or automatically through saved user & password), then the user will be redirected to the homepage "The Zone". 

Given that the user is on some page in the app, when the user presses the "Z" icon on the lower navigation bar, then the user will be redirected back to the homepage.


## Open Court

__** 6: As a user, I want to be able to browse and create basketball posts in the open court on my favorite teams.__

Tech needed: frontend, API, DB update

Given a registered user, when the user enters the open court, then they will be able to see a list from most recent to least recent posts. In addition, there will be a button for the user to add their own post, when the user submits their post, the post should be publicly shown with other recent posts.__

__\* 10: As a user, I want to share my favourite posts on other social media platforms so that I can share them with my friends and family.__

Tech needed: ???????

Given that the user is looking at a post when the user presses the share button on the post, a dialog will pop up for the user to select what social media platform to share the post on (ie twitter) and the post will be shown on the other social media platform

__** 7: As a user, I want to give feedback on other users' posts in the open court by commenting and agreeing/disagreeing so I can be more engaged and involved in the community.__

Tech needed: frontend, API, DB update

Given that the user is looking at a post, there will be an option for the user to add another comment to the top of the comment list of the post, when the user submits their comment, the post's comment section will then be updated to include the user's comment. When the user presses agree/or disagree on the post, the respective agree or disagree count will be incremented accordingly. The user should be able to remove their like/dislike for a post or change to the other option, but they are not allowed to like/dislike multiple times if the feedback is already given.

---

## Trivia

__*** 9: As a user, I want to be able to play trivia alone so that I can increase my A.C.S while improving upon my sports knowledge and analytical skills.__

Tech needed: frontend UI, frontend timer, backend time and response validation, API, DB update

Given that the user is on the main Trivia page, 
- They should be able to play trivia alone.
- They should be able to choose a category: General Sports, Sports Scenarios, Basketball 
- When the user chooses an answer, they should be notified by a pop up whether their answer was correct or not. They should be awarded points for correct answers and lose points for incorrect answers.

__*** 9: As a user, I want to be able to play trivia head to head with other users so that I can increase my A.C.S. by competing with them.__

Tech needed: frontend UI, frontend timer, backend time and response validation, API, DB update

Given the user is on the Trivia page, 
- They should be able to choose to play with other users (random users or a user that they invited).
- They should be able to choose a category: General Sports, Sports Scenarios, Basketball 
- They should be able to view if any users have challenged them to play trivia with them.
- They should be able to view the invites that they sent to other users as well as their statuses (i.e. if they are pending, in progress, accepted, rejected).

Given that a user is challenged by another user to play trivia with them, they should be able to accept the challenge and notify that user that they are ready to play.

Given that a user is playing a trivia game with another user, 
- The user should be able to see both their points as well as their opponents during the game.
- The user that answers the question correctly first will get points while the opponent loses points. The points will be added to the winning user’s A.C.S. and will be taken from the other user’s A.C.S.
- The user can only select an answer within the time limit.
- The user should be able to see a count-down timer on the screen so that they are aware of how much time they have left. They should be notified with a sound effect, a pop-up, or highlighting the timer if they are running out of time or if the time is up.

(Optional) If the user wins the trivia game against a player in a greater tier class, they should be awarded bonus points.

(Optional) Users can play friendly trivia games where their A.C.S. score is not affected.

(Optional) If a user decides to quit a multiplayer trivia game in the middle, the other player should be declared as the “winner” and get bonus points.

---

## Picks & Prediction

__*** 6: As a basketball fan, I enjoy speculating about the future and predicting outcomes. I want to be rewarded for applying my knowledge of basketball to make correct predictions.__

Tech needed: frontend UI, API, DB update

Given that the user is on the “picks and prediction” page, they should be able to click a button to select a match, and then click another button to make a “bet” on things like which team will win, how much they will win by, and who the MVP is. (Note that unlike gambling bets, users can't decide how much of their ACS they are betting.)

Users should also be able to change their “bets” anytime before the game starts.

(optional) Users should be able to see the “odds”. “Betting” on teams with low chances should yield a higher reward if the team actually wins, and a lower loss if the team doesn’t win.

---

## Debate

__* 10: As an avid basketball fan, I want to put my analytical skills in a head to head competition against other fans to see who knows more about the sport.__

When the user navigates to the debate page, they should be able to pick a debate topic, get matched with a random debate opponent in the same rank,  have an open debate, and then have an increase/decrease in ACS score based on how well they do. (debates have 3 rounds, with each speaker given 30 sec per round)

Given the contents of a debate, we must have a way to decide how well they did in the debate.

__* 10: As a casual basketball fan, I want to see what the “hot” topics in basketball are when I get on the app, as well as what the common viewpoints and arguments for each side are.__

Given that users are on the debates page, when they click a “view debates” button, they should be able to view current and past debates and select how much they agree or disagree using a slider.
