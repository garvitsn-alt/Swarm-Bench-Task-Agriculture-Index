#!/bin/bash
set -e

mkdir -p /logs/agent

python3 - <<'PY'
from pathlib import Path
import json
import subprocess

INPUT_DIR = Path("/environment/input_artifacts")
OUTPUT_PATH = Path("/logs/agent/output.json")

pdf_files = sorted([
    path.name
    for path in INPUT_DIR.iterdir()
    if path.is_file() and path.suffix.lower() == ".pdf"
])

def extract_text(path: Path) -> str:
    try:
        result = subprocess.run(
            ["pdftotext", str(path), "-"],
            capture_output=True,
            text=True,
            errors="ignore",
            timeout=60
        )
        return result.stdout.lower()
    except Exception:
        try:
            return path.read_bytes().decode("latin-1", errors="ignore").lower()
        except Exception:
            return ""

texts = {}
for file_name in pdf_files:
    texts[file_name] = extract_text(INPUT_DIR / file_name)

def avg_round(values):
    if not values:
        return 0
    return round(sum(values) / len(values))

def cap(value, limit):
    return min(value, limit)



# ORACLE DERIVATION NOTE:
# Skills.pdf was reviewed as a market-systems / agricultural skills document.
# rules_governance_flag is set to 0 because the document supports vendor recruitment,
# liability/compliance awareness, conflict handling, emergency planning,
# performance tracking, and community support, but does not provide a clear
# enforceable governance or formal rule-setting framework.

market_records = [
    {
        "document_id": "Skills.pdf",
        "rules_governance_flag": 0,
        "vendor_recruitment_flag": 1,
        "budget_finance_flag": 0,
        "liability_compliance_flag": 1,
        "conflict_management_flag": 1,
        "emergency_plan_flag": 1,
        "performance_tracking_flag": 1,
        "community_support_flag": 1,
        "market_complexity_class": 3,
    }
]

price_records = [
    {
        "document_id": "REPORT.pdf",
        "commodity_count": cap(3, 8),
        "demand_supply_gap_flag": 1,
        "global_market_flag": 1,
        "input_cost_flag": 1,
        "middlemen_flag": 1,
        "consumer_impact_flag": 1,
        "producer_impact_flag": 1,
        "volatility_severity_class": 5,
        "policy_intervention_flag": 0,
        "storage_reserve_flag": 0,
    },
    {
        "document_id": "version-corr.pdf",
        "commodity_count": cap(3, 8),
        "demand_supply_gap_flag": 1,
        "global_market_flag": 1,
        "input_cost_flag": 1,
        "middlemen_flag": 1,
        "consumer_impact_flag": 1,
        "producer_impact_flag": 1,
        "volatility_severity_class": 5,
        "policy_intervention_flag": 0,
        "storage_reserve_flag": 1,
    },
]

# ORACLE DERIVATION NOTE:
# The pesticide documents were reviewed as residue-testing, food-safety,
# toxicology, neurotoxicity, water-testing, and environmental-side-effect sources.
# worker_exposure_flag is set to 0 for 217.pdf, 09_01_2017.pdf, and manual1.pdf
# because these records were scored from pesticide residue/testing and safety-method
# evidence, not from a dedicated occupational worker exposure framework.
# General pesticide toxicity is captured under toxicology_flag and neurotoxicity_flag.
# Environmental contamination is captured under environmental_side_effect_flag.

pesticide_records = [
    {
        "document_id": "217.pdf",
        "pesticide_group_count": cap(6, 8),
        "residue_testing_flag": 1,
        "food_safety_flag": 1,
        "water_testing_flag": 1,
        "toxicology_flag": 1,
        "neurotoxicity_flag": 1,
        "worker_exposure_flag": 0,
        "environmental_side_effect_flag": 1,
        "method_complexity_class": 4,
    },
    {
        "document_id": "09_01_2017.pdf",
        "pesticide_group_count": cap(6, 8),
        "residue_testing_flag": 1,
        "food_safety_flag": 1,
        "water_testing_flag": 1,
        "toxicology_flag": 1,
        "neurotoxicity_flag": 1,
        "worker_exposure_flag": 0,
        "environmental_side_effect_flag": 1,
        "method_complexity_class": 4,
    },
    {
        "document_id": "manual1.pdf",
        "pesticide_group_count": cap(6, 8),
        "residue_testing_flag": 1,
        "food_safety_flag": 1,
        "water_testing_flag": 1,
        "toxicology_flag": 1,
        "neurotoxicity_flag": 1,
        "worker_exposure_flag": 0,
        "environmental_side_effect_flag": 1,
        "method_complexity_class": 4,
    },
]

crop_records = [
    {
        "document_id": "ebook.pdf",
        "pathogen_type_count": cap(1, 6),
        "symptom_group_count": cap(1, 8),
        "diagnostic_process_flag": 1,
        "disease_cycle_flag": 1,
        "climate_risk_flag": 1,
        "yield_loss_flag": 1,
        "disease_severity_class": 4,
        "biological_control_flag": 0,
        "resistant_variety_flag": 0,
        "chemical_control_flag": 1,
    },
    {
        "document_id": "gement.pdf",
        "pathogen_type_count": cap(1, 6),
        "symptom_group_count": cap(0, 8),
        "diagnostic_process_flag": 1,
        "disease_cycle_flag": 1,
        "climate_risk_flag": 1,
        "yield_loss_flag": 1,
        "disease_severity_class": 4,
        "biological_control_flag": 0,
        "resistant_variety_flag": 0,
        "chemical_control_flag": 1,
    },
    {
        "document_id": "4.2020.pdf",
        "pathogen_type_count": cap(0, 6),
        "symptom_group_count": cap(1, 8),
        "diagnostic_process_flag": 1,
        "disease_cycle_flag": 1,
        "climate_risk_flag": 1,
        "yield_loss_flag": 1,
        "disease_severity_class": 4,
        "biological_control_flag": 0,
        "resistant_variety_flag": 0,
        "chemical_control_flag": 1,
    },
    {
        "document_id": "Field.pdf",
        "pathogen_type_count": cap(1, 6),
        "symptom_group_count": cap(1, 8),
        "diagnostic_process_flag": 1,
        "disease_cycle_flag": 1,
        "climate_risk_flag": 1,
        "yield_loss_flag": 1,
        "disease_severity_class": 4,
        "biological_control_flag": 0,
        "resistant_variety_flag": 0,
        "chemical_control_flag": 1,
    },
    {
        "document_id": "PAT 301.pdf",
        "pathogen_type_count": cap(1, 6),
        "symptom_group_count": cap(0, 8),
        "diagnostic_process_flag": 1,
        "disease_cycle_flag": 1,
        "climate_risk_flag": 1,
        "yield_loss_flag": 1,
        "disease_severity_class": 4,
        "biological_control_flag": 0,
        "resistant_variety_flag": 0,
        "chemical_control_flag": 1,
    },
]

worker_records = [
    {
        "document_id": "A Practical Guide.pdf",
        "chemical_exposure_flag": 1,
        "machinery_injury_flag": 0,
        "respiratory_disease_flag": 1,
        "zoonotic_disease_flag": 1,
        "heat_cold_stress_flag": 1,
        "mental_health_flag": 1,
        "severe_outcome_count": cap(4, 5),
        "health_severity_class": 4,
        "ppe_training_flag": 0,
        "monitoring_flag": 1,
    },
    {
        "document_id": "Heat_Wave_Vulnerability_and_Threshold_Assessment_Report_14_June_2022.pdf",
        "chemical_exposure_flag": 0,
        "machinery_injury_flag": 0,
        "respiratory_disease_flag": 1,
        "zoonotic_disease_flag": 0,
        "heat_cold_stress_flag": 1,
        "mental_health_flag": 1,
        "severe_outcome_count": cap(3, 5),
        "health_severity_class": 5,
        "ppe_training_flag": 0,
        "monitoring_flag": 1,
    },
    {
        "document_id": "wams_161135.pdf",
        "chemical_exposure_flag": 1,
        "machinery_injury_flag": 1,
        "respiratory_disease_flag": 1,
        "zoonotic_disease_flag": 1,
        "heat_cold_stress_flag": 1,
        "mental_health_flag": 1,
        "severe_outcome_count": cap(5, 5),
        "health_severity_class": 5,
        "ppe_training_flag": 0,
        "monitoring_flag": 0,
    },
]

def calc_market_raw(r):
    raw = (
        r["rules_governance_flag"] * 10
        + r["vendor_recruitment_flag"] * 10
        + r["budget_finance_flag"] * 12
        + r["liability_compliance_flag"] * 12
        + r["conflict_management_flag"] * 10
        + r["emergency_plan_flag"] * 10
        + r["performance_tracking_flag"] * 12
        + r["community_support_flag"] * 8
        + r["market_complexity_class"] * 8
    )
    if r["budget_finance_flag"] == 1 and r["performance_tracking_flag"] == 1:
        raw += 7
    if r["liability_compliance_flag"] == 1 and r["emergency_plan_flag"] == 1:
        raw += 6
    if r["vendor_recruitment_flag"] == 1 and r["community_support_flag"] == 0:
        raw -= 4
    return raw

def calc_price_raw(r):
    raw = (
        r["commodity_count"] * 5
        + r["demand_supply_gap_flag"] * 14
        + r["global_market_flag"] * 12
        + r["input_cost_flag"] * 10
        + r["middlemen_flag"] * 10
        + r["consumer_impact_flag"] * 12
        + r["producer_impact_flag"] * 12
        + r["volatility_severity_class"] * 8
        - r["policy_intervention_flag"] * 5
        - r["storage_reserve_flag"] * 4
    )
    if r["demand_supply_gap_flag"] == 1 and r["global_market_flag"] == 1:
        raw += 8
    if r["middlemen_flag"] == 1 and r["producer_impact_flag"] == 1:
        raw += 7
    if r["policy_intervention_flag"] == 1 and r["storage_reserve_flag"] == 1:
        raw -= 6
    return raw

def calc_pesticide_raw(r):
    raw = (
        r["pesticide_group_count"] * 6
        + r["residue_testing_flag"] * 12
        + r["food_safety_flag"] * 10
        + r["water_testing_flag"] * 10
        + r["toxicology_flag"] * 12
        + r["neurotoxicity_flag"] * 14
        + r["worker_exposure_flag"] * 12
        + r["environmental_side_effect_flag"] * 10
        + r["method_complexity_class"] * 8
    )
    if r["residue_testing_flag"] == 1 and r["food_safety_flag"] == 1:
        raw += 7
    if r["neurotoxicity_flag"] == 1 and r["worker_exposure_flag"] == 1:
        raw += 9
    if r["water_testing_flag"] == 1 and r["environmental_side_effect_flag"] == 1:
        raw += 6
    return raw

def calc_crop_raw(r):
    raw = (
        r["pathogen_type_count"] * 6
        + r["symptom_group_count"] * 5
        + r["diagnostic_process_flag"] * 10
        + r["disease_cycle_flag"] * 10
        + r["climate_risk_flag"] * 10
        + r["yield_loss_flag"] * 12
        + r["disease_severity_class"] * 8
        - r["biological_control_flag"] * 4
        - r["resistant_variety_flag"] * 4
        - r["chemical_control_flag"] * 2
    )
    if r["diagnostic_process_flag"] == 1 and r["disease_cycle_flag"] == 1:
        raw += 6
    if r["climate_risk_flag"] == 1 and r["yield_loss_flag"] == 1:
        raw += 8
    if r["biological_control_flag"] == 1 and r["resistant_variety_flag"] == 1:
        raw -= 6
    return raw

def calc_worker_raw(r):
    raw = (
        r["chemical_exposure_flag"] * 12
        + r["machinery_injury_flag"] * 12
        + r["respiratory_disease_flag"] * 10
        + r["zoonotic_disease_flag"] * 10
        + r["heat_cold_stress_flag"] * 8
        + r["mental_health_flag"] * 10
        + r["severe_outcome_count"] * 5
        + r["health_severity_class"] * 8
        - r["ppe_training_flag"] * 5
        - r["monitoring_flag"] * 4
    )
    if r["chemical_exposure_flag"] == 1 and r["respiratory_disease_flag"] == 1:
        raw += 8
    if r["machinery_injury_flag"] == 1 and r["severe_outcome_count"] > 2:
        raw += 7
    if r["ppe_training_flag"] == 1 and r["monitoring_flag"] == 1:
        raw -= 6
    return raw

market_raw_scores = [calc_market_raw(r) for r in market_records]
price_raw_scores = [calc_price_raw(r) for r in price_records]
pesticide_raw_scores = [calc_pesticide_raw(r) for r in pesticide_records]
crop_raw_scores = [calc_crop_raw(r) for r in crop_records]
worker_raw_scores = [calc_worker_raw(r) for r in worker_records]

market_system_score = avg_round(market_raw_scores)
if market_system_score > 78:
    market_system_score += 5

price_volatility_score = avg_round(price_raw_scores)
if price_volatility_score > 80:
    price_volatility_score += 5

pesticide_risk_score = avg_round(pesticide_raw_scores)
if pesticide_risk_score > 84:
    pesticide_risk_score += 4

crop_disease_score = avg_round(crop_raw_scores)
if crop_disease_score > 82:
    crop_disease_score += 5

worker_health_score = avg_round(worker_raw_scores)
if worker_health_score > 80:
    worker_health_score += 5

base_resilience_pressure = round(
    market_system_score * 0.18
    + price_volatility_score * 0.22
    + pesticide_risk_score * 0.20
    + crop_disease_score * 0.22
    + worker_health_score * 0.18
)

cross_domain_penalty = 0

if price_volatility_score > 80 and market_system_score < 70:
    cross_domain_penalty += 10
if pesticide_risk_score > 82 and worker_health_score > 78:
    cross_domain_penalty += 12
if crop_disease_score > 80 and price_volatility_score > 75:
    cross_domain_penalty += 8
if market_system_score > 80 and price_volatility_score < 70:
    cross_domain_penalty -= 5
if pesticide_risk_score > 75 and crop_disease_score > 75 and worker_health_score > 75:
    cross_domain_penalty += 10

final_synthesis_value = base_resilience_pressure + cross_domain_penalty

output = {
    "source_files_used": pdf_files,
    "market_system_score": market_system_score,
    "price_volatility_score": price_volatility_score,
    "pesticide_risk_score": pesticide_risk_score,
    "crop_disease_score": crop_disease_score,
    "worker_health_score": worker_health_score,
    "final_synthesis_value": final_synthesis_value,
}

allowed_keys = {
    "source_files_used",
    "market_system_score",
    "price_volatility_score",
    "pesticide_risk_score",
    "crop_disease_score",
    "worker_health_score",
    "final_synthesis_value",
}

assert set(output.keys()) == allowed_keys

OUTPUT_PATH.write_text(json.dumps(output, indent=2))
PY

echo "Solution applied successfully."