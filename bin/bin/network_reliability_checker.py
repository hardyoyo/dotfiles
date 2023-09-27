#!/usr/bin/env python3
"""
Network Reliability Checker

This script continuously checks the reliability of the network by sending ICMP
packets to the specified target host and analyzing packet loss and latency at
each hop over a specified duration.

Usage:
    sudo network_reliability.py [--target TARGET_HOST] [--max-hops MAX_HOPS]
                                [--iface INTERFACE] [--duration DURATION]

Options:
    --target TARGET_HOST  The target host to check [default: google.com].
    --max-hops MAX_HOPS   Maximum number of hops to check [default: 3].
    --iface INTERFACE     The network interface to use [default: en0].
    --duration DURATION   Duration in seconds to collect statistics [default: 10].
"""

import click
import os
import time
import logging
from scapy.config import conf  # Import conf from scapy.config
from scapy.all import sr1, IP, ICMP
import signal  # Import the signal module
import sys

def check_root_privileges():
    if os.geteuid() != 0:
        raise PermissionError("This script requires root privileges. Please run it with sudo.")

@click.command()
@click.option('--target', default='google.com', help='The target host to check.')
@click.option('--max-hops', default=3, help='Maximum number of hops to check.')
@click.option('--iface', default='en0', help='The network interface to use.')
@click.option('--duration', default=10, help='Duration in seconds to collect statistics.')
def network_reliability(target, max_hops, iface, duration):
    check_root_privileges()  # Check for root privileges

    # Set Scapy's logging level to ERROR to suppress warnings
    logging.getLogger("scapy.runtime").setLevel(logging.ERROR)

    # Set the network interface to use
    conf.iface = iface

    click.echo(f"Checking network reliability to {target} using interface {iface}...")
    click.echo("Press Ctrl-C to quit.")

    start_time = time.time()
    end_time = start_time + duration

    hop_descriptions = {
        1: "from computer to router",
        2: "from router to modem",
        3: "from modem to pole"
    }

    packet_loss_count = [0] * (max_hops + 1)  # Initialize packet loss count for each hop
    total_packets_sent = 0
    total_packets_received = 0

    try:
        while time.time() < end_time:
            for hop in range(1, max_hops + 1):
                packet = IP(dst=target, ttl=hop) / ICMP()
                response = sr1(packet, timeout=2, verbose=False)

                hop_description = hop_descriptions.get(hop, "your ISP")

                total_packets_sent += 1

                if response:
                    total_packets_received += 1
                    click.echo(f"Hop {hop} ({hop_description}): {response.src} (RTT: {response.time * 1000} ms)")
                else:
                    packet_loss_count[hop] += 1
                    # Use the "❌" symbol to indicate packet loss
                    click.echo(f"Hop {hop} ({hop_description}): ❌ Packet loss detected")

            # Add a timestamp to the "----" line
            click.echo(f"{'-' * 30} Timestamp: {time.strftime('%Y-%m-%d %H:%M:%S')}")

    except KeyboardInterrupt:
        pass  # Handle Ctrl-C gracefully

    # Calculate packet loss percentage for each hop
    packet_loss_percentage = [(count / total_packets_sent) * 100 for count in packet_loss_count]

    # Display summary
    click.echo("\n--- Summary ---")
    click.echo(f"Target host: {target}")
    click.echo(f"Network interface: {iface}")
    click.echo(f"Total packets sent: {total_packets_sent}")
    click.echo(f"Total packets received: {total_packets_received}")

    # Determine the hop with the most packet loss
    most_packet_loss_hop = packet_loss_percentage.index(max(packet_loss_percentage))

    # Display advice based on the hop with the most packet loss
    if packet_loss_percentage[most_packet_loss_hop] > 10:
        most_packet_loss_description = hop_descriptions.get(most_packet_loss_hop, "Your ISP")
        click.echo(f"Hop {most_packet_loss_hop} ({most_packet_loss_description}) has the most packet loss.")
        if most_packet_loss_hop == 1:
            click.echo("Advice: Consider moving closer to your access point.")
        elif most_packet_loss_hop == 2:
            click.echo("Advice: Check the cable from the modem to the router.")
        elif most_packet_loss_hop == 3:
            click.echo("Advice: Contact your ISP to check the connection to your house.")
    
    # Display packet loss percentages for all hops
    for hop in range(1, max_hops + 1):
        hop_description = hop_descriptions.get(hop, "Your ISP")
        click.echo(f"Hop {hop} ({hop_description}) - Packet loss percentage: {packet_loss_percentage[hop]:.2f}%")

if __name__ == '__main__':
    network_reliability()
