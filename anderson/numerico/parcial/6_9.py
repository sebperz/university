import math

def function(x):
    return 0.95*x*x*x -5.9*x*x +10.9*x -6

def derivated_function(x):
    return 3*0.95*x*x -5.9*2*x +10.9

def calc_error(x0, x1):
    return abs((x1 - x0) / x1)

x = 3.5
target_error = 0.01

for i in range(3):
    x_plus_one = x - (function(x)/derivated_function(x))
    print(f"Value of Xi: \t{x}")
    print(f"Value of Xi+1: \t{x_plus_one}")
    error = calc_error(x, x_plus_one)
    print(f"Error: {error}\n")

    x = x_plus_one

