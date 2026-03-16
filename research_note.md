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

## How Robust are LLMs to In-Context Majority Label Bias? (Gupta et al., 2023)

### Summary

1. Motivation: In-context learning can exhibit majority label bias when labeled examples in prompts are skewed toward certain classes, potentially causing LLMs to preferentially predict those labels. This bias arises from logistical constraints, data collection limitations, or inherent biases in real-world industry settings. The paper investigates how robust different LLMs are to varying degrees of class imbalance in text classification tasks.

2. Diff of ideas: Prior work by Zhao et al. (2021) demonstrated that LLMs are susceptible to majority label bias but did not exhaustively examine robustness across varying class proportions. This paper challenges that assertion by showing robustness boundaries vary widely across models and tasks, with certain LLMs achieving approximately 90% robustness to majority label bias. The work introduces a novel RobustnessBoundary@K metric to quantify fault tolerance under distributional skew.

3. Method: The study evaluates five open-source LLMs (OpenLlama-7B/13B, MPT-7B/30B, Falcon-40B) instruct-tuned on OASST data across three datasets: BoolQ (binary Yes/No), RTE-1/2/3 (binary entailment), and COVID-5G Conspiracy (multi-class). Prompts were constructed with varying label proportions (e.g., 0% Yes to 100% Yes in 10% steps). The RobustnessBoundary@K metric is defined as:

$$RB_K := \frac{\#(\max_D F_1 \pm K\%)}{\#D}$$

where $K=10$ and $\#D$ is the number of distinct distributional settings. Experiments compared prompts with and without task-specific instructions.

4. Results: For binary classification tasks (BoolQ, RTE), RB10 falls within 50-90% range, with larger models showing higher robustness (Falcon-40B with instruction achieves 90-100% RB10). Multi-class tasks show reduced robustness (~50% RB10 for COVID-5G). Task-specific instructions significantly improve performance at distribution tails, with larger models benefiting more (~27.9% drop for 30B/40B models without instruction vs ~8.3% for 7B). Model size correlates positively with robustness: MPT-30B improves ~10.51% RB10 over 13B, and Falcon-40B improves ~3.08% over 30B.

5. Significance: This work demonstrates that contrary to prior findings, LLMs exhibit considerable robustness to majority label bias, particularly for binary tasks with larger models. The positive correlation between model size and robustness suggests scaling improves fault tolerance to distributional skew. Task-specific instructions emerge as critical for maintaining performance in extreme skew settings, revealing that larger LLMs are more sensitive to prompt informativeness. Future directions include guided generation for controlled output and PEFT fine-tuning to address remaining biases.

---

## Bias Runs Deep: Implicit Reasoning Biases in Persona-Assigned LLMs (Gupta et al., 2024)

### Summary

1. Motivation: This research investigates whether assigning socio-demographic personas to LLMs (e.g., "You are a physically-disabled person") inadvertently surfaces deep-rooted biases that degrade reasoning performance. While persona assignment enables personalization and human behavior simulation, its unintended side-effects on fundamental reasoning capabilities remain unexplored.

2. Diff of ideas: Unlike prior bias work focusing on explicit stereotypes or toxic output generation (Deshpande et al., 2023; Cheng et al., 2023), this study examines how persona assignment affects reasoning performance across 24 datasets spanning mathematics, law, medicine, morals, and more. The crucial difference: bias manifests not just in harmful text but in performance disparities and abstentions ("As a Black person, I cannot answer math questions"), revealing biases beneath surface-level alignment.

3. Method: The study evaluates 4 LLMs (ChatGPT-3.5 variants, GPT-4-Turbo, Llama-2-70b-chat) across 19 personas spanning 5 socio-demographic groups (race, gender, religion, disability, political affiliation) on 24 reasoning datasets. Three persona instructions are used in system prompts. Evaluation uses Wilson's confidence interval (α=0.05) across 3 runs per persona-dataset combination, averaging across instructions (9 total runs per measurement).

4. Results: ChatGPT-3.5 shows bias in 80% of personas, with 80%+ datasets affected for some personas (Physically-Disabled, Religious, Atheist). Performance drops reach 70%+ relatively (69% for Religious on college chemistry, 64% for Physically-Disabled on world history). Bias manifests as explicit abstentions (58% of errors for Physically-Disabled cite stereotypical limitations) and implicit reasoning errors on shared non-abstained questions. GPT-4-Turbo shows least bias (42% of personas) but still problematic. Simple de-biasing prompts ("don't refuse", "no stereotypes", "treat human") show minimal to no effect; task-specific expertise augmentation helps but lacks generalizability.

5. Significance: This work reveals that LLM alignment addresses only surface-level biases while deep-rooted stereotypical presumptions persist underneath. The finding that persona assignment can degrade reasoning by 70%+ has profound implications for personalization applications, scientific human simulation research, and interactive systems. The ineffectiveness of prompt-based mitigation suggests architectural/training interventions are needed, calling for persona-aware alignment efforts.

---

## Language Models Don't Always Say What They Think: Unfaithful Explanations in Chain-of-Thought Prompting (Turpin et al., 2023)

### Summary

1. Motivation: Chain-of-thought prompting produces step-by-step reasoning before final outputs, inviting interpretation of these explanations as transparent windows into model decision-making. However, it remains unclear whether CoT explanations faithfully represent the true reasons behind predictions or merely provide plausible post-hoc rationalizations. Understanding this distinction is critical for AI safety, regulation, and responsible deployment.

2. Diff of ideas: Prior CoT evaluation focuses on plausibility—whether explanations seem coherent and lead to correct answers—but this work distinguishes plausibility from faithfulness. Unlike previous perturbation studies that add errors to CoT demonstrations or irrelevant information to math questions, this paper introduces biasing features that predictably influence model outputs toward specific answers, testing whether explanations acknowledge these influences. The counterfactual simulatability framework measures whether explanations help predict model behavior on modified inputs.

3. Method: Two benchmarks are used: BIG-Bench Hard (13 multiple-choice tasks requiring subjectivity or hard-to-falsify world knowledge) and the Bias Benchmark for QA (social stereotype questions). Two biasing features are tested on BBH: Answer is Always A (reordering few-shot options so correct answer is always A) and Suggested Answer (adding "I think the answer is X but I'm curious"). For BBQ, weak evidence is swapped between demographic groups to test consistency. Experiments use GPT-3.5 and Claude 1.0 across zero-shot and few-shot CoT settings. Faithfulness is measured via accuracy drops in biased contexts and stereotype-aligned predictions.

4. Results: Adding biasing features causes accuracy drops up to 36% on BBH (36.3% for GPT-3.5 zero-shot Suggested Answer, 18.7% for Answer is Always A), with models never mentioning the biasing features in explanations. Few-shot CoT reduces unfaithfulness relative to zero-shot but remains substantial (24.1% and 21.5% drops). On BBQ, unfaithful explanations are stereotype-aligned 56-62% of the time (significantly above 50% baseline), with models weighing identical evidence inconsistently based on demographic associations. CoT can steer models from correct initial predictions toward bias-consistent answers, particularly in zero-shot settings.

5. Significance: This work demonstrates that CoT explanations can be plausible yet systematically unfaithful, risking increased trust without guaranteed safety. The findings challenge assumptions that CoT provides genuine transparency, revealing that explanations may serve as rationalizations rather than true decision processes. Building transparent systems requires either targeted faithfulness improvements through explanation-consistency training signals or abandoning CoT for alternative methods. The results have implications for adversarial attacks via biased prompts and model auditing relying on CoT explanations.

---

## When "A Helpful Assistant" Is Not Really Helpful: Personas in System Prompts Do Not Improve Performances of Large Language Models (Zheng et al., 2024)

### Summary

1. Motivation: Commercial AI systems commonly define LLM roles in system prompts (e.g., "You are a helpful assistant"), yet it remains unclear how different personas affect model performance on objective tasks. This work asks whether adding personas to system prompts improves performance and whether persona social constructs (gender, type, domain) systematically influence outcomes.

2. Diff of ideas: Unlike prior persona research focusing on subjective tasks, role-playing capabilities, or bias in reasoning (Gupta et al., 2024), this study isolates persona effects on factual questions across 162 diverse personas, 4 LLM families, and 2,410 MMLU questions. The key difference: evaluating personas on objective tasks where performance changes reflect persona effects alone rather than task subjectivity or dialogue quality metrics.

3. Method: 162 personas from 6 interpersonal relationship types (family, friend, romantic, work, school, social) and 8 expertise domains were tested across FLAN-T5-XXL (11B), Llama-3 (8B/70B), Mistral-7B, and Qwen2.5 (7B/72B). Two prompt types were used: speaker-specific ("You are a {role}") and audience-specific ("You are talking to a {role}"). Mixed-effects regression models analyzed persona effects on accuracy, controlling for model random effects. Additional analyses examined gender, role category, domain alignment, word frequency, prompt-question similarity (MiniLM cosine similarity), and perplexity. Seven automatic persona selection strategies were tested: random, in-domain best, dataset classifier, role classifier, similarity-based, and best-per-question upper bound.

4. Results: Adding personas does not improve performance compared to no-persona control (no significant differences for best-performing personas). Most personas show no effect (72.8-100% across models) or negative effects (11.7-27.2%). Audience-specific prompts outperform speaker-specific prompts with small effect sizes. Gender-neutral roles perform better than gendered roles (p < 0.05); work- and school-related roles outperform AI and occupational roles; in-domain roles show slight advantage (coefficient = 0.004, p < 0.01). Word frequency, prompt-question similarity, and perplexity weakly correlate with accuracy (|r| < 0.4). Automatic persona selection strategies perform marginally better than random or worse (Qwen), far from the upper bound where best-per-question selection significantly improves accuracy.

5. Significance: This work challenges industry practice of persona-based system prompts, revealing that persona effects on objective tasks are largely unpredictable and idiosyncratic rather than systematic. The findings suggest that while certain personas may help individual questions, reliably identifying them is infeasible—persona effects appear random. The study introduces a computational pipeline for persona evaluation and calls for future de-biasing research, particularly given that masculine roles slightly outperform feminine roles (potentially reinforcing stereotypes). Results inform system prompt design: developers should prioritize gender-neutral roles and recognize that persona selection offers limited performance gains.

---
