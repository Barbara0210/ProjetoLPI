import joblib
import numpy as np
from sklearn.preprocessing import OneHotEncoder

# Load the model
try:
    model = joblib.load("NeuralNetwork.pkcls")
    print("Model loaded successfully")
except Exception as e:
    print(f"Error loading model: {e}")

# List of all possible medications
medications = [
    'Adrenaline', 'Alfentanil', 'Aminophyline', 'Amiodarona', 'Atracurium',
    'Bicabornato de sodio', 'Calcio', 'Cetorolac', 'Ciprofloxacin', 'Cis-atracurium'
]

# Initialize and fit the one-hot encoder
onehot_encoder = OneHotEncoder(categories=[medications], drop=None)
onehot_encoder.fit(np.array(medications).reshape(-1, 1))

# Function to classify compatibility
def classify_compatibility(med_list):
    incompatibles = []
    no_info = []
    compatibles = []

    for i in range(len(med_list)):
        for j in range(i + 1, len(med_list)):
            med1_encoded = onehot_encoder.transform(np.array([med_list[i]]).reshape(-1, 1)).toarray()
            med2_encoded = onehot_encoder.transform(np.array([med_list[j]]).reshape(-1, 1)).toarray()
            input_data_encoded = np.hstack([med1_encoded, med2_encoded])

            # Check the shape of the input data
            if input_data_encoded.shape[1] != 20:
                raise ValueError(f"Expected 20 features but got {input_data_encoded.shape[1]} features")

            # Predict using the model
            prediction = model.predict(input_data_encoded)
            probabilities = model.predict_proba(input_data_encoded)

            # Map prediction to descriptive label
            labels = ["compatible", "incompatible", "no info"]
            prediction_label = labels[int(prediction[0].item())]  # Use .item() to extract the scalar value

            if prediction_label == "incompatible":
                incompatibles.append((med_list[i], med_list[j]))
            elif prediction_label == "no info":
                no_info.append((med_list[i], med_list[j]))
            else:
                compatibles.append((med_list[i], med_list[j]))

    if incompatibles:
        return {
            "compatibilidade": "incompatible",
            "details": incompatibles
        }
    elif no_info:
        return {
            "compatibilidade": "no info",
            "compatibles": compatibles,
            "no_info": no_info
        }
    else:
        return {
            "compatibilidade": "compatible",
            "details": compatibles
        }

# Test with multiple medications
test_medications = ['Adrenaline', 'Alfentanil', 'Calcio']
result = classify_compatibility(test_medications)

print(f"Result: {result['compatibilidade']}")
if result['compatibilidade'] == 'incompatible':
    print(f"Incompatibles: {result['details']}")
elif result['compatibilidade'] == 'no info':
    print(f"Compatibles: {result['compatibles']}")
    print(f"No info: {result['no_info']}")
else:
    print(f"Compatibles: {result['details']}")
