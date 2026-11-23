#!/bin/bash
# Petersen: L-meta-256 asks for <=19; L-meta-608 implies >=25. n=10.
PETERSEN='[[0,1],[1,2],[2,3],[3,4],[4,0],[0,5],[1,6],[2,7],[3,8],[4,9],[5,7],[7,9],[9,6],[6,8],[8,5]]'
SUBK4='[[0,4],[4,1],[0,5],[5,2],[0,6],[6,3],[1,7],[7,2],[1,8],[8,3],[2,9],[9,3]]'
C9='[[0,1],[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8],[8,0]]'
echo "=== job 1: Petersen k=19 (L-meta-256: SAT kills 608, UNSAT kills 256)"
python3 sat/cegis_gh.py "$PETERSEN" 19 40 2700
echo "=== job 2: subdivided K4 k=14 (L-meta-655: SAT solves 655 + kills 608)"
python3 sat/cegis_gh.py "$SUBK4" 14 40 1500
echo "=== job 3: C9 k=12 (608 sanity: bound 13; SAT kills 608)"
python3 sat/cegis_gh.py "$C9" 12 40 900
