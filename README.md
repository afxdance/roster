# afxdance/roster

This app manages the AFX Dance roster each semester.

## Setup

### Recommended editors for this repo

We support the following editors:

- **Visual Studio Code** (highly recommended):
  - VSCode is highly recommended because it is reasonably fast and has a built-in terminal (even for Windows!) that works well.
  - Install on Mac: `brew cask install visual-studio-code`
  - Install elsewhere: <https://code.visualstudio.com/>
  - After you open VSCode, install either the `Sublime Text Keymap` or `Atom Keymap` extensions. (The default VSCode keymap is very different from that of the other editors.)
- **Github Atom**:
  - Atom technically has support for the most features, but it is slower, and its plugins tend to be buggier.
  - Install on Mac: `brew cask install atom`
  - Install elsewhere: <https://atom.io/>
- **Sublime Text**:
  - Sublime Text is very fast and lean but its UI is limited. (For example, you have to check the status bar for linter messages.)
  - Install on Mac: `brew cask install sublime-text`
  - Install elsewhere: <https://www.sublimetext.com/>

Note: Using `brew cask install` is preferred on Mac, because it will also install command-line tools that let you launch the editor from your terminal.

In addition to downloading the editor, you should also install the following:

| Feature             | VSCode extension | Atom package     | Sublime Text package    |
|---------------------|------------------|------------------|-------------------------|
| Package manager     | Built-in!        | Built-in!        | Package Control         |
| Linting framework   | Built-in!        | `linter`         | `SublimeLinter`         |
| rubocop linter      | `ruby-rubocop`   | `linter-rubocop` | `SublimeLinter-rubocop` |
| Ruby support        | `ruby-symbols`   | Built-in!        | Built-in!               |
| Ruby debugger       | `Ruby`           | Unsupported      | Unsupported             |
| Integrated terminal | Built-in!        | Unsupported      | Unsupported             |
| File commands       | `File Utils`     | Built-in!        | `SideBarEnhancements`   |

### Initial setup

To set up this app for the first time:

1. Install a Ruby environment manager. There are two popular options:
    - **rbenv** (recommended):
       - Install on Mac: <https://github.com/rbenv/rbenv#homebrew-on-macos>
       - Install elsewhere: <https://github.com/rbenv/rbenv#basic-github-checkout> \
         You need to follow the optional step to install ruby-build.
    - **rvm**:
       - Install: <https://rvm.io/>
2. Clone this repo
    - `git clone <SSH URL OF THIS REPO>`
    - `cd roster`
3. Install Ruby 2.5.0.
   - **rbenv**: `rbenv install 2.5.0`
   - **rvm**: `rvm install 2.5.0`
4. Install all required gems:
   1. `gem install bundler`
   2. `rbenv rehash` (if you're using rbenv)
   3. `bundle install`
   4. `rbenv rehash` (if you're using rbenv)

### Database setup

You'll also need to set up the database:

```shell
rails afx:db:reset
```

The command explains what it does and asks for confirmation before it does anything.

You can also use this command later at any time to **irreversibly clear all the data you've saved in the app** and start from a clean slate.
(Note: data = stuff like saved dancers, teams, etc. Code and files won't be modified.)

### Running and developing the app

To edit files, open the entire repo in your editor:

- `cd roster`
- VSCode: `code .`
- Atom: `atom .`
- Sublime Text: `subl .`

To start the server:

1. In your VSCode terminal or regular terminal, type: \
   `rails server` (`rails s` for short)
2. The app is served from <http://localhost:3000/>. Check out these pages:
   - <http://localhost:3000/> – this is just a static page for now
   - <http://localhost:3000/admin> – this is the ActiveAdmin interface
   - <http://localhost:3000/rails/db> – this shows you the raw database

## Contributing

If you're in AFX Tech Committees, make sure you've checked out [afxdance/onboarding](https://github.com/afxdance/onboarding).

Then:

1. Make a new branch off the base branch.
    - `rails afx:git:make-branch`
2. Start making your changes and push periodically to your branch.
    - Use `git push -u` the first time you push a branch!
      Then you can run `git pull` without needing the extra arguments at the end.
3. On GitHub, make a pull request into the base branch.
4. You can still make changes and push to your branch! Make sure you add tests!
5. In your PR, make sure the CI checks pass.
6. When your feature is ready, get someone to code review the PR.
7. According to our current process, you should ask an AFX Tech Committee Lead for a review as well.
8. All good? Merge the PR! Thank you for your contributions!
