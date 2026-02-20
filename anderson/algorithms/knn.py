from sklearn.neighbors import KNeighborsClassifier
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
knn = KNeighborsClassifier(n_neighbors=3)
knn.fit(measurements, labels)

# Predict
sample = numpy.array([[6, 130, 8]])
prediction = knn.predict(sample)[0]
proba = knn.predict_proba(sample)[0]
# proba[0] = hombre | proba[1] = mujer

print(f"Prediction: {prediction}")
print(f"Probabilities: hombre={proba[0]:.4f}, mujer={proba[1]:.4f}")
