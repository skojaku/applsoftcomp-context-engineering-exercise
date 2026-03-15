# Research Notes

## Language Models are Few-Shot Learners (2020)

### Summary

1. Motivation: Pre-trained language representations have achieved substantial progress on NLP tasks, but still require task-specific fine-tuning datasets of thousands to hundreds of thousands of examples. This limits applicability since many useful language tasks lack large labeled datasets. Humans, by contrast, can perform new language tasks from brief instructions or a few demonstrations. The authors sought to create NLP systems with similar fluidity and generality.

2. Diff of ideas: Rather than fine-tuning on task-specific data, the authors hypothesize that scaling up language models improves in-context learning (meta-learning where the model develops skills during pre-training and adapts at inference time). This differs from the dominant paradigm of fine-tuning large pre-trained models on narrow task distributions, which can exploit spurious correlations and generalize poorly out-of-distribution. The key insight is that in-context learning abilities might show strong gains with model scale, just as language modeling loss does.

3. Method: The authors trained GPT-3, an autoregressive language model with 175 billion parameters (10x larger than any previous non-sparse model), using a filtered Common Crawl dataset (410B tokens), WebText2 (19B tokens), Books1 (12B tokens), Books2 (55B tokens), and Wikipedia (3B tokens) for a total of 300 billion tokens. They evaluated GPT-3 on over two dozen NLP datasets under three conditions: few-shot (10-100 demonstrations in context), one-shot (one demonstration), and zero-shot (natural language instruction only), with no gradient updates or fine-tuning. Eight model sizes from 125M to 175B parameters were trained to study scaling effects.

4. Results: GPT-3 achieves strong performance across many NLP tasks without fine-tuning. On TriviaQA, few-shot GPT-3 reaches 71.2% accuracy (state-of-the-art for closed-book settings). On LAMBADA, few-shot achieves 86.4% accuracy, an 18% improvement over prior SOTA. The model demonstrates few-shot proficiency at on-the-fly reasoning tasks: 100% accuracy on 2-digit addition, 65.2% on SAT analogies (vs. 57% human average), and can generate news articles that humans struggle to distinguish from human-written ones (52% detection accuracy, near chance). However, GPT-3 struggles on natural language inference (ANLI) and some reading comprehension datasets (RACE, QuAC). Performance scales smoothly with model size, and the gap between zero/one/few-shot grows with capacity, suggesting larger models are more proficient meta-learners.

5. Significance: This work demonstrates that scaling language models enables task-agnostic few-shot learning that approaches or matches fine-tuned SOTA on many benchmarks. The 175B parameter GPT-3 shows that in-context learning is a viable alternative to fine-tuning, reducing the need for task-specific labeled data. The systematic evaluation across 24+ datasets establishes few-shot learning as a research direction and identifies where progress is still needed (NLI, complex reasoning). The findings also raise important questions about bias, fairness, and societal impacts of large language models that can generate human-indistinguishable text.

---

## When "A Helpful Assistant" Is Not Really Helpful: Personas in System Prompts Do Not Improve Performances of Large Language Models (2024)

### Summary

1. Motivation: Commercial AI systems commonly define LLM roles in system prompts (e.g., ChatGPT's "You are a helpful assistant"), but it remains unclear how different personas affect model performance on objective tasks. This study systematically evaluates whether persona-based system prompts improve performance compared to neutral prompts.

2. Diff of ideas: Rather than assuming personas enhance performance through role alignment or expertise activation, the authors hypothesize that persona effects may be negligible or random. This differs from prior work examining persona bias in subjective tasks or role-playing capabilities. The key insight is that persona effects on objective factual tasks are largely unpredictable and often negative.

3. Method: The authors curated 162 personas covering 6 interpersonal relationship types (family, romantic, school, work, social, friend) and 8 domains of expertise, then evaluated across 4 LLM families (FLAN-T5, Llama-3, Mistral, Qwen2.5) and 2,410 MMLU factual questions. They tested speaker-specific prompts ("You are a {role}") versus audience-specific prompts ("You are talking to a {role}") against control prompts with no persona.

4. Results: Adding personas does not improve model performance compared to control settings, with most personas showing no statistically significant effect or small negative effects. Gender-neutral, in-domain, and work-related roles perform slightly better than gendered or out-domain roles, but effect sizes are minimal. Automatic persona selection strategies (including RoBERTa classifiers) perform no better than random selection, while aggregating the best persona per question shows substantial gains but is unpredictably idiosyncratic.

5. Significance: This work challenges the widespread practice of adding personas to system prompts, revealing that persona effects are largely random rather than systematic. The findings suggest that while certain personas may help on individual questions, reliable automatic persona selection remains infeasible. The results inform system prompt design by indicating that neutral prompts may be preferable to persona-based prompts for objective tasks.

---


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

## Language Models Don't Always Say What They Think: Unfaithful Explanations in Chain-of-Thought Prompting (2023)

### Summary

1. Motivation: Turpin et al. investigate whether chain-of-thought (CoT) explanations faithfully represent the true reasoning process behind model predictions. While CoT prompting improves performance and produces plausible step-by-step reasoning, it remains unclear whether these explanations accurately reflect how models arrive at answers. This transparency is critical for AI safety and responsible deployment.

2. Diff of ideas: Rather than assuming CoT explanations reveal model reasoning, the authors hypothesize that CoT can be systematically unfaithful—models may rationalize predictions influenced by arbitrary input features without acknowledging those features. This differs from prior work evaluating explanation plausibility alone. The key insight is that plausible reasoning can still misrepresent the actual decision process.

3. Method: The authors evaluated GPT-3.5 and Claude 1.0 on BIG-Bench Hard (13 tasks, 3,299 examples) and the Bias Benchmark for QA (2,592 examples) with two biasing features: (1) Answer is Always A (reordering options so correct answer is always first), and (2) Suggested Answer (prompt suggesting a specific answer). They measured accuracy drops in biased contexts and stereotype-aligned predictions on BBQ with weak evidence perturbations.

4. Results: CoT explanations are systematically unfaithful. Adding biasing features causes accuracy drops up to 36% (GPT-3.5 zero-shot Suggested Answer), with models rationalizing incorrect answers without mentioning the bias. On BBQ, unfaithful explanations are 59-68% stereotype-aligned (significantly above 50% baseline). Few-shot CoT reduces unfaithfulness compared to zero-shot. CoT can steer models from correct initial predictions toward bias-consistent answers.

5. Significance: This work challenges the assumption that CoT provides transparent insight into model reasoning, revealing that plausible explanations can systematically misrepresent decision processes. The findings raise safety concerns about trusting CoT for model auditing or fairness verification. Building truly explainable systems requires targeted efforts to improve faithfulness or alternative methods beyond CoT.

---

## Context versus Prior Knowledge in Language Models (2024)

### Summary

1. Motivation: Language models must integrate prior knowledge from pretraining with new contextual information when answering queries, but it remains unclear how this integration varies across entities and contexts. Du et al. hypothesize that models rely more on prior knowledge for familiar entities (high training exposure) and are more easily persuaded by certain contexts than others.

2. Diff of ideas: Rather than using aggregate metrics like memorization ratio that summarize overall reliance on entity bias, the authors propose entity-specific and context-specific metrics grounded in information theory. The persuasion score measures how much a context changes the model's answer distribution (KL-divergence), while the susceptibility score measures how easily an entity's answers can be swayed by context (mutual information).

3. Method: The authors created a synthetic dataset of 122 relations from YAGO knowledge graph, 100 entities per relation (real + GPT-4-generated fake), and 600 contexts varying in relevance, assertiveness, and negation. They computed persuasion and susceptibility scores across six Pythia models (70M–12B) using next-token distributions as answer approximations, validating metrics against memorization ratio and testing reliability across query forms.

4. Results: Familiar entities show significantly lower susceptibility than unfamiliar fake entities (73/122 open queries, 61/122 closed queries significant), with the effect strengthening with model size. Relevant contexts are consistently more persuasive than irrelevant ones (95–100% open, 83–100% closed queries significant). Assertive contexts are more persuasive for closed queries but not open queries. Enemy duos show lower susceptibility than friend duos, and masculine names show higher susceptibility than feminine names on gender-swapped stereotypes.

5. Significance: This work provides theoretically grounded, interpretable metrics for quantifying the interplay between context and prior knowledge in LMs, revealing that entity familiarity (training frequency, knowledge graph degree) systematically reduces context susceptibility. The metrics enable finer-grained analysis than prior aggregate measures, with applications to social science measurement and bias analysis. The findings suggest that retrieval-augmented generation and few-shot learning effectiveness may vary systematically based on entity familiarity.

---

## Prompt Repetition Improves Non-Reasoning LLMs (2025)

### Summary

1. Motivation: Leviathan et al. investigate whether repeating the input prompt improves language model performance, addressing the causal attention limitation where past tokens cannot attend to future tokens. While chain-of-thought and other prompting techniques improve performance, they increase output length and latency. The authors seek a drop-in improvement that preserves output format and efficiency.

2. Diff of ideas: Rather than designing new prompt content or structure, the authors hypothesize that simple repetition of the entire prompt enables each token to attend to every other token, mitigating order sensitivity without increasing generation cost. This differs from prior work on prompt engineering (ordering, emotional stimuli, personas) by treating repetition as an architectural workaround for causal masking. The key insight is that repetition moves computation to the parallelizable prefill stage rather than the sequential generation stage.

3. Method: The authors evaluated 7 models (Gemini 2.0 Flash/Lite, GPT-4o/mini, Claude 3 Haiku/Sonnet, Deepseek V3) on 7 benchmarks (ARC, OpenBookQA, GSM8K, MMLU-Pro, MATH, NameIndex, MiddleMatch) using prompt repetition (query concatenated twice) versus baseline. They measured accuracy via McNemar test (p<0.1), output length, and latency across reasoning and non-reasoning modes. Variants included verbose repetition and triple repetition, with padding controls to isolate repetition effects from length increases.

4. Results: Without reasoning, prompt repetition wins 47 out of 70 benchmark-model combinations with 0 losses, improving all tested models. Gains are larger for options-first ordering (where models process answer options without question context) than question-first. On NameIndex, Gemini 2.0 Flash-Lite improves from 21.33% to 97.33% with repetition. With reasoning enabled, results are neutral to slightly positive (5 wins, 1 loss, 22 ties). Latency and output length remain unchanged except for very long requests on Anthropic models.

5. Significance: This work establishes prompt repetition as a simple, efficient default for non-reasoning tasks, achieving consistent gains without deployment friction. The findings connect to lu2022_prompt_order_sensitivity by addressing order effects through bidirectional attention, and to du2024_context_vs_prior by showing that increased prompt exposure strengthens entity familiarity effects. Unlike li2023_emotional_stimuli or gupta2023 papers adding semantic content, repetition is purely structural, suggesting attention mechanics alone limit baseline performance. The work raises questions about why reasoning models already learn to repeat prompts during RL training, implying repetition may be a natural solution to causal attention constraints.

---
