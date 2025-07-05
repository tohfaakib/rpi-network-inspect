from mitmproxy import http
import regex as re
import requests
import json

def request(flow: http.HTTPFlow):
    url = flow.request.pretty_url
    if "ads" in url or "tracking" in url:
        flow.response = http.Response.make(
            403,
            b"Blocked by Raspberry Pi Inspector",
            {"Content-Type": "text/plain"}
        )
    elif re.search(r"/api/v1/.*", flow.request.path):
        resp = requests.get(f"https://example.com/metadata?path={flow.request.path}")
        data = resp.json()
        flow.response = http.Response.make(
            200,
            json.dumps(data).encode(),
            {"Content-Type": "application/json"}
        )
