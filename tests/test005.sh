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

TEST_CASE="ptimeout catching signals"

cat >uninterruptible.sh <<EOF
#!/bin/sh
[ "\$DEBUG" = "" ] || set -x
trap "" TERM
sleep \$1
EOF
chmod 755 uninterruptible.sh

$PTIMEOUT -d 5 sleep 1 >test.log 2>&1 &
wait $!
grep -w COMPLETING test.log >/dev/null

$PTIMEOUT -d 10 sleep 5 >test.log 2>&1 &
sleep 1
kill $!
r=0
wait $! || r=$?
test $r = 143
grep -w COMPLETING test.log >/dev/null
grep -w SIGNALING test.log >/dev/null

$PTIMEOUT -d -k 1 10 ./uninterruptible.sh 5 >test.log 2>&1 &
sleep 1
kill $!
r=0
wait $! || r=$?
test $r = 143
grep -w COMPLETING test.log >/dev/null
grep -w SIGNALING test.log >/dev/null
grep -w KILLING test.log >/dev/null
