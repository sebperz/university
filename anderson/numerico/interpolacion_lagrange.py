def lagrange(x_data, y_data, num_values, interpol):
    if len(x_data) != len(y_data):
        return "Data Error: Lenght of arrays NOT equal"
    sum = 0.0
    for i in range(num_values):
        product = y_data[i]
        for j in range(num_values):
            if i != j:
                product = product * (interpol - x_data[j]) / (x_data[i] - x_data[j])
        
        sum = sum + product
        
    return sum

x_data = [1, 3, 5, 7, 13]
y_data = [800, 2310, 3090, 3940, 4755]

num_values = len(x_data)
x_interpol = 10.0

output = lagrange(x_data, y_data, num_values, x_interpol)
print(f"X Values: {x_data}")
print(f"Y Values: {y_data}")
print(f"Polynomial degree (n):    {num_values -1}")
print(f"Value to Interpolate (x): {x_interpol}")
print(f"Result: {output}")
