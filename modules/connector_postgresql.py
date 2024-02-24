import psycopg2
from dotenv import dotenv_values

# chama as variáveis de ambiente
config=dotenv_values("modules\.env")

def connector():
    try:
        conn = psycopg2.connect(
            dbname = config.get("DB_NAME"),
            user = config.get("USER"),
            password = config.get("PASSWORD"),
            host = config.get("HOST")
        )
        return conn
    except psycopg2.Error as e:
        print('Error connecting to PostgreSQL:', e)
        return None