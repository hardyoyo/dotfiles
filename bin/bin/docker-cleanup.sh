#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# uncomment for debug
# set -x

# Set cleanup parameters
DAYS_TO_KEEP=7

# default DRY_RUN to false
DRY_RUN=false

# Function to show usage
show_usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -n, --dry-run  Perform a dry run (show what would be cleaned)"
    echo ""
    echo "Example:"
    echo "  $0 -n    # Show what would be cleaned without making changes"
    echo "  $0      # Perform actual cleanup"
}

# Function to show disk usage
show_disk_usage() {
    echo
    echo "────────────────────────────────────────────────────────────────"
    echo "                    Current Docker disk usage"
    echo "────────────────────────────────────────────────────────────────"
    docker system df
    echo
}

# Function to check if cleanup is needed
check_cleanup_needed() {
    local dangling_images
    local exited_containers
    local dangling_volumes

    dangling_images=$(docker images -f "dangling=true" -q | wc -l)
    exited_containers=$(docker container ls -a --filter "status=exited" -q | wc -l)
    dangling_volumes=$(docker volume ls -f dangling=true -q | wc -l)

    if [ "$dangling_images" -eq 0 ] && [ "$exited_containers" -eq 0 ] && [ "$dangling_volumes" -eq 0 ]; then
        echo
        echo -e "\033[32m✨ All clean! Nothing to do here\033[0m"
        echo " - any remaining usage is more recent than $DAYS_TO_KEEP days"
        echo " - if you really want it ALL to go away, run this command:"
        echo -e "   \033[1mdocker system prune -af --volumes\033[0m"
        return 1
    fi

    echo "Found:"
    [ "$dangling_images" -gt 0 ] && echo "- $dangling_images dangling images"
    [ "$exited_containers" -gt 0 ] && echo "- $exited_containers exited containers"
    [ "$dangling_volumes" -gt 0 ] && echo "- $dangling_volumes dangling volumes"
    return 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_usage
            exit 0
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Function to clean unused layers
clean_layers() {
    echo "Cleaning Docker layers..."
    docker system prune -f --filter "until=$((60*60*24*DAYS_TO_KEEP))"

    # Clean builder cache
    echo "Cleaning builder cache..."
    docker builder prune -f --filter "until=$((60*60*24*DAYS_TO_KEEP))"

    # Clean old containers
    echo "Cleaning old containers..."
    docker container prune -f --filter "until=$((60*60*24*DAYS_TO_KEEP))"

    # Clean volumes - safely
    echo "Cleaning unused volumes..."
    if docker volume ls -f dangling=true -q | grep -q .; then
        docker volume rm "$(docker volume ls -f dangling=true -q)"
    else
        echo "No dangling volumes to clean"
    fi
}

# Main execution
if check_cleanup_needed; then
    if [ "$DRY_RUN" = true ]; then
        echo "Dry run simulation:"
        echo "Images that would be removed:"
        docker images -f "dangling=true" --format "{{.Repository}}:{{.Tag}}"
        echo "Containers that would be removed:"
        docker container ls -a --filter "status=exited" --format "{{.Names}}"
        echo "Volumes that would be removed:"
        docker volume ls -f dangling=true -q
    else
        clean_layers
    fi
fi

show_disk_usage

exit 0
