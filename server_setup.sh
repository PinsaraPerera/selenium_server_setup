#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update package list and upgrade system packages
echo "Updating and upgrading system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install necessary packages
echo "Installing required packages..."
sudo apt-get install -y python3 python3-pip python3-venv unzip wget curl xvfb

# Set up a virtual environment
echo "Setting up a Python virtual environment..."
python3 -m venv selenium_env
source selenium_env/bin/activate

# Install Selenium
echo "Installing Selenium..."
pip install --upgrade pip
pip install selenium

# Install Google Chrome
echo "Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Install ChromeDriver
echo "Installing ChromeDriver..."
CHROME_VERSION=$(google-chrome --version | grep -oP '[0-9.]+' | head -1)
CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION")
wget "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip"
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/local/bin/
rm chromedriver_linux64.zip

# Set permissions for ChromeDriver
echo "Setting permissions for ChromeDriver..."
sudo chmod +x /usr/local/bin/chromedriver

# Install Firefox and GeckoDriver (Optional)
echo "Installing Firefox and GeckoDriver (optional)..."
sudo apt-get install -y firefox-esr
GECKODRIVER_VERSION=$(curl -s "https://api.github.com/repos/mozilla/geckodriver/releases/latest" | grep -oP '"tag_name": "\K(.*)(?=")')
wget "https://github.com/mozilla/geckodriver/releases/download/${GECKODRIVER_VERSION}/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz"
tar -xvzf "geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz"
sudo mv geckodriver /usr/local/bin/
rm "geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz"

# Install additional dependencies for headless browsing
echo "Installing additional dependencies for headless browsing..."
sudo apt-get install -y fonts-liberation libappindicator3-1 xdg-utils

# Verify installation
echo "Verifying installations..."
google-chrome --version
chromedriver --version
firefox --version
geckodriver --version

echo "Setup complete! Activate the virtual environment with 'source selenium_env/bin/activate' and run your Selenium script."
