#!/bin/bash
set -e

######### Adjust these variables as needed ################

insightApiDir="${HOME}/source/insight-api"
insightUIDir="${HOME}/source/insight-ui"
poliscoreDir="${HOME}/source/poliscore"
poliscoreNodeDir="${HOME}/source/poliscore-node"

###########################################################

# given a string tag, make signed commits, push to relevant repos, create signed tags and publish to npm

bump_version () {
  sed -i '' -e "s/\"version\"\: .*$/\"version\"\: \"${shortTag}\",/g" package.json
}

set_deps () {
  sed -i '' -e "s/\"poliscore-node\"\: .*$/\"poliscore-node\"\: \"${shortTag}\",/g" package.json
  sed -i '' -e "s/\"insight-api\"\: .*$/\"insight-api\"\: \"${shortTag}\",/g" package.json
  sed -i '' -e "s/\"insight-ui\"\: .*$/\"insight-ui\"\: \"bitpay\/insight\#${tag}\"/g" package.json
}

tag="${1}"
shortTag=`echo "${tag}" | cut -c 2-`

if [ -z "${tag}" ]; then
  echo ""
  echo "No tag given, exiting."
  exit 1
fi


#############################################
# poliscore-node
#############################################
function poliscoreNode() {
  echo ""
  echo "Starting with poliscore-node..."
  sleep 2
  pushd "${poliscoreNodeDir}"

  sudo rm -fr node_modules
  bump_version
  npm install

  git add .
  git diff --staged
  echo ""
  echo -n 'Resume?: (Y/n): '

  read ans

  if [ "${ans}" == 'n' ]; then
    echo "Exiting as requested."
    exit 0
  fi

  echo ""
  echo "Committing changes for poliscore-node..."
  sleep 2
  git commit -S

  echo ""
  echo "Pushing changes to Github..."
  git push origin master && git push upstream master

  echo ""
  echo "Signing a tag"
  git tag -s "${tag}" -m"${tag}"


  echo ""
  echo "Pushing the tag to upstream..."
  git push upstream "${tag}"

  echo ""
  echo "Publishing to npm..."
  npm publish --tag beta

  popd
}

#############################################
# insight-api
#############################################
function insightApi() {
  echo ""
  echo "Releasing insight-api..."
  sleep 2
  pushd "${insightApiDir}"

  sudo rm -fr node_modules
  bump_version
  npm install

  git add .
  git diff --staged
  echo ""
  echo -n 'Resume?: (Y/n): '

  read ans

  if [ "${ans}" == 'n' ]; then
    echo "Exiting as requested."
    exit 0
  fi

  echo ""
  echo "Committing changes for insight-api..."
  sleep 2
  git commit -S

  echo ""
  echo "Pushing changes to Github..."
  git push origin master && git push upstream master

  echo ""
  echo "Signing a tag"
  git tag -s "${tag}" -m"${tag}"


  echo ""
  echo "Pushing the tag to upstream..."
  git push upstream "${tag}"

  echo ""
  echo "Publishing to npm..."
  npm publish --tag beta

  popd
}

#############################################
# insight-ui
#############################################
function insightUi() {
  echo ""
  echo "Releasing insight-ui..."
  sleep 2
  pushd "${insightUIDir}"

  sudo rm -fr node_modules
  bump_version
  npm install

  git add .
  git diff --staged
  echo ""
  echo -n 'Resume?: (Y/n): '

  read ans

  if [ "${ans}" == 'n' ]; then
    echo "Exiting as requested."
    exit 0
  fi

  echo ""
  echo "Committing changes for insight-ui..."
  sleep 2
  git commit -S

  echo ""
  echo "Pushing changes to Github..."
  git push origin master && git push upstream master

  echo ""
  echo "Signing a tag"
  git tag -s "${tag}" -m"${tag}"


  echo ""
  echo "Pushing the tag to upstream..."
  git push upstream "${tag}"

  echo ""
  echo "Publishing to npm..."
  npm publish --tag beta

  popd
}

#############################################
# poliscore
#############################################
function poliscore() {
  echo ""
  echo "Releasing poliscore..."
  sleep 2
  pushd "${poliscoreDir}"

  sudo rm -fr node_modules
  bump_version
  set_deps

  npm install

  git add .
  git diff --staged
  echo ""
  echo -n 'Resume?: (Y/n): '

  read ans

  if [ "${ans}" == 'n' ]; then
    echo "Exiting as requested."
    exit 0
  fi

  echo ""
  echo "Committing changes for poliscore..."
  sleep 2
  git commit -S

  echo ""
  echo "Pushing changes to Github..."
  git push origin master && git push upstream master

  echo ""
  echo "Signing a tag"
  git tag -s "${tag}" -m"${tag}"


  echo ""
  echo "Pushing the tag to upstream..."
  git push upstream "${tag}"

  echo ""
  echo "Publishing to npm..."
  npm publish --tag beta

  popd

  echo "Completed releasing tag: ${tag}"
}

echo ""
echo "Tagging with ${tag}..."

echo "Assuming projects at ${HOME}/source..."

releases="${2}"
if [ -z "${releases}" ]; then
  poliscoreNode
  insightApi
  insightUi
  poliscore
else
  eval "${releases}"
fi

