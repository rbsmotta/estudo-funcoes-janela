import psycopg2
import csv
from dotenv import dotenv_values

config=dotenv_values("modules\.env")

csv_file_1 = r'data\Employee Table.csv'
csv_file_2 = r'data\Product Table.csv'

# chama as variáveis de ambiente
def insertCsv(conn):

    # tabela1
    try:
        cur = conn.cursor()
        with open(csv_file_1, 'r') as f:
            reader = csv.reader(f)
            next(reader)
            for row in reader:
                cur.execute(f'INSERT INTO {config.get("TABLE1")} VALUES ({config.get("TABLE1_VALUES")})', row)
        conn.commit()
        print(f'Inserting data in table {config.get("TABLE1")} successfully')
    except psycopg2.Error as e:
        print(f'Error inserting data in table {config.get("TABLE1")}:', e)

    # tabela2
    try:
        cur = conn.cursor()
        with open(csv_file_2, 'r') as f:
            reader = csv.reader(f)
            next(reader)
            for row in reader:
                cur.execute(f'INSERT INTO {config.get("TABLE2")} VALUES ({config.get("TABLE2_VALUES")})', row)
        conn.commit()
        print(f'Inserting data in table {config.get("TABLE2")} successfully')
    except psycopg2.Error as e:
        print(f'Error inserting data in table {config.get("TABLE2")}:', e)