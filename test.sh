#!/bin/bash

set -u

SOLUTION="./student_solution.sh"
TOTAL=10
PASS=0

echo "=============================================="
echo " Linux Practical Autograder"
echo " Delete Files and Directories"
echo "=============================================="

# Check student solution file
if [ ! -f "$SOLUTION" ]; then
    echo "FAIL: student_solution.sh not found"
    echo "Marks: 0/$TOTAL"
    exit 1
fi

chmod +x "$SOLUTION"

# Create temporary test environment
WORKDIR="$(mktemp -d)"

trap 'rm -rf "$WORKDIR"' EXIT

# Create test files
touch "$WORKDIR/filename.txt"

touch "$WORKDIR/file1.txt"
touch "$WORKDIR/file2.txt"
touch "$WORKDIR/file3.txt"

# Create empty directory
mkdir "$WORKDIR/directory_name"

# Create non-empty directory
mkdir -p "$WORKDIR/nonempty_directory/subdirectory"

touch "$WORKDIR/nonempty_directory/file_inside.txt"

echo
echo "Running student solution..."
echo

(
    cd "$WORKDIR"
    bash "$OLDPWD/student_solution.sh"
)

STATUS=$?

if [ "$STATUS" -ne 0 ]; then
    echo
    echo "FAIL: student_solution.sh returned an error."
    echo "Marks: 0/$TOTAL"
    exit 1
fi

# ------------------------------------------------
# TEST CASE 1
# ------------------------------------------------

if [ ! -e "$WORKDIR/filename.txt" ]; then

    echo "PASS: Test Case 1 - Single file removed (+2)"

    PASS=$((PASS+2))

else

    echo "FAIL: Test Case 1 - filename.txt was not removed"

fi


# ------------------------------------------------
# TEST CASE 2
# ------------------------------------------------

if [ ! -e "$WORKDIR/file1.txt" ] && \
   [ ! -e "$WORKDIR/file2.txt" ] && \
   [ ! -e "$WORKDIR/file3.txt" ]; then

    echo "PASS: Test Case 2 - Multiple files removed (+2)"

    PASS=$((PASS+2))

else

    echo "FAIL: Test Case 2 - One or more files were not removed"

fi


# ------------------------------------------------
# TEST CASE 3
# ------------------------------------------------

if [ ! -e "$WORKDIR/directory_name" ]; then

    echo "PASS: Test Case 3 - Empty directory removed (+2)"

    PASS=$((PASS+2))

else

    echo "FAIL: Test Case 3 - directory_name was not removed"

fi


# ------------------------------------------------
# TEST CASE 4
# ------------------------------------------------

if [ ! -e "$WORKDIR/nonempty_directory" ]; then

    echo "PASS: Test Case 4 - Non-empty directory removed (+4)"

    PASS=$((PASS+4))

else

    echo "FAIL: Test Case 4 - Non-empty directory was not completely removed"

fi


# ------------------------------------------------
# FINAL RESULT
# ------------------------------------------------

echo
echo "=============================================="
echo "Final Marks: $PASS/$TOTAL"
echo "=============================================="

if [ "$PASS" -eq "$TOTAL" ]; then

    exit 0

else

    exit 1

fi
