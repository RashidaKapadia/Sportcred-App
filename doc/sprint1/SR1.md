# Sprint 1 Retrospective 

#### Participants
- Devanshi Parekh
- Rashida Kapadia
- Maunica Toleti
- Lim Zhi Hua
- Jenny Quach
- Anmole Bajwa

#### 1. What are practices that you should continue during next sprint:
- Having dev meeting when we run into issues or need help
- Update the team member in case you work on his or her task or class for any minimum change 

#### 2. What are some new practices that you might want to use during next sprint?
- Define the connecting pieces between large working components and their type contracts so that they can easily be shared across dependent systems/classes.   
  (i.e. type contract for shared classes, definitions for api endpoints, database node declarations, etc)
- Add more specific descriptions for each ticket. 
- Create JIRA tickets for connecting the frontend and backend of each pages of the app.
- Make sure to mention the ticket number in all branch names and commit messages to make it easier to track our progress.

#### 3. What are (if any) harmful practices you should stop using during next sprint(stop doing?)
- Do not merge a branch B into a parent branch A if branch B still has child branches C and D with unmerged features.
- Merge your child branches into you before you merge into your parent branches.
- Do not make branch B off of parent A but merge into sibling branch C.
- Merge back from where you pulled from.

#### 4. What was your best/worst experience during sprint 1?
- What went well:
    - Task division
    - Finished all the user stories that we planned on completing
- What needs to improve: 
    - Git branching, what to branch off of.
    - Git merge, where to merge back to for a clean git history
    - Git conflict resolutions
    - Probably use pull request function for merging back so history is logged on JIRA.
    - Organized bug fixes, should use Jira.
    - All commits should have a ticket (even for bugs or modifications). Commit messages should start with the associated ticket number.
    
#### 5. New User Stories:

___\* 11: As a new user, I should be immediately alerted when I failed to sign up due to using an existing email or username.___

Tech needed: frontend, API, backend session check, DB lookup

When the user clicks the “sign up” button on the signup page, if the username or email they entered is already in the database, a pop up message should appear, letting them know that they must choose another username/email.

___\* 12: As a new user, I should be immediately be alerted when I update the profile page with incorrect email or birthday format.___

When a user clicks the “update” button on the profile to update its user info, if the email or birthday was entered in an incorrect format, a pop up message should appear, letting them know that they must enter the values in a correct format. The user should be able to pick the date using the calendar widget (similar to signup page) instead of typing it to ensure proper format.

