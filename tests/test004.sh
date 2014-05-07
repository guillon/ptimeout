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

TEST_CASE="ptimeout help flags"

$PTIMEOUT -h | head -1 | grep "^usage: ptimeout "
test ${PIPESTATUS[0]} = 0

$PTIMEOUT --help | head -1 | grep "^usage: ptimeout "
test ${PIPESTATUS[0]} = 0
