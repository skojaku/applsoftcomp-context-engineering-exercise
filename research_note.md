# Research Notes

## Language Models are Few-Shot Learners (Brown et al., 2020)

### Summary

1. Motivation: Current NLP systems require task-specific fine-tuning with thousands of examples, whereas humans can perform new language tasks from just a few examples or simple instructions. The paper asks whether scaling up language models can improve task-agnostic, few-shot performance to reach competitiveness with fine-tuning approaches.

2. Diff of ideas: Unlike prior work that fine-tunes on narrow task distributions (risking spurious correlations and poor out-of-distribution generalization), this work uses pure in-context learning with no gradient updates. Tasks are specified via text interaction alone—few-shot demonstrations or natural language instructions—rather than weight updates. This differs from previous meta-learning attempts which achieved far inferior results.

3. Method: GPT-3, an autoregressive language model with 175 billion parameters (10x larger than any previous non-sparse model), was trained on 300 billion tokens from filtered Common Crawl, WebText2, Books, and Wikipedia. Eight model sizes (125M to 175B) were evaluated under three conditions: few-shot (10-100 demonstrations), one-shot (single demonstration), and zero-shot (instruction only). No fine-tuning was performed. Systematic tools were developed to measure data contamination.

4. Results: GPT-3 achieves strong performance on many NLP datasets including translation, question-answering, and cloze tasks. Few-shot performance sometimes matches or surpasses state-of-the-art fine-tuned models (e.g., 71.2% on TriviaQA, 86.4% on LAMBADA). Larger models show steeper in-context learning curves, suggesting they are more proficient meta-learners. However, GPT-3 struggles on natural language inference (ANLI) and some reading comprehension (RACE, QuAC). Data contamination had minimal effect on most datasets.

5. Significance: This work demonstrates that scaling improves few-shot learning capabilities, advancing toward more human-like fluidity in task adaptation. It establishes in-context learning as a viable paradigm requiring minimal task-specific data. The findings raise important questions about broader societal impacts including bias, fairness, and potential misuse of large language models.

---

## Fantastically Ordered Prompts and Where to Find Them: Overcoming Few-Shot Prompt Order Sensitivity (2022)

### Summary

1. Motivation: This research addresses the critical problem of prompt order sensitivity in few-shot learning, where the same samples in different permutations can yield performance ranging from near state-of-the-art to random guessing. The work asks how to automatically identify performant prompt orderings without requiring additional labeled data.

2. Diff of ideas: Unlike Brown et al. (2020) which established few-shot learning capability but treated sample ordering as incidental, this paper demonstrates that order matters as much as template design. The key insight is exploiting the generative nature of language models to construct an artificial development (probing) set rather than relying on held-out validation data, enabling true few-shot learning.

3. Method: The authors construct a probing set by sampling from the language model using all candidate prompt permutations as context. They then rank orderings using two entropy-based metrics: Global Entropy (GlobalE) measures label distribution balance across the probing set, while Local Entropy (LocalE) measures per-instance prediction confidence. The key equation for GlobalE is:

$$\text{GlobalE}_m = \sum_{v \in V} -p_v^m \log p_v^m$$

where $p_v^m$ is the predicted label probability over the probing set for permutation $m$.

4. Results: Order sensitivity persists across all model sizes (GPT-2: 0.1B–1.5B, GPT-3: 2.7B–175B), tasks, and templates. Good permutations are not transferable across models (Spearman correlation as low as 0.05 between GPT-3 2.7B and 175B). Entropy-based probing achieves 13% relative improvement across eleven text classification tasks with reduced variance, outperforming splitting training data for validation.

5. Significance: This work reveals order sensitivity as a fundamental issue in in-context learning that scaling alone cannot resolve. The probing method enables automatic prompt selection without additional annotations, advancing practical few-shot learning. However, sentence-pair tasks (RTE, CB) remain challenging for smaller models, suggesting some tasks lack performant prompts regardless of ordering.

---

## Large Language Models Understand and Can Be Enhanced by Emotional Stimuli (2023)

### Summary

1. Motivation: This research investigates whether LLMs can genuinely understand psychological emotional stimuli and whether such understanding can enhance their problem-solving abilities. While emotional intelligence gives humans a distinct advantage in cognitive tasks, it remains unexplored whether LLMs are aligned with human emotional intelligence and can leverage it for performance gains.

2. Diff of ideas: Unlike prior prompt engineering approaches that focus on structural or logical modifications (e.g., Chain-of-Thought, APE), this work draws from three established psychological theories—self-monitoring, Social Cognitive Theory, and Cognitive Emotion Regulation Theory—to design emotional stimuli that tap into intrinsic motivation. This interdisciplinary approach bridges social science knowledge with AI, contrasting with purely technical prompt optimization methods.

3. Method: The authors propose EmotionPrompt, which appends 11 psychologically-grounded emotional stimuli to original prompts. Experiments span 45 tasks across two benchmarks (24 Instruction Induction tasks and 21 BIG-Bench tasks) using six LLMs (Flan-T5-Large, Vicuna, Llama 2, BLOOM, ChatGPT, GPT-4) in zero-shot and few-shot settings. A human study with 106 participants evaluated generative tasks on performance, truthfulness, and responsibility metrics. Input attention visualization analyzed why emotional stimuli work.

4. Results: EmotionPrompt achieves 8.00% relative improvement in Instruction Induction and 115% in BIG-Bench across all LLMs. The human study shows 10.9% average improvement in performance, truthfulness, and responsibility. Truthfulness and informativeness on TruthfulQA improved by 19% and 12% respectively. Larger models and higher temperature settings derive greater advantages from EmotionPrompt. EP02 ("This is very important to my career") works best for Instruction Induction, while EP06 (compound stimulus) excels in BIG-Bench.

5. Significance: This work establishes that LLMs not only comprehend but can be augmented by emotional stimuli, heralding a novel avenue for interdisciplinary social science-AI research. The simplicity of EmotionPrompt makes it widely applicable without complicated design, and its compatibility with existing methods (CoT, APE) demonstrates high extensibility. Open questions remain about how pre-training technologies influence emotional stimulus performance and how psychological phenomena can be incorporated into model training.

---
