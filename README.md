# Linux_materials
a collection of scripts and tutorials for linux related topics


import json
import logging
import os
import ssl
import urllib

import boto3
import psycopg2
from prometheus_client import CollectorRegistry, Gauge, pushadd_to_gateway

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Specify the AWS region where your secret is stored
AWS_REGION = os.getenv("AWS_REGION")
ENV = os.getenv("ENV")
#DB Identifier
DB_IDENTIFIER = os.getenv("DB_IDENTIFIER")

#Pushgateway_config
PUSHGATEWAY_URL = os.getenv("PUSHGATEWAY_URL")
JOB_NAME = os.getenv("PUSHGATEWAY_JOB_NAME")
BATCH_SIZE = int(os.getenv("BATCH_SIZE"))
count = 0


# type: ignore
def prometheus_pushgateway_con_handler(url, method, timeout, headers, data):
    def handler():  # type: ignore
        try:
            ssl_context = ssl.create_default_context()
            ssl_context.check_hostname = False
            ssl_context.verify_mode = ssl.CERT_NONE
            ssl_handler = urllib.request.HTTPSHandler(
                context=ssl_context
            )  # type: ignore

            request = urllib.request.Request(url, data=data)
            request.get_method = lambda: method
            for k, v in headers:
                request.add_header(k, v)
            response = urllib.request.build_opener(ssl_handler).open(
                request, timeout=timeout
            )
            if (
                    response.getcode() > 299
            ):  # include redirects in non-successful response codes.
                logger.info(
                    "Pushgateway has failed. url: {} response_info: {}".format(
                        response.geturl(), response.info()
                    )
                )
        except ConnectionError as e:
            logger.error(f"ConnectionError when trying to connect to: {url}, exception: {e}")
        except Exception as e:
            logger.error(f"Pushgateway failed. url: {url}, exception: {e}")

    return handler


def get_rds_secret():
    # Get Credentials from RDS client and Secret Manager
    db_identifier = f"{DB_IDENTIFIER.replace('xcore', ENV)}"
    try:
        # Create a RDS client
        rds_client = boto3.client("rds", region_name=AWS_REGION)
        postgres_db = rds_client.describe_db_clusters(
            DBClusterIdentifier= db_identifier
        )['DBClusters'][0]

        postgres_db_arn = postgres_db['MasterUserSecret']['SecretArn']

        secrets_manager = boto3.client("secretsmanager", region_name=AWS_REGION)
        # Retrieve the secret value
        response = secrets_manager.get_secret_value(SecretId=postgres_db_arn)

        # Parse and print the secret JSON
        secret_value = json.loads(response["SecretString"])
        secret_value["host"] = postgres_db['ReaderEndpoint']
        secret_value["port"] = postgres_db['Port']
        return secret_value
    
    except ConnectionError as e:
        logger.error(f"Error: {e}, When trying to retrieve {postgres_db_arn}")
    except Exception as e:
        logger.error(f"Error: {e}")


def execute_query(secret_value):
    # Extract URL, username, and password
    db_host = secret_value["host"]
    db_username = secret_value["username"]
    db_password = secret_value["password"]
    db_name = "vault"  # secret_value['dbname']
    db_port = secret_value["port"]

    # Print the extracted values
    logger.info(f"Url: {db_host}")
    logger.info(f"Username: {db_host}")
    logger.info(f"dbname: {db_name}")
    logger.info(f"port: {db_port}")

    offset = 0
    registry_count = 0
    try:
        # Establish a database connection
        connection = psycopg2.connect(
            host=db_host,
            port=db_port,
            dbname=db_name,
            user=db_username,
            password=db_password,
        )

        # Create a cursor object
        cursor = connection.cursor()

        while True:
            # SQL query to execute
            sql_query = f"""
             select current_status, smart_contract_version_id , type from accounts
             where account_type = 1
             AND lower(type) not like '%wash'
             AND lower(type) not like '%hold%'
             AND lower(type) not like '%wrt%' 
             AND lower(type) not like '%writeoff%'
             LIMIT {BATCH_SIZE} OFFSET {offset};
             """

            # Execute the SQL query
            cursor.execute(sql_query)
            # Fetch all rows from the result set
            result = cursor.fetchall()
            # End if there is no more rows
            if not result:
                send_metrics_to_pushgateway(result, registry_count)
                logger.info("No more rows")
                logger.info(f"Total Accounts: {count}")
                break
            logger.info(f"Total Accounts: {count}")
            send_metrics_to_pushgateway(result, registry_count)
            registry_count += 1
            offset += BATCH_SIZE
    except json.JSONDecodeError as e:
        logger.error(f"Error parsing JSON: {e}")
    except KeyError as e:
        logger.error(f"Error accessing JSON fields: {e}")
    except Exception as e:
        logger.error(f"Error: {e}")
    finally:
        if connection in locals():
            # Close the cursor and the connection
            cursor.close()
            connection.close()
        logger.info("Connection to database has been closed successfully")


def send_metrics_to_pushgateway(result, registry_count):
    """Function sending metrics to pushgateway"""
    global PUSHGATEWAY_URL
    global JOB_NAME
    global count
    try:
        registry = CollectorRegistry()

        # Format the query result as Prometheus exposition format
        # metrics
        metric_name = "TM_Accounts_Summary"
        labels = {
            "current_status": "current_status",
            "smart_contract_version_id": "smart_contract_version_id",
            "type": "type",
        }

        # Create a Gauge metric with multiple labels
        accounts_summary = Gauge(
            metric_name,
            "Accounts Summary Status",
            labelnames=labels.keys(),
            registry=registry,
        )

        status = {
            1: "UNKNOWN",
            2: "OPEN",
            3: "CLOSED",
            4: "CANCELLED",
            5: "PENDING_CLOSURE",
            6: "PENDING",
        }

        # Get the SQL query result (replace this with your actual
        # query result)
        for row in result:
            count += 1

            current_status = status.get(row[0], 0)
            smart_contract_version_id = row[1] if row[1] else "UNKNOWN"
            account_type = row[2] if row[2] else "UNKNOWN"

            accounts_summary.labels(
                current_status=current_status,
                smart_contract_version_id=smart_contract_version_id,
                type=account_type
            ).inc()

        logger.info(f"Sendin metrics to Pushgateway: {PUSHGATEWAY_URL}, Job: {JOB_NAME}_{registry_count}")

        # Send metrics
        pushadd_to_gateway(
            PUSHGATEWAY_URL,
            job=f'{JOB_NAME}_{registry_count}',
            registry=registry,
            handler=prometheus_pushgateway_con_handler
        )
        logger.info("Metrics sent to Pushgateway")
    except ConnectionError as e:
        logger.error(f"ConnectionError when trying to send metrics to Pushgateway {e}")
    except Exception as e:
        logger.error(f"Error sending metrics to Pushgateway {e}")


if __name__ == "__main__":
    secret_value = get_rds_secret()
    execute_query(secret_value)
