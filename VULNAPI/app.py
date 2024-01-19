from flask import Flask, jsonify, render_template, request
import psycopg2
import config

app = Flask(__name__)

def connect():
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        # read connection parameters
        params = config.get_db_config()

        # connect to the PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(**params)

        return conn
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

def close_connection(conn):
    """ Close the PostgreSQL database connection """
    if conn is not None:
        conn.close()
        print('Database connection closed.')

@app.route('/')
def begin():
    return render_template('welcome.html')

@app.route('/addfiles', methods=['POST'])
def add_files():
    conn = connect()
    try:
        data = request.get_json()
        print('Received data:', data)

        file_taken = data.get('file', '')
        file_path = data.get('file_path', '')
        is_infected = data.get('infected', False)
        is_clean = data.get('clean', False)
        is_quarantined = data.get('quarantine', False)

        cur = conn.cursor()

        # Check if the file already exists in the database
        cur.execute("SELECT COUNT(*) FROM files WHERE file = %s AND file_path = %s",
                    (file_taken, file_path))
        count = cur.fetchone()[0]

        if count == 0:
            # File doesn't exist, proceed with insertion
            cur.execute(
                "INSERT INTO files (file, file_path, infected, clean, quarantine) VALUES (%s, %s, %s, %s, %s)",
                (file_taken, file_path, is_infected, is_clean, is_quarantined)
            )
            conn.commit()
            return jsonify({'message': 'File added successfully'})
        else:
            # File already exists, return a message
            return jsonify({'message': 'File already exists in the database'})

    except Exception as e:
        return jsonify({'error': str(e)})
    finally:
        close_connection(conn)


@app.route('/getfiles')
def get_files():
    conn = connect()
    try:
        cur = conn.cursor()
        cur.execute("SELECT * FROM files")
        files = [{'id': row[0], 'file': row[1], 'file_path': row[2], 'infected': row[3], 'clean': row[4], 'quarantine': row[5]} for row in cur.fetchall()]
        return jsonify(files)
    except Exception as e:
        return jsonify({'error': str(e)})
    finally:
        close_connection(conn)

@app.route('/getinfectedfiles')
def get_infected_files():
    conn = connect()
    try:
        cur = conn.cursor()
        cur.execute("SELECT * FROM files WHERE infected = true")
        infected_files = [{'id': row[0], 'file': row[1], 'file_path': row[2], 'infected': row[3], 'clean': row[4], 'quarantine': row[5]} for row in cur.fetchall()]
        return jsonify(infected_files)
    except Exception as e:
        return jsonify({'error': str(e)})
    finally:
        close_connection(conn)

@app.route('/getquarantinedfiles')
def get_quarantined_files():
    conn = connect()
    try:
        cur = conn.cursor()
        cur.execute("SELECT * FROM files WHERE quarantine = true")
        quarantined_files = [{'id': row[0], 'file': row[1], 'file_path': row[2], 'infected': row[3], 'clean': row[4], 'quarantine': row[5]} for row in cur.fetchall()]
        return jsonify(quarantined_files)
    except Exception as e:
        return jsonify({'error': str(e)})
    finally:
        close_connection(conn)
        
@app.route('/getfile/<int:file_id>', methods=['GET'])
def get_file(file_id):
    conn = connect()
    try:
        cur = conn.cursor()
        cur.execute("SELECT * FROM files WHERE id = %s", (file_id,))
        file_data = cur.fetchone()

        if file_data:
            file = {
                'id': file_data[0],
                'file': file_data[1],
                'file_path': file_data[2],
                'infected': file_data[3],
                'clean': file_data[4],
                'quarantine': file_data[5]
            }
            return jsonify(file)
        else:
            return jsonify({'error': 'File not found'})
    except Exception as e:
        return jsonify({'error': str(e)})
    finally:
        close_connection(conn)

@app.route('/updatefile', methods=['PUT'])
def update_file():
    conn = connect()
    
    try:
        data = request.get_json()
        file = data['file']

        # Retrieve the existing file data
        cur = conn.cursor()
        cur.execute("SELECT * FROM files WHERE file = %s", (file,))
        existing_file = cur.fetchone()

        if existing_file:
            # Update fields that are present in the request
            file_taken = data.get('file', existing_file[1])
            file_path = data.get('file_path', existing_file[2])
            is_infected = data.get('infected', existing_file[3])
            is_clean = data.get('clean', existing_file[4])
            is_quarantined = data.get('quarantine', existing_file[5])

            # Perform the update
            cur.execute(
                "UPDATE files SET file = %s, file_path = %s, infected = %s, clean = %s, quarantine = %s WHERE file = %s",
                (file_taken, file_path, is_infected, is_clean, is_quarantined, file)
            )
            conn.commit()

            return jsonify({'message': 'file updated successfully'})
        else:
            return jsonify({'error': 'File not found'})
    except Exception as e:
        return jsonify({'error': str(e)})
    finally:
        close_connection(conn)

@app.route('/add_message', methods=['POST'])
def add_message():
    try:
        conn = connect()
        if conn is None:
            return jsonify({'error': 'Unable to connect to the database'}), 500

        data = request.get_json()
        message_text = data.get('message_text')

        if message_text is None:
            return jsonify({'error': 'Message text is required'}), 400

        cur = conn.cursor()
        cur.execute("INSERT INTO feedback_messages (message) VALUES (%s) RETURNING id;", (message_text,))
        inserted_id = cur.fetchone()[0]
        conn.commit()
        cur.close()

        return jsonify({'message': 'Message added successfully', 'id': inserted_id}), 201

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    finally:
        close_connection(conn)

@app.route('/deletefile', methods=['DELETE'])
def delete_file():
    conn = connect()
    try:
        data = request.get_json()
        file_name = data['file_name']

        if not file_name:
            return jsonify({'error': 'File name is required'}), 400

        cur = conn.cursor()
        cur.execute("DELETE FROM files WHERE file = %s", (file_name,))
        conn.commit()
        cur.close()

        return jsonify({'message': f'File {file_name} deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        close_connection(conn)


if __name__ == '__main__':
    print("Welcome to VULN")
    app.run(host='0.0.0.0',port=5000)
