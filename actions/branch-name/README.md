# Branch Name Action

This action finds the branch name to run tests for depending on whether the action is a tag or branch.

## Inputs

## `release-branch-prefix`

The prefix of the release branch. Default `"release"`.

Workflows running on tags are expected to to match branch with this prefix.

## Outputs

## `branch`

The name of the branch we should run tests against.

In the case of a tag, should be a branch with prefix `${release-branch-prefix}`.

For a pull request build. will return the name of the base branch the pull request targets.

## Example usage

```yaml
uses: NVIDIA-Merlin/.github/actions/branch-name@main
```
