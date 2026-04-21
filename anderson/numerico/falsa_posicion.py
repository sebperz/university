import math

def calculate_c(a,b):
    fa = evaluate(a)
    fb = evaluate(b)
    return b - fb*(b-a)/(fb-fa)

def evaluate(x:float):
    return x*x*x*x-8*x*x*x-35*x*x+450*x-1001

def swap_variables(a:float,c:float,b:float):
    fa = evaluate(a)
    fc = evaluate(c)
    fb = evaluate(b)
    if (fa<0 and fc>0) or (fa>0 and fc<0):
        return a, c
    return c, b

def calculate_error(a,b):
    return (b-a)/2

#values
target_error = 0.01
a=4.5
b=6
c_old = None

while(True):
    c=calculate_c(a,b)
    print(f"""Our values are:
a = {a}
c = {c}
b = {b}
f(a) = {evaluate(a)}
f(c) = {evaluate(c)}
f(b) = {evaluate(b)}
""")

    a,b = swap_variables(a,c,b)
    if c_old is not None:
        error = abs(c - c_old) / abs(c)
    else:
        error = abs(b - a) / abs(c)
    c_old = c
    print(f"""After evaluate:
a = {a}
b = {b}
error = {error}
          """)
    if error < target_error:
        break
