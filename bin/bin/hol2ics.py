#!/usr/bin/env python3
"""
Script to convert a .HOL file (Outlook holidays) to an iCalendar (.ics) file.

Usage:
    ./script.py --summary-prefix=<prefix> <hol_file>

Parameters:
    --summary-prefix=<prefix>: Prefix for the SUMMARY field.
    hol_file: The path to the .HOL file to be converted.

This script reads a .HOL file and generates an iCalendar file containing UCOP holidays.
"""

import click

@click.command()
@click.option('--summary-prefix', default='UCOP Holiday', help='Prefix for the SUMMARY field.')
@click.argument('hol_file', type=click.File('r'))
def convert_hol_to_ics(summary_prefix, hol_file):
    """
    Convert .HOL file to iCalendar (.ics) format.

    :param summary_prefix: Prefix for the SUMMARY field.
    :param hol_file: The input .HOL file.
    """
    converted_ics = []

    # Add iCalendar header
    converted_ics.append(
        "BEGIN:VCALENDAR\nMETHOD:PUBLISH\nVERSION:2.0\n"
        "X-WR-CALNAME:UCOP Holidays\nPRODID:-//Your Company//Your App//EN\n"
        "X-WR-TIMEZONE:America/Los_Angeles\nCALSCALE:GREGORIAN\n"
        "BEGIN:VTIMEZONE\nTZID:America/Los_Angeles\n"
        "BEGIN:STANDARD\nTZOFFSETFROM:-0700\n"
        "RRULE:FREQ=YEARLY;UNTIL=20061029T090000Z;BYMONTH=10;BYDAY=-1SU\n"
        "DTSTART:19621028T020000\nTZNAME:PST\nTZOFFSETTO:-0800\n"
        "END:STANDARD\nBEGIN:DAYLIGHT\nTZOFFSETFROM:-0800\n"
        "RRULE:FREQ=YEARLY;UNTIL=20060402T100000Z;BYMONTH=4;BYDAY=1SU\n"
        "DTSTART:19870405T020000\nTZNAME:PDT\nTZOFFSETTO:-0700\n"
        "END:DAYLIGHT\nBEGIN:DAYLIGHT\nTZOFFSETFROM:-0800\n"
        "RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU\nDTSTART:20070311T020000\n"
        "TZNAME:PDT\nTZOFFSETTO:-0700\nEND:DAYLIGHT\nBEGIN:STANDARD\n"
        "TZOFFSETFROM:-0700\nRRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU\n"
        "DTSTART:20071104T020000\nTZNAME:PST\nTZOFFSETTO:-0800\n"
        "END:STANDARD\nEND:VTIMEZONE\n"
    )

    for line in hol_file:
        if line.startswith("[") or not line.strip():
            continue  # Skip lines with headers or empty lines

        parts = line.strip().split(",", 1)
        if len(parts) == 2:
            summary, date = parts
            converted_ics.append(
                f"BEGIN:VEVENT\n"
                f"SUMMARY:{summary_prefix}: {summary}\n"
                f"DTSTART;VALUE=DATE:{date.replace('/', '')}\n"
                f"DTEND;VALUE=DATE:{date.replace('/', '')}\n"
                f"TRANSP:OPAQUE\nSEQUENCE:0\n"
                f"END:VEVENT\n"
            )

    # Add iCalendar footer
    converted_ics.append("END:VCALENDAR\n")

    # Print the converted lines or save them to a new file
    for line in converted_ics:
        print(line, end='')

if __name__ == '__main__':
    convert_hol_to_ics()

