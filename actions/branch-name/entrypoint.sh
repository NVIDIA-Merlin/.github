#!/bin/sh -l

release_branch_prefix=$1

branch=""

if [[ "${GITHUB_REF_TYPE}" == "tag" ]]
then
    remote_name="origin"
    release_branch_refspec="+refs/heads/${release_branch_prefix}*:refs/remotes/${remote_name}/${release_branch_prefix}*"
    # fetch release branches (the branch name is not automatically fetched by the actions/checkout step)
    git -c protocol.version=2 fetch \
        --no-tags \
        --prune \
        --progress \
        --no-recurse-submodules \
        --depth=1 \
        "${remote_name}" "${release_branch_refspec}"

    # find the release branch that we're pointing at
    branch=$(
        git branch \
            --contains "${GITHUB_REF_NAME}" \
            --list "*${release_branch_prefix}*"  \
            --format "%(refname:short)" \
            | sed -e 's/^origin\///'
          )
    if [[ -z "${branch}" ]]
    then
        cat <<EOF
::error::Could not find release branch corresponding to tag '${GITHUB_REF_NAME}'.
Please check that the tag points to a commit on a branch with prefix '${release_branch_prefix}'
EOF
        exit 1
    fi
elif [[ "${GITHUB_REF_TYPE}" == "branch" ]]
then
    branch="${GITHUB_BASE_REF}"
    if [[ -z "${branch}" ]]
    then
        cat <<EOF
::error::Running branch build where `GITHUB_BASE_REF` is not set (not a pull request).
This action currently supports only builds on tags or pull requests.
EOF
    fi
else
    cat <<EOF
::error::GITHUB_REF_TYPE must be one of 'branch' or 'tag'. Found '${GITHUB_REF_TYPE}'
EOF
fi

echo "branch=$branch" #>> $GITHUB_OUTPUT
