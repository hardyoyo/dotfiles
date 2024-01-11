#!/usr/bin/env python3

import feedparser
import requests
import re

def monitor_jenkins_rss(rss_url):
    try:
        response = requests.get(rss_url)
        response.raise_for_status()
        feed = feedparser.parse(response.text)

        found_broken_since = False  # Flag to track if we found "broken since" in the title
        broken_build_number = None  # Store the build number when "broken since" is found
        failure_count = 0  # Count of build failures

        # blank line, for readability
        print();

        for entry in feed.entries:
            # Check if the entry is related to "janeway-master-ci"
            if "janeway-master-ci" in entry.title.lower():
                print(entry.title)
                print(entry.link)
                print(entry.published)

                # Check if the title contains "broken since" and stop reporting if found
                if "broken since" in entry.title.lower():
                    found_broken_since = True

                # Extract the build number from the title using regex
                last_word = entry.title.split()[-1]
                broken_build_number = re.sub('[^0-9]', '', last_word)

                print("-" * 50)

                # Increment the failure count
                failure_count += 1

            if found_broken_since:
                break

        # If no build failures were found, report that condition
        if failure_count == 0:
            print("WOOHOO! No build failures on janeway-master-ci!")

        # If "broken since" was found and a build number was extracted, output it at the end
        if found_broken_since and broken_build_number:
            print(f"Build has been broken since build #{broken_build_number}")
            build_link = f"https://jenkins.janeway.systems/job/janeway-master-ci/{broken_build_number}/"
            print(f"{build_link}")

        # blank line, for readability
        print();

    except requests.exceptions.RequestException as e:
        print(f"Aw, shoot, there was an issue fetching the RSS feed: {e}")

if __name__ == "__main__":
    rss_url = "https://jenkins.janeway.systems/rssFailed"
    monitor_jenkins_rss(rss_url)

