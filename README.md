afxdance/roster
===============

This app manages the AFX Dancer roster each semester.


## Setup

### Recommended tools

1. Atom text editor
2. These Atom packages: `apm install ...` (TODO: finish writing this line)
3. rbenv

### Initial setup

To set up this app for the first time:

1. Install a Ruby environment manager -- rbenv or RVM.
2. Clone this repo (use the SSH URL!) and `cd` into it.
3. Install Ruby 2.5.0.
   - RVM: `rvm install 2.5.0`
   - rbenv: `rbenv install 2.5.0`
4. Install all required gems: `bundle install`
   - If you're using rbenv, you'll also need to run `rbenv rehash` afterwards.

### Database setup

You'll also need to reset the database. You need to run these steps once when you set up, but you can run it again **if you irreversibly want to clear all data** you've changed in the app:

```
rails db:drop     # Delete the existing database
rails db:create   # Create an empty database.
rails db:migrate  # Run migrations. This sets up the database structure.
rails db:seed     # Puts in some sample data, including a user, so you can log in!
```

You can combine these commands in one: `rails db:drop db:migrate db:seed`

<!--
  Note:
  rails db:reset doesn't do exactly what we expect and can fail if db/schema.rb is messed up.
  This is why we don't use it.
  See here for what the db: commands do: https://stackoverflow.com/a/10302357/782045
  -->

### Running the app

1. `rails server` (`rails s` for short)
2. The app is served from <http://localhost:3000/>. Some important pages:
   - <http://localhost:3000/>
   - <http://localhost:3000/admin>


## Contributing

If you're in AFX Tech Committees, make sure you've checked out [afxdance/onboarding](https://github.com/afxdance/onboarding).

Then:

1. Checkout the branch you want to base your changes off of.
2. Make a new branch off the base branch.
3. Start making your changes and push periodically to your branch.
4. On GitHub, make a pull request into the base branch.
5. You can still make changes and push to your branch! Make sure you add tests!
6. In your PR, make sure the CI checks pass.
7. When your feature is ready, get someone to code review the PR.
8. According to our current process, you should ask an AFX Tech Committee Lead for a review as well.
9. Merge the PR!
