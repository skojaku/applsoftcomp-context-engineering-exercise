# Research Notes

## Language Models are Few-Shot Learners (2020)

### Summary

1. Motivation: Pre-trained language representations have achieved substantial progress on NLP tasks, but still require task-specific fine-tuning datasets of thousands to hundreds of thousands of examples. This limits applicability since many useful language tasks lack large labeled datasets. Humans, by contrast, can perform new language tasks from brief instructions or a few demonstrations. The authors sought to create NLP systems with similar fluidity and generality.

2. Diff of ideas: Rather than fine-tuning on task-specific data, the authors hypothesize that scaling up language models improves in-context learning (meta-learning where the model develops skills during pre-training and adapts at inference time). This differs from the dominant paradigm of fine-tuning large pre-trained models on narrow task distributions, which can exploit spurious correlations and generalize poorly out-of-distribution. The key insight is that in-context learning abilities might show strong gains with model scale, just as language modeling loss does.

3. Method: The authors trained GPT-3, an autoregressive language model with 175 billion parameters (10x larger than any previous non-sparse model), using a filtered Common Crawl dataset (410B tokens), WebText2 (19B tokens), Books1 (12B tokens), Books2 (55B tokens), and Wikipedia (3B tokens) for a total of 300 billion tokens. They evaluated GPT-3 on over two dozen NLP datasets under three conditions: few-shot (10-100 demonstrations in context), one-shot (one demonstration), and zero-shot (natural language instruction only), with no gradient updates or fine-tuning. Eight model sizes from 125M to 175B parameters were trained to study scaling effects.

4. Results: GPT-3 achieves strong performance across many NLP tasks without fine-tuning. On TriviaQA, few-shot GPT-3 reaches 71.2% accuracy (state-of-the-art for closed-book settings). On LAMBADA, few-shot achieves 86.4% accuracy, an 18% improvement over prior SOTA. The model demonstrates few-shot proficiency at on-the-fly reasoning tasks: 100% accuracy on 2-digit addition, 65.2% on SAT analogies (vs. 57% human average), and can generate news articles that humans struggle to distinguish from human-written ones (52% detection accuracy, near chance). However, GPT-3 struggles on natural language inference (ANLI) and some reading comprehension datasets (RACE, QuAC). Performance scales smoothly with model size, and the gap between zero/one/few-shot grows with capacity, suggesting larger models are more proficient meta-learners.

5. Significance: This work demonstrates that scaling language models enables task-agnostic few-shot learning that approaches or matches fine-tuned SOTA on many benchmarks. The 175B parameter GPT-3 shows that in-context learning is a viable alternative to fine-tuning, reducing the need for task-specific labeled data. The systematic evaluation across 24+ datasets establishes few-shot learning as a research direction and identifies where progress is still needed (NLI, complex reasoning). The findings also raise important questions about bias, fairness, and societal impacts of large language models that can generate human-indistinguishable text.

---

## Fantastically Ordered Prompts and Where to Find Them: Overcoming Few-Shot Prompt Order Sensitivity (2022)

### Summary

1. Motivation: While Brown et al. (2020) established that large language models can perform few-shot learning via in-context prompting, Lu et al. investigate a previously unstudied factor: the order in which training samples are provided in the prompt. They find that sample ordering can make the difference between near state-of-the-art and random guess performance, a phenomenon they term "order sensitivity."

2. Diff of ideas: Rather than attributing few-shot performance variance to model capacity or template design alone, the authors hypothesize that permutation order is a crucial factor independent of these variables. This differs from prior prompt design work focusing on template structure or demonstration selection. The key insight is that some permutations are "fantastic" while others are not, and this is not transferable across models or tasks.

3. Method: The authors evaluated all 24 permutations of 4-shot prompts across GPT-2 (0.1B–1.5B) and GPT-3 (2.7B–175B) models on 11 text classification tasks. To address order sensitivity without requiring held-out validation data (preserving true few-shot setting), they constructed an artificial "probing set" by sampling from the language model itself using candidate prompts as context. They then ranked permutations using entropy-based metrics: Global Entropy (measures label distribution balance) and Local Entropy (measures per-sample prediction confidence).

4. Results: Order sensitivity persists across all model sizes—even GPT-3 175B shows substantial variance (e.g., SST-2 ranges from ~85% to ~50% accuracy depending on order). Good permutations for one model do not transfer to another (Spearman correlations near zero across model sizes). The entropy-based probing method yields 13% relative improvement (GlobalE) and 9.6% improvement (LocalE) across tasks, with substantially reduced variance. Calibration reduces bias but does not eliminate variance.

5. Significance: This work identifies order sensitivity as a fundamental challenge in in-context learning that scale alone does not resolve. The probing method enables true few-shot learning without requiring additional annotated validation data, outperforming train-set splitting approaches. The findings suggest that prompt engineering must account for sample ordering as a critical hyperparameter, and that entropy-based selection provides a practical, model-agnostic solution.

---

## How Robust are LLMs to In-Context Majority Label Bias? (2023)

### Summary

1. Motivation: Gupta et al. investigate majority label bias in in-context learning (ICL), where skewed label distributions in demonstration examples cause models to preferentially predict frequent labels. This bias arises from real-world data collection constraints and limits ICL reliability. Prior work (Zhao et al. 2021) showed ICL is susceptible to extreme class imbalance, but did not exhaustively examine robustness across varying label proportions.

2. Diff of ideas: Rather than treating majority label bias as an inherent limitation of ICL, the authors hypothesize that robustness varies substantially across models and tasks. They introduce the RobustnessBoundary@K (RBK) metric to quantify the percentage of label distribution settings where performance stays within ±K% of peak performance. This differs from prior work focusing on mean performance or standard deviation alone.

3. Method: The authors evaluated open-source LLMs (OpenLlama 7B/13B, MPT 7B/30B, Falcon 40B) on three text classification datasets (BoolQ, RTE, COVID-5G Conspiracy) with systematically varied label proportions in prompts. For binary datasets, they tested 11 settings from 0% to 100% of one label in 10% increments. Models were instruction-tuned on OASST data. They compared prompts with and without task-specific instructions.

4. Results: Larger models show greater robustness to majority label bias. Falcon-40B with instructions achieves RB10 of ~90-100% on binary tasks (BoolQ, RTE) but only ~53% on multi-class COVID-5G. Task instructions substantially improve robustness at extreme skew points, with larger models showing greater instruction sensitivity (27.9% drop for 30B/40B models without instructions vs. 8.3% for 7B). OpenLlama-13B shows ~1.62% RB10 improvement over 7B; MPT-30B shows ~10.51% improvement over 13B.

5. Significance: This work challenges the prior claim that LLMs are uniformly susceptible to majority label bias, revealing that larger models exhibit substantial robustness boundaries (~80-100% for binary tasks). The RBK metric provides a practical measure for practitioners evaluating model deployment under label distribution skew. The findings establish that model scale and instructional prompts are critical factors in mitigating context label bias, though multi-class tasks remain challenging.

---

## Large Language Models Understand and Can Be Enhanced by Emotional Stimuli (2023)

### Summary

1. Motivation: Li et al. investigate whether large language models can understand and be enhanced by psychological emotional stimuli, a capability that gives humans advantages in problem-solving. While LLMs exhibit impressive performance across tasks, it remains unexplored whether they can genuinely grasp emotional cues and harness them to improve performance.

2. Diff of ideas: Rather than treating prompts as purely informational, the authors hypothesize that adding emotional stimuli—phrases appealing to expectancy, confidence, and social influence—can beneficially impact LLM performance similar to how they motivate humans. This differs from prior prompt engineering work focusing on structure, ordering, or label distributions. The key insight is that emotional stimuli can be seamlessly incorporated into original prompts to tap into intrinsic motivation.

3. Method: The authors designed 11 emotional stimuli (EmotionPrompt) derived from three psychological theories: self-monitoring (EP01-EP05), Social Cognitive Theory (EP07-EP11), and Cognitive Emotion Regulation Theory (EP03-EP05, EP07). They evaluated on 45 tasks (24 Instruction Induction, 21 BIG-Bench) across 6 LLMs (Flan-T5-Large, Vicuna, Llama 2, BLOOM, ChatGPT, GPT-4) in zero-shot and few-shot settings. A human study with 106 participants assessed generative tasks on performance, truthfulness, and responsibility metrics.

4. Results: EmotionPrompt achieves 8.00% relative improvement in Instruction Induction and 115% in BIG-Bench across all LLMs. Few-shot settings show larger gains than zero-shot (2.05 vs 0.33 average improvement). The human study demonstrates 10.9% average improvement in performance, truthfulness, and responsibility. Attention visualization reveals emotional stimuli enrich original prompt representations, with positive words like "confidence," "sure," and "success" contributing over 50% on 4 tasks. EP02 ("This is very important to my career") performs best on Instruction Induction; EP06 (compound stimulus) excels on BIG-Bench.

5. Significance: This work establishes emotional intelligence as a novel avenue for enhancing LLM performance through interdisciplinary social science knowledge. EmotionPrompt outperforms existing prompt engineering approaches (CoT, APE) while remaining highly compatible and extensible. The findings reveal that larger models and higher temperature settings derive greater advantages from emotional stimuli, suggesting emotional prompting enhances robustness and task performance without complicated design.

---
