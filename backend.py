from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse
from PIL import Image
import numpy as np
import tensorflow as tf
import io
import os
os.environ['TF_USE_LEGACY_KERAS'] = '1'


app = FastAPI()
from keras.models import load_model  # ✅ correct

model = load_model("2.keras", compile=False)



CLASS_NAMES = ['Fungi', 'Healthy', 'Nematode', 'Pest', 'Phytopthora', 'Virus']

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    try:
        contents = await file.read()

        # Load and process image
        image = Image.open(io.BytesIO(contents)).convert("RGB")
        image = image.resize((224, 224))

        # Don't normalize — match tf.data image_dataset_from_directory
        img_array = np.array(image).astype("float32")
        img_array = np.expand_dims(img_array, axis=0)  # (1, 224, 224, 3)

        # Predict
        prediction = model.predict(img_array)
        predicted_class = int(np.argmax(prediction[0]))
        predicted_label = CLASS_NAMES[predicted_class]

        return {
            "prediction": predicted_label,
            "probabilities": {
                CLASS_NAMES[i]: float(round(prediction[0][i], 4)) for i in range(6)
            }
        }

    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})
