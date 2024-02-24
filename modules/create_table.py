import psycopg2
from dotenv import dotenv_values

# chama as variáveis de ambiente
config=dotenv_values("modules\.env")

def createTable(conn):
    try:
        cur = conn.cursor()
        # TABLE1
        cur.execute(f'''
            CREATE TABLE IF NOT EXISTS {config.get("TABLE1")}(
                    {config.get("TABLE1_COLUMNS")}
            )
        ''')
        
        # TABLE2
        cur.execute(f'''
            CREATE TABLE IF NOT EXISTS {config.get("TABLE2")}(
                    {config.get("TABLE2_COLUMNS")}
            )
        ''')
        conn.commit()
        print('Tables created successfully')
    except psycopg2.Error as e:
        print('Error creating table', e)