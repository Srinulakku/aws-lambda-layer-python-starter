"""
Example Lambda Function using the Custom Layer

This demonstrates how to use the custom helpers and dependencies
from the Lambda layer in your Lambda function.
"""

# Standard library imports
import json

# Local imports from Lambda layer
from helpers.utils import greet, make_http_request

# Use third-party library from layer


def lambda_handler(event, context):
    """
    Example Lambda handler that uses the custom layer.
    
    AWS Lambda will automatically invoke this function when your Lambda is triggered.
    Configure the handler as: example-lambda-function.lambda_handler
    
    The layer provides:
    1. Custom helpers module (helpers.utils)
    2. Third-party packages (requests, etc.)
    
    Args:
        event: Event data passed to the function
        context: Runtime information about the Lambda execution
    
    Returns:
        Response dictionary with statusCode and body
    """
    # Use custom helper function
    greeting = greet("AWS Lambda")
    
    try:
        # Example: Make an HTTP request
        response = make_http_request("https://httpbin.org/get")
        http_status = response.status_code
    except Exception as e:
        http_status = f"Error: {str(e)}"
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': greeting,
            'http_status': http_status,
            'layer_info': 'Custom Lambda Layer is working!'
        })
    }


# Optional: Local testing block (NOT needed for AWS Lambda deployment)
# AWS Lambda automatically calls lambda_handler() - you don't need this block
# This is only useful for testing locally before deployment
if __name__ == "__main__":
    test_event = {}
    test_context = {}
    result = lambda_handler(test_event, test_context)
    print(json.dumps(result, indent=2))

