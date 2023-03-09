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
- name: Get Branch name
  id: get-branch-name
  uses: NVIDIA-Merlin/.github/actions/branch-name@branch-name

- name: Use the branch name
  run: |
    echo "${{ steps.get-branch-name.outputs.branch }}"
```

The main complexity and the reason this Action exists comes from the case of a workflow triggered by a tag.
In the case of a tag build we don't have access to the branch name without performing some additional git commands.
The reason we need to find the release branch name corresponding to the tag is so that we can run the tests with the corresponding versions of other packges in our ecosystem that we depend on.

- tag
  - the build for a tag on `release-23.02` returns branch `release-23.02`
- pull request
  - the build for a pull_request with base branch `main` returns branch `main`
  - the build for a pull request with base branch `release-23.02` returns branch `release-23.02`
- merge commit
  - the build for a push to branch `main` (following a merge of a PR) returns branch `main`
  - the build for a push to branch `release-23.02` (following a merge of a PR) returns branch `release-23.02`
