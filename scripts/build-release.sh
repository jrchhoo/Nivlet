#!/bin/sh
# Release configuration with local ad-hoc signing; not a notarized distribution build.
set -eu
project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
NIVLET_BUILD_CONFIGURATION=Release sh "$project_dir/scripts/build-dev.sh"
