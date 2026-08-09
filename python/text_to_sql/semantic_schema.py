from pathlib import Path
from typing import Any

import yaml


PROJECT_ROOT = Path(__file__).resolve().parents[2]
CUBES_DIR = PROJECT_ROOT / "model" / "cubes"


def load_cube_file(file_path: Path) -> dict[str, Any]:
    """Load a single Cube YAML file."""

    with file_path.open("r", encoding="utf-8") as file:
        data = yaml.safe_load(file)

    return data or {}


def load_semantic_schema() -> dict[str, Any]:
    """
    Load all Cube definitions from model/cubes.

    Returns:
        Dictionary keyed by cube name.
    """

    schema: dict[str, Any] = {}

    if not CUBES_DIR.exists():
        raise FileNotFoundError(
            f"Cube directory not found: {CUBES_DIR}"
        )

    for file_path in sorted(CUBES_DIR.glob("*.yml")):
        data = load_cube_file(file_path)

        for cube in data.get("cubes", []):
            cube_name = cube.get("name")

            if cube_name:
                schema[cube_name] = cube

    return schema


def get_cube(cube_name: str) -> dict[str, Any]:
    """Return a specific cube definition."""

    schema = load_semantic_schema()

    if cube_name not in schema:
        raise ValueError(
            f"Cube '{cube_name}' not found. "
            f"Available cubes: {list(schema.keys())}"
        )

    return schema[cube_name]


def get_cube_names() -> list[str]:
    """Return all available cube names."""

    return list(load_semantic_schema().keys())


def get_dimensions(cube_name: str) -> list[str]:
    """Return dimension names for a cube."""

    cube = get_cube(cube_name)

    return [
        dimension["name"]
        for dimension in cube.get("dimensions", [])
        if "name" in dimension
    ]


def get_measures(cube_name: str) -> list[str]:
    """Return measure names for a cube."""

    cube = get_cube(cube_name)

    return [
        measure["name"]
        for measure in cube.get("measures", [])
        if "name" in measure
    ]


def print_schema_summary() -> None:
    """Print a human-readable summary of the semantic layer."""

    schema = load_semantic_schema()

    print(f"Loaded {len(schema)} cubes:\n")

    for cube_name, cube in schema.items():
        dimensions = [
            dimension["name"]
            for dimension in cube.get("dimensions", [])
        ]

        measures = [
            measure["name"]
            for measure in cube.get("measures", [])
        ]

        print(f"Cube: {cube_name}")
        print(f"  Table: {cube.get('sql_table')}")
        print(f"  Dimensions: {len(dimensions)}")
        print(f"  Measures: {len(measures)}")
        print()


if __name__ == "__main__":
    print_schema_summary()