#!/bin/bash

usage() {
    echo "Usage: grades.sh FILE.csv" >&2
    exit 1
}

# Remove \r and spaces around a value
trim() {
    local value="$1"
    value="${value//$'\r'/}"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    printf '%s' "$value"
}

# Let it succeed only for a whole number from 0 to 20
is_valid_score() {
    [[ "$1" =~ ^[0-9]+$ ]] || return 1
    (( 10#$1 <= 20 )) || return 1
}

# make a total (out of 80) into a mention
get_mention() {
    local total="$1"
    if (( total >= 64 )); then
        echo "Très bien"
    elif (( total >= 56 )); then
        echo "Bien"
    elif (( total >= 48 )); then
        echo "Assez bien"
    elif (( total >= 40 )); then
        echo "Passable"
    else
        echo "Échec"
    fi
}

# This is an exactly one argument.
if [[ $# -ne 1 ]]; then
    usage
fi

file="$1"

if [[ ! -r "$file" ]]; then
    echo "Error: cannot read file '$file'" >&2
    exit 1
fi

tmp=$(mktemp)      
line_num=1      
skipped=0
valid=0
grand_total=0

# Reading with "< $file" keeps our counters alive after the loop
{
    read -r _header    # skip the header

    while IFS=',' read -r raw_name raw_html raw_css raw_bash raw_git || [[ -n "$raw_name" ]]; do
        (( line_num += 1 ))

        name=$(trim "$raw_name")
        html=$(trim "$raw_html")
        css=$(trim "$raw_css")
        bash_score=$(trim "$raw_bash")
        git_score=$(trim "$raw_git")

        # Ignore blank lines
        if [[ -z "$name$html$css$bash_score$git_score" ]]; then
            continue
        fi

        if [[ -z "$name" ]]; then
            echo "Warning: line $line_num skipped (missing name)" >&2
            (( skipped += 1 ))
            continue
        fi

        bad=0
        for score in "$html" "$css" "$bash_score" "$git_score"; do
            if [[ -z "$score" ]]; then
                echo "Warning: line $line_num skipped (missing score)" >&2
                bad=1
                break
            elif ! is_valid_score "$score"; then
                echo "Warning: line $line_num skipped (invalid score '$score')" >&2
                bad=1
                break
            fi
        done
        if (( bad == 1 )); then
            (( skipped += 1 ))
            continue
        fi

        total=$(( 10#$html + 10#$css + 10#$bash_score + 10#$git_score ))
        avg=$(awk -v t="$total" 'BEGIN { printf "%.2f", t / 4 }')
        mention=$(get_mention "$total")

        # Average first, so sort can use it
        echo "$avg|$name|$html|$css|$bash_score|$git_score|$mention" >> "$tmp"

        (( valid += 1 ))
        (( grand_total += total ))
    done
} < "$file"

printf "%-4s  %-16s %4s %4s %4s %4s %6s  %s\n" \
    "RANK" "NAME" "HTML" "CSS" "BASH" "GIT" "AVG" "MENTION"

rank=0
# Sort by average, highest first
sort -t'|' -k1,1 -rn "$tmp" | while IFS='|' read -r avg name html css bash_score git_score mention; do
    (( rank += 1 ))
    printf "%4d  %-16s %4s %4s %4s %4s %6s  %s\n" \
        "$rank" "$name" "$html" "$css" "$bash_score" "$git_score" "$avg" "$mention"
done

rm "$tmp"

printf -- '------------------------------------------------------------\n'

if (( valid > 0 )); then
    class_avg=$(awk -v t="$grand_total" -v n="$valid" 'BEGIN { printf "%.2f", t / (n * 4) }')
    echo "Class average: $class_avg"
else
    echo "Class average: n/a (no valid students)"
fi

echo "Skipped $skipped invalid lines (see warnings above)"