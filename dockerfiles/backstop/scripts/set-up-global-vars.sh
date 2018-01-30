#!/bin/bash

set -ex

# Make artifacts directory
CIRCLE_ARTIFACTS_DIR='/tmp/artifacts'
mkdir -p $CIRCLE_ARTIFACTS_DIR

# By default, we will make the environment name after the circle build number.
DEFAULT_ENV=ci-$CIRCLE_BUILD_NUM

# If there is a PR number provided, though, then we will use it instead.
if [[ -n ${CIRCLE_PULL_REQUEST} ]] ; then
  PR_NUMBER=${CIRCLE_PULL_REQUEST##*/}
  DEFAULT_ENV="pr-${PR_NUMBER}"
fi

#=====================================================================================================================
# EXPORT needed environment variables
#
# Circle CI 2.0 does not yet expand environment variables so they have to be manually EXPORTed
# Once environment variables can be expanded this section can be removed
# See: https://discuss.circleci.com/t/unclear-how-to-work-with-user-variables-circleci-provided-env-variables/12810/11
# See: https://discuss.circleci.com/t/environment-variable-expansion-in-working-directory/11322
# See: https://discuss.circleci.com/t/circle-2-0-global-environment-variables/8681
#=====================================================================================================================
(
  echo 'CIRCLE_ARTIFACTS_DIR="/tmp/artifacts"'
  echo 'export CIRCLE_ARTIFACTS_URL=${CIRCLE_BUILD_URL}/artifacts/$CIRCLE_NODE_INDEX/artifacts'
  echo "export DEFAULT_ENV='$DEFAULT_ENV'"
  echo 'export TERMINUS_ENV=${TERMINUS_ENV:-$DEFAULT_ENV}'
  echo 'export PANTHEON_DEV_SITE_URL=https://dev-${TERMINUS_SITE}.pantheonsite.io'
  echo 'export PANTHEON_SITE_URL=https://${TERMINUS_ENV}-${TERMINUS_SITE}.pantheonsite.io'
  echo 'export PR_NUMBER=${CIRCLE_PULL_REQUEST##*/}'
) >> $BASH_ENV
source $BASH_ENV
