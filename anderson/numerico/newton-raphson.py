import math

def function(x):
    return -1 + 5.5*x -4*x*x + 0.5*x*x*x
    # return -(x*x)+1.8*x+2.5
    # return math.exp(-num)-num

def derivated_function(x):
    return 5.5 -8*x + 1.5*x*x
    # return -2*x+1.8
    # return -math.exp(-num)-1

def calc_error(x0, x1):
    return abs((x1 - x0) / x1)

x = 4.54
target_error = 0.01

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

