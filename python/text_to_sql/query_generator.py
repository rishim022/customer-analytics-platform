from typing import Any

from .semantic_schema import load_semantic_schema


class QueryGenerator:
    """
    Converts simple natural-language questions into Cube queries.

    This is intentionally deterministic for the first version.
    An LLM can be added later for more flexible natural-language
    interpretation.
    """

    def __init__(self) -> None:
        self.schema = load_semantic_schema()

    def generate(self, question: str) -> dict[str, Any]:
        """
        Generate a Cube query from a natural-language question.
        """

        normalized = question.lower().strip()

        if not normalized:
            raise ValueError("Question cannot be empty.")

        # --------------------------------------------------
        # Customer count
        # --------------------------------------------------

        if (
            "how many customers" in normalized
            or "number of customers" in normalized
            or "customer count" in normalized
        ):
            return {
                "measures": [
                    "mart_customer_360.count"
                ]
            }

        # --------------------------------------------------
        # Customer health
        # --------------------------------------------------

        if (
            "at risk" in normalized
            or "customer health" in normalized
            or "unhealthy customers" in normalized
        ):
            return {
                "measures": [
                    "mart_customer_health.count"
                ],
                "dimensions": [
                    "mart_customer_health.customer_health_status"
                ]
            }

        # --------------------------------------------------
        # Revenue
        # --------------------------------------------------

        if (
            "revenue" in normalized
            or "invoiced amount" in normalized
            or "paid amount" in normalized
        ):
            query: dict[str, Any] = {
                "measures": [
                    "mart_customer_revenue.total_invoiced_amount",
                    "mart_customer_revenue.total_paid_invoice_amount",
                ]
            }

            if "customer" in normalized:
                query["dimensions"] = [
                    "mart_customer_revenue.customer_id"
                ]

            return query

        # --------------------------------------------------
        # Product engagement
        # --------------------------------------------------

        if (
            "feature" in normalized
            or "product usage" in normalized
            or "product engagement" in normalized
            or "most used" in normalized
        ):
            return {
                "measures": [
                    "mart_product_engagement.total_usage_count"
                ],
                "dimensions": [
                    "mart_product_engagement.feature_name"
                ],
                "order": {
                    "mart_product_engagement.total_usage_count": "desc"
                },
                "limit": 10,
            }

        # --------------------------------------------------
        # Support tickets
        # --------------------------------------------------

        if (
            "support ticket" in normalized
            or "support tickets" in normalized
            or "tickets" in normalized
            or "support cases" in normalized
        ):
            query = {
                "measures": [
                    "mart_support_performance.count"
                ]
            }

            if "agent" in normalized:
                query["dimensions"] = [
                    "mart_support_performance.agent_id"
                ]

            elif "category" in normalized:
                query["dimensions"] = [
                    "mart_support_performance.category"
                ]

            elif "channel" in normalized:
                query["dimensions"] = [
                    "mart_support_performance.channel"
                ]

            return query

        raise ValueError(
            f"I don't know how to answer this question yet: "
            f"'{question}'"
        )


def generate_cube_query(question: str) -> dict[str, Any]:
    """Convenience function."""

    generator = QueryGenerator()

    return generator.generate(question)


if __name__ == "__main__":
    questions = [
        "How many customers do we have?",
        "How many customers are at risk?",
        "What is the revenue?",
        "What are the most used features?",
        "How many support tickets are there?",
    ]

    generator = QueryGenerator()

    for question in questions:
        print("=" * 60)
        print(f"Question: {question}")

        try:
            query = generator.generate(question)
            print("Cube query:")
            print(query)
        except ValueError as error:
            print(f"Error: {error}")