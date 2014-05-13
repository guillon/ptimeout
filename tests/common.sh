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

# common setup for unit tests

set -e
DIRNAME=$(dirname $0)
TEST=$(basename $0)
SRCDIR=${SRCDIR:-$(cd $DIRNAME/.. && pwd)}
PTIMEOUT=${PTIMEOUT:-$SRCDIR/ptimeout}
TMPDIR=${TMPDIR:-/tmp}
KEEPTEST=${KEEPTEST:-0}
KEEPFAIL=${KEEPFAIL:-0}
_skipped=0

test_cleanup() {
    : # Override this function in the test if some local cleanup is needed
}

cleanup() {
    local exit=$?
    set +x
    trap - INT QUIT TERM EXIT
    test_cleanup
    cd $TMPDIR # ensure not in TMPTEST before cleaning
    [ -d "$TMPTEST" ] && [ "$KEEPTEST" = 0 ] && [ "$KEEPFAIL" = 0 -o $exit = 0 ] && rm -rf $TMPTEST
    [ $exit != 0 -o $_skipped = 1 ] || success
    [ $exit = 0 -o $exit -ge 128 ] || failure
    [ $exit = 0 -o $exit -lt 128 ] || interrupted && trap - EXIT && exit $exit
}

trap "cleanup" INT QUIT TERM EXIT

interrupted() {
    echo "***INTERRUPTED: $TEST: $TEST_CASE" >&2
}

failure() {
    local reason=${1+": $1"}
    echo "***FAIL: $TEST: $TEST_CASE$reason" >&2
}

success() {
    echo "SUCCESS: $TEST: $TEST_CASE" >&2
}

skip() {
    set +x
    local reason=${1+": $1"}
    echo "---SKIP: $TEST: $TEST_CASE$reason" >&2
    _skipped=1
    exit 0
}

rm -rf $TEST.dir
[ "$KEEPTEST" != 0 -o "$KEEPFAIL" != 0 ] || TMPTEST=`mktemp -d $TMPDIR/ptimeout.XXXXXX`
[ "$KEEPTEST" = 0 -a "$KEEPFAIL" = 0 ] || TMPTEST=`mkdir -p $TEST.dir && echo $PWD/$TEST.dir`
[ "$KEEPTEST" = 0 -a "$KEEPFAIL" = 0 ] || echo "Keeping test directory in: $TMPTEST"
cd $TMPTEST
[ "$DEBUG" = "" ] || export PS4='+ $0: ${FUNCNAME+$FUNCNAME :}$LINENO: '
[ "$DEBUG" = "" ] || set -x
