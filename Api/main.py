from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import numpy as np
from sklearn.preprocessing import OneHotEncoder
import logging

app = FastAPI()
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load the model
try:
    model = joblib.load("NeuralNetwork.pkcls")
    logger.info("Model loaded successfully")
except Exception as e:
    logger.error(f"Error loading model: {e}")
    raise HTTPException(status_code=500, detail="Model could not be loaded")

# List of all possible medications
medications = [
    'Adrenaline', 'Alfentanil', 'Aminophyline', 'Amiodarona', 'Atracurium',
    'Bicabornato de sodio', 'Calcio', 'Cetorolac', 'Ciprofloxacin', 'Cis-atracurium'
]

# Initialize and fit the one-hot encoder
onehot_encoder = OneHotEncoder(categories=[medications], drop=None)
onehot_encoder.fit(np.array(medications).reshape(-1, 1))

class MedicamentoRequest(BaseModel):
    medicamentos: list[str]

class MedicamentoResponse(BaseModel):
    compatibilidade: str
    details: dict

@app.post("/classificar", response_model=MedicamentoResponse)
async def classificar_compatibilidade(request: MedicamentoRequest):
    medicamentos = request.medicamentos
    incompatibles = []
    compatibles = []
    no_info = []

    for i in range(len(medicamentos)):
        for j in range(i + 1, len(medicamentos)):
            med1 = medicamentos[i]
            med2 = medicamentos[j]
            try:
                med1_encoded = onehot_encoder.transform(np.array([med1]).reshape(-1, 1)).toarray()
                med2_encoded = onehot_encoder.transform(np.array([med2]).reshape(-1, 1)).toarray()
                input_data_encoded = np.hstack([med1_encoded, med2_encoded])

                # Check the shape of the input data
                if input_data_encoded.shape[1] != 20:
                    raise ValueError(f"Expected 20 features but got {input_data_encoded.shape[1]} features")

                prediction = model.predict(input_data_encoded)
                probabilities = model.predict_proba(input_data_encoded)

                labels = ["compatível", "incompatível", "sem informação"]
                prediction_label = labels[int(prediction[0])]

                if prediction_label == "incompatível":
                    incompatibles.append((med1, med2))
                elif prediction_label == "sem informação":
                    no_info.append((med1, med2))
                else:
                    compatibles.append((med1, med2))

            except Exception as e:
                logger.error(f"Error during prediction: {e}")
                raise HTTPException(status_code=500, detail="Prediction failed")

    if incompatibles:
        return MedicamentoResponse(compatibilidade="incompatível", details={"incompatíveis": incompatibles, "compatíveis": compatibles, "sem informação": no_info})
    elif no_info:
        return MedicamentoResponse(compatibilidade="sem informação", details={"incompatíveis": incompatibles, "compatíveis": compatibles, "sem informação": no_info})
    else:
        return MedicamentoResponse(compatibilidade="compatível", details={"incompatíveis": incompatibles, "compatíveis": compatibles, "sem informação": no_info})
