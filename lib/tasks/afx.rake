# Add custom tasks in this file. They can be run using:
#   rails TASKNAME
# We will be using tasks that start with afx: by convention. This is so that we know which commands
# are made by us and which commands come with Rails by default.
#
# Try to keep tasks in alphabetical order! If this file becomes too long, we can start splitting it
# up into multiple files.

require "./lib/afx_rake_helper.rb"
include AfxRakeHelper

define_task "afx:db:reset" do |t|
  t.describe <<~EOS
    Reset the db to what is described in in db/migrate.
    WARNING: All your database data will be deleted.
  EOS

  # Note:
  # rails db:reset doesn't do exactly what we expect and can fail if db/schema.rb is messed up.
  # This is why we don't use it.
  # See here for what the db: commands do: https://stackoverflow.com/a/10302357/782045
  t.rake "db:drop"
  t.rake "db:create"
  t.rake "db:migrate"
  t.rake "db:seed"
end

define_task "afx:db:seed:demo" => :environment do |t|
  t.describe <<~EOS
    This is a demo seed task. It creates some dancers.
    You should run rails afx:db:reset beforehand if you want this applied to a clean db.
  EOS

  t.step "Create test dancers" do
    Dancer.create(id: 1, name: "Ping Quach")
    Dancer.create(id: 2, name: "Ping Quach 2")
    Dancer.create(id: 3, name: "Ping Quach 3")
  end
end

define_task "afx:git:make-branch" do |t|
  t.describe <<~EOS
    Make a new branch based off the given base branch, and check it out.
    Note: The base doesn't have to be a branch name.
    It can be a commit id. It can also be #{"HEAD".bold} to mean the current branch.
  EOS
  base = t.require_arg(:base)
  branch = t.require_arg(:branch)

  t.assert("You have uncommitted changes.") { `git status --porcelain`.empty? }

  t.shell "git checkout #{base} -b #{branch}"
end

define_task "afx:git:reset-local-branch" do |t|
  t.describe <<~EOS
    Checkout the given branch and set it to the remote version.
    WARNING: You will lose unpushed commits on that branch.
  EOS
  branch = t.require_arg(:branch)

  t.assert("You have uncommitted changes.") { `git status --porcelain`.empty? }

  t.shell "git checkout #{branch}"
  t.shell "git fetch origin"
  t.shell "git rev-parse HEAD  # This is the current commit. Save this value to undo."
  t.shell "git reset --hard origin/#{branch}"
end

define_task "afx:git:reset-upstream" do |t|
  t.describe <<~EOS
    Set the upstream of the current branch.
    (The upstream is how Git knows where to pull from when you run just `git pull`.)

    Tip: If you run `git push -u` instead of `git push`, the upstream is set automatically.
    Then you wouldn't need to be doing this at all.
  EOS
  branch = `git rev-parse --abbrev-ref HEAD`

  t.assert('The remote "origin" does not exist.') \
    { system "git remote get-url origin >/dev/null 2>&1" }
  t.assert("You are not a branch.") \
    { system "git symbolic-ref HEAD >/dev/null 2>&1" }

  t.shell "git branch --set-upstream-to origin/#{branch}"
end

define_task "afx:git:stash" do |t|
  t.describe <<~EOS
    `git stash` away all uncommitted changes.

    You can get these changes back with: `git stash apply`
    Then you can delete the stash with `git stash drop`
  EOS

  t.shell "git add --all :/"
  t.shell "git stash"
end
