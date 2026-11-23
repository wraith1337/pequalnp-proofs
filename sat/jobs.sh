#!/bin/bash
set -u
echo "=== C7 k=9"
timeout 600 python3 sat/cegis_gh.py '[[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 0]]' 9 128 590
status=$?
echo "solver exit=$status (124 means timed out, not UNSAT)"
echo "=== cube k=10"
timeout 600 python3 sat/cegis_gh.py '[[0, 1], [0, 2], [0, 4], [1, 3], [1, 5], [2, 3], [2, 6], [3, 7], [4, 5], [4, 6], [5, 7], [6, 7]]' 10 256 590
status=$?
echo "solver exit=$status (124 means timed out, not UNSAT)"
echo "=== prism k=8"
timeout 600 python3 sat/cegis_gh.py '[[0, 1], [1, 2], [0, 2], [3, 4], [4, 5], [3, 5], [0, 3], [1, 4], [2, 5]]' 8 64 590
status=$?
echo "solver exit=$status (124 means timed out, not UNSAT)"
