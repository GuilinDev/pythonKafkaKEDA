from kafka import KafkaProducer
import time
import random

producer = KafkaProducer(bootstrap_servers='kafka:9092')

while True:
    # Vary the number of messages to send
    number_of_messages = random.randint(1, 20)
    for _ in range(number_of_messages):
        message = f"Message {random.randint(1, 100)}"
        producer.send('test-topic', value=message.encode('utf-8'))
        print(f"Sent: {message}")
    # Sleep for a random time to simulate varying traffic load
    time.sleep(random.uniform(1, 5))
