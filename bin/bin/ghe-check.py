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
    GHE_URL = "https://git-stage.ucsf.edu"
    EXPECTED_TEXT = "GitHub lives!"

    # Run comprehensive checks
    checks = {
        "status": {
            "url": f"{GHE_URL}/status",
            "expected_text": EXPECTED_TEXT
        },
        "search_repos_ucsf": {
            "path": "/search/repositories?q=ucsf",
            "expected_count": 27
        },
        "search_repos_radiology": {
            "path": "/search/repositories?q=radiology",
            "expected_count": 12
        },
        "search_repos_ars": {
            "path": "/search/repositories?q=ars",
            "expected_count": 7
        },
        "search_repos_covid": {
            "path": "/search/repositories?q=covid",
            "expected_count": 3
        },
        "search_code_covid": {
            "path": "/search/code?q=covid",
            "expected_count": 199
        },
        "search_issues_covid": {
            "path": "/search/issues?q=covid",
            "expected_count": 3
        },
        "search_commits_covid": {
            "path": "/search/commits?q=covid",
            "expected_count": 16
        },
        "packages": {
            "path": "/users/hardy-pottinger/packages?package_type=container",
            "expected_text": "nginx"
        },
        "org_ucsf_shared": {
            "path": "https://git-stage.ucsf.edu/api/v3/orgs/UCSF-Shared",
            "expected_text": "UCSF-Shared"
        }
    }

    # Run all checks
    all_passed = True
    for check_name, check_config in checks.items():
        print(f"\nRunning check: {check_name}")

        if "url" in check_config:
            result = check_web_access(check_config["url"], check_config["expected_text"])
        else:
            result = check_gh_cli(
                path=check_config["path"],
                expected_text=check_config.get("expected_text", ""),
                expected_count=check_config.get("expected_count")
            )

        print(f"{check_name}: {'OK' if result else 'FAILED'}")
        all_passed = all_passed and result

    # Exit with appropriate status code
    sys.exit(0 if all_passed else 1)

if __name__ == "__main__":
    main()
