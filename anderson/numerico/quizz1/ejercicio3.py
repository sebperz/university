import math

def function(num):
    return 2*math.sin(math.sqrt(num))
    # return math.exp(-num)
    # return 0.4 * math.exp(num ** 2)

def calc_error(x0, x1):
    return abs((x1 - x0) / x1)

x = 0.5
target_error = 0.001

while True:
    x_plus_one = function(x)
    print(f"Value of Xi \t= {x}")
    print(f"Value of Xi+1 \t= {x_plus_one}")
    error = calc_error(x, x_plus_one)
    print(f"Error \t\t= {error}\n")

    if error <= target_error:
        print("END of process")
        break
    x = x_plus_one
