import os
import mysql.connector

def get_connection():
    # os.getenv busca las variables que pusimos en la pestaña Environment de Render
    return mysql.connector.connect(
        host=os.getenv('MYSQL_HOST'),
        user=os.getenv('MYSQL_USER'),
        password=os.getenv('MYSQL_PASSWORD'),
        port=os.getenv('MYSQL_PORT'),
        database=os.getenv('MYSQL_DB')
    )