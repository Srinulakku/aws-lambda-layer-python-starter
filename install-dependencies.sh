#!/bin/bash

# Install Python dependencies for Lambda Layer
# This script installs packages from requirements.txt into the correct location
#
# Usage:
#   ./install-dependencies.sh              # Uses Python 3.12 (default)
#   ./install-dependencies.sh 3.11         # Uses Python 3.11
#   PYTHON_VERSION=3.10 ./install-dependencies.sh  # Uses Python 3.10

set -e

LAYER_DIR="custom-layer"
# Accept Python version as argument or environment variable, default to 3.12
PYTHON_VERSION="${1:-${PYTHON_VERSION:-3.12}}"
SITE_PACKAGES_DIR="$LAYER_DIR/python/lib/python$PYTHON_VERSION/site-packages"

echo "Installing dependencies for AWS Lambda Layer..."
echo "Python Version: $PYTHON_VERSION"

# Check if requirements.txt exists
if [ ! -f "$LAYER_DIR/requirements.txt" ]; then
    echo "Error: $LAYER_DIR/requirements.txt not found!"
    exit 1
fi

# Clean site-packages directory to avoid duplicate versions
if [ -d "$SITE_PACKAGES_DIR" ] && [ "$(ls -A $SITE_PACKAGES_DIR)" ]; then
    echo "Cleaning existing packages to avoid conflicts..."
    rm -rf "$SITE_PACKAGES_DIR"/*
fi

# Create site-packages directory if it doesn't exist
mkdir -p "$SITE_PACKAGES_DIR"

# Install dependencies using the specified Python version's pip
echo "Installing packages to $SITE_PACKAGES_DIR..."
echo "Using: python$PYTHON_VERSION -m pip"

# Try to use the specific Python version's pip
if command -v "python$PYTHON_VERSION" &> /dev/null; then
    "python$PYTHON_VERSION" -m pip install -r "$LAYER_DIR/requirements.txt" -t "$SITE_PACKAGES_DIR" --no-cache-dir
elif command -v "python3" &> /dev/null; then
    # Fallback to python3, but warn user
    echo "Warning: python$PYTHON_VERSION not found, using python3"
    echo "⚠️  Make sure python3 matches Python $PYTHON_VERSION for your Lambda runtime!"
    python3 -m pip install -r "$LAYER_DIR/requirements.txt" -t "$SITE_PACKAGES_DIR" --no-cache-dir
else
    echo "Error: No Python interpreter found!"
    exit 1
fi

echo "✓ Dependencies installed successfully!"
echo ""
echo "⚠️  Important: Verify Python version matches Lambda runtime!"
echo "   Layer path: $SITE_PACKAGES_DIR"
echo "   Target Lambda runtime: python$PYTHON_VERSION"

