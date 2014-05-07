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

TEST_CASE="ptimeout raising timeout"

cat >uninterruptible.sh <<EOF
#!/bin/sh
trap "" TERM
sleep 10
EOF
chmod 755 uninterruptible.sh

$PTIMEOUT 5 sleep 1 2>&1
test $? = 0
$PTIMEOUT 1 sleep 5 2>&1 | grep "Terminated after timeout"
test ${PIPESTATUS[0]} = 124
$PTIMEOUT -s 9 -d 1 sleep 5 2>&1 | grep "Killed after timeout"
test ${PIPESTATUS[0]} = 124
$PTIMEOUT -s 9 1 sleep 5 2>&1 | grep "Killed after timeout"
test ${PIPESTATUS[0]} = 124
$PTIMEOUT -s 15 -k 1 1 ./uninterruptible.sh 5 2>&1 | grep "Killed after timeout"
test ${PIPESTATUS[0]} = 124
res=0
$PTIMEOUT 1 $PTIMEOUT 2 sleep 5 2>test.out || res=$?
grep "Terminated after timeout" test.out
test $res = 124
$PTIMEOUT 1 $PTIMEOUT 2 sleep 5 2>&1 | grep "Terminated after timeout"
test ${PIPESTATUS[0]} = 124
