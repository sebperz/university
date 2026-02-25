import math

def calculate_m(a,b):
    return (b+a)/2

def evaluate(x:float):
    return -0.5*(x*x)+2.5*(x)+4.5

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
a=5.0
b=10.0
iteraciones=3

#Este ejercicio unicamente pide 3 iteraciones
for i in range(iteraciones):
    m=calculate_m(a,b)
    print(f"""Our values are:
a = {a}
m = {m}
b = {b}
Now we evaluate them =>
f(a) = {evaluate(a)}
f(m) = {evaluate(m)}
f(b) = {evaluate(b)}""")

    a,b = swap_variables(a,m,b)
    error  = calculate_error(a,b)
    print(f"""Our new values are:
    a = {a}
    b = {b}
error = {error}
          """)

