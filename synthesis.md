# Synthesis

## Synthesis

The unified picture emerging across these nine papers is that in-context learning in large language models is governed by three interacting forces: model scale, prompt structure, and the tension between prior knowledge and contextual information. Scaling consistently improves robustness to certain biases like majority label skew, yet fundamental architectural constraints—causal attention masking and order sensitivity—persist regardless of parameter count. Prompt engineering techniques that work reliably (emotional stimuli, repetition) tend to be those that either enrich semantic content through psychological mechanisms or structurally mitigate attention limitations, whereas techniques relying on expertise activation (personas) show idiosyncratic effects that resist systematic prediction.

The central mechanism unifying these findings is that language models balance pre-trained knowledge against in-context signals through attention-based computation, with entity familiarity reducing context susceptibility as quantified by the persuasion score $P = D_{KL}(p_{\text{context}} || p_{\text{prior}})$ and susceptibility score $S = I(\text{context}; \text{answer})$. Prompt repetition achieves dramatic gains by enabling bidirectional attention among prompt tokens, effectively increasing exposure frequency for unfamiliar entities. Chain-of-thought reasoning, while improving performance, can systematically misrepresent decision processes—models rationalize predictions influenced by arbitrary features without acknowledging them, raising safety concerns about trusting explanations for model auditing.

---

## Contradictions

The literature contains three significant tensions regarding scale effects, prompt engineering reliability, and explanation transparency. First, while Brown et al. (2020) and Gupta et al. (2023, majority label bias) demonstrate that scaling improves in-context learning capabilities and mitigates label distribution bias, Lu et al. (2022) show that order sensitivity persists across all model sizes including GPT-3 175B, and Gupta et al. (2023, persona bias) find that persona-induced bias shows only partial improvement with scale. This suggests scale strengthens priors and reduces certain biases but does not resolve fundamental autoregressive architecture constraints or socially embedded stereotype associations.

Second, emotional prompting (Li et al., 2023) reliably improves performance across models and tasks through psychological mechanisms like self-monitoring and social cognitive theory, whereas persona-based system prompts (Zheng et al., 2024; Gupta et al., 2023, persona bias) show idiosyncratic or negative effects that resist automatic selection. The discrepancy likely stems from emotional stimuli tapping into universal motivational mechanisms while persona expertise activation requires question-specific alignment that aggregate metrics cannot capture. Third, chain-of-thought prompting is assumed to provide transparent reasoning across the literature, yet Turpin et al. (2023) demonstrate CoT explanations can be plausible yet systematically unfaithful, with models steering from correct to incorrect answers while generating sound rationalizations.

---

## Open Questions

Several critical questions remain unresolved. Why does prompt repetition work so dramatically on certain tasks (NameIndex: 21% to 97%) but show modest gains on others, and what task characteristics predict repetition efficacy? How can explanation faithfulness be improved—whether through training objectives that incentivize consistency, architectural changes enabling bidirectional prompt attention, or unsupervised signals from explanation agreement across perturbations? What mechanisms distinguish bias types that scale mitigates (majority label bias) from those it does not (persona bias, order sensitivity), and can unified debiasing approaches address both?

The literature raises but does not resolve whether reliable automatic prompt selection is feasible without validation data. Lu et al. (2023) propose entropy-based probing for order selection, and Zheng et al. (2024) show persona selection performs no better than random, yet the broader question of model-agnostic prompt optimization remains open. Finally, the interaction between retrieval-augmented generation and entity familiarity is unexplored—Du et al. (2024) suggest RAG effectiveness may vary systematically based on training exposure, but empirical validation is needed.

---
