# AWS Lambda Layer - Custom Layer

This Lambda layer provides custom helper utilities and third-party dependencies for AWS Lambda functions.

## Contents

### Custom Modules

- **`helpers.utils`** - Utility functions for common Lambda operations

### Third-Party Dependencies

- **`requests`** - HTTP library for making API calls
- **`urllib3`** - HTTP client library (dependency of requests)
- **`certifi`** - SSL certificate bundle
- **`charset_normalizer`** - Character encoding detection
- **`idna`** - Internationalized Domain Names support

## API Reference

### `helpers.utils` Module

#### `greet(name: str = "World") -> str`

A simple greeting function.

**Parameters:**
- `name` (str, optional): Name to greet. Defaults to `"World"`.

**Returns:**
- `str`: A greeting message

**Example:**
```python
from helpers.utils import greet

message = greet("AWS Lambda")
# Returns: "Hello, AWS Lambda! Function from custom_helpers.utils"
```

#### `make_http_request(url: str, method: str = "GET") -> requests.Response`

Make an HTTP request using the requests library.

**Parameters:**
- `url` (str): The URL to request
- `method` (str, optional): HTTP method (GET, POST, PUT, DELETE, etc.). Defaults to `"GET"`.

**Returns:**
- `requests.Response`: Response object from requests library

**Example:**
```python
from helpers.utils import make_http_request

# GET request
response = make_http_request("https://api.example.com/data")
print(response.status_code)
print(response.json())

# POST request
response = make_http_request(
    "https://api.example.com/users",
    method="POST"
)
```

**Error Handling:**
```python
from helpers.utils import make_http_request
import requests

try:
    response = make_http_request("https://api.example.com/data")
    response.raise_for_status()  # Raises exception for bad status codes
except requests.exceptions.RequestException as e:
    print(f"Request failed: {e}")
```

## Usage in Lambda Functions

### Basic Example

```python
from helpers.utils import greet, make_http_request

def lambda_handler(event, context):
    # Use custom helper
    greeting = greet("Lambda User")
    
    # Make HTTP request
    try:
        response = make_http_request("https://httpbin.org/get")
        http_status = response.status_code
    except Exception as e:
        http_status = f"Error: {str(e)}"
    
    return {
        'statusCode': 200,
        'body': {
            'message': greeting,
            'http_status': http_status
        }
    }
```

### Using Third-Party Libraries Directly

```python
import requests
from helpers.utils import greet

def lambda_handler(event, context):
    # Use requests library directly
    response = requests.get("https://api.example.com/data")
    
    # Use custom helper
    message = greet("API Consumer")
    
    return {
        'statusCode': 200,
        'body': {
            'message': message,
            'data': response.json()
        }
    }
```

## Import Paths

When this layer is attached to your Lambda function, you can import:

```python
# Custom helpers
from helpers.utils import greet, make_http_request

# Third-party packages (installed in site-packages)
import requests
import urllib3
```

## Version & Compatibility

- **Python Runtime:** 3.12
- **Layer Structure:** `python/lib/python3.12/site-packages/`
- **Compatible Runtimes:** `python3.12`

⚠️ **Important:** Ensure your Lambda function uses Python 3.12 runtime to match this layer.

## Dependencies

See `requirements.txt` for the complete list of dependencies and versions.

Current dependencies:
- `requests` - HTTP library
- `urllib3` - HTTP client (dependency)
- `certifi` - SSL certificates (dependency)
- `charset_normalizer` - Encoding detection (dependency)
- `idna` - Domain name support (dependency)

## Layer Size

- **Zipped:** Check with `du -h custom-layer.zip`
- **Unzipped:** Check with `du -sh custom-layer/`
- **AWS Limits:** 50MB (zipped) / 250MB (unzipped)

## Troubleshooting

### Import Errors

If you get `ModuleNotFoundError`:
1. Verify the layer is attached to your Lambda function
2. Check that your Lambda runtime matches the layer version (Python 3.12)
3. Ensure imports use correct paths (e.g., `from helpers.utils import ...`)

### Version Conflicts

If you have version conflicts with other layers:
- This layer includes: `requests`, `urllib3`, `certifi`, `charset_normalizer`, `idna`
- Lambda uses the first matching package found across layers (order matters)

### HTTP Request Issues

If HTTP requests fail:
- Check Lambda execution role has VPC/network access if needed
- Verify timeout settings (Lambda has execution time limits)
- Consider using `requests` with timeout: `requests.get(url, timeout=5)`

## License

See individual package licenses in `python/lib/python3.12/site-packages/*/LICENSE*`

