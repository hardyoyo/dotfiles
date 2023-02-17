#!/usr/bin/env python
"""
Read an events file and print the number days since or until the given
dates listed inside.
"""
from __future__ import print_function, with_statement
from datetime import datetime
import argparse
import math
import re
import sys

EVENT_FORMAT_RE = re.compile("([A-Z][a-z]{2} [0-9]{2} (?:[0-9]{4}|----)) (.*)\n")

DESCRIPTION = "List events by days since/until they happen(ed)."
HELP_DELTA = "Only print events whose days since/until is less than this argument. \
(0 for no limits)"
HELP_RDELTA = "Only print events whose days since/until is greater than or equal to \
this argument. (default is 0)"
HELP_REVERSE = "Print the events in reverse order."
HELP_NOPAST = "Don't print any events that have already happened."
HELP_NOFUTURE = "Don't print any events that haven't happened yet."
HELP_TOTAL_STYLE = "Specify how you want %(prog)s to print event totals. (default is \
'none')"
HELP_TOTAL_ONLY = "Print only the event totals; do not print any events."
HELP_TOTAL_ALL = "When displaying totals, print them for all events in all files, not \
just the ones that were printed."
HELP_COMMAS = "Add commas whenever printing numbers."
HELP_ARGUMENTS = "Specify input file(s)."

def get_events(fns):
    """
    Collect all events listed in the specified files and return a tuple in the following
    format: (list_of_past_events, list_of_future_events, width)

    Both lists will be sorted by date, and will contain two-item tuples, each containing
    the day delta (always positive), and the name of the event. See parse_file().

    The 'width' item refers to an integer denoting how many digits the biggest day delta is,
    which hints to how many spaces must be printed to properly space the values.
    """

    past = []
    future = []

    for fn in set(fns):
        if fn == "-": # Read from stdin
            parse_file(sys.stdin, past, future)
        else:
            with open(fn, 'r') as fh:
                parse_file(fh, past, future)
    past.sort()
    future.sort()

    if not (past or future):
        # Event list is empty
        _width = 1
    elif not past:
        # Past event list is empty
        _width = math.ceil(math.log10(future[-1][0]))
    elif not future:
        # Future event list is empty
        _width = math.ceil(math.log10(past[-1][0]))
    else:
        # Calculate number of digits
        _width = math.ceil(math.log10(max(past[-1][0], future[-1][0])))
    return past[::-1], future, _width # [::-1] reverses the collection

def parse_file(fh, past, future):
    """
    Parses the given file (passes as file handle) and modifies the 'past'
    and 'future' list arguments, adding in events from the file.

    Each 'event' in the lists are two-item tuples, each containing the day
    delta and the name of the event.

    The order that events will be added to list is dependent on the original
    file, and is therefore undefined.

    This function returns a tuple containing the two arguments, 'past' and
    'future'.
    """
    today = datetime.today()
    line = fh.readline()
    while line:
        match = EVENT_FORMAT_RE.match(line)
        if match:
            if match.group(1).endswith("----"):
                # Recurring events like birthdays
                date = datetime.strptime(match.group(1), "%b %d ----")
                # Check if the event has already happened this year,
                # if so, refer to next year's event.
                if (today.month > date.month) or \
                        (today.month == date.month and today.day > date.day):
                    date = datetime.strptime(match.group(1) \
                            .replace("----", str(today.year + 1)), "%b %d %Y")
                else:
                    date = datetime.strptime(match.group(1) \
                            .replace("----", str(today.year)), "%b %d %Y")
            else:
                # One time events like wars
                date = datetime.strptime(match.group(1), "%b %d %Y")

            name = match.group(2)
            delta = (today - date).days
            if delta >= 0:
                past.append((delta, name))
            else:
                future.append((-delta, name))
        line = fh.readline()
    return past, future

def in_range(args, event):
    """
    Determine whether the given event is in range, based on the
    arguments passed to the program.
    """
    return (not args.delta or event[0] <= args.delta) and \
           event[0] >= args.rdelta

def print_past_events(args, past, width, actually_print=True):
    """
    Prints all past events in the order given, spacing the day delta
    based on the passed width argument.

    Returns the number of events printed.
    """
    count = 0
    if not args.nopast:
        form = "%%%dd day%%c since %%s" % width
        for event in past:
            if in_range(args, event):
                count += 1

                if actually_print:
                    fargs = (event[0], ' ' if event[0] == 1 else 's', event[1])
                    print(form % fargs)
    return count

def print_future_events(args, future, width, actually_print=True):
    """
    Prints all future events in the order given, spacing the day delta
    based on the passed width argument.

    Returns the number of events printed.
    """
    count = 0
    if not args.nofuture:
        form = "%%%dd day%%c until %%s" % width
        for event in future:
            if in_range(args, event):
                count += 1

                if actually_print:
                    fargs = (event[0], ' ' if event[0] == 1 else 's', event[1])
                    print(form % fargs)
    return count

def print_totals(style, reverse, future, past):
    """
    Print the number of events displayed given the current filtering
    settings passed to the program. The style of how it is displayed
    depends on which arguments were passed.
    """
    if style == "none":
        return
    elif style == "simple":
        count = future + past
        print("Total: %d event%s." % (count, ' ' if count == 1 else 's'))
    elif style == "categories" and reverse:
        print("%d future event%s." % (future, ' ' if future == 1 else 's'))
        print("%d past event%s." % (past, ' ' if past == 1 else 's'))
    elif style == "categories":
        print("%d past event%s." % (past, ' ' if past == 1 else 's'))
        print("%d future event%s." % (future, ' ' if future == 1 else 's'))
    elif style == "both":
        print_totals("categories", reverse, future, past)
        print_totals("simple", reverse, future, past)

if __name__ == "__main__":
    # Parse options with argparse
    argparser = argparse.ArgumentParser(description=DESCRIPTION)
    argparser.add_argument("-d", "--delta", type=int, default=0, help=HELP_DELTA)
    argparser.add_argument("-D", "--reverse-delta", type=int, default=0, \
            dest='rdelta', help=HELP_RDELTA)
    argparser.add_argument("-r", "--reverse", action="store_true", help=HELP_REVERSE)
    argparser.add_argument("-n", "--nopast", action="store_true", help=HELP_NOPAST)
    argparser.add_argument("-N", "--nofuture", action="store_true", help=HELP_NOFUTURE)
    argparser.add_argument("-t", "--totals-style", nargs='?', choices=\
            ("none", "simple", "categories", "both"), default="none", dest="tstyle", \
            help=HELP_TOTAL_STYLE)
    argparser.add_argument("-c", "--total-only", action="store_true", help=HELP_TOTAL_ONLY)
    argparser.add_argument("-T", "--total-all", action="store_true", dest="total_all", \
            help=HELP_TOTAL_ALL)
    argparser.add_argument("-C", "--commas", action="store_true", help=HELP_COMMAS)
    argparser.add_argument("input-file", nargs='+', help=HELP_ARGUMENTS)
    args = argparser.parse_args()

    # Perform sanity checks on arguments
    if args.delta < 0:
        print("The delta must be a positive integer.", file=sys.stderr)
        exit(1)

    if args.rdelta < 0:
        print("The reverse delta must be a positive integer.", file=sys.stderr)
        exit(1)

    if args.delta < args.rdelta:
        print("Warning: the deltas you specified will result in no events being printed.", file=sys.stderr)

    # Fetch event data
    past, future, width = get_events(getattr(args, "input-file"))

    if args.total_only:
        future_total = print_future_events(args, future, width, False)
        past_total = print_past_events(args, past, width, False)
        print(future_total + past_total)
    elif args.reverse:
        future_total = print_future_events(args, reversed(future), width)
        past_total = print_past_events(args, reversed(past), width)

        if args.total_all:
            print_totals(args.tstyle, True, len(future), len(past))
        else:
            print_totals(args.tstyle, True, future_total, past_total)
    else:
        future_total = print_past_events(args, past, width)
        past_total = print_future_events(args, future, width)

        if args.total_all:
            print_totals(args.tstyle, False, len(future), len(past))
        else:
            print_totals(args.tstyle, False, future_total, past_total)

