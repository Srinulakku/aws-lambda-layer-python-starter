"""
Utility functions for AWS Lambda Layer
"""


def greet(name: str = "World") -> str:
    """
    A simple greeting function.
    
    Args:
        name: Name to greet (default: "World")
    
    Returns:
        A greeting message
    """
    return f"Hello, {name}! Function from custom_helpers.utils"


def make_http_request(url: str, method: str = "GET"):
    """
    Make an HTTP request using the requests library from the layer.
    
    Args:
        url: The URL to request
        method: HTTP method (GET, POST, etc.)
    
    Returns:
        Response object from requests
    """
    import requests
    return requests.request(method=method, url=url)