# Customer Experience Analytics Platform

## 1. Business Problem

SupportIQ is a fictional B2B SaaS company that provides customer support
software to enterprise customers.

As the company grows, customer, support, billing, and product usage data
is distributed across multiple operational systems.

Business stakeholders currently rely on manual exports and spreadsheets
to understand customer health, support performance, product adoption,
and revenue.

The company needs a centralized analytics platform that provides a
trusted and scalable source of truth for business reporting.

## 2. Business Objectives

The platform will provide a unified Customer 360 view and enable
stakeholders to answer questions such as:

- Which customers are at risk of churn?
- Which customers generate the highest support volume?
- Which support teams are meeting their SLAs?
- Which agents have the best performance?
- Which customers have low product adoption?
- What is the relationship between product usage and support activity?
- Which customers generate the highest revenue?

## 3. Data Domains

The platform will initially cover four core business domains:

### CRM

- Companies
- Customers
- Contacts

### Customer Support

- Tickets
- Ticket Events
- Agents
- Customer Satisfaction

### Billing

- Subscriptions
- Plans
- Invoices
- Payments

### Product Usage

- Sessions
- Feature Usage
- Product Events

## 4. Key Business Metrics

### Customer

- Active Customers
- Customer Lifetime Value
- Customer Health Score
- Churn Risk

### Support

- Ticket Volume
- Average Resolution Time
- First Response Time
- SLA Compliance
- Ticket Backlog
- Reopen Rate
- CSAT

### Revenue

- Monthly Recurring Revenue
- Annual Recurring Revenue
- Expansion Revenue
- Customer Revenue

### Product

- Daily Active Users
- Feature Adoption
- Sessions
- Product Engagement

## 5. Proposed Technology Stack

| Layer                 | Technology                     |
| --------------------- | ------------------------------ |
| Source Systems        | REST APIs / SaaS-style sources |
| Ingestion             | Airbyte                        |
| Data Lake             | Amazon S3                      |
| Serverless Processing | AWS Lambda                     |
| Data Catalog          | AWS Glue                       |
| Data Exploration      | Amazon Athena                  |
| Data Warehouse        | Snowflake                      |
| Transformation        | dbt                            |
| Orchestration         | Apache Airflow                 |
| BI                    | Metabase                       |
| Containerization      | Docker                         |
| Version Control       | GitHub                         |

## 6. Expected Outcome

The final platform will provide an automated analytics pipeline from
operational source systems through ingestion, storage, transformation,
data modeling, orchestration, and BI reporting.

The resulting platform will provide trusted, reusable datasets for
Customer 360, customer support, revenue, and product analytics.
