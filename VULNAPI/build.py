#!/usr/bin/python
import psycopg2
import config

def connect():
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        # read connection parameters
        params = config.get_db_config()

        # connect to the PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(**params)
		
        # create a cursor
        cur = conn.cursor()
        user_input = ""
	# execute a statement
        while(user_input != "q"or user_input != "Q"):
            print("Enter 'q' or 'Q' to quit")
            user_input = input("Enter <PostgreSQL command> followed by ';' : ")
            

            # SQL Query you'd like to run should be in the quotes with a semicolon at the end
            cur.execute(user_input)  
            # display the PostgreSQL database return message
            result = cur.fetchone()
            print(result)
       
	# close the communication with the PostgreSQL
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
            print('Database connection closed.')


if __name__ == '__main__':
    connect()
