# Bash-09 Grade Report

## Problem Statement

Instructors spend a lot of time calculating student averages and rankings manually. This project automates the process using a Bash script that reads student scores from a CSV file and generates a grade report.

## Project Goals

- Calculate each student's average.
- Rank students from highest to lowest.
- Assign the correct grade mention.
- Display the class average.
- Identify and skip invalid records.

## Tech Stack

- **Bash:** Main scripting language.
- **AWK:** Used for calculating averages.
- **Git and GitHub:** Version control and collaboration.
- **VS Code and Terminal:** Development and testing.

## Screenshot

![Grade Report Output](assets/images/output.png)

## Features

- Reads student scores from a CSV file.
- Calculates averages to two decimal places.
- Assigns mentions: Très bien, Bien, Assez bien, Passable, and Échec.
- Ranks students from highest to lowest.
- Displays aligned columns using `printf`.
- Skips invalid lines and displays warnings.
- Shows the class average and skipped line count.
- Handles extra spaces and Windows line endings.

## Installation and Setup
Clone the repository:

```bash
git clone https://github.com/Fokeng126/bash-09-grade-report.git
```

Enter the project folder:

```bash
cd bash-09-grade-report
```

Give the script execution permission:

```bash
chmod +x grades.sh
```

Run the script:

```bash
./grades.sh grades.csv
```

## Challenges Faced

- **Wrong filenames:** I initially used `grade.sh` instead of `grades.sh`.
- **Decimal calculations:** I used AWK for averages because Bash does not directly support decimal arithmetic.
- **Missing project tool:** I created the project structure manually using `mkdir`, `touch`, and `git init`.

## What I Learnt

- Reading CSV files line by line using Bash.
- Using functions and AWK in Bash scripts.
- Validating input and handling errors.
- Sorting student records and calculating rankings.
- Working with Git branches, commits, and pull requests.

## Author
**Joshua Kroos**
