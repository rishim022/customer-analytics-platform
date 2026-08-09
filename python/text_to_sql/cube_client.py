import os
from typing import Any

import jwt
import requests
from dotenv import load_dotenv


load_dotenv()


class CubeClient:
    """Client for communicating with the Cube API."""

    def __init__(
        self,
        api_url: str | None = None,
        api_secret: str | None = None,
    ) -> None:

        self.api_url = (
            api_url
            or os.getenv(
                "CUBE_API_URL",
                "http://localhost:4000",
            )
        ).rstrip("/")

        self.api_secret = (
            api_secret
            or os.getenv("CUBEJS_API_SECRET")
        )

        if not self.api_secret:
            raise ValueError(
                "CUBEJS_API_SECRET is not configured."
            )

    def _create_token(self) -> str:
        """Create a JWT token for Cube."""

        payload = {
            "iat": 0,
        }

        return jwt.encode(
            payload,
            self.api_secret,
            algorithm="HS256",
        )

    def execute_query(
        self,
        query: dict[str, Any],
    ) -> dict[str, Any]:
        """Execute a Cube query."""

        token = self._create_token()

        response = requests.get(
            f"{self.api_url}/cubejs-api/v1/load",
            params={
                "query": __import__("json").dumps(query)
            },
            headers={
                "Authorization": f"Bearer {token}",
            },
            timeout=60,
        )

        response.raise_for_status()

        return response.json()


if __name__ == "__main__":
    client = CubeClient()

    query = {
        "measures": [
            "mart_customer_360.count"
        ]
    }

    result = client.execute_query(query)

    print(result)