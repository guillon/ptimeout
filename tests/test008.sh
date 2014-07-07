#!/usr/bin/env bash
#
# Copyright (c) STMicroelectronics 2012
#
# This file is part of ptimeout.
#
# ptimeout is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License v2.0
# as published by the Free Software Foundation
#
# ptimeout is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# v2.0 along with ptimeout. If not, see <http://www.gnu.org/licenses/>.
#

# unitary test

source `dirname $0`/common.sh

TEST_CASE="ptimeout exit with detached processes"

cat >detaching.sh <<EOF
#!/bin/sh
[ "\$DEBUG" = "" ] || set -x
handler() {
  echo "\$\$: \$0: CODE: \$?" >detaching.out
  trap - TERM INT QUIT EXIT
}
trap handler TERM INT QUIT EXIT
\$* &
sleep 1
echo "Exititing $0"
EOF
chmod 755 detaching.sh

cat >signaling.sh <<EOF
#!/bin/sh
[ "\$DEBUG" = "" ] || set -x
handler() {
  echo "\$\$: \$0: CODE: \$?" >signaling.out
}
trap handler TERM INT QUIT EXIT
delay=\$1
while true; do sleep \$delay; done
echo "ERROR: Exititing $0 should not be reached"
exit 1
EOF
chmod 755 signaling.sh

rm -f detaching.out signaling.out

r=0
$PTIMEOUT ${DEBUG:+-d} 3 ./detaching.sh ./signaling.sh 20 || r=$?
# Normal exit, but unterruptible detached process is killed
test $r = 0
grep "./signaling.sh: CODE: 143" signaling.out >/dev/null
grep "./detaching.sh: CODE: 0" detaching.out >/dev/null

