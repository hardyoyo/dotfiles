#!/usr/bin/env python3
import requests
import subprocess
import sys
from typing import Dict, Any

def check_web_access(url: str, expected_text: str) -> bool:
    """Check web access to GitHub Enterprise server."""
    try:
        response = requests.get(url, timeout=10)
        return (response.status_code == 200 and 
                expected_text.lower() in response.text.lower())
    except requests.RequestException as e:
        print(f"Web check failed: {e}")
        return False

def check_gh_cli(hostname: str = "git-stage.ucsf.edu", path: str = "/", expected_text: str = "") -> bool:
    """Check GitHub CLI functionality with specific path and expected text."""
    try:
        result = subprocess.run(['gh', 'api', '--hostname', hostname, path],
                              capture_output=True,
                              text=True)

        # Store the full result for debugging
        check_gh_cli.full_result = result

        # uncomment for debug output
        # print("\ngh CLI Command Details:")
        # print(f"Command: {' '.join(result.args)}")
        # print(f"Exit Code: {result.returncode}")
        # print(f"stdout: {result.stdout}")
        # print(f"stderr: {result.stderr}")

        return (result.returncode == 0 and
                (not expected_text or expected_text.lower() in result.stdout.lower()))
    except FileNotFoundError:
        print("gh CLI not found")
        return False
    except subprocess.SubprocessError as e:
        print(f"gh CLI check failed: {e}")
        return False

def main():
    # Configuration
    GHE_URL = "https://git-stage.ucsf.edu/status"
    EXPECTED_TEXT = "GitHub lives!"

    # Run checks
    web_result = check_web_access(GHE_URL, EXPECTED_TEXT)
    packages_result = check_gh_cli("git-stage.ucsf.edu", "/users/hardy-pottinger/packages?package_type=container", "https://git-stage.ucsf.edu/api/v3/users/hardy-pottinger/packages/container/nginx-custom")

    # Print results
    print(f"\nResults:")
    print(f"Web access check: {'OK' if web_result else 'FAILED'}")
    print(f"gh CLI check for packages: {'OK' if packages_result else 'FAILED'}")

    # Exit with appropriate status code
    sys.exit(0 if web_result and packages_result else 1)

if __name__ == "__main__":
    main()
