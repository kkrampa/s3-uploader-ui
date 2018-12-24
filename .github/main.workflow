workflow "New workflow" {
  on = "push"
  resolves = ["GitHub Action for npm-2"]
}

action "GitHub Action for npm" {
  uses = "actions/npm@e7aaefe"
  args = "install"
  runs = "yarn"
}

action "GitHub Action for npm-1" {
  uses = "actions/npm@e7aaefe"
  runs = "yarn"
  args = "install"
}

action "GitHub Action for npm-2" {
  uses = "actions/npm@e7aaefe"
  needs = ["GitHub Action for npm-1"]
  runs = "yarn"
  args = "build"
}
