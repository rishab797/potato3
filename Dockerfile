FROM python:3.10

WORKDIR /app

COPY . .

# Install dependencies
RUN pip install --upgrade pip
RUN pip install keras-core tensorflow fastapi uvicorn pillow numpy

EXPOSE 7860

CMD ["uvicorn", "backend:app", "--host", "0.0.0.0", "--port", "7860"]
