
#!/bin/bash -x

export plugin_name=${PWD##*/}
echo "PLUGIN_NAME=$plugin_name"
chmod -R 777 . # This is necessary if your plugin installs gems

echo "travis_fold:start:starting_docker_container"

[ -d './test' ] || export RUBY_ONLY=1
[ -d './spec' ] || export JS_ONLY=1

echo "RUBY_ONLY=$RUBY_ONLY"
echo "JS_ONLY=$JS_ONLY"

docker run \
  -t \
  -e "COMMIT_HASH=origin/tests-passed" \
  -e "SKIP_CORE=1" \
  -e RUBY_ONLY \
  -e JS_ONLY \
  -e SKIP_LINT \
  -e TRAVIS \
  -e SINGLE_PLUGIN=${plugin_name} \
  -v $(pwd):/var/www/discourse/plugins/${plugin_name} \
  ${DOCKER_OPTIONS} \
  discourse/discourse_test:release
