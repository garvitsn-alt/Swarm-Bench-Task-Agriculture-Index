import json
from pathlib import Path

# -----------------------------
# Expected input files
# -----------------------------

EXPECTED_INPUT_FILES = sorted([
    "Skills.pdf",
    "REPORT.pdf",
    "version-corr.pdf",
    "217.pdf",
    "09_01_2017.pdf",
    "ebook.pdf",
    "gement.pdf",
    "4.2020.pdf",
    "A Practical Guide.pdf",
     "Heat_Wave_Vulnerability_and_Threshold_Assessment_Report_14_June_2022.pdf",
     "wams_161135.pdf",
     "manual1.pdf",
     "Field.pdf",
     "PAT 301.pdf"






])

ALLOWED_OUTPUT_KEYS = {
    "source_files_used",
    "market_system_score",
    "price_volatility_score",
    "pesticide_risk_score",
    "crop_disease_score",
    "worker_health_score",
    "final_synthesis_value",
}

EXPECTED_OUTPUT_KEYS = {
    "source_files_used",
    "market_system_score",
    "price_volatility_score",
    "pesticide_risk_score",
    "crop_disease_score",
    "worker_health_score",
    "final_synthesis_value",
}

INTERMEDIATE_KEYS = {
    "rules_governance_flag",
    "vendor_recruitment_flag",
    "budget_finance_flag",
    "liability_compliance_flag",
    "chemical_exposure_flag",
    "machinery_injury_flag",
    "respiratory_disease_flag",
    "storage_reserve_flag",
    "consumer_impact_flag",
    "producer_impact_flag",
    "volatility_severity_class",
    "global_market_flag",
    "conflict_management_flag",
    "emergency_plan_flag",
    "performance_tracking_flag",
    "community_support_flag",
    "biological_control_flag",
    "chemical_control_flag",
    "resistant_variety_flag",
    "yield_loss_flag",
    "disease_severity_class",
    "input_cost_flag",
    "middlemen_flag",
    "policy_intervention_flag",
    "toxicology_flag",
    "neurotoxicity_flag",
    "worker_exposure_flag",
    "environmental_side_effect_flag",
    "method_complexity_class",
    "pesticide_group_count",
    "residue_testing_flag",
    "food_safety_flag",
    "water_testing_flag",
    "zoonotic_disease_flag",
    "heat_cold_stress_flag",
    "market_complexity_class",
    "commodity_count",
    "demand_supply_gap_flag",
    "pathogen_type_count",
    "symptom_group_count",
    "diagnostic_process_flag",
    "disease_cycle_flag",
    "climate_risk_flag",
    "mental_health_flag",
    "ppe_training_flag",
    "monitoring_flag",
    "severe_outcome_count",
    "health_severity_class",
}

EXPECTED_SOURCE_FILES_USED = EXPECTED_INPUT_FILES

# -----------------------------
# Paths
# -----------------------------

INPUT_DIR = Path("/environment/input_artifacts")
OUTPUT_PATH = Path("/logs/agent/output.json")
REWARD_DIR = Path("/logs/verifier")
REWARD_PATH = REWARD_DIR / "reward.txt"

# -----------------------------
# Expected values
# -----------------------------

EXPECTED_MARKET_SYSTEM_SCORE = 97
EXPECTED_PRICE_VOLATILITY_SCORE = 143
EXPECTED_PESTICIDE_RISK_SCORE = 153
EXPECTED_CROP_DISEASE_SCORE = 99
EXPECTED_WORKER_HEALTH_SCORE = 114
EXPECTED_FINAL_SYNTHESIS_VALUE = 152

# -----------------------------
# Weights
# -----------------------------

SOURCE_FILES_USED_WEIGHT = 0.025
OUTPUT_KEYS_WEIGHT = 0.025
VALUE_CHECK_WEIGHT = 0.925 / 6
CONSTRAINT_CHECK_WEIGHT = 0.025

score = 0.0
checks = []


def add_check(name, passed, weight):
    global score
    checks.append((name, passed, weight))
    if passed:
        score += weight


def approx_match(actual, expected, tolerance):
    try:
        return abs(float(actual) - float(expected)) <= tolerance
    except Exception:
        return False


def exact_match(actual, expected):
    return actual == expected


def write_reward():
    final_score = min(score, 1.0)

    REWARD_DIR.mkdir(parents=True, exist_ok=True)
    REWARD_PATH.write_text(str(round(final_score, 4)))

    for name, passed, weight in checks:
        print(f"{name}: {'PASS' if passed else 'FAIL'} ({weight})")

    print(f"FINAL SCORE: {round(final_score, 4)}")


def expected_final_from_scores(data):
    try:
        market = float(data.get("market_system_score"))
        price = float(data.get("price_volatility_score"))
        pesticide = float(data.get("pesticide_risk_score"))
        crop = float(data.get("crop_disease_score"))
        worker = float(data.get("worker_health_score"))

        base = round(
            market * 0.18
            + price * 0.22
            + pesticide * 0.20
            + crop * 0.22
            + worker * 0.18
        )

        penalty = 0

        if price > 80 and market < 70:
            penalty += 10

        if pesticide > 82 and worker > 78:
            penalty += 12

        if crop > 80 and price > 75:
            penalty += 8

        if market > 80 and price < 70:
            penalty -= 5

        if pesticide > 75 and crop > 75 and worker > 75:
            penalty += 10

        return base + penalty

    except Exception:
        return None



# -----------------------------
# Input files present check
# -----------------------------

actual_input_files = []

if INPUT_DIR.exists():
    actual_input_files = sorted([
        path.name
        for path in INPUT_DIR.iterdir()
        if path.is_file()
    ])


# -----------------------------
# Load output lightly
# -----------------------------

if not OUTPUT_PATH.exists():
    write_reward()
    raise SystemExit(0)

try:
    data = json.loads(OUTPUT_PATH.read_text())
except Exception:
    write_reward()
    raise SystemExit(0)

# -----------------------------
# Value checks
# -----------------------------

add_check(
    "all_source_files_used",
    sorted(data.get("source_files_used", [])) == sorted(EXPECTED_SOURCE_FILES_USED),
    SOURCE_FILES_USED_WEIGHT
)

add_check(
    "market_system_score_correct",
    approx_match(data.get("market_system_score"), EXPECTED_MARKET_SYSTEM_SCORE, 13),
    VALUE_CHECK_WEIGHT
)

add_check(
    "price_volatility_score_correct",
    approx_match(data.get("price_volatility_score"), EXPECTED_PRICE_VOLATILITY_SCORE, 14),
    VALUE_CHECK_WEIGHT
)

add_check(
    "pesticide_risk_score_correct",
    approx_match(data.get("pesticide_risk_score"), EXPECTED_PESTICIDE_RISK_SCORE, 16),
    VALUE_CHECK_WEIGHT
)

add_check(
    "crop_disease_score_correct",
    approx_match(data.get("crop_disease_score"), EXPECTED_CROP_DISEASE_SCORE, 12),
    VALUE_CHECK_WEIGHT
)

add_check(
    "worker_health_score_correct",
    approx_match(data.get("worker_health_score"), EXPECTED_WORKER_HEALTH_SCORE, 14),
    VALUE_CHECK_WEIGHT
)

add_check(
    "exact_output_keys_only",
    set(data.keys()) == ALLOWED_OUTPUT_KEYS,
    OUTPUT_KEYS_WEIGHT,
)


add_check(
    "no_intermediate_variables_in_output",
    not any(key in data for key in INTERMEDIATE_KEYS),
    CONSTRAINT_CHECK_WEIGHT,
)

add_check(
    "final_synthesis_value_correct",
    approx_match(data.get("final_synthesis_value"), EXPECTED_FINAL_SYNTHESIS_VALUE, 15),
    VALUE_CHECK_WEIGHT
)



add_check(
    "final_synthesis_consistent_with_domain_scores",
    exact_match(
        data.get("final_synthesis_value"),
        expected_final_from_scores(data)
    ),
    CONSTRAINT_CHECK_WEIGHT,
)
write_reward()
