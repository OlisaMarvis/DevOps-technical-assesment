from prometheus_client import start_http_server, Gauge
import requests
import time
import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Environment variables
RABBITMQ_HOST = os.getenv('RABBITMQ_HOST')
RABBITMQ_USER = os.getenv('RABBITMQ_USER')
RABBITMQ_PASSWORD = os.getenv('RABBITMQ_PASSWORD')

# Define Prometheus metrics
QUEUE_MESSAGES = Gauge('rabbitmq_individual_queue_messages',
                      'Total number of messages in queue',
                      ['host', 'vhost', 'name'])
QUEUE_MESSAGES_READY = Gauge('rabbitmq_individual_queue_messages_ready',
                            'Number of messages ready in queue',
                            ['host', 'vhost', 'name'])
QUEUE_MESSAGES_UNACK = Gauge('rabbitmq_individual_queue_messages_unacknowledged',
                            'Number of unacknowledged messages in queue',
                            ['host', 'vhost', 'name'])

def get_queue_metrics():
    """Fetch metrics from RabbitMQ API and update Prometheus gauges"""
    try:
        url = f"http://{RABBITMQ_HOST}:15672/api/queues"
        response = requests.get(
            url,
            auth=(RABBITMQ_USER, RABBITMQ_PASSWORD),
            timeout=10
        )
        response.raise_for_status()
        
        queues = response.json()
        for queue in queues:
            labels = {
                'host': RABBITMQ_HOST,
                'vhost': queue['vhost'],
                'name': queue['name']
            }
            
            QUEUE_MESSAGES.labels(**labels).set(queue['messages'])
            QUEUE_MESSAGES_READY.labels(**labels).set(queue['messages_ready'])
            QUEUE_MESSAGES_UNACK.labels(**labels).set(queue['messages_unacknowledged'])
            
        logger.info(f"Successfully updated metrics for {len(queues)} queues")
    
    except requests.exceptions.RequestException as e:
        logger.error(f"Error fetching metrics: {str(e)}")
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")

def main():
    # Start Prometheus HTTP server
    start_http_server(8000)
    logger.info("Prometheus metrics server started on port 8000")
    
    # Main loop
    while True:
        get_queue_metrics()
        time.sleep(15)  # Collect metrics every 15 seconds

if __name__ == '__main__':
    if not all([RABBITMQ_HOST, RABBITMQ_USER, RABBITMQ_PASSWORD]):
        logger.error("Missing required environment variables")
        exit(1)
    
    main()