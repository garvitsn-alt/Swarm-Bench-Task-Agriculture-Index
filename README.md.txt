# Agriculture Index - Multi-Agent LLM Benchmark Task

A SwarmBench benchmark task designed to evaluate the reasoning, coordination, extraction, and synthesis capabilities of Large Language Models (LLMs) in multi-agent settings.

## Overview

This benchmark simulates a complex agricultural risk assessment workflow where agents must analyze multiple domain-specific reports and synthesize them into structured quantitative outputs.

The task is intentionally designed to create a performance gap between:
- Single-agent execution
- Multi-agent collaborative execution

## Objective

Agents must:

1. Analyze multiple agricultural and environmental PDF reports
2. Extract domain-specific indicators
3. Compute structured agricultural risk metrics
4. Generate a final synthesized JSON output

## Domains Covered

- Market systems
- Price volatility
- Pesticide exposure
- Crop disease risks
- Worker health impacts

## Output Metrics

The benchmark evaluates:
- market_system_score
- price_volatility_score
- pesticide_risk_score
- crop_disease_score
- worker_health_score

## Multi-Agent Design

The task follows a fan-out → synthesize architecture.

### Specialist Agents
Each specialist analyzes a subset of reports independently.

### Reducer Agent
The reducer synthesizes intermediate outputs into final benchmark metrics.

This design tests:
- Distributed reasoning
- Information reconciliation
- Cross-document synthesis
- Context management
- Coordination efficiency

## Benchmark Goal

The benchmark is designed so that:

- Single-agent systems struggle with:
  - context overload
  - missed evidence
  - inconsistent synthesis

- Multi-agent systems perform better through:
  - parallel extraction
  - domain specialization
  - coordinated synthesis

## Repository Structure

```text
.
├── instruction.md
├── decomposition.yaml
├── task.toml
├── environment/
├── tests/
├── solution/
└── execution_logs/