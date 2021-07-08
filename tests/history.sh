#! /bin/sh
#
# SPDX-License-Identifier: BSD-2-Clause
#
# Copyright (c) 2018-2021 Gavin D. Howard and contributors.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

script="$0"

testdir=$(dirname "$script")

. "$testdir/../scripts/functions.sh"

# usage: history.sh dir -a|idx

py=$(command -v python3)
err=$?

if [ "$err" -ne 0 ]; then

	py=$(command -v python)
	err=$?

	if [ "$err" -ne 0 ]; then
		printf 'Could not find Python 3.\n'
		printf 'Skipping %s history tests...\n' "$d"
		exit 0
	fi
fi

d="$1"
shift

idx="$1"
shift

if [ "$idx" = "-a" ]; then
	idx=$("$py" "$testdir/history.py" "$d" -a)
	idx=$(printf '%s - 1\n' "$idx" | bc)
	st=0
else
	st="$idx"
fi

for i in $(seq "$st" "$idx"); do

	printf 'Running %s history test %d...' "$d" "$i"

	"$py" "$testdir/history.py" "$d" "$i" "$@"
	err=$?

	checktest_retcode "$d" "$err" "$d history tests $i"

	printf 'pass\n'

done
