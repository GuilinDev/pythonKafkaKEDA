# Dockerfile
FROM python:3.10-slim
RUN pip install kafka-python
COPY consumer.py /consumer.py
CMD ["python", "/consumer.py"]
