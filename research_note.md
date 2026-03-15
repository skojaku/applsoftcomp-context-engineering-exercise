# Research Notes

## Language Models are Few-Shot Learners (Brown et al., 2020)

### Summary

1. Motivation: Pre-trained language models typically require task-specific fine-tuning on thousands of examples, which limits applicability and risks overfitting to narrow distributions. Humans can learn new language tasks from just a few examples or natural language instructions, but NLP systems struggle with this. The paper asks whether scaling language models enables task-agnostic, few-shot performance competitive with fine-tuning approaches.

2. Diff of ideas: Prior work used smaller models (up to 17B parameters) with fine-tuning or achieved poor few-shot results (e.g., 4% on Natural Questions). This paper trains GPT-3 with 175B parameters (10x larger than any previous non-sparse model) and evaluates purely via in-context learning without gradient updates. The key insight is that meta-learning abilities—using the model's context window to specify tasks via demonstrations—improve dramatically with scale.

3. Method: GPT-3 is an autoregressive transformer trained on 300 billion tokens from diverse web corpora. Evaluation uses three settings: few-shot (10-100 demonstrations in context), one-shot (single demonstration plus instruction), and zero-shot (instruction only). The model's 2048-token context window holds demonstrations as conditioning. A series of smaller models (125M to 13B parameters) enables scaling analysis.

4. Results: GPT-3 achieves strong performance across 42+ benchmarks. In few-shot settings it reaches state-of-the-art on some tasks: 71.2% on TriviaQA (closed-book), 85.0 F1 on CoQA. Performance scales smoothly with model size, and the gap between zero/one/few-shot widens with scale, suggesting larger models are better meta-learners. However, performance lags on NLI tasks (ANLI) and some reading comprehension (RACE, QuAC). Human evaluators struggle to distinguish GPT-3's synthetic news articles from human-written ones.

5. Significance: This work demonstrates that scale alone—without architectural innovation or fine-tuning—enables broad task adaptability through in-context learning. The 175B parameter model shows that few-shot learning can approach fine-tuning performance on many tasks while requiring no task-specific gradient updates. This suggests a path toward more general, fluid language systems that learn tasks at inference time rather than through expensive fine-tuning.

---

## Context versus Prior Knowledge in Language Models (Du et al., 2024)

### Summary

1. Motivation: Language models must integrate prior knowledge from pretraining with new information in context when answering questions. The authors hypothesize that models rely more on prior knowledge for familiar entities (due to higher training corpus exposure) and are more easily persuaded by some contexts than others.

2. Diff of ideas: Unlike prior work that produces single aggregate metrics for model reliance on entity bias (e.g., memorization ratio), this paper develops entity-specific and context-specific metrics grounded in information theory. This allows measuring the interplay of context and prior knowledge beyond adversarial knowledge conflict cases.

3. Method: Two mutual information-based metrics are proposed: the persuasion score $\psi(c, q(e)) = \text{KL}(p(A | c, q(e)) || p(A | q(e)))$ measures how much a context changes the model's answer distribution for a query about an entity; the susceptibility score $\chi(q(e)) = I(C; A | q(E) = q(e))$ measures how much the model's answer distribution can be swayed across all contexts. Experiments use 122 relations from YAGO, 100 entities per relation (real and GPT-4-generated fake), and 600 contexts varying in relevance, assertiveness, and negation across six Pythia models (70m to 12b).

4. Results: Relevant contexts are consistently more persuasive than irrelevant ones (95-100% of open queries, 83-100% of closed queries show significant results). Assertive contexts are more persuasive than base contexts for closed queries but not open queries, with strongest effects in medium-sized models (1.4b, 2.8b). Familiar entities have significantly lower susceptibility scores than unfamiliar fake entities (73/122 open queries, 61/122 closed queries for Pythia-6.9b). Susceptibility scores show a decreasing upper bound as training data co-occurrence frequency increases (Spearman $\rho = -0.23$). Case studies find enemy duos are less susceptible than friend duos, and masculine names have higher susceptibility than feminine names when swapping genders in stereotypical contexts.

5. Significance: The metrics provide valid, reliable, and interpretable tools for analyzing context-prior knowledge interactions in LMs. Applications include social science measurement (understanding annotation reliability for different entity types) and gender bias analysis. The framework enables greater control over model behavior and can extend to retrieval-augmented generation, model editing, and few-shot learning.

---
