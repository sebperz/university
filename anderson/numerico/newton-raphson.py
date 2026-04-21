import math

def function(x):
    return 8*math.sin(x)*math.exp(-x)-1
    # return -(x*x)+1.8*x+2.5
    # return math.exp(-num)-num

def derivated_function(x):
    return 8*math.exp(-x)*(math.cos(x)-math.sin(x))
    # return -2*x+1.8
    # return -math.exp(-num)-1

def calc_error(x0, x1):
    return abs((x1 - x0) / x1)

x = 0.3
target_error = 0.001

while True:
    x_plus_one = x - (function(x)/derivated_function(x))
    print(f"Value of Xi: \t{x}")
    print(f"Value of Xi+1: \t{x_plus_one}")
    error = calc_error(x, x_plus_one)
    print(f"Error: {error}\n")

    if error <= target_error:
        print("END of process")
        break
    x = x_plus_one

