## Data Model (Star Schema)

Your model has:

**Dimensions:**
- `dim_date` – calendar hierarchy (day → month → quarter → year).
- `dim_user` – attributes about users (id, display_name, reputation, location).
- `dim_tag` – attributes about tags (tag name, usage counts, wiki posts).
- `dim_question` – attributes about questions (title, score, views, has_accepted_answer).

**Facts:**
- `fact_questions` – one row per question, measures like views, answers, favorites.
- `fact_answers` – one row per answer, measures like score, accepted flag.

**Bridge Table:**
- `bridge_question_tag` – resolves the many-to-many relationship between questions and tags.

**Conformed Dimensions:**
- `dim_date` and `dim_user` are shared across multiple fact tables.
- `dim_tag` connects both to questions (via bridge) and indirectly to answers.

**Surrogate Keys:**
- All dimensions use surrogate keys created in dbt (`sk` macro with MD5 hash).
- Business keys (raw ids from source tables) are still retained for reference.

**Hierarchies & Attributes:**
- `dim_date`: day → month → quarter → year.
- `dim_user`: user_id → attributes like reputation, location.
- `dim_tag`: tag_name → usage stats.
- `dim_question`: question_id → attributes like score, has_accepted_answer.

**Fact Types:**
- Transaction facts: `fact_questions` (a single event: question asked).
- Transaction facts: `fact_answers` (a single event: answer given).
- Bridge fact: `bridge_question_tag` (associates questions with multiple tags).
