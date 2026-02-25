import math

def calculate_m(a,b):
    return (b+a)/2

def evaluate(x:float):
    return 5.0*(x*x*x)-5*(x*x)+6*x -2

def swap_variables(a:float,m:float,b:float):
    fa = evaluate(a)
    fb = evaluate(b)
    fm = evaluate(m)
    if (fa<0 and fm>0) or (fa>0 and fm<0):
        return a, m
    return m, b

def calculate_error(a,b):
    return (b-a)/2

#values
target_error = 0.1
a=0.0
b=1.0

while(True):
    m=calculate_m(a,b)
    print(f"""Our values are:
a = {a}
m = {m}
b = {b}
f(a) = {evaluate(a)}
f(m) = {evaluate(m)}
f(b) = {evaluate(b)}
""")

    a,b = swap_variables(a,m,b)
    error  = calculate_error(a,b)
    print(f"""After evaluate:
a = {a}
b = {b}
error = {error}
          """)
    if error < target_error:
        break

