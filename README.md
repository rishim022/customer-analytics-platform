# Customer Analytics Platform

An end-to-end Customer Experience Analytics Platform designed to ingest, transform, model, and analyze customer, product, revenue, and support data.

The platform demonstrates a modern analytics engineering architecture using **Airbyte, AWS S3, Lambda, Glue, Athena, Snowflake, dbt, Airflow, Docker, Cube, and Metabase**, with a natural-language analytics API on top of the semantic layer.

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

---

# 🏗️ Architecture

```text
                    ┌──────────────────────┐
                    │   Source Systems     │
                    │                      │
                    │ Customers            │
                    │ Product Events       │
                    │ Invoices / Payments  │
                    │ Support Tickets      │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │       Airbyte        │
                    │  Data Ingestion / CDC │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │        AWS S3        │
                    │     Raw Data Lake    │
                    └──────────┬───────────┘
                               │
                    ┌──────────┴───────────┐
                    │                      │
                    ▼                      ▼
             ┌──────────────┐      ┌──────────────┐
             │ AWS Lambda   │      │ AWS Glue     │
             │ Processing   │      │ Catalog      │
             └──────────────┘      └──────┬───────┘
                                          │
                                          ▼
                                   ┌──────────────┐
                                   │    Athena    │
                                   │ Data Lake SQL│
                                   └──────┬───────┘
                                          │
                                          ▼
                                  ┌────────────────┐
                                  │   Snowflake    │
                                  │ Data Warehouse │
                                  └───────┬────────┘
                                          │
                                          ▼
                                  ┌────────────────┐
                                  │      dbt       │
                                  │ Transformations│
                                  │ + Data Models  │
                                  └───────┬────────┘
                                          │
                                          ▼
                              ┌─────────────────────┐
                              │ Analytics Marts     │
                              │                     │
                              │ Customer 360        │
                              │ Customer Health     │
                              │ Customer Revenue    │
                              │ Product Engagement  │
                              │ Support Performance │
                              └──────────┬──────────┘
                                         │
                         ┌───────────────┴───────────────┐
                         │                               │
                         ▼                               ▼
                 ┌──────────────┐                ┌──────────────┐
                 │     Cube     │                │   Metabase   │
                 │ Semantic     │                │ BI / Dashboards│
                 │ Layer       │                └──────────────┘
                 └──────┬───────┘
                        │
                        ▼
                ┌─────────────────┐
                │ Text-to-SQL API │
                │    FastAPI      │
                └─────────────────┘
