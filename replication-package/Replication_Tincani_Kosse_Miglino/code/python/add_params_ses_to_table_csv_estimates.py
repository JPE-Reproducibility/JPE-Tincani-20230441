#!/usr/bin/env python3
"""
Compute bootstrap standard errors, read the final parameter estimates, and populate
a LaTeX table with estimates, significance stars, and standard errors.

This script:
1) Reads vectors from estimation_theta_s_bootstrap1.csv ... estimation_theta_s_bootstrap50.csv
2) Computes sample standard deviations element-wise (denominator n-1, so 49 when n=50)
3) Writes the SE vector (element order) to a CSV file
4) Reads the final parameter vector from a vertical CSV file
5) Replaces the Estimate and Standard Error columns in a LaTeX table using an explicit
    parameter mapping and significance stars from a normal approximation
"""

from __future__ import annotations

import argparse
import math
import re
from pathlib import Path
from typing import Dict, List, Tuple

PACKAGE_NAME = "Replication_Tincani_Kosse_Miglino"


def find_package_root() -> Path:
    script_path = Path(__file__).resolve()

    for candidate in (script_path.parent, *script_path.parents):
        if candidate.name == PACKAGE_NAME:
            return candidate

        nested_package = candidate / PACKAGE_NAME
        if nested_package.exists():
            return nested_package

    raise RuntimeError(
        f"Could not locate {PACKAGE_NAME}. "
        "Run this script from inside the replication package."
    )


PACKAGE_ROOT = find_package_root()
PROCESSED_DIR = PACKAGE_ROOT / "confidential-data-not-for-publication" / "processed"
TABLES_DIR = PACKAGE_ROOT / "code" / "tex" / "output" / "tables"
TABLES_DIR_IN = PACKAGE_ROOT / "code" / "python"

DEFAULT_BOOTSTRAP_DIR = PROCESSED_DIR
DEFAULT_SE_OUTPUT_FILE = PROCESSED_DIR / "bootstrapped_standard_errors.csv"
DEFAULT_TABLE_INPUT = TABLES_DIR_IN / "structural_model_estimates_to_edit.tex"
DEFAULT_TABLE_OUTPUT = TABLES_DIR / "structural_model_estimates_edited.tex"
DEFAULT_ESTIMATES_INPUT = PROCESSED_DIR / "estimation_theta_rescale_fast_adjw_20shocks.csv"
DEFAULT_N_BOOTSTRAPS = 50


# Mapping from LaTeX symbol (first column of table) to element index in parameter vectors.
# Element indices are 1-based to match the mapping provided by the user.
TABLE_SYMBOL_TO_ELEMENT: Dict[str, int] = {
    r"$\xi_{11}$": 9,
    r"$\xi_{12}$": 10,
    r"$\xi_2$": 17,
    r"$c_0^S$": 19,
    r"$c_1^S$": 18,
    r"$\lambda_{01}$": 1,
    r"$\lambda_{02}$": 2,
    r"$\lambda^{G}_{0}$": 23,
    r"$\delta$": 22,
    r"$\beta^{G}_{01}$": 3,
    r"$\beta^{G}_{02}$": 4,
    r"$\beta^{G}_{1}$": 25,
    r"$\beta^{G}_{2}$": 26,
    r"$\beta^{G}_{3}$": 27,
    r"$\beta^{P}_{01}$": 5,
    r"$\beta^{P}_{02}$": 6,
    r"$\beta^{P}_{1}$": 29,
    r"$\beta^{P}_{2}$": 30,
    r"$\beta^{P}_{3}$": 31,
    r"$\rho_{01}$": 7,
    r"$\rho_{02}$": 8,
    r"$\rho_{1}$": 33,
    r"$\rho_{2}$": 34,
    r"$\gamma^{b}_{0}$": 20,
    r"$\gamma^{b}_{1}$": 21,
    r"$\pi^{b}_{0}$": 15,
    r"$\pi^{b}_{1}$": 16,
    r"$\omega_{20}$": 11,
    r"$\omega_{21}$": 12,
    r"$\omega_{22}$": 13,
    r"$\omega_{23}$": 14,
    r"$\sigma_{mee}$": 24,
    r"$\sigma_{GPA}$": 28,
    r"$\sigma_{PSU}$": 32,
}

ELEMENT_TO_MODEL_PARAM: Dict[int, str] = {
    1: "lambdaPR_0[1]",
    2: "lambdaPR_0[2]",
    3: "betaGPA_0[1]",
    4: "betaGPA_0[2]",
    5: "betaPSU_0[1]",
    6: "betaPSU_0[2]",
    7: "theta_ppersist0[1]",
    8: "theta_ppersist0[2]",
    9: "xi_1[1]",
    10: "xi_1[2]",
    11: "omega_0[2]",
    12: "omega_1[2]",
    13: "omega_2[2]",
    14: "omega_3[2]",
    15: "zetapace_0",
    16: "zetapace_1",
    17: "xi_2",
    18: "costSTreat",
    19: "costS",
    20: "gammab_0",
    21: "gammab_1",
    22: "delta",
    23: "lambdaGO",
    24: "sigma_error_eff",
    25: "betaGPA_1",
    26: "betaGPA_2",
    27: "betaGPA_3",
    28: "sigma_eGPA",
    29: "betaPSU_1",
    30: "betaPSU_2",
    31: "betaPSU_3",
    32: "sigma_ePSU",
    33: "theta_ppersist[1]",
    34: "theta_ppersist[2]",
}

def parse_vertical_vector_csv(path: Path) -> List[float]:
    if not path.exists():
        raise FileNotFoundError(f"Estimate CSV file does not exist: {path}")

    out: List[float] = []
    for line_number, raw_line in enumerate(
        path.read_text(encoding="utf-8-sig", errors="replace").splitlines(),
        start=1,
    ):
        line = raw_line.strip()
        if not line:
            continue

        fields = [field.strip() for field in line.split(",") if field.strip()]
        if len(fields) != 1:
            raise ValueError(
                f"Expected one numeric value per non-empty row in {path}, "
                f"but line {line_number} has {len(fields)} values: {raw_line!r}"
            )

        try:
            out.append(float(fields[0]))
        except ValueError as exc:
            raise ValueError(
                f"Could not parse a float from line {line_number} of {path}: {raw_line!r}"
            ) from exc

    if not out:
        raise ValueError(f"Parsed an empty estimate vector from {path}")
    return out


def load_bootstrap_vectors(bootstrap_dir: Path, n_bootstraps: int) -> List[List[float]]:
    paths = [bootstrap_dir / f"estimation_theta_s_bootstrap{i}.csv" for i in range(1, n_bootstraps + 1)]
    missing = [str(path) for path in paths if not path.exists()]
    if missing:
        missing_str = "\n".join(missing)
        raise FileNotFoundError(
            f"Expected {n_bootstraps} files named estimation_theta_s_bootstrap1..{n_bootstraps}.csv.\n"
            f"Missing files:\n{missing_str}"
        )

    vectors: List[List[float]] = []
    parse_errors: List[str] = []
    for path in paths:
        try:
            vectors.append(parse_vertical_vector_csv(path))
        except Exception as exc:
            parse_errors.append(f"{path}: {exc}")

    if parse_errors:
        details = "\n".join(parse_errors)
        raise ValueError(
            "Some bootstrap files could not be parsed. "
            "Each file must be a vertical CSV vector with one numeric value per non-empty row.\n"
            f"{details}"
        )

    expected_len = len(vectors[0])
    for idx, vector in enumerate(vectors, start=1):
        if len(vector) != expected_len:
            raise ValueError(
                f"Inconsistent vector length: bootstrap {idx} has length {len(vector)} "
                f"but expected {expected_len}."
            )

    return vectors


def compute_sample_standard_errors(vectors: List[List[float]]) -> List[float]:
    n_vectors = len(vectors)
    if n_vectors < 2:
        raise ValueError("Need at least two bootstrap vectors to compute sample SD.")

    n_parameters = len(vectors[0])
    standard_errors = [0.0] * n_parameters
    for idx in range(n_parameters):
        mean_value = sum(vector[idx] for vector in vectors) / n_vectors
        squared_sum = sum((vector[idx] - mean_value) ** 2 for vector in vectors)
        standard_errors[idx] = math.sqrt(squared_sum / (n_vectors - 1))

    return standard_errors


def write_se_vector(path: Path, standard_errors: List[float]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)

    lines = ["element,model_param,standard_error"]
    for idx, value in enumerate(standard_errors, start=1):
        model_param = ELEMENT_TO_MODEL_PARAM.get(idx, f"element_{idx}")
        lines.append(f"{idx},{model_param},{value:.12g}")

    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def format_se_for_table(value: float) -> str:
    formatted = f"{value:.3f}"
    if formatted == "-0.000":
        formatted = "0.000"
    return f"({formatted})"


def compute_significance_stars(estimate: float, standard_error: float) -> str:
    if standard_error < 0:
        raise ValueError(f"Standard errors must be non-negative, got {standard_error}")
    if standard_error == 0:
        if estimate == 0:
            return ""
        return "^{***}"

    z_score = abs(estimate) / standard_error
    if z_score > 2.576:
        return "^{***}"
    if z_score > 1.96:
        return "^{**}"
    if z_score > 1.645:
        return "^{*}"
    return ""


def format_estimate_for_table(estimate: float, standard_error: float) -> str:
    formatted = f"{estimate:.3f}"
    if formatted == "-0.000":
        formatted = "0.000"
    stars = compute_significance_stars(estimate, standard_error)
    return f"${formatted}{stars}$"


def replace_table_estimates_and_standard_errors(
    table_text: str,
    estimates: List[float],
    standard_errors: List[float],
) -> Tuple[str, int]:
    if len(estimates) != len(standard_errors):
        raise ValueError(
            f"Estimate vector length {len(estimates)} does not match SE vector length {len(standard_errors)}."
        )

    line_pattern = re.compile(
        r"^(?P<prefix>\s*[^&]+&[^&]+&)\s*(?P<current_estimate>.*?)\s*&\s*(?P<current_se>.*?)\s*(?P<suffix>\\\\.*)$"
    )

    lines = table_text.splitlines()
    replaced = 0
    seen_symbols = set()
    out_lines: List[str] = []

    for line in lines:
        if "&" not in line:
            out_lines.append(line)
            continue

        first_col = line.split("&", 1)[0].strip()
        element = TABLE_SYMBOL_TO_ELEMENT.get(first_col)
        if element is None:
            out_lines.append(line)
            continue

        if element < 1 or element > len(estimates):
            raise IndexError(
                f"Element index {element} for symbol {first_col} is outside vector length {len(estimates)}."
            )

        match = line_pattern.match(line)
        if not match:
            raise ValueError(f"Could not parse parameter line for symbol {first_col}:\n{line}")

        estimate = estimates[element - 1]
        if first_col == r"$\delta$":
            # delta enters the model code with a leading minus as a disutility:
            # a positive estimate means a PACE enrollment disutility, and vice versa.
            # The table reports utility, so flip the sign only for the table display.
            estimate = -estimate
        if first_col == r"$c_1^S$":
            # costSTreat enters the model code with a leading minus: a positive
            # estimate means the treatment impact on perceived exam value is negative,
            # and vice versa. Flip the sign only for the table display.
            estimate = -estimate
        standard_error = standard_errors[element - 1]
        estimate_cell = format_estimate_for_table(estimate, standard_error)
        se_cell = format_se_for_table(standard_error)
        new_line = f"{match.group('prefix')} {estimate_cell} & {se_cell} {match.group('suffix')}"
        out_lines.append(new_line)
        replaced += 1
        seen_symbols.add(first_col)

    missing_symbols = [symbol for symbol in TABLE_SYMBOL_TO_ELEMENT if symbol not in seen_symbols]
    if missing_symbols:
        missing_pretty = ", ".join(missing_symbols)
        raise ValueError(
            "Failed to find some mapped symbols in table. "
            f"Missing symbols: {missing_pretty}"
        )

    return "\n".join(out_lines) + "\n", replaced


def update_table(
    table_input: Path,
    table_output: Path,
    estimates: List[float],
    standard_errors: List[float],
) -> int:
    if not table_input.exists():
        raise FileNotFoundError(f"Table input file does not exist: {table_input}")

    table_text = table_input.read_text(encoding="utf-8", errors="replace")
    updated_text, replaced_count = replace_table_estimates_and_standard_errors(
        table_text,
        estimates,
        standard_errors,
    )
    table_output.parent.mkdir(parents=True, exist_ok=True)
    table_output.write_text(updated_text, encoding="utf-8")
    return replaced_count


def build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Compute bootstrap SEs, add estimates and stars, and populate a LaTeX table."
    )
    parser.add_argument(
        "--bootstrap-dir",
        type=Path,
        default=DEFAULT_BOOTSTRAP_DIR,
        help=f"Directory containing estimation_theta_s_bootstrap*.csv (default: {DEFAULT_BOOTSTRAP_DIR})",
    )
    parser.add_argument(
        "--n-bootstraps",
        type=int,
        default=DEFAULT_N_BOOTSTRAPS,
        help=f"Number of bootstrap files expected (default: {DEFAULT_N_BOOTSTRAPS})",
    )
    parser.add_argument(
        "--se-output-file",
        type=Path,
        default=DEFAULT_SE_OUTPUT_FILE,
        help=f"Output CSV file with SE vector (default: {DEFAULT_SE_OUTPUT_FILE})",
    )
    parser.add_argument(
        "--estimates-input",
        type=Path,
        default=DEFAULT_ESTIMATES_INPUT,
        help=f"Path to the CSV file containing the final parameter vector (default: {DEFAULT_ESTIMATES_INPUT})",
    )
    parser.add_argument(
        "--table-input",
        type=Path,
        default=DEFAULT_TABLE_INPUT,
        help=f"Input LaTeX table path (default: {DEFAULT_TABLE_INPUT})",
    )
    parser.add_argument(
        "--table-output",
        type=Path,
        default=DEFAULT_TABLE_OUTPUT,
        help=f"Output LaTeX table path (default: {DEFAULT_TABLE_OUTPUT})",
    )
    return parser


def main() -> None:
    args = build_arg_parser().parse_args()

    bootstrap_vectors = load_bootstrap_vectors(args.bootstrap_dir, args.n_bootstraps)
    standard_errors = compute_sample_standard_errors(bootstrap_vectors)
    estimates = parse_vertical_vector_csv(args.estimates_input)
    if len(estimates) != len(standard_errors):
        raise ValueError(
            f"Estimate vector length {len(estimates)} does not match SE vector length {len(standard_errors)}."
        )

    write_se_vector(args.se_output_file, standard_errors)
    replaced_count = update_table(
        args.table_input,
        args.table_output,
        estimates,
        standard_errors,
    )

    print(f"Processed {len(bootstrap_vectors)} bootstrap files.")
    print(f"Parameter vector length: {len(estimates)}")
    print(f"Read parameter estimates CSV from: {args.estimates_input}")
    print(f"Wrote SE vector to: {args.se_output_file}")
    print(f"Updated {replaced_count} table rows in: {args.table_output}")


if __name__ == "__main__":
    main()
