from typing import Any

from .semantic_schema import load_semantic_schema


class QueryGenerator:
    """
    Deterministic natural-language-to-Cube query planner.
    """

    def __init__(self) -> None:
        self.schema = load_semantic_schema()

    def generate(self, question: str) -> dict[str, Any]:
        normalized = question.lower().strip()

        if not normalized:
            raise ValueError("Question cannot be empty.")

        # Customer count
        if (
            "how many customers" in normalized
            or "number of customers" in normalized
            or "customer count" in normalized
        ):
            if "at risk" in normalized or "at-risk" in normalized:
                return {
                    "measures": ["mart_customer_health.count"],
                    "filters": [
                        {
                            "member": "mart_customer_health.customer_health_status",
                            "operator": "equals",
                            "values": ["at_risk"],
                        }
                    ],
                }

            return {
                "measures": ["mart_customer_360.count"]
            }

        # Numeric health score does not exist in the semantic model.
        if (
            "health score" in normalized
            or "health scores" in normalized
        ):
            raise ValueError(
                "The semantic model contains customer health categories "
                "(at_risk, low_engagement, healthy, monitor), but does "
                "not contain a numeric customer health score."
            )

        # Customer health status
        if (
            "customer health" in normalized
            or "account health" in normalized
            or "health status" in normalized
        ):
            return {
                "measures": ["mart_customer_health.count"],
                "dimensions": [
                    "mart_customer_health.customer_health_status"
                ],
            }

        # Explicit at-risk query
        if "at risk" in normalized or "at-risk" in normalized:
            return {
                "measures": ["mart_customer_health.count"],
                "filters": [
                    {
                        "member": "mart_customer_health.customer_health_status",
                        "operator": "equals",
                        "values": ["at_risk"],
                    }
                ],
            }

        # Revenue
        if (
            "revenue" in normalized
            or "invoiced amount" in normalized
            or "paid amount" in normalized
            or "billing" in normalized
        ):
            if "paid" in normalized or "payment" in normalized:
                measure = (
                    "mart_customer_revenue.total_paid_invoice_amount"
                )
            else:
                measure = (
                    "mart_customer_revenue.total_invoiced_amount"
                )

            query: dict[str, Any] = {
                "measures": [measure]
            }

            if "customer" in normalized:
                query["dimensions"] = [
                    "mart_customer_revenue.customer_id"
                ]

                if (
                    "highest" in normalized
                    or "top" in normalized
                    or "largest" in normalized
                    or "most" in normalized
                ):
                    query["order"] = {measure: "desc"}
                    query["limit"] = 10

                elif (
                    "lowest" in normalized
                    or "smallest" in normalized
                    or "least" in normalized
                ):
                    query["order"] = {measure: "asc"}
                    query["limit"] = 10

            return query

        # Product engagement
        if (
            "feature" in normalized
            or "product usage" in normalized
            or "product engagement" in normalized
            or "most used" in normalized
        ):
            query = {
                "measures": [
                    "mart_product_engagement.total_usage_count"
                ],
                "dimensions": [
                    "mart_product_engagement.feature_name"
                ],
            }

            if (
                "most used" in normalized
                or "highest" in normalized
                or "top" in normalized
            ):
                query["order"] = {
                    "mart_product_engagement.total_usage_count": "desc"
                }
                query["limit"] = 10

            elif (
                "least used" in normalized
                or "lowest" in normalized
            ):
                query["order"] = {
                    "mart_product_engagement.total_usage_count": "asc"
                }
                query["limit"] = 10

            return query

        # Support tickets
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
            elif "priority" in normalized:
                query["dimensions"] = [
                    "mart_support_performance.priority"
                ]
            elif "status" in normalized:
                query["dimensions"] = [
                    "mart_support_performance.status"
                ]
            elif "customer" in normalized:
                query["dimensions"] = [
                    "mart_support_performance.customer_id"
                ]

            return query

        raise ValueError(
            f"I don't know how to answer this question yet: "
            f"'{question}'"
        )


def generate_cube_query(question: str) -> dict[str, Any]:
    """Convenience function."""
    return QueryGenerator().generate(question)


if __name__ == "__main__":
    questions = [
        "How many customers do we have?",
        "How many customers are at risk?",
        "Show customer health status",
        "What is the revenue?",
        "Which customers have the highest revenue?",
        "Which customers have the lowest paid revenue?",
        "What are the most used features?",
        "What are the least used features?",
        "How many support tickets are there?",
        "How many tickets are there by category?",
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
