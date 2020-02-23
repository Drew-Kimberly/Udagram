#! /bin/bash

split_package() {
  package_slug=$1
  package_dir=$2
  package_remote="udagram-packages/${package_slug}"
  package_git_url="git@github.com:Drew-Kimberly/${package_slug}.git"

  GIT=$(which git)
  REMOTES=$($GIT remote)

  if [[ $REMOTES != *${package_remote}* ]]
  then
    $GIT remote add ${package_remote} ${package_git_url}
  fi

  $GIT push ${package_remote} `git subtree split --prefix ${package_dir}`:master --force
}


