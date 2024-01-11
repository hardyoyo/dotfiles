#!/usr/bin/env python3

import click
import requests
from bs4 import BeautifulSoup
from icalendar import Calendar, Event
from dateutil import parser

@click.command()
@click.option('--url', default='https://www.ucop.edu/local-human-resources/op-life/holiday-calendar.html', help='URL of the HTML page')
@click.argument('ics_file', type=click.Path(dir_okay=False, writable=True, resolve_path=True), default='UCOP_holidays.ics')
def generate_ics(url, ics_file):
    """
    Parse HTML with holiday information from a URL and generate an ICS file.
    """
    try:
        # Fetch HTML content from the URL
        response = requests.get(url)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')

        calendar = Calendar()

        # Find the table containing holiday information
        table = soup.find('table', {'summary': 'UCOP Holiday Calendar'})
        rows = table.find_all('tr')

        for row in rows[1:]:  # Skip header row
            columns = row.find_all(['th', 'td'])
            holiday_name = columns[0].text.strip()
            date_str = ' '.join(columns[1].text.strip().split())  # Keep spaces between words

            # Handling multiple dates on the same line (e.g., Thanksgiving)
            date_parts = date_str.split('<br>')

            # Debug logging
            click.echo(f"Debug: Processing date string - '{date_str}'")

            # Create an event for each holiday, with each parsed date
            for date_part in date_parts:
                date_part = date_part.replace(',', '')  # Remove commas
                try:
                    date_obj = parser.parse(date_part)
                    event = Event()
                    event.add('summary', holiday_name)
                    event.add('dtstart', date_obj)
                    event.add('dtend', date_obj)
                    calendar.add_component(event)
                except parser.ParserError:
                    click.echo(f"Debug: Skipped invalid date string - '{date_part}'")

        # Write the calendar to the ICS file
        with open(ics_file, 'wb') as file:
            file.write(calendar.to_ical())

        click.echo(f"ICS file '{ics_file}' generated successfully!")
    except requests.exceptions.RequestException as e:
        click.echo(f"Error fetching HTML content from the URL: {e}")

if __name__ == '__main__':
    generate_ics()

