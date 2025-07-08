FROM tensorflow/tensorflow:2.15.0

# Set working directory
WORKDIR /app

# Copy your code
COPY . .

# Install required packages (Keras already included)
RUN pip install --no-cache-dir fastapi uvicorn pillow numpy

# Expose port for Render (optional but common)
EXPOSE 7860

# Run your app
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "7860"]
