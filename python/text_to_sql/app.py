from typing import Any

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from .cube_client import CubeClient
from .query_generator import QueryGenerator


app = FastAPI(
    title="Customer Analytics Text-to-SQL API",
    description=(
        "Natural language interface for the "
        "Customer Analytics Cube semantic layer."
    ),
    version="1.0.0",
)


class QueryRequest(BaseModel):
    question: str


class QueryResponse(BaseModel):
    question: str
    cube_query: dict[str, Any]
    result: dict[str, Any]


query_generator = QueryGenerator()
cube_client = CubeClient()


@app.get("/")
def root() -> dict[str, str]:
    return {
        "status": "ok",
        "service": "customer-analytics-text-to-sql",
    }


@app.get("/health")
def health() -> dict[str, str]:
    return {
        "status": "healthy"
    }


@app.post("/query", response_model=QueryResponse)
def query(request: QueryRequest) -> QueryResponse:

    try:
        cube_query = query_generator.generate(
            request.question
        )

        result = cube_client.execute_query(
            cube_query
        )

        return QueryResponse(
            question=request.question,
            cube_query=cube_query,
            result=result,
        )

    except ValueError as error:
        raise HTTPException(
            status_code=400,
            detail=str(error),
        ) from error

    except Exception as error:
        raise HTTPException(
            status_code=500,
            detail=str(error),
        ) from error