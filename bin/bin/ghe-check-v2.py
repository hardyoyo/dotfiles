#!/usr/bin/env python3
import requests
import subprocess
import sys
import json
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

def check_gh_cli(hostname: str = "git-stage.ucsf.edu", path: str = "/",
                 expected_text: str = "", expected_count: int = None) -> bool:
    """Check GitHub CLI functionality with specific path and expected text."""
    try:
        result = subprocess.run(['gh', 'api', '--hostname', hostname, path],
                              capture_output=True,
                              text=True)

        # Store the full result for debugging
        check_gh_cli.full_result = result

        # uncomment for debug
        # print(f"\ngh CLI Command Details:")
        # print(f"Command: {' '.join(result.args)}")
        # print(f"Exit Code: {result.returncode}")
        # print(f"stdout: {result.stdout}")
        # print(f"stderr: {result.stderr}")

        # Check text first
        if expected_text and expected_text.lower() not in result.stdout.lower():
            print(f"Text not found: expected '{expected_text}'")
            return False

        # Check count if provided
        if expected_count is not None:
            try:
                data = json.loads(result.stdout)
                total_count = data.get('total_count', 0)
                if total_count != expected_count:
                    print(f"Count mismatch: expected {expected_count}, got {total_count}")
                    return False
            except json.JSONDecodeError as e:
                print(f"Failed to parse JSON: {e}")
                return False

        return result.returncode == 0

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
    packages_result = check_gh_cli("git-stage.ucsf.edu", "/users/hardy-pottinger/packages?package_type=container", "nginx-custom")
    count_radiology_result = check_gh_cli("git-stage.ucsf.edu", "https://git-stage.ucsf.edu/api/v3/search/repositories?q=radiology", "radiology", 12)
    # Print results
    print(f"\nResults:")
    print(f"Web access check: {'OK' if web_result else 'FAILED'}")
    print(f"gh CLI check for packages: {'OK' if packages_result else 'FAILED'}")
    print(f"gh CLI check for radiology repos count: {'OK' if count_radiology_result else 'FAILED'}")

    # Exit with appropriate status code
    sys.exit(0 if web_result and packages_result else 1)

if __name__ == "__main__":
    main()
