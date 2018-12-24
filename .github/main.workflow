workflow "New workflow" {
  on = "push"
  resolves = ["GitHub Action for AWS"]
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

action "GitHub Action for AWS" {
  uses = "actions/aws/cli@8d31870"
  needs = ["GitHub Action for npm-2"]
  secrets = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
  runs = "make"
  args = "prod-env-deploy"
}
