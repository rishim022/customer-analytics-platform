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



