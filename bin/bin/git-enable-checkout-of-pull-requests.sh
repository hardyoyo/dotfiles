#!/bin/sh
# configures a git repository to fetch upstream pull requests
# assumes you are running it from a directory within the project on which you want to enable this
git config --add remote.upstream.fetch +refs/pull/*/head:refs/remotes/upstream/pr/*
