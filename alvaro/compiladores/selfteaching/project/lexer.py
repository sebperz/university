TOKEN_TYPES = ("NUMBER", "PLUS", "MINUS", "STAR", "SLASH", "LPAREN", "RPAREN", "EOF") #, "SEMICOLON")

class Token:
    def __init__(self, type_, lexeme):
        self.type = type_
        self.lexeme = lexeme
    def __repr__(self):
        return f"Token({self.type}, {self.lexeme!r})"

class Lexer:
    def __init__(self, source):
        self.source = source
        self.pos = 0

    def next_token(self):
        while self.pos < len(self.source) and self.source[self.pos].isspace():
            self.pos += 1
        if self.pos >= len(self.source):
            return Token("EOF", "")
        c = self.source[self.pos]
        if c.isdigit():
            start = self.pos
            while self.pos < len(self.source) and self.source[self.pos].isdigit():
                self.pos += 1
            return Token("NUMBER", self.source[start:self.pos])
        symbols = {"+": "PLUS", "-": "MINUS", "*": "STAR", "/": "SLASH",
                   "(": "LPAREN", ")": "RPAREN", ";": "SEMICOLON"}
        if c in symbols:
            self.pos += 1
            return Token(symbols[c], c)
        raise SyntaxError(f"Unexpected character {c!r} at position {self.pos}")

    def tokenize(self):
        tokens = []
        while True:
            t = self.next_token()
            tokens.append(t)
            if t.type == "EOF":
                return tokens

for t in Lexer(";;; 1 + 22 * ; (3 - 4);;;").tokenize():
    print(t)
