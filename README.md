This is the code for the Brandeis Official Readers' Guild website, developed by Martin Silberberg.

The application is coded primarily in Ruby using the Sinatra DSL, and also utilizes several ERB files that contain a combination of HTML, Javascript, 
and additional Ruby code. The application utilizes the Bootstrap web development framework for HTML, CSS, and Javascript. 
The application also uses a SQL database to store information.

The website currently has the following features:
-Login/logout functionality for the site's users, with basic password encryption
-A forum system, where the users can create and edit posts on various topics
-A page that interacts with the API from tumblr.com to retrieve and display posts from the club's official Tumblr account.
-Several pages that retrieve and display lists of upcoming events, book reviews, or forum posts from the application's database
-A front-end interface for the site's administrators, where they can add new book reviews and events without needing any knowledge of the site's code
-A module that converts ActiveRecord timestamps into a more readable date/time format

The universal password for new forum members is 'Borgling'.

If only one user is in the database, they are considered a temporary admin with limited privileges.

The app is configured to run using the Unicorn HTTP server, with a sqlite3 database in a development environment 
and with postgresql in a production environment.
