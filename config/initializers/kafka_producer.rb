require "kafka"

# Configure the Kafka client with the broker hosts and the Rails
# logger.
$kafka = Kafka.new(["localhost:9092"], client_id: "spree-kafka-stock-updates",
  logger: Rails.logger)

# Set up an asynchronous producer that delivers its buffered messages
# every ten seconds:
$kafka_producer = $kafka.async_producer(
  delivery_interval: 10,
)

# Make sure to shut down the producer when exiting.
at_exit { $kafka_producer.shutdown }
