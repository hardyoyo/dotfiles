#!/usr/bin/env python3
import subprocess
import re
import click

@click.command()
@click.option('--target', default='google.com', help='The target for ping (default: google.com)')
@click.option('--quiet', '-q', is_flag=True, help='Enable quiet mode (less detailed output)')
@click.option('--count', '-c', default=10, type=int, help='Number of pings to send (default: 10)')
@click.option('--latency-threshold', default=150, type=int, help='Latency threshold in milliseconds for warning (default: 150)')
def net_info(target, quiet, count, latency_threshold):
    """
    A script to gather network-related information including active interface, MTU, ping latency, and network speeds.
    """
    if not quiet:
        click.echo("Gathering network information...")
    try:
        # Ping the target to determine the active interface
        ping_cmd = f"ping -c {count} {target}"  # Sending specified number of pings
        ping_result = subprocess.run(ping_cmd, shell=True, stdout=subprocess.PIPE, text=True, check=True)

        if not quiet:
            click.echo("Determining active network interface...")
        # Extract the active interface name
        route_cmd = f"route get {target} | grep interface"
        route_result = subprocess.run(route_cmd, shell=True, stdout=subprocess.PIPE, text=True, check=True)
        active_interface = route_result.stdout.split(":")[1].strip()

        if not quiet:
            click.echo(f"Active network interface: {active_interface}")
        # Get the current MTU for the active interface
        mtu_cmd = f"networksetup -getMTU {active_interface}"
        mtu_result = subprocess.run(mtu_cmd, shell=True, stdout=subprocess.PIPE, text=True, check=True)
        
        # Extract the numeric value from the MTU output
        mtu_match = re.search(r'(\d+)', mtu_result.stdout)
        mtu = int(mtu_match.group()) if mtu_match else None

        if not quiet:
            click.echo(f"Current MTU for {active_interface}: {mtu} bytes")

            # Get the valid MTU range for the active interface
            valid_mtu_range_cmd = f"networksetup -listvalidMTUrange {active_interface}"
            valid_mtu_range_result = subprocess.run(valid_mtu_range_cmd, shell=True, stdout=subprocess.PIPE, text=True, check=True)

            # Extract the minimum MTU value from the range
            mtu_range_match = re.search(r'(\d+)-(\d+)', valid_mtu_range_result.stdout)
            min_mtu = int(mtu_range_match.group(1)) if mtu_range_match else None

            click.echo(f"Valid MTU Range for {active_interface}: {valid_mtu_range_result.stdout.strip()}")

            if mtu != min_mtu:
                click.echo("Advice: Consider configuring the MTU to the minimum value within the valid range.")
                click.echo("This may help optimize network performance.")
                click.echo("Helpful article: https://andrewbaker.ninja/2023/05/24/finding-and-setting-the-maximum-transmission-unit-mtu-on-mac-osx/")
                click.echo("Or search for 'how to tune MTU' on your favorite search engine.")
            else:
                click.echo(" 🌟 MTU is set to the minimum value, an excellent choice for the user of flaky WiFi!")

        if not quiet:
            click.echo("Calculating average ping/latency...")
        # Extract and calculate average ping/latency
        ping_lines = ping_result.stdout.split('\n')
        ping_times = [float(re.search(r'time=(\d+\.\d+)', line).group(1)) for line in ping_lines if "time=" in line]
        average_latency = sum(ping_times) / len(ping_times) if ping_times else None

        if not quiet:
            click.echo(f"Average Ping/Latency to {target}: {average_latency} ms")

            # Check for high latency and provide a warning
            if average_latency is not None and average_latency > latency_threshold:
                click.echo(f"Warning: High latency detected (over {latency_threshold} ms). This may impact network performance.")
                click.echo("Consider troubleshooting your network or contacting your service provider for assistance.")
                click.echo("You can search 'troubleshoot high latency' in your favorite search engine for advice.")
                click.echo("TLDR: you may want to restart your router, and check your network connection hardware.")
                click.echo("I.e.is it on? Is it plugged in? Have you tried turning it off and on? You know the drill. :-)")
    except subprocess.CalledProcessError as e:
        click.echo(f"Error: {e}")
        exit(1)

    # Run speedtest with --simple in quiet mode
    click.echo("Running speed test. Press Ctrl+C to exit if needed...")
    speedtest_cmd = "speedtest-cli --simple" if quiet else "speedtest-cli"
    subprocess.run(speedtest_cmd, shell=True, check=True)

if __name__ == '__main__':
    net_info()
