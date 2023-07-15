Project Setup 
● Added libs for KeyChainWrapper.
● Added CoreData model for Person having  attributes > token, name, phone_number

Login flow implementation
● Implemented SignIn and SignUp screens.
● Used KeyChainWrapper to store and retrieve username, password, token from the KeyChain.
● A new user can register using the SignUp Screen.
● Old users able to login using SignIn Screen.

Phone Book Application
● Implemented UI with tableview to display the contact information.
● Implemented CRUD functionality for inserting, editing, retrieving, and deleting the Person objects
from Core Data. Built UI for respective purposes.

Show data specific to logged in user
● Used NSPredicate to fetch Person objects based on the token of the logged in user.
● Used NSSortDescriptor to fetch the objects in ascending order first based on givenName and then
based on familyName.
