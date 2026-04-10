import psycopg2

DB_CONFIG = {
    "host": "localhost",
    "database": "polesye_dairy",
    "user": "postgres",
    "password": "1221"
}


def get_connection():
    return psycopg2.connect(**DB_CONFIG)
