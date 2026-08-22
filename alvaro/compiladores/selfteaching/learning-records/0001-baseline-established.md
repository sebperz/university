# Baseline: complete beginner, Python project-first path

Established at session start: the user is a complete beginner to compilers (no prior lexer/parser experience), taking a university compilers course in Spanish, and wants to pass it *with* genuine understanding. Learning style is project-first in Python (chosen over Go/Rust/C for minimal friction). Mission documented in [[MISSION.md]].

**Evidence:** direct statements in the intake questionnaire; course folder contains "Actividad 1" covering phases, regex/DFA, ambiguity.

**Implications:** teach each compiler phase by building it into the running Python interpreter, in pipeline order (lexer → parser → AST → semantic analysis → evaluator). Anchor lessons to the course's Spanish terminology and to the Dragon Book, which the course cites. Do not introduce a second language or advanced optimization topics until the course demands them. Future lessons should assume no prior compiler vocabulary.