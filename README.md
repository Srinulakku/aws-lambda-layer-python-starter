# AWS Custom Lambda Layer Starter Kit

A starter template for creating AWS Lambda Layers with custom Python code and dependencies.

## Project Structure

```
custom-lambda-layer/
├── .gitignore                    # Git ignore rules
├── build.sh                      # Build script (creates zip)
├── install-dependencies.sh       # Dependency installer
├── example-lambda-function.py    # Example Lambda function
├── README.md                     # This file
├── custom-layer.zip              # Built layer (generated)
└── custom-layer/                 # Lambda Layer directory
    ├── README.md                 # Layer API documentation
    ├── requirements.txt          # Python dependencies list
    └── python/
        ├── helpers/              # Custom code modules
        │   ├── __init__.py       # Package initialization
        │   └── utils.py          # Custom utilities
        └── lib/
            └── python3.12/
                └── site-packages/ # Third-party dependencies
                    ├── requests/
                    ├── urllib3/
                    └── ... (other packages)
```

## Quick Start

### 1. Install Dependencies

Install Python packages from `requirements.txt`:

```bash
# Option 1: Use the install script (recommended - cleans duplicates)
chmod +x install-dependencies.sh
./install-dependencies.sh

# Option 2: Manual installation
pip install -r custom-layer/requirements.txt -t custom-layer/python/lib/python3.12/site-packages/
```

**Note**: The install script automatically cleans existing packages to avoid version conflicts.

### 2. Build the Layer

Create the zip file for deployment:

```bash
# Option 1: Use the build script (recommended - cleans cache files)
chmod +x build.sh
./build.sh

# Option 2: Manual build
cd custom-layer
zip -r ../custom-layer.zip .
cd ..
```

**Note**: The build script automatically removes `__pycache__` directories and `.pyc` files before zipping.

### 3. Deploy to AWS

1. Upload `custom-layer.zip` to AWS Lambda Layers via:
   - **AWS Console**: Lambda → Layers → Create layer
   - **AWS CLI**: 
     ```bash
     aws lambda publish-layer-version \
       --layer-name my-layer \
       --zip-file fileb://custom-layer.zip \
       --compatible-runtimes python3.12
     ```

2. Attach the layer to your Lambda function

3. Use in your Lambda function:
   ```python
   # Custom helpers from layer
   from helpers.utils import greet, make_http_request
   
   # Third-party packages from layer
   import requests
   
   def lambda_handler(event, context):
       message = greet("AWS Lambda")
       return {'statusCode': 200, 'body': message}
   ```

## Customization

### Adding Dependencies

Add packages to `custom-layer/requirements.txt`:
```
requests
boto3
pandas
```

Then run `./install-dependencies.sh` to install them.

### Adding Custom Code

Add your Python modules under `custom-layer/python/`:
```
custom-layer/
└── python/
    └── my_module/
        ├── __init__.py
        └── my_code.py
```

Import in Lambda: `from my_module.my_code import my_function`

## Structure Validation

### AWS Lambda Layer Requirements
- ✅ **Correct path**: `custom-layer/python/` - AWS Lambda looks for code here
- ✅ **Dependencies location**: `python/lib/python3.12/site-packages/` - Correct for Python 3.12
- ✅ **Custom code location**: `python/helpers/` - Accessible as `from helpers import ...`
- ✅ **Package structure**: `__init__.py` present in helpers module

### Build Scripts Features
- ✅ **Auto-clean duplicates**: `install-dependencies.sh` removes old packages before installing
- ✅ **Auto-clean cache**: `build.sh` removes `__pycache__` and `.pyc` files before zipping

## Important Notes

- **Python Version**: This layer is built for Python 3.12. Make sure your Lambda runtime matches.
- **Layer Size Limit**: AWS Lambda layers have a 50MB (zipped) or 250MB (unzipped) limit.
- **Path Structure**: The `python/` directory structure is required for Lambda to find your code.
- **Handler Configuration**: Set your Lambda handler as `example-lambda-function.lambda_handler` (or your function name)

## Example Lambda Function

See `example-lambda-function.py` for a complete example of using this layer.

## Layer Documentation

For detailed API documentation and usage examples of what's included in the layer, see [`custom-layer/README.md`](custom-layer/README.md).

This layer-specific README includes:
- Complete API reference for helper functions
- Usage examples
- Dependency information
- Troubleshooting guide

## Troubleshooting

- **Import errors**: Ensure your Lambda runtime Python version matches the layer (3.12)
- **Module not found**: Verify the module path matches the directory structure under `python/`
- **Large dependencies**: Some packages may exceed Lambda limits. Consider using Lambda container images for very large dependencies.
- **Duplicate packages**: Run `./install-dependencies.sh` to clean and reinstall packages
- **Cache files in zip**: The build script automatically handles this, but you can manually clean with: `find custom-layer -type d -name "__pycache__" -exec rm -r {} +`

## Verification Checklist

Before deploying, verify:
- [x] `custom-layer/python/` directory exists
- [x] `custom-layer/python/lib/python3.12/site-packages/` contains dependencies
- [x] `custom-layer/python/helpers/` contains custom code
- [x] `__init__.py` present in helpers module
- [x] `requirements.txt` in custom-layer directory
- [x] Build scripts executable (`chmod +x *.sh`)
- [x] `.gitignore` configured
- [x] No duplicate package versions (run install script to clean)
- [x] Zip file size under 50MB
