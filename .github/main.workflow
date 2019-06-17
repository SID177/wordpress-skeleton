workflow "Inspections" {
  on = "pull_request"
  resolves = ["Run PHPCS inspection"]
}

action "Run PHPCS inspection" {
  uses = "rtCamp/action-phpcs-code-review@master"
  secrets = ["VAULT_ADDR", "VAULT_TOKEN"]
  args = ["WordPress,WordPress-Core,WordPress-Docs"]
}

workflow "Deploy and Slack Notification" {
  on = "push"
  resolves = ["Slack Notification"]
}

action "Deploy" {
  uses = "rtCamp/action-deploy-wordpress@master"
  secrets = ["VAULT_ADDR", "VAULT_TOKEN"]
}

action "Slack Notification" {
  needs = ["Deploy"]
  uses = "rtCamp/action-slack-notify@master"
  secrets = ["VAULT_ADDR", "VAULT_TOKEN"]
  env = {
    SLACK_CHANNEL="test"
  }
}
