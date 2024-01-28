import psycopg2
from datetime import datetime, timedelta
from sqlalchemy import *
from sqlalchemy.engine import reflection
import timeit
import numpy as np
import pandas as pd
from sqlalchemy import MetaData
from sqlalchemy import text
from sqlalchemy.orm import Session
metadata = MetaData()
# PostgreSQL Verbindungsinformationen
db_params = {
    'host': '141.100.232.118',
    'database': 'ProjectDB',
    'user': 'postgres',
    'password': 'postgres'
}

engine = create_engine("postgresql+psycopg2://{user}:{password}@{host}/{DB}".format(
                        user = db_params["user"],
                        password = db_params["password"],
                        host = db_params["host"],
                        DB = db_params["database"]
                        )
                       , echo = False, future = True)
connection = engine.connect()
def call_table(table_name:str = "states", limit:Boolean = True, limit_rows:int = 100, text_queries:str = None):
    """
    table_name: string, name of table
    limit: default is True and print first 100 rows, set to False to select all table
    """
    session = Session(bind = engine)
    try: 

        if text_queries is None:
            res_table = Table(table_name, metadata, autoload_with=engine)
            if limit :
                query = select(res_table).limit(limit_rows)
                df = pd.read_sql(query, connection)
            else:
                df = pd.read_sql_table(table_name, connection)
            
            
        else:
            df = pd.read_sql(text(text_queries), connection)
        return df
    except Exception as e :
        print(f"Error executing query: {str(e)}")
        session.rollback()
        raise
    finally:
        session.close()

if __name__ == '__main__':
    #print(call_table("complaintid"))
    #print(call_table(table_name="failplace", text_queries=None))
    #print(call_table(table_name="failplace", limit=False))
    # print(call_table(text_queries="SELECT * FROM failplace LIMIT 10"))
    query = """SELECT COUNT(*) AS amount , maketxt
    FROM car
    WHERE yeartxt < 2020
    GROUP BY maketxt
    ORDER BY amount DESC LIMIT 10;
    """
    print(call_table(text_queries=query))
    #print(call_table(table_name="Case", limit_rows=100))