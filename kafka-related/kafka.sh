# Kafka focuses on real-time analysis, not batch processing, mainly for streams.
# Messaging is a loosely coupled system => messages are consumed by consumers / subscribers
# Messages are produced by one or more producers. => organized into topics
# Messages are processed by message brokers. => usually persistent over the short term.
# Producer – send → “Message Queue” – receive → consumer
# What if the topic gets too big for one computer => topic partitions

# Message: immutable array of bites
# ** a sequence of messages is called a data stream
# Topic: a feed of messages, a stream of data like a table in database, each topic has a unique name
# Producer: a process that publishes messages to a topic
# Consumer : a process that subscribes to a topic
# Broker: one of the servers that comprises a cluster

# Kafka broker can connect to databases, analytics systems, search engines, apache spark,...

# Kafka topics are like database tables where rows are messages. A kafka cluster can have an unlimited number of kafka topics. Topics have NO data verification.

# Kafka topic :  partition 0 { message1,...., message100}
#                         partition 1
#                         partition 2

# ** message id is the offset of the partition
# ** data in kafka will be deleted after a specific amount of time


# Producer =>    topicA / Partition0  [truck_id_123, truck_id_145]
# 	            topicA /  Partition1  [truck_id_345, truck_id_394]

# Key is “truck_id”

Access Control List (ACL)
Kafka uses Access Control List(ACL) for authorization
An authorizer controls whether or not to authorize an operation based on the principal and the resource being accessed
The user principal, which is used for Kafka authorization, is derived from the certificate common name (CN) based on
core-kafka SSL mapping rules, 

topic_name=your.test.topic
kafka-acls --bootstrap-server $BOOTSTRAP_SERVER:9092 --command-config ~/connect.properties --list --topic $topic_name


# It's better to have the same amount of partitions and application instances, to prevent bottlenecks.
# As each app instance can read/consume from one broker partition
# Offsets are ID of a message within a partition.
# Data by default is kept for 7 days of retention in each topic/partition.
# Offsets are not reused, index of topic won’t go back once a message is consumed
# Data sent to a kafka topic is assigned randomly unless you give it specific key for the message

# kafka polling => Polling involves making repeated requests to a server to check for updates. However, traditional polling can be inefficient and “chatty,”
# leading to increased bandwidth usage. This is where long polling comes into play. Instead of the server immediately responding with a “not ready” message,
# it delays the response, allowing the client to check back later.
# In Kafka, long polling is instrumental for clients subscribing to topics. The consumer sends a request to check for messages in a topic, and if none are 
# found, Kafka holds the response until new messages arrive. This ensures that clients receive updates without continuously polling the server.


# ** Each kafka cluster has several brokers, each broker has an ID. kafka can have from 3 to 1000 brokers. Once you connect to the broker you access the entire cluster.
# ** one broker can be the leader of a partition. Producers send data to it and other brokers replicate from that.

# What are DLQs?
# Dead Letter Queues (DLQs) are a standard error handling mechanism for streaming software systems. In certain scenarios messages that cannot be processed by a production component when read from a queue are instead placed on 
# a separate queue, the DLQ, for manual investigation and recovery. This ensures that subsequent messages on the original queue can continue to be processed, while any messages that cannot be processed are 
# retained in full, i.e. there is no data loss.

# Once a message has been placed on a DLQ this indicates that the standard processing of the message was not able to complete, and no further processing of the message will occur automatically. 
# You must take additional steps in order to recover the original operation that was unable to complete. Failure to do so can lead to incomplete Vault functionality.

# When are DLQs used?
# The errors encountered by a Vault component when processing a message consumed from a Kafka topic fall into two broad categories:

# Transient => Errors occur when automatically retrying at a later time, without any state change within Vault, is likely to lead to successful processing of the message. For example if the database 
# is temporarily unavailable, this would be a retryable error as when the database becomes available again the message will be processed successfully.

# Non-Transient => Errors occur when automatically retrying, without any state change within Vault, is unlikely to lead to successfully processing 
# the message. For example, if the message cannot be deserialised by the consumer, attempts to retry processing will not be successful.

# While most transient errors are handled within, DLQs are used as a recovery mechanism for Kafka messages that are unable to be processed due to some 
# non-transient errors.

# A component which is a consumer of a particular Kafka topic consumes a message from the topic and attempts to process it.
# While processing the message, a non-transient error is encountered, meaning retrying with the system in its current state will not produce a successful outcome.
# The message is placed on a dedicated DLQ Kafka topic. Processing of subsequent messages from the original topic continues, but processing of the message that has been 
# placed on the DLQ does not continue.
# Note that in some cases when a transient error is encountered when processing a message, depending on the cause of the error, processing of the message 
# may be retried indefinitely. For example if the database remains unavailable. Cases like this should still be monitored as they may still require 
# manual intervention to proceed (e.g. ensuring services can communicate with one another).

# DLQs may contain PII data both in the message bodies and the error output. As a result any personnel or system reading data from any DLQ may be exposed to it. You 
# must take the appropriate steps to ensure that readers of DLQ messages have the appropriate authorisation.

# DLQ naming
# All DLQ topics follow a standard naming convention of containing .dlq or .failure in the topic name, most often at the end.

# DLQ message format
# When a message is placed on a DLQ topic, the format of the message on the DLQ will be as follows:

# The body of the message is identical to the original message, in the same format (JSON or Protobuf). For example if the originally consumed message is an AccountEvent, then the DLQ’d message body will be the same AccountEvent message.

# Generally the processing error that led to the message being DLQ’d is present in either the message header or in the stack_trace header within the DLQ 
# metadata . These values will always be formatted as a JSON key / value pair.
# The DLQ metadata contains four mandatory fields and one optional field all as JSON key / value pairs:

# original_headers. This is a repeated field containing all the Kafka headers present in the original message.
# original_topic. This is a single string whose value is the topic that the original message was consumed from.
# original_consumer_group. This is a single string whose value is the consumer group used by the consumer which encountered the error while processing the message.
# original_timestamp. This is a single string whose value is the timestamp of when the original message was created.
# stack_trace. This is an optional single string field which, if present, will contain the processing error.

# Monitoring DLQs
# As mentioned above, you must actively monitor DLQs for new messages. In many cases, a message being placed on a DLQ represents a critical processing error
# which requires immediate attention.
# Prometheus Alerts that track new messages being placed onto DLQ topics. Alert pagers should be built on top of these alerts to inform you of new messages 
# placed on a DLQ.

# DLQ recovery
# Any time a message is placed on a DLQ, you must take any necessary action to recover processing. Failure to do so will result in a loss of data and/or functionality. While
# the severity of the functionality affected by a message placed on a DLQ will vary, note that even for less critical issues you must recover from DLQ messages within the
# timeframe of your Kafka retention period, which defaults to 7 days. Failure to do so will result in the message on the DLQ being permanently deleted, meaning recovery of 
# the data/functionality may no longer be possible.

# When a message is detected on a DLQ Kafka topic:
# Consume the message from the DLQ, including the headers. As mentioned above the headers contain the error message. If displaying the Kafka message in full, take care to
# ensure viewers have the appropriate authorisation to view the data.
# You should only manually interact with DLQ Kafka topics in error scenarios, and when doing so must take care not to use any consumer groups that are used by 
# any production services

# Reading messages from a DLQ
# How you interact with Kafka topics within Vault will depend on your Kafka hosting solution and internal processes. If a lightweight approach is required for consuming 
# messages, Thought Machine recommends the use of Kafkacat for interacting with DLQ Kafka topics in error scenarios. Remember that wherever 
# you choose to run Kafkacat, it will need access to your Kafka broker.

# If you are using Kafkacat to consume and read messages from a DLQ, we recommend:
# Running via Docker to ensure the latest version of Kafkacat is used. The command should start with 

docker run --rm confluentinc/cp-kafkacat kafkacat -b <your_kafka_broker> -t <name_of_dlq_topic> -C

# Using the -J option to ensure the headers are displayed along with the message body for the consumed messages. Alternatively you can specify a format via -f which must
# include the %h header token.
# Kafkacat will produce output to Stdout by default.

# If the message body is in protobuf format, it will not be human readable when read from the DLQ. You are still required to deserialise using the provided .proto files. 
# If your Kafka solution or internal process prohibits the use of Kafkacat, you must implement your own method of consuming from/producing to DLQ Kafka topics.

# Deserialising Protobuf messages
# Depending on your environment settings, some DLQ message bodies will be in either Protobuf or JSON format:
# If the format is JSON, you do not need to follow the remainder of this section and must not use protoc on your message output.
# If the format is Protobuf, you will need to deserialise the message before it is human readable, instructions for which are below.
# To deserialise an encoded protobuf message, you must have access to the corresponding .proto file that contains the message definition in question. 

# For example:

protoc --decode=test_package.TestMessage path_to_proto/test.proto

# would deserialise protobuf bytes into JSON format for a protobuf message of type TestMessage where:
# The TestMessage type is defined in 'test.proto'.
# The 'test.proto' contains a package test_package; line, which defines the package name.
# The 'test.proto' file is located in your /path_to_proto/ directory.
# If using protoc in conjunction with Kafkacat, you should only read the message body from Kafka before passing it to protoc. For example: 

docker run --rm confluentinc/cp-kafkacat kafkacat -b <your_kafka_broker> -t <name_of_dlq_topic> -C -D “” | protoc --decode=test_package.TestMessage path_to_proto/test.proto

# ** DLQ monitoring *

# When a message cannot be processed by the main queue, it is automatically routed to the DLQ. This ensures that problematic messages do not block the processing of other messages.
# Monitoring tools or dashboards are set up to keep track of the DLQ. These tools can provide insights into the number of messages in the DLQ, the reasons for failure, and the time messages have been in the queue.
# Alerts can be configured to notify administrators or developers when the number of messages in the DLQ exceeds a certain threshold. This helps in quickly identifying and addressing issues.
# Analysis and Troubleshooting: Messages in the DLQ are analyzed to determine the cause of failure. This can involve checking message content, reviewing logs, and debugging the processing logic.
# Reprocessing: Once the issue is identified and resolved, messages can be reprocessed. This might involve moving them back to the main queue or directly processing them from the DLQ.
# Reporting: Regular reports can be generated to provide insights into the frequency and types of errors occurring, helping to improve the overall system reliability.

# ** How can we monitor Kafka topics DLQs **

# Set Up DLQs: Create separate Kafka topics designated as DLQs for each main topic that requires error handling.
# Configure Producers/Consumers: Ensure that your Kafka consumers are configured to send failed messages to the appropriate DLQ. This can be done by implementing error handling logic in your consumer applications.
# Use Monitoring Tools: Utilize Prometheus, or Grafana to track the status of your DLQs. These tools can provide metrics such as message count, consumer lag, and throughput.
# Set Up Alerts: also can be done via prometheus and grafana
# Automated Reprocessing: Develop scripts or applications to automatically reprocess messages from the DLQ once issues are resolved. This can be done by consuming messages from the DLQ and attempting to process them again.

kafka-acls --bootstrap-server $BOOTSTRAP_SERVER:9092 --command-config ~/connect.properties --add --resource-pattern-type prefixed --allow-host '*' --allow-principal User:my-operator --topic "scheduler." --operation Describe --operation Read --operation Write

# command is using the "kafka-acls" tool to manage Access Control Lists (ACLs) in Kafka:
# kafka-acls => This is the Kafka Authorization management CLI used for managing ACLs
# --bootstrap-server $BOOTSTRAP_SERVER:9092 => This specifies the address of the Kafka broker to connect to
# --command-config ~/connect.properties => This points to a properties file that contains the configuration settings for the command
# --add => This flag indicates that you are adding a new ACL
# --resource-pattern-type prefixed => This specifies that the resource pattern will be treated as a prefix, meaning it will match any resource that starts with the given pattern
# --allow-host '*' => This allows access from any host
# --allow-principal User:my-operator => This specifies the principal (user or application) that is being granted access
# --topic "scheduler." => This is the prefix of the topic names that the ACL will apply to
# --operation Describe --operation Read --operation Write => These specify the operations that the principal is allowed to perform on the resources. In this case, the principal can describe, read, and write to resources that match the prefix "scheduler."

# the command is adding an ACL that allows the user" my-operator" to describe, read, and write to any topic that starts with the prefix "scheduler." from any host.

# kafka command to list all users
kafka-acls --bootstrap-server $BOOTSTRAP_SERVER:9092 --command-config ~/connect.properties --list --principal User:my-operator

# Check if principal user has access to topics
kafka-acls --bootstrap-server $BOOTSTRAP_SERVER:9092 --command-config ~/connect.properties --list --principal User:my-operator --topic __schedulers-01

# ktl is same as ./bin/kafka-topics.sh -bootstrapserver=    list and lists all existing topics

kafka-acls --bootstrap-server $BOOTSTRAP_SERVER:9092 --command-config ~/connect.properties --list --topic __consumer_offsets

kafka-console-consumer --bootstrap-server $BOOTSTRAP_SERVER:9092 --offset 1 --partition 1 --max-messages 1 --value-deserializer "org.apache.kafka.common.serialization.BytesDeserializer" --consumer.config /home/appuser/conect.properties --topic $topic_name

# KafkaTopic CRD - Kubernetes custom resource definition for Kafka topics. Provides possibility to create topic and ACLs for it
# KafkaTopic CRD gives you possibility to create topic with specific parameters and list consumers and producers in order to provide the read/write access to the topic 
# through the ACL(access control list).

# kafka-toolkit- a client pod which contains a set of CLI tools provided by Confluent to interact with Kafka cluste
# is a simple client pod (same as CockroachDB client pod) where you can execute Kafka CLI commands

alias kafka="kubectl exec -it deploy/core-kafka-toolkit -n 105340-kafka -- bash"

# create a topic from CRD
apiVersion: dynamo.jpmorgan.com/v1
kind: KafkaTopic
metadata:
    namespace: foobar
    name: my-topic # name of the KafkaTopic resource. THIS FIELD CANNOT BE CHANGED  
spec:
    name: my-topic # name of the topic which will be created. THIS FIELD CANNOT BE CHANGED
    properties:
        retention.ms: "100000" # override default retention (7 days for D/I/E, or infinite for N/P)
        cleanup.policy: compact # only set this if you want to change this to compact (default is delete)
        compression.type: gzip # only set if applicable to topic (not applied by default)
        max.message.bytes: "2097176"  # override the largest record batch size allowed by Kafka. Default is 1MB
        confluent.tier.enable: "false"  # enables or disables the tiered storage feature for the topic (enabled by default)
        confluent.tier.local.hotset.ms: "172800000"  # maximum time we will retain a log segment on broker-local storage


# It is impossible to reduce number of partitions after topic is created. If you really need less partitions, you will have to migrate to a new topic

# message with the same key always goes to the same partition, because Kafka uses hash function to calculate its location. Hash function depends on thenumber of partitions, so if you change it, old data might be either non-accessible or lost

# Set retention to a very short period (e.g. 10 seconds)
kafka-configs --alter --add-config retention.ms=10000 \
--bootstrap-server $BOOTSTRAP_SERVER:9092 --topic $topic_name \
--command-config /home/appuser/connect.properties

# Produce messages without schema
topic_name=your.test.topic
kafka-console-producer --topic $topic_name \
--bootstrap-server $BOOTSTRAP_SERVER:9092 \
--producer.config /home/appuser/connect.properties

# Produce messages with Avro schema
topic_name=your.test.topic
kafka-avro-console-producer --bootstrap-server $BOOTSTRAP_SERVER:9092 \
--property schema.registry.url=https://$SCHEMA_REGISTRY_HOST:8081 $SCHEMA_REGISTRY_SSL_PROPS \
--property value.schema=--property value.schema='{"type":"record","name":"MySchemaName","namespace":"com.mycorps.dynamo.foo.bar","fields":[{"name":"us}]}'
--producer.config /home/appuser/connect.properties \
--topic $topic_name \
--property key.schema='{"type":"string"}' \
--property parse.key=true --property key.separator=":" \
--property avro.use.logical.type.converters=true \
--property key.serializer=org.apache.kafka.common.serialization.StringSerializer

# Consume messages without schema
topic_name=your.test.topic
# raw message, print as is
kafka-console-consumer --topic $topic_name --from-beginning \
--bootstrap-server $BOOTSTRAP_SERVER:9092 \
--consumer.config /home/appuser/connect.properties

# Consume messages with Avro schema
topic_name=your.test.topic
# you can remove the max-messages key from the command if you want all messages
max_message_count=10
kafka-avro-console-consumer --bootstrap-server $BOOTSTRAP_SERVER:9092 \
--consumer.config /home/appuser/connect.properties \
--from-beginning \
--property schema.registry.url=https://$SCHEMA_REGISTRY_HOST:8081 $SCHEMA_REGISTRY_SSL_PROPS \
--topic $topic_name \
--max-messages $max_message_count --property print.key=true \
--property print.separator="|"
--property key.deserializer="org.apache.kafka.common.serialization.StringDeserializer"
--property print.headers=true

# Consume messages with protobuf schema
topic_name=your.test.topic
# raw message, print as is
kafka-console-consumer --bootstrap-server $BOOTSTRAP_SERVER:9092 \
--offset 1 --partition 1 --max-messages 1 \
--value-deserializer "org.apache.kafka.common.serialization.BytesDeserializer" \
--topic $topic_name \
--consumer.config /home/appuser/connect.properties


# Offset manipulation (skip or replay message)
# With offset manipulation we can do two things, either move a consumergroup forward or backwards.
# With forward we will skip messages, with backwards we will have the effect of a replay.
topic_name=your.topic.name
consumer_group_name=your-consumer-group
kafka-consumer-groups --command-config /home/appuser/connect.properties \
--bootstrap-server $BOOTSTRAP_SERVER:9092 --group $consumer_group_name \
--reset-offsets --topic $topic_name:6,9 --shift-by 1 

# provide access to a topic via CRD
apiVersion: dynamo.jpmorgan.com/v1
kind: KafkaTopic
metadata:
    namespace: foobar
    name: my-topic # name of the KafkaTopic resource
spec:
    name: my-topic 
    partitions: 3
    replication.factor: 3
    consumers:
        - name: consumer1 # will grant READ access, with group.id consumer1*
        - name: consumer2 # will grant READ access, with group.id consumer2*
        consumerGroup: differentConsumerGroup2  # will grant READ access to group.id differentConsumerGroup2
    producers:
        - name: producer1 # will grant WRITE access, with group.id consumer1*
        - name: producer2 # will grant WRITE access, with group.id consumer2*


# what is bootstrap-server in kafka config?
# We know that a kafka cluster can have 100s or 1000nds of brokers (kafka servers). But how do we tell clients (producers or consumers) to which to connect?
# Should we specify all 1000nds of kafka brokers in the configuration of clients? no, that would be troublesome and the list will be very lengthy. Instead 
# what we can do is, take two to three brokers and consider them as bootstrap servers where a client initially connects. And then depending on alive or 
# spacing, those brokers will point to a good kafka broker.
# So bootstrap.servers is a configuration we place within clients, which is a comma-separated list of host and port pairs that are the addresses of the 
# Kafka brokers in a "bootstrap" Kafka cluster that a Kafka client connects to initially to bootstrap itself.
# So as mentioned, bootstrap.servers provides the initial hosts that act as the starting point for a Kafka client to discover the full set of 
# alive servers in the cluster.

# Streaming metrics
# Kafka streams provide a means for producers and consumers to write and read data to and from brokers. Monitoring streams allows you to detect and resolve 
# any bottlenecks across the event streaming layer of the cluster.

# How to get rid of negative consumer lag in Kafka
# "Producer offset is polled. Consumer offset is read from the offset topic for Kafka based consumers. This means the reported lag may be negative since we 
# are consuming offset from the offset topic faster then polling the producer offset. This is normal and not a problem."
