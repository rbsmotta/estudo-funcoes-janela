from modules.connector_postgresql import connector
from modules.create_table import createTable
from modules.insert_csv import insertCsv

def main():
    
    createTable(connector())
    insertCsv(connector())