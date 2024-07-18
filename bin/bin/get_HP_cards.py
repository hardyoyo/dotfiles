#!/usr/bin/env python3
import os
import requests
import click
import json
import sys

# Function to get lists from a board
def get_lists_from_board(api_key, token, board_id):
    # print("Fetching lists from board...")
    url = f"https://api.trello.com/1/boards/{board_id}/lists"
    query = {
        "key": api_key,
        "token": token,
    }
    response = requests.get(url, params=query)
    if response.status_code == 200:
        # print("Lists fetched successfully.")
        return response.json()
    else:
        print(f"Error: Failed to get lists from board. Status code: {response.status_code}")
        sys.exit(1)

# Function to get cards from a list
def get_cards_from_list(api_key, token, list_id):
    # print(f"Fetching cards from list ID: {list_id}...")
    url = f"https://api.trello.com/1/lists/{list_id}/cards"
    query = {
        "key": api_key,
        "token": token,
    }
    response = requests.get(url, params=query)
    if response.status_code == 200:
        # print("Cards fetched successfully.")
        return response.json()
    else:
        print(f"Error: Failed to get cards from list. Status code: {response.status_code}")
        sys.exit(1)

@click.command()
@click.option('--board-id', prompt='Board ID', help='The ID of the Trello board.')
def main(board_id):
    # print("Starting script...")
    api_key = os.getenv('TRELLO_API_KEY')
    token = os.getenv('TRELLO_TOKEN') # Use the pre-generated token

    if not api_key or not token:
        print("Error: API key or token is missing. Please set the TRELLO_API_KEY and TRELLO_TOKEN environment variables.")
        sys.exit(1)

    # Fetch all lists from the board
    lists = get_lists_from_board(api_key, token, board_id)
    # print(f"Total lists fetched: {len(lists)}")

    # # Print all list names to verify the data
    # print("List names:")
    # for list in lists:
    #     print(list['name'])

    # Filter lists that exactly match "HP" in their names
    filtered_lists = [list for list in lists if "HP" in list['name']]
    # print(f"Lists with 'HP' in their names: {len(filtered_lists)}")

    # Extract IDs of filtered lists
    filtered_list_ids = [list['id'] for list in filtered_lists]

    for list_id in filtered_list_ids:
        cards = get_cards_from_list(api_key, token, list_id)
        # print(f"Cards fetched for list ID {list_id}: {len(cards)}")
        for card in cards:
            print(json.dumps(card, indent=4))

    # Exit with status code 0
    # print("Script completed successfully.")
    sys.exit(0)

if __name__ == '__main__':
    main()

