FROM python:3.10-slim

# Avoid writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages (TensorFlow 2.15 & Keras 3)
RUN pip install --upgrade pip
RUN pip install tensorflow==2.15.0 keras==3.0.5 fastapi uvicorn numpy pillow

# Copy app code
COPY . .

# Expose port
EXPOSE 7860

# Start app
CMD ["uvicorn", "backend:app", "--host", "0.0.0.0", "--port", "7860"]
