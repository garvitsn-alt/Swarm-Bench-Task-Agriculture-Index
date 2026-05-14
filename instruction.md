# Agricultural Resilience Stress Benchmark

Working directory: /workspace

You are given a folder of agricultural PDF reports and manuals.

Your task is to:

1. Read all reports
2. Extract agricultural system evidence
3. Calculate:
   - market_system_score
   - price_volatility_score
   - pesticide_risk_score
   - crop_disease_score
   - worker_health_score
4. Calculate final_synthesis_value

Write the final answer to:

/logs/agent/output.json

Return JSON only.

---

# Input Files

The reports are located at:

/environment/input_artifacts/

Use all reports. Do not ignore files.

---

# Output Format

The output must be valid JSON with exactly this structure:

{
  "source_files_used": [],
  "market_system_score": 0,
  "price_volatility_score": 0,
  "pesticide_risk_score": 0,
  "crop_disease_score": 0,
  "worker_health_score": 0,
  "final_synthesis_value": 0
}

source_files_used must list every PDF file used from /environment/input_artifacts/.

Use exact filenames including .pdf.

Output key restrictions:
- The final output JSON must contain ONLY the following 7 keys:
  - source_files_used
  - market_system_score
  - price_volatility_score
  - pesticide_risk_score
  - crop_disease_score
  - worker_health_score
  - final_synthesis_value

- Do not include any extra diagnostic, explanation, intermediate, evidence, table, or debug keys.
- Extra keys will cause verification failure.

Final synthesis consistency:
- final_synthesis_value must be internally consistent with the submitted domain scores.
- It must be computed from the reported values of:
  - market_system_score
  - price_volatility_score
  - pesticide_risk_score
  - crop_disease_score
  - worker_health_score

- Use the synthesis formula defined in this instruction.
Return JSON only.

---

# General Rules

During intermediate extraction, use 0/1 values for flags, 1–5 values for severity_class variables, and 1–4 values for complexity_class variables (market_complexity_class, method_complexity_class). These are intermediate variables only and must not appear in the final JSON output.



Count caps:
- commodity_count must be capped at 8
- pesticide_group_count must be capped at 8
- pathogen_type_count must be capped at 6
- symptom_group_count must be capped at 8
- severe_outcome_count must be capped at 5

If the document mentions more than the cap, use the capped value.
When a domain-specific decomposition step defines a maximum cap for a count variable, apply that cap before score calculation.
---

Extraction Rules

Extract:

- rules_governance_flag
- vendor_recruitment_flag
- budget_finance_flag
- liability_compliance_flag
- chemical_exposure_flag
- machinery_injury_flag
- respiratory_disease_flag
- storage_reserve_flag
- consumer_impact_flag
- producer_impact_flag
- volatility_severity_class
- global_market_flag
- conflict_management_flag
- emergency_plan_flag
- performance_tracking_flag
- community_support_flag
- biological_control_flag
- chemical_control_flag
- resistant_variety_flag
- yield_loss_flag
- disease_severity_class
- input_cost_flag
- middlemen_flag
- policy_intervention_flag
- toxicology_flag
- neurotoxicity_flag
- worker_exposure_flag
- environmental_side_effect_flag
- method_complexity_class
- pesticide_group_count
- residue_testing_flag
- food_safety_flag
- water_testing_flag
- zoonotic_disease_flag
- heat_cold_stress_flag
- market_complexity_class
- commodity_count
- demand_supply_gap_flag
- pathogen_type_count
- symptom_group_count
- diagnostic_process_flag
- disease_cycle_flag
- climate_risk_flag
- mental_health_flag
- ppe_training_flag
- monitoring_flag
- severe_outcome_count
- health_severity_class




Definitions:

market_complexity_class:
1=basic
2=moderate
3=complex
4=highly complex

volatility_severity_class:
1=low
2=moderate
3=serious
4=severe
5=extreme

method_complexity_class:
1=basic
2=moderate
3=complex
4=highly complex


disease_severity_class:
1=low
2=moderate
3=serious
4=severe
5=extreme


health_severity_class:
1=low
2=moderate
3=serious
4=severe
5=extreme



Calculate:

market_raw_score =
rules_governance_flag * 10
+ vendor_recruitment_flag * 10
+ budget_finance_flag * 12
+ liability_compliance_flag * 12
+ conflict_management_flag * 10
+ emergency_plan_flag * 10
+ performance_tracking_flag * 12
+ community_support_flag * 8
+ market_complexity_class * 8

if budget_finance_flag = 1 and performance_tracking_flag = 1:
market_raw_score = market_raw_score + 7

if liability_compliance_flag = 1 and emergency_plan_flag = 1:
market_raw_score = market_raw_score + 6

if vendor_recruitment_flag = 1 and community_support_flag = 0:
market_raw_score = market_raw_score - 4

market_system_score =
round(average(all market_raw_score))

if market_system_score > 78:
market_system_score = market_system_score + 5


price_raw_score =
commodity_count * 5
+ demand_supply_gap_flag * 14
+ global_market_flag * 12
+ input_cost_flag * 10
+ middlemen_flag * 10
+ consumer_impact_flag * 12
+ producer_impact_flag * 12
+ volatility_severity_class * 8
- policy_intervention_flag * 5
- storage_reserve_flag * 4

if demand_supply_gap_flag = 1 and global_market_flag = 1:
price_raw_score = price_raw_score + 8

if middlemen_flag = 1 and producer_impact_flag = 1:
price_raw_score = price_raw_score + 7

if policy_intervention_flag = 1 and storage_reserve_flag = 1:
price_raw_score = price_raw_score - 6

price_volatility_score =
round(average(all price_raw_score))

if price_volatility_score > 80:
price_volatility_score = price_volatility_score + 5


pesticide_raw_score =
pesticide_group_count * 6
+ residue_testing_flag * 12
+ food_safety_flag * 10
+ water_testing_flag * 10
+ toxicology_flag * 12
+ neurotoxicity_flag * 14
+ worker_exposure_flag * 12
+ environmental_side_effect_flag * 10
+ method_complexity_class * 8

if residue_testing_flag = 1 and food_safety_flag = 1:
pesticide_raw_score = pesticide_raw_score + 7

if neurotoxicity_flag = 1 and worker_exposure_flag = 1:
pesticide_raw_score = pesticide_raw_score + 9

if water_testing_flag = 1 and environmental_side_effect_flag = 1:
pesticide_raw_score = pesticide_raw_score + 6

pesticide_risk_score =
round(average(all pesticide_raw_score))

if pesticide_risk_score > 84:
pesticide_risk_score = pesticide_risk_score + 4


commodity_count = min(commodity_count, 8)
pesticide_group_count = min(pesticide_group_count, 8)
pathogen_type_count = min(pathogen_type_count, 6)
symptom_group_count = min(symptom_group_count, 8)
severe_outcome_count = min(severe_outcome_count, 5)


crop_raw_score =
pathogen_type_count * 6
+ symptom_group_count * 5
+ diagnostic_process_flag * 10
+ disease_cycle_flag * 10
+ climate_risk_flag * 10
+ yield_loss_flag * 12
+ disease_severity_class * 8
- biological_control_flag * 4
- resistant_variety_flag * 4
- chemical_control_flag * 2

if diagnostic_process_flag = 1 and disease_cycle_flag = 1:
crop_raw_score = crop_raw_score + 6

if climate_risk_flag = 1 and yield_loss_flag = 1:
crop_raw_score = crop_raw_score + 8

if biological_control_flag = 1 and resistant_variety_flag = 1:
crop_raw_score = crop_raw_score - 6

crop_disease_score =
round(average(all crop_raw_score))

if crop_disease_score > 82:
crop_disease_score = crop_disease_score + 5




worker_raw_score =
chemical_exposure_flag * 12
+ machinery_injury_flag * 12
+ respiratory_disease_flag * 10
+ zoonotic_disease_flag * 10
+ heat_cold_stress_flag * 8
+ mental_health_flag * 10
+ severe_outcome_count * 5
+ health_severity_class * 8
- ppe_training_flag * 5
- monitoring_flag * 4

if chemical_exposure_flag = 1 and respiratory_disease_flag = 1:
worker_raw_score = worker_raw_score + 8

if machinery_injury_flag = 1 and severe_outcome_count > 2:
worker_raw_score = worker_raw_score + 7

if ppe_training_flag = 1 and monitoring_flag = 1:
worker_raw_score = worker_raw_score - 6

worker_health_score =
round(average(all worker_raw_score))

if worker_health_score > 80:
worker_health_score = worker_health_score + 5
  

Important calculation order:

1. Calculate raw score separately for each document.
2. Apply document-level conditional adjustments.
3. Average raw scores within each domain.
4. Round the averaged domain score to nearest integer.
5. Apply high-score domain bonus only once per domain.
6. Calculate base_resilience_pressure using final domain scores.
7. Apply each cross_domain_penalty rule at most once.



base_resilience_pressure =
round(
market_system_score * 0.18
+ price_volatility_score * 0.22
+ pesticide_risk_score * 0.20
+ crop_disease_score * 0.22
+ worker_health_score * 0.18
)

cross_domain_penalty = 0

if price_volatility_score > 80 and market_system_score < 70:
cross_domain_penalty = cross_domain_penalty + 10

if pesticide_risk_score > 82 and worker_health_score > 78:
cross_domain_penalty = cross_domain_penalty + 12

if crop_disease_score > 80 and price_volatility_score > 75:
cross_domain_penalty = cross_domain_penalty + 8

if market_system_score > 80 and price_volatility_score < 70:
cross_domain_penalty = cross_domain_penalty - 5

if pesticide_risk_score > 75 and crop_disease_score > 75 and worker_health_score > 75:
cross_domain_penalty = cross_domain_penalty + 10


final_synthesis_value =
base_resilience_pressure
+ cross_domain_penalty

Return JSON only.