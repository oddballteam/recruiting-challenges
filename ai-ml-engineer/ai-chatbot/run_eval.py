"""
Evaluation Runner

Load the eval dataset, run metrics against mock responses, and print results.

TODO: Implement this script to:
1. Load data/eval_dataset.json
2. Run each metric against every test case
3. Print per-case and aggregate results
4. (Optional) Output results in a format suitable for RESULTS.md
"""

import json
import os

# TODO: Import your metric functions from metrics.py and implement the runner


def main():
    # Load dataset
    dataset_path = os.path.join(os.path.dirname(__file__), '..', 'data', 'eval_dataset.json')
    with open(dataset_path, 'r') as f:
        dataset = json.load(f)

    test_cases = dataset['test_cases']

    # TODO: Run metrics and print results
    print(f"Loaded {len(test_cases)} test cases")
    print("Implement your evaluation runner here.")


if __name__ == "__main__":
    main()
