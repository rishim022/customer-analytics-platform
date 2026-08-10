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

🔎 3. AWS Glue + Athena

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

🏢 4. Amazon Redshift Serverless

Amazon Redshift Serverless is the analytical data warehouse for the platform.

The warehouse contains curated analytical models produced by dbt.

The design separates:

Raw Data
    ↓
Intermediate Business Logic
    ↓
Analytics Marts

This creates a stable analytical layer for BI and semantic-layer consumers.





---

# 🔨 dbt Transformation Approach

dbt is responsible for transforming warehouse data into trusted analytical models using a layered architecture:

```text
Source Data
    │
    ▼
Staging
    │
    ▼
Intermediate
    │
    ▼
Analytics Marts
```

### Staging

The staging layer stays close to source data and handles:

- Naming standardization
- Type normalization
- Basic cleaning
- Source-level transformations

### Intermediate

The intermediate layer contains reusable domain logic and combines related source entities.

Examples include:

```text
int_customers
int_customer_usage
int_customer_financials
int_customer_support
```

This prevents complex business logic from being duplicated across multiple downstream models.

### Analytics Marts

The final dbt layer exposes business-ready models:

- `mart_customer_360`
- `mart_customer_health`
- `mart_customer_revenue`
- `mart_product_engagement`
- `mart_support_performance`

These marts are designed around business questions rather than source-system structure.

---

# 📊 Analytics Marts

## Customer 360

`mart_customer_360`

A consolidated customer-level model combining customer attributes, product engagement, support activity, and financial information.

## Customer Health

`mart_customer_health`

Provides customer-level health information including:

- Customer status
- Product usage
- Product events
- Sessions
- Support tickets
- Open tickets
- High-priority tickets
- Response and resolution metrics
- Customer health classification

Customer health is calculated using deterministic business rules.

```text
IF open tickets >= 3
OR high-priority tickets >= 2
    → at_risk

ELSE IF sessions = 0
    → low_engagement

ELSE IF product events > 0
AND open tickets = 0
    → healthy

ELSE
    → monitor
```

## Customer Revenue

`mart_customer_revenue`

Provides customer-level:

- Total invoiced amount
- Total paid invoice amount
- Customer and company identifiers

## Product Engagement

`mart_product_engagement`

Provides feature-level:

- Feature usage
- First usage
- Latest usage
- Event activity
- Customer-feature engagement

## Support Performance

`mart_support_performance`

Provides ticket-level:

- Ticket volume
- Customer
- Agent
- Category
- Channel
- Priority
- Status
- First response
- Resolution

---

# 🧪 Data Quality & Validation

The analytical layer is validated across multiple stages.

Validation includes:

- Schema inspection
- Row-count validation
- Duplicate detection
- Null checks
- Aggregation validation
- Business-rule validation
- Warehouse-to-semantic-layer reconciliation
- API-to-Cube validation

A key design principle is:

```text
Warehouse Result
       =
Cube Result
       =
API Result
       =
BI Result
```

This helps ensure that the same business metric produces a consistent result regardless of the consuming interface.

---

# 🧠 Cube Semantic Layer

Cube provides a governed semantic layer between Redshift and downstream consumers.

Instead of allowing each dashboard or application to implement its own SQL and metric definitions, Cube centralizes:

- Measures
- Dimensions
- Business definitions
- Filters
- Ordering
- Metric metadata
- Business synonyms
- Query structure

Example governed metrics include:

```text
mart_customer_health.count
mart_customer_health.customer_health_status

mart_customer_revenue.total_invoiced_amount
mart_customer_revenue.total_paid_invoice_amount

mart_product_engagement.total_usage_count
mart_product_engagement.feature_name

mart_support_performance.count
mart_support_performance.category
```

This allows Metabase and FastAPI to consume the same analytical definitions.

---

# 🤖 Natural-Language Analytics API

The FastAPI application provides a natural-language interface on top of Cube.

The request flow is:

```text
Business Question
       │
       ▼
    FastAPI
       │
       ▼
Query Generator
       │
       ▼
Governed Cube Query
       │
       ▼
      Cube
       │
       ▼
   Redshift
       │
       ▼
 Analytical Result
```

For example:

```text
How many customers are at risk?
```

is converted into a governed Cube query:

```json
{
  "measures": [
    "mart_customer_health.count"
  ],
  "filters": [
    {
      "member": "mart_customer_health.customer_health_status",
      "operator": "equals",
      "values": ["at_risk"]
    }
  ]
}
```

The API does not expose arbitrary SQL generation directly against the warehouse. Instead, it maps supported business questions to governed semantic-layer queries.

---

# 💬 Example Natural-Language Queries

### Customer Health

```text
How many customers are at risk?
```

### Revenue

```text
Which customers have the highest revenue?
```

The query planner generates a ranked query using:

```text
total_invoiced_amount
ORDER BY DESC
LIMIT 10
```

### Product Engagement

```text
What are the most used features?
```

### Support

```text
How many tickets are there by category?
```

---

# 📈 Metabase Analytics

Metabase provides the self-service BI layer on top of the analytical platform.

The dashboard layer covers the major customer-experience domains.

## Customer Overview

Key analysis includes:

- Total customers
- Customer distribution
- Customer status
- Customer health
- Product engagement
- Revenue indicators
- Support activity

## Customer Health

Key analysis includes:

- Customers at risk
- Healthy customers
- Low-engagement customers
- Customers requiring monitoring
- Open support tickets
- High-priority tickets
- Health distribution

## Customer Revenue

Key analysis includes:

- Total invoiced amount
- Total paid amount
- Highest-value customers
- Revenue ranking
- Payment performance

## Product Engagement

Key analysis includes:

- Most-used features
- Feature usage volume
- Customer-feature engagement
- Feature adoption
- First and latest usage

## Support Performance

Key analysis includes:

- Ticket volume
- Tickets by category
- Tickets by channel
- Tickets by priority
- Tickets by agent
- Open vs resolved tickets
- Response and resolution metrics

---

# 🔄 Airflow Orchestration

Apache Airflow orchestrates the analytical workflow and establishes dependencies between ingestion, transformation, and downstream consumption.

A typical workflow is:

```text
Ingestion
    │
    ▼
Raw Data Available
    │
    ▼
Data Validation
    │
    ▼
dbt Staging
    │
    ▼
dbt Intermediate
    │
    ▼
dbt Marts
    │
    ▼
Semantic Layer Refresh
    │
    ▼
BI / API Consumers
```

---

# 🐳 Docker

Docker provides reproducible development and service environments.

The containerized setup makes it possible to run and validate the analytics API and supporting services consistently across environments.

---

# 🔐 Security & Configuration

Credentials and environment-specific configuration are kept outside source control.

Sensitive configuration such as:

```text
.env
AWS credentials
Database credentials
API secrets
```

is excluded through `.gitignore`.

No production credentials or secrets should be committed to the repository.

---

# 📐 Design Principles

### Separation of Concerns

Ingestion, storage, transformation, semantic modeling, and consumption are separated.

### Reusable Business Logic

Business logic is implemented in dbt models rather than repeatedly inside dashboards.

### Trusted Metrics

Cube provides governed definitions for analytical metrics.

### Layered Modeling

```text
Source
  ↓
Staging
  ↓
Intermediate
  ↓
Marts
  ↓
Semantic Layer
  ↓
BI / API
```

### Self-Service Analytics

Business users can consume curated metrics through Metabase without needing to understand the underlying warehouse schema.

### Consistent Analytical Definitions

The same semantic definitions can be consumed by both Metabase and FastAPI.

---

# 🎯 Key Outcomes

The platform provides a centralized analytical foundation for customer experience analytics.

It enables teams to:

- Centralize customer analytics
- Standardize business definitions
- Analyze customer health
- Identify high-value customers
- Understand product engagement
- Monitor support performance
- Build self-service dashboards
- Query analytics using natural language
- Reuse governed metrics across multiple consumers

---

# 🧩 Skills Demonstrated

### Data Engineering

- AWS S3
- AWS Lambda
- AWS Glue
- AWS Athena
- Airbyte
- Amazon Redshift Serverless

### Analytics Engineering

- dbt
- SQL
- Business modeling
- Staging / intermediate / mart architecture
- Business logic centralization
- Data quality validation

### Analytics & BI

- Cube
- Metabase
- Semantic modeling
- Metric governance
- Customer analytics
- Product analytics
- Revenue analytics
- Support analytics

### Application Engineering

- Python
- FastAPI
- REST APIs
- Natural-language query planning
- Docker

### Orchestration

- Apache Airflow
- Dependency-driven analytical workflows

---

# 🔮 Future Enhancements

Potential extensions include:

- LLM-powered natural-language query generation
- Automated query validation
- More advanced customer health scoring
- Customer lifetime value modeling
- Cohort analysis
- Retention analysis
- Churn prediction
- Automated anomaly detection
- Incremental dbt models
- Expanded data-quality monitoring
- CI/CD for dbt and semantic models
- Automated Airflow deployment

---

# 👨‍💻 Project

**Customer Analytics Platform**

An end-to-end analytics engineering project demonstrating how modern cloud data infrastructure, analytics engineering, semantic modeling, BI, and application interfaces can work together to create a governed customer analytics platform.
