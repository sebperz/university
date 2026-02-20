from sklearn.naive_bayes import GaussianNB
import numpy 

# Training data: [height, weight, foot_size] -> gender
measurements = numpy.array([
    [6, 180, 12],      # hombre
    [5.92, 190, 11],   # hombre
    [5.58, 170, 12],   # hombre
    [5.92, 165, 10],   # hombre
    [5, 100, 6],       # mujer
    [5.5, 150, 8],     # mujer
    [5.42, 130, 7],    # mujer
    [5.75, 150, 9]     # mujer
])
labels = numpy.array(['hombre', 'hombre', 'hombre', 'hombre', 'mujer', 'mujer', 'mujer', 'mujer'])

# Train
naive_bayers = GaussianNB()
naive_bayers.fit(measurements, labels)

# Predict
sample = numpy.array([[6, 130, 8]])
prediction = naive_bayers.predict(sample)[0]
proba = naive_bayers.predict_proba(sample)[0]

print(f"Prediction: {prediction}")
print(f"Probabilities: hombre={proba[0]:.4f}, mujer={proba[1]:.4f}")
