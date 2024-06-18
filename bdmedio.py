import pymysql.cursors

def obtenerconexion():
    try:
        connection = pymysql.connect(host='brandomedina.mysql.pythonanywhere-services.com',
                                     user='brandomedina',
                                     password='Brandobryan22',
                                     database='brandomedina$pa2',
                                     cursorclass=pymysql.cursors.DictCursor)
        return connection
    except Exception as e:
        print(f"Error connecting to the database: {e}")
        return None