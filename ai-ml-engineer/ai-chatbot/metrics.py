"""
Evaluation Metrics for Chatbot Response Quality

Implement the three metric functions below.
Each function includes a docstring explaining the metric, its formula, and expected behavior.

You may add helper functions as needed.
"""

from typing import List


def fact_recall(response: str, expected_facts: List[str]) -> float:
    """
    Fact Recall: What proportion of expected facts appear in the response?

    Formula:
        fact_recall = |found_facts ∩ required_facts| / |required_facts|

    Args:
        response: The chatbot's response text
        expected_facts: List of facts that should be present in the response

    Returns:
        Float between 0.0 and 1.0

    Example:
        response = "We ship in 5-7 business days. Express takes 2-3 days."
        expected = ["5-7 business days", "2-3 business days", "free shipping over $50"]
        fact_recall(response, expected) → 0.667  (2 out of 3 facts found)

    Notes:
        - Matching should be case-insensitive
        - Consider how to handle paraphrased facts (exact substring match is acceptable
          as a baseline, but describe any limitations in your RESULTS.md)
    """
    # TODO: Implement
    raise NotImplementedError


def mean_reciprocal_rank(responses: List[dict]) -> float:
    """
    MRR (Mean Reciprocal Rank): On average, how early does the first relevant
    fact appear in each response?

    Formula:
        MRR = (1/N) × Σ(1/rank_i)

    where rank_i is the 1-indexed sentence position of the first sentence
    containing any expected fact in response i.

    Args:
        responses: List of dicts, each with keys:
            - "response": str (the chatbot response)
            - "expected_facts": List[str] (facts to look for)

    Returns:
        Float between 0.0 and 1.0

    Example:
        If the first expected fact appears in sentence 1 → reciprocal rank = 1/1 = 1.0
        If the first expected fact appears in sentence 3 → reciprocal rank = 1/3 = 0.333
        If no expected fact is found → reciprocal rank = 0.0

    Notes:
        - Split the response into sentences (splitting on '. ', '! ', '? ' is acceptable)
        - Sentence indexing is 1-based
    """
    # TODO: Implement
    raise NotImplementedError


def freshness_at_k(response: str, expected_facts: List[str], k: int = 5) -> float:
    """
    Freshness@k: Weighted recall that rewards facts appearing earlier in the response.
    A response that front-loads important information should score higher than one
    that buries the answer at the end.

    Formula:
        Freshness@k = Σ(weight_i × found_i) / Σ(weight_i)

        where:
            - Split the response into k equal-sized chunks (by character or sentence)
            - weight_i = (k - i + 1) / k   for chunk i (1-indexed)
            - found_i = 1 if any expected fact appears in chunk i, else 0

    Args:
        response: The chatbot's response text
        expected_facts: List of facts to look for
        k: Number of chunks to divide the response into (default 5)

    Returns:
        Float between 0.0 and 1.0

    Example:
        If all facts are in the first chunk  → high score (close to 1.0)
        If all facts are in the last chunk   → low score
        If no facts are found               → 0.0
    """
    # TODO: Implement
    raise NotImplementedError
