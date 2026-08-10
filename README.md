# Customer Analytics Platform

An end-to-end Customer Experience Analytics Platform designed to ingest, transform, model, and analyze customer, product, revenue, and support data.

The platform demonstrates a modern analytics engineering architecture using **Airbyte, AWS S3, Lambda, Glue, Athena, Amazon Redshift Serverless, dbt, Airflow, Docker, Cube, and Metabase**, with a natural-language analytics API built on top of the semantic layer.

---

## 🎯 Business Problem

Customer-facing SaaS companies typically have customer data distributed across multiple operational systems:

- Customer/account systems
- Product usage and event tracking
- Billing and invoice systems
- Customer support platforms
- Product engagement data

This makes it difficult for business teams to answer questions such as:

- How many customers do we have?
- Which customers are at risk?
- Which customers generate the most revenue?
- What are the most-used product features?
- How many support tickets are being created?
- Which support categories generate the most tickets?
- Which customers have high revenue but low product engagement?

The goal of this project is to build a centralized analytics platform that transforms raw operational data into trusted customer-level analytical models and makes those insights accessible through BI tools and natural-language queries.


## 🧰 Technology Stack

| Layer                  | Technology                 |
| ---------------------- | -------------------------- |
| Ingestion              | Airbyte                    |
| Object Storage         | AWS S3                     |
| Data Processing        | AWS Lambda                 |
| Data Catalog           | AWS Glue                   |
| Data Lake Query Engine | AWS Athena                 |
| Data Warehouse         | Amazon Redshift Serverless |
| Transformation         | dbt                        |
| Orchestration          | Apache Airflow             |
| Semantic Layer         | Cube                       |
| API                    | FastAPI                    |
| BI                     | Metabase                   |
| Containerization       | Docker                     |
| Language               | Python                     |
| Query Language         | SQL                        |
| Cloud                  | AWS                        |

## 🗂️ Repository Structure
customer-analytics-platform/
│
├── python/
│   └── text_to_sql/
│       ├── app.py
│       ├── cube_client.py
│       ├── query_generator.py
│       └── semantic_schema.py
│
├── model/
│   └── cubes/
│       ├── mart_customer_360.yml
│       ├── mart_customer_health.yml
│       ├── mart_customer_revenue.yml
│       ├── mart_product_engagement.yml
│       └── mart_support_performance.yml
│
├── dbt/
│   └── customer_analytics/
│       ├── models/
│       │   ├── staging/
│       │   ├── intermediate/
│       │   └── marts/
│       │
│       ├── tests/
│       ├── dbt_project.yml
│       └── packages.yml
│
├── airflow/
│   └── dags/
│
├── lambda/
│
├── docker/
│
├── data/
│
├── .gitignore
└── README.md
---

# 🏗️ Architecture

```text
                         ┌─────────────────────────┐
                         │     Source Systems      │
                         │                         │
                         │ Customers / Accounts    │
                         │ Product Events          │
                         │ Invoices / Payments     │
                         │ Support Tickets         │
                         └────────────┬────────────┘
                                      │
                                      ▼
                         ┌─────────────────────────┐
                         │         Airbyte         │
                         │                         │
                         │ Ingestion / Replication │
                         └────────────┬────────────┘
                                      │
                                      ▼
                         ┌─────────────────────────┐
                         │          AWS S3         │
                         │                         │
                         │       Raw Data Lake     │
                         └────────────┬────────────┘
                                      │
                     ┌────────────────┴────────────────┐
                     │                                 │
                     ▼                                 ▼
             ┌───────────────┐                ┌───────────────┐
             │  AWS Lambda   │                │   AWS Glue    │
             │               │                │               │
             │ Processing /   │                │ Data Catalog  │
             │ Automation    │                │ & Discovery   │
             └───────────────┘                └───────┬───────┘
                                                      │
                                                      ▼
                                               ┌──────────────┐
                                               │    Athena    │
                                               │              │
                                               │ Data Lake SQL│
                                               └──────┬───────┘
                                                      │
                                                      ▼
                                      ┌────────────────────────┐
                                      │ Amazon Redshift        │
                                      │ Serverless              │
                                      │                        │
                                      │ Analytical Warehouse  │
                                      └────────────┬───────────┘
                                                   │
                                                   ▼
                                          ┌─────────────────┐
                                          │      dbt        │
                                          │                 │
                                          │ Staging         │
                                          │ Intermediate    │
                                          │ Marts           │
                                          └────────┬────────┘
                                                   │
                                                   ▼
                                      ┌────────────────────────┐
                                      │    Analytics Marts     │
                                      │                        │
                                      │ Customer 360           │
                                      │ Customer Health        │
                                      │ Customer Revenue       │
                                      │ Product Engagement     │
                                      │ Support Performance    │
                                      └────────────┬───────────┘
                                                   │
                                                   ▼
                                      ┌────────────────────────┐
                                      │         Cube           │
                                      │                        │
                                      │    Semantic Layer      │
                                      │                        │
                                      │ Measures / Dimensions  │
                                      │ Business Definitions   │
                                      │ Query Governance       │
                                      └────────────┬───────────┘
                                                   │
                              ┌────────────────────┴──────────────────┐
                              │                                       │
                              ▼                                       ▼
                     ┌─────────────────┐                    ┌─────────────────┐
                     │    Metabase     │                    │     FastAPI     │
                     │                 │                    │                 │
                     │ BI Dashboards   │                    │ Natural Language│
                     │ & Analytics     │                    │ Analytics API   │
                     └─────────────────┘                    └────────┬────────┘
                                                                      │
                                                                      ▼
                                                            Natural Language
                                                            Analytics Queries




## 🧱 Data Engineering Architecture

The platform separates ingestion, storage, transformation, and consumption responsibilities.

1. Ingestion

Airbyte is responsible for extracting data from operational systems and replicating it into the analytical environment.

The ingestion layer handles datasets such as:

Customers
Companies
Product Events
Feature Usage
Invoices
Payments
Support Tickets
Support Agents

The objective is to keep ingestion independent from analytical transformations.

## 🪣 2. AWS S3 Data Lake

S3 acts as the raw landing zone.

A logical structure is maintained by source and entity:

s3://customer-analytics/
│
├── raw/
│   ├── customers/
│   ├── companies/
│   ├── product_events/
│   ├── feature_usage/
│   ├── invoices/
│   ├── payments/
│   └── support_tickets/
│
└── processed/

The raw layer preserves source data while downstream transformations remain reproducible.

## 🔎 3. AWS Glue + Athena

AWS Glue provides metadata and schema discovery for the data lake.

Athena provides SQL access over S3-based datasets.

This enables:

Data discovery
Schema inspection
Raw data validation
Ad-hoc investigation
Data quality checks
Lake-level analytics

Athena acts as the query layer for the data lake while Redshift Serverless serves as the centralized analytical warehouse.

## 🏢 4. Amazon Redshift Serverless

Amazon Redshift Serverless is the analytical data warehouse for the platform.

The warehouse contains curated analytical models produced by dbt.

The design separates:

Raw Data
    ↓
Intermediate Business Logic
    ↓
Analytics Marts

This creates a stable analytical layer for BI and semantic-layer consumers.



