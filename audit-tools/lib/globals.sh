#!/bin/bash

# ANSI Colors
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export NC='\033[0m'

# Score Tracking
export SCORE_START=100
export GLOBAL_PENALTY_POINTS=0
export CRITICAL_ISSUES_COUNT=0
export WARNING_ISSUES_COUNT=0
export ISSUE_LOG=()

register_issue() {
    local type=$1
    local weight=$2
    local message=$3
    GLOBAL_PENALTY_POINTS=$((GLOBAL_PENALTY_POINTS + weight))
    ISSUE_LOG+=("$type|$weight|$message")
}
