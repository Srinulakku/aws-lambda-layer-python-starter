#!/bin/bash

# AWS Lambda Layer Build Script
# This script builds the Lambda layer zip file
#
# Usage:
#   ./build.sh                      # Creates custom-layer.zip
#   ./build.sh my-layer             # Creates my-layer.zip
#   ZIP_NAME=my-layer ./build.sh    # Creates my-layer.zip

set -e

LAYER_DIR="custom-layer"
# Accept zip file name as argument or environment variable, default to custom-layer.zip
ZIP_FILE="${1:-${ZIP_NAME:-custom-layer.zip}}"
PYTHON_VERSION="3.12"  # Note: This is informational - actual version is in directory structure

echo "Building AWS Lambda Layer..."

# Check if custom-layer directory exists
if [ ! -d "$LAYER_DIR" ]; then
    echo "Error: $LAYER_DIR directory not found!"
    exit 1
fi

# Remove old zip file if it exists
if [ -f "$ZIP_FILE" ]; then
    echo "Removing old $ZIP_FILE..."
    rm "$ZIP_FILE"
fi

# Clean up __pycache__ directories and .pyc files before zipping
echo "Cleaning up cache files..."
find "$LAYER_DIR" -type d -name "__pycache__" -exec rm -r {} + 2>/dev/null || true
find "$LAYER_DIR" -type f -name "*.pyc" -delete 2>/dev/null || true
find "$LAYER_DIR" -type f -name "*.pyo" -delete 2>/dev/null || true

# Create zip file
echo "Creating $ZIP_FILE..."
cd "$LAYER_DIR"
zip -r "../$ZIP_FILE" . -q
cd ..

# Check zip file size
ZIP_SIZE=$(du -h "$ZIP_FILE" | cut -f1)
echo "✓ Layer built successfully!"
echo "  File: $ZIP_FILE"
echo "  Size: $ZIP_SIZE"
echo ""
echo "Next steps:"
echo "  1. Upload $ZIP_FILE to AWS Lambda Layers"
echo "  2. Attach the layer to your Lambda function"
echo "  3. Import: from helpers.utils import greet, make_http_request"
echo ""
echo "Note: Ensure your Lambda runtime Python version matches the layer version"
echo "      Check the python/lib/pythonX.Y/ directory structure in the layer"

