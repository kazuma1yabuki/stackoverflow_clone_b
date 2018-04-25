#!/usr/bin/env bash
set -euo pipefail

cwd=$(dirname "${0}")

## gear

rm -r -f "${cwd}"/../web/controller
rm -r -f "${cwd}"/../web/helper
rm -r -f "${cwd}"/../web/plug
rm -r -f "${cwd}"/../test
rm "${cwd}"/../web/router.ex

cp -r -f "${cwd}"/../training_src/gear/web/* "${cwd}"/../web/
cp -r -f "${cwd}"/../training_src/gear/lib "${cwd}"/../
cp -r -f "${cwd}"/../training_src/gear/test "${cwd}"/../

## webfrontend

cp -f "${cwd}"/../training_src/webfrontend/js_test/components/* "${cwd}"/../js_test/components/
cp -f "${cwd}"/../training_src/webfrontend/js_test/pages/* "${cwd}"/../js_test/pages/
cp -f "${cwd}"/../training_src/webfrontend/static/components/* "${cwd}"/../web/static/components/
cp -f "${cwd}"/../training_src/webfrontend/static/pages/* "${cwd}"/../web/static/pages/

echo "Finish overriding"
