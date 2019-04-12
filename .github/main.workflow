workflow "lint, build, deploy" {
  on = "push"
  resolves = [
    "lint",
    "deploy",
  ]
}

action "npm install" {
  uses = "actions/npm@3c8332795d5443adc712d30fa147db61fd520b5a"
  args = "ci"
}

action "lint" {
  uses = "actions/npm@3c8332795d5443adc712d30fa147db61fd520b5a"
  needs = "npm install"
  args = "run lint"
}

action "build" {
  uses = "actions/npm@3c8332795d5443adc712d30fa147db61fd520b5a"
  needs = "npm install"
  args = "run build"
}

action "releases" {
  uses = "./.github/actions/releases"
  needs = "build"
}

action "deploy" {
  uses = "primer/deploy@v2.0.0"
  secrets = ["GITHUB_TOKEN", "NOW_TOKEN"]
  needs = "releases"
}
