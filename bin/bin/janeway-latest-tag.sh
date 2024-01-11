#!/bin/bash
gh api repos/BirkbeckCTP/janeway/tags | /opt/homebrew/bin/jq '.[0].name'
