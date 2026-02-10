# AI Chatbot Evaluation Exercise

## Overview

You are joining a team responsible for an AI-powered support widget for **Wick & Glow**, an e-commerce candle company. The widget is embedded across the site and answers customer questions using the current page’s content as context.

The existing chatbot implementation contains bugs and lacks a proper evaluation strategy. Your task is to **fix the code** and **design an evaluation framework** to measure response quality. In production AI systems, evaluation is a core requirement.

## Production Constraints

- ~100 concurrent users at peak
- Sub-2-second response time requirement
- Widget is loaded on all product and FAQ pages

---

## Part 1: Code Review & Fixes

The file `chatbot.py` contains the current chatbot implementation. It has **3 bugs** to find and fix.

For each bug:
1. Explain what the issue is
2. Explain the production impact
3. Provide the fix

> **Note:** You do not need AWS credentials or access to Bedrock to complete this exercise. Focus on the code logic and structure.

---

## Part 2: Evaluation Framework

The files for the Evaluation Framework are as follows:
- `data/faq.json` — The Wick & Glow FAQ knowledge base
- `data/eval_dataset.json` — 10 pre-built test cases with page context, user questions, and expected facts
- `eval/metrics.py` — Skeleton file for your metric implementations

### Your Task

**Implement three evaluation metrics** in `eval/metrics.py`:

#### 1. Fact Recall
What proportion of expected facts are present in the response?

```
fact_recall = |found_facts ∩ required_facts| / |required_facts|
```

#### 2. MRR (Mean Reciprocal Rank)
How early does the first relevant fact appear in the response? Measures whether the chatbot front-loads the important information.

```
MRR = (1/N) × Σ(1/rank_i)
```
where `rank_i` is the sentence position (1-indexed) of the first found fact in response `i`

#### 3. Freshness@k
Weighted recall that rewards facts appearing earlier in the response. A response that buries the answer at the end should score lower.

```
Freshness@k = Σ(weight_i × found_i) / Σ(weight_i)
where weight_i = (k - position_i + 1) / k
```

### Then

1. **Run your metrics** against the provided eval dataset using the mock responses in the test cases
2. **Write `RESULTS.md`** with:
   - Your metric results
   - What the scores tell you about response quality
   - What you would change about the chatbot or prompt to improve scores
   - Any additional metrics you'd recommend for production (and why)

---

## Deliverables

| File | Description |
|------|-------------|
| `chatbot.py` | Fixed chatbot (annotate your 3 fixes with comments) |
| `eval/metrics.py` | Your metric implementations |
| `eval/run_eval.py` | Script that loads the dataset, runs metrics, prints results |
| `RESULTS.md` | Analysis and recommendations |

---

## Getting Started

```bash
# No external dependencies required beyond Python 3.8+
python eval/run_eval.py
```

Good luck!
