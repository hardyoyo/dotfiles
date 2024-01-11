#!/usr/bin/env python3


import click
from datetime import datetime, timedelta
import os
import holidays

def validate_script(script):
    """Validate the script existence and executability."""
    if not script or not os.path.isfile(script) or not os.access(script, os.X_OK):
        click.echo(f"Cannot run {script}. Check if the file exists and is executable.")
        return False
    return True

def is_us_holiday(date):
    """Check if the given date is a US holiday."""
    us_holidays = holidays.UnitedStates(years=date.year)
    return date in us_holidays

def is_monday_after_holiday(date):
    """Check if the given date is a Monday immediately following a holiday."""
    if date.weekday() == 0:  # Check if the date is a Monday
        previous_day = date - timedelta(days=1)
        return is_us_holiday(previous_day)
    return False

# FIXME: this script does not work correctly for certain cases in the first week of January
# this function is not currently used, because it seems to prevent the script from working
# correctly for non-January dates
def is_january_first_before(date):
    """Check if the first of January is exactly two days before the given date."""
    return datetime(date.year, 1, 1) + timedelta(days=2) == date

@click.command()
@click.option('--script', help='Path to the script to run')
@click.option('--today', default=None, help='Custom date for testing in the format YYYY-MM-DD')
@click.option('--verbose', is_flag=True, default=False, help='Enable verbose mode')
@click.option('--dry-run', is_flag=True, default=False, help='Enable dry-run mode (do not execute the script)')
def run_script(script, today, verbose, dry_run):
    # Validate the script before proceeding
    if not validate_script(script):
        return

    if today:
        today = datetime.strptime(today, '%Y-%m-%d')
    else:
        today = datetime.now()

    # Calculate the first day of the month
    first_day_of_month = datetime(today.year, today.month, 1)

    # Find the next workday of the month, excluding weekends and holidays
    next_workday = first_day_of_month
    while (next_workday.weekday() >= 5 or
           is_us_holiday(next_workday) or
           is_monday_after_holiday(next_workday)): #or
           # not is_january_first_before(next_workday)):
        next_workday += timedelta(days=1)

    # Run the script if today is the first workday of the month and not in dry-run mode
    if today == next_workday:
        if verbose:
            click.echo(f"Running {script} because it's the first workday of the month!")
        if not dry_run:
            os.system(script)  # Execute the script
    elif verbose:
        click.echo("Not the first workday of the month. No action taken.")

if __name__ == '__main__':
    run_script()

