#!/bin/bash
echo "Restarting networking... pausing a minute, and knocking on the captive portal's door..."
echo "If you see RTNETLINK answers: Network is unreachable, check your AP, it has fallen off."
sudo service network-manager restart && sleep 60 && xdg-open http://$(ip --oneline route get 8.8.8.8 | awk '{print $3}')
