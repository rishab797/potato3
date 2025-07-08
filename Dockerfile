# Use a Debian-based image with Python
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies for OpenCV & image processing
RUN apt-get update && apt-get install -y \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# Copy your app files into the container
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir tensorflow==2.15.0 keras==3.0.5

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir \
    tensorflow==2.15.0 \
    fastapi uvicorn[standard] \
    python-multipart \
    numpy opencv-python-headless pillow scikit-image

# Expose the port your app runs on
EXPOSE 7860

# Run the FastAPI app using Uvicorn
CMD ["uvicorn", "backend:app", "--host", "0.0.0.0", "--port", "7860"]
