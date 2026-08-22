# Token types are an enforced vocabulary; user reads code critically

Two things in this session. First, a design correction: in Lesson 1's original lexer, `TOKEN_TYPES` was dead code — token types were minted as plain strings by the `symbols` dict and nothing validated against the tuple. The lesson's exercise ("add `;` to symbols but not to TOKEN_TYPES → error") promised an error that never fired. Fixed by adding a `make_token` method that rejects undeclared types. The insight for the project: token types are the fixed vocabulary the whole pipeline switches on; real compilers enforce it with an enum, and our project should too.

Second, the user independently caught that the expected error did not occur — evidence they read and reasoned about the code's behaviour rather than copying mechanically.

**Evidence:** user reported "i don't see the error when semicolon is not added to TOKEN_TYPES"; root cause confirmed by reading the code (tuple never referenced) and by running a reproduction.

**Implications:** the user can be trusted with exercises that require understanding behaviour, not just transcription. Future lesson code must have its claimed properties verified (this one now is). The make_token design pattern carries forward into the parser lesson.