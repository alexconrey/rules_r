#!/bin/bash
# Copyright 2021 The Bazel Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

EXEC_ROOT=$(pwd -P)

dir="$(mktemp -d --tmpdir=${EXEC_ROOT})"
tar -C "${dir}" -xzf "${IN_TAR}"
rsync --recursive --copy-links --no-perms --chmod=u+w --executability --specials \
    "${PKG_SRC_DIR}/tests" "${dir}/${PKG_NAME}"
# Reset mtime so that tarball is reproducible.
TZ=UTC find "${dir}" -exec touch -amt 197001010000 {} \+
# Ask gzip to not store the timestamp.
tar -C "${dir}" -cf - "${PKG_NAME}" | gzip --no-name -c > "${OUT_TAR}"
rm -rf "${dir}"

