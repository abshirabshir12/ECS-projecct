URL Shortener on AWS ECS

A production-ready URL shortening service deployed on AWS using ECS Fargate. The project focuses on secure, reliable deployments, sensible cost control, and simple operations while following modern cloud best practices.

Overview

This repository contains a scalable URL shortener built with containerised services on AWS ECS. It supports zero-downtime deployments, runs fully in private networking, and avoids unnecessary infrastructure costs by relying on managed AWS services and VPC endpoints.

The goal of this project is to demonstrate how a real-world service can be deployed in a production-style environment without over-engineering or excessive monthly spend.

Features

Zero-downtime deployments using blue/green strategy

ECS Fargate with serverless containers

Private networking with no public ECS tasks

AWS WAF protection with rate limiting and managed rules

Cost-conscious infrastructure choices

Secure IAM configuration using least privilege

Automated CI/CD using GitHub Actions

Infrastructure managed with Terraform

Technology Stack

Application: Python (FastAPI)

Compute: AWS ECS Fargate

Load Balancing: Application Load Balancer

Database: DynamoDB (on-demand)

Security: AWS WAF, IAM, private subnets

CI/CD: GitHub Actions + CodeDeploy

Infrastructure as Code: Terraform

Container Registry: Amazon ECR

Logging & Monitoring: CloudWatch

How It Works

Users submit a long URL via an API endpoint

The service generates a short code and stores it in DynamoDB

Requests to the short URL are redirected to the original URL

All traffic passes through WAF and an ALB before reaching ECS tasks

Deployments are handled with a blue/green strategy to avoid downtime

Security Considerations

ECS tasks run in private subnets with no public IPs

No outbound internet access for containers

AWS WAF provides protection against common web attacks

IAM roles are scoped to the minimum required permissions

Containers run as non-root users

CI/CD uses OIDC instead of long-lived AWS credentials

CI/CD Pipeline

The deployment pipeline is fully automated:

Code pushed to main branch

Tests and security scans run

Container image built and pushed to ECR

New ECS task definition created

CodeDeploy performs blue/green deployment

Health checks verified before traffic shift

Automatic rollback on failure

Deployment
Prerequisites

AWS account

Terraform 1.5+

AWS CLI

Docker

GitHub account

Steps

Deploy the Terraform backend

Deploy infrastructure using Terraform

Build and push the initial container image

Verify health and API endpoints

Push code changes to trigger automated deployments

Cost Overview

Typical monthly cost is under $100, depending on usage.

Main contributors:

Application Load Balancer

ECS Fargate tasks

VPC endpoints

AWS WAF

DynamoDB on-demand usage

CloudWatch logs

The setup avoids NAT Gateways to reduce fixed monthly costs.

Known Limitations

Designed for low to moderate traffic

Single-region deployment

No custom domain or HTTPS by default

Manual scaling configuration

Possible Improvements

Add HTTPS with ACM and Route 53

Enable auto-scaling for ECS services

Configure CloudWatch alarms and notifications

Add URL expiration with DynamoDB TTL

Improve observability with distributed tracing

Multi-region failover setup