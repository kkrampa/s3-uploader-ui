workflow "New workflow" {
  on = "push"
  resolves = ["GitHub Action for AWS"]
}

action "GitHub Action for npm" {
  uses = "actions/npm@e7aaefe"
  args = "build"
}

action "GitHub Action for AWS" {
  uses = "actions/aws/cli@8d31870"
  needs = ["GitHub Action for npm"]
  runs = " make"
  args = "prod-env-deploy"
}
