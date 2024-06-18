from flask import Flask, request, jsonify
from bdmedio import obtenerconexion
from flask_jwt import JWT, jwt_required, current_identity
from bd1 import obtenerconexionU
import hashlib

### SEGURIDAD - INICIO ###
class User(object):
    def __init__(self, id, username, password):
        self.id = id
        self.username = username
        self.password = password

    def __str__(self):
        return "User(id='%s')" % self.id

def buscarusuario_username(p_username):
    conn = obtenerconexionU()
    objUsuario = None
    if conn is not None:
        try:
            with conn.cursor() as cursor:
                sql = "SELECT `id`, `email`, `password` FROM `users` WHERE `email` = %s"
                cursor.execute(sql, (p_username,))
                result = cursor.fetchone()
                if result:
                    objUsuario = User(result["id"], result["email"], result["password"])
        except Exception as e:
            print(f"Error en buscarusuario_username +o usuario no autenticado: {e}")
        finally:
            conn.close()
    return objUsuario

def buscarusuario_id(p_id):
    conn = obtenerconexionU()
    objUsuario = None
    if conn is not None:
        try:
            with conn.cursor() as cursor:
                sql = "SELECT `id`, `email`, `password` FROM `users` WHERE `id` = %s"
                cursor.execute(sql, (p_id,))
                result = cursor.fetchone()
                if result:
                    objUsuario = User(result["id"], result["email"], result["password"])
        except Exception as e:
            print(f"Error en buscarusuario_id o usuario no autenticado: {e}")
        finally:
            conn.close()
    return objUsuario

def authenticate(username, password):
    user = buscarusuario_username(username)
    if user and verificar_password(password, user.password):
        return user
def verificar_password(password, hashed_password):
    return hashlib.sha256(password.encode('utf-8')).hexdigest() == hashed_password

def identity(payload):
    user_id = payload['identity']
    return buscarusuario_id(user_id)

### SEGURIDAD - FIN ###

app = Flask(__name__)
app.debug = True
app.config['SECRET_KEY'] = 'super-secret'

jwt = JWT(app, authenticate, identity)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@app.route("/probarconexion")
def probarconexion():
    try:
        conn = obtenerconexion()
        if conn is not None:
            return "Conexión exitosa base medio"
        else:
            return "Problemas en la conexión MySQL"
    except Exception as e:
        return "Problemas en la función del sistema. " + repr(e)


@app.route('/api_registrarusuario', methods=['POST'])
def api_registrarusuario():
    try:
        usuario = request.json["usuario"]
        password = request.json["pass"]
        hashed_password = hashlib.sha256(password.encode('utf-8')).hexdigest()
        conn = obtenerconexionU()
        with conn.cursor() as cursor:
            sql = "INSERT INTO users (email, password) VALUES (%s, %s)"
            cursor.execute(sql, (usuario, hashed_password))
        conn.commit()
        response = {
            'code': 1,
            'data': {'usuario': usuario},
            'message': 'Usuario registrado correctamente'
        }
    except Exception as e:
        response = {
            'code': 0,
            'data': {},
            'message': 'Error al registrar usuario: ' + str(e)
        }
    finally:
        conn.close()

    return jsonify(response)


@app.route('/api_registrarevento', methods=['POST'])
@jwt_required()
def api_registrarevento():
    try:
        tipo_evento = request.json["tipo_evento"]
        nivel = request.json["nivel"]
        fecha_hora= request.json["fecha_hora"]
        origen = request.json["origen"]
        id_evento = request.json["id_evento"]
        categoria_tarea = request.json["categoria_tarea"]
        conn = obtenerconexion()
        with conn.cursor() as cursor:
            if tipo_evento != "seguridad":
                sql = "INSERT INTO eventos (tipo_evento, nivel, fecha_hora, origen,id_evento, categoria_tarea) VALUES (%s, %s, %s, %s, %s, %s)"
                cursor.execute(sql, (tipo_evento, nivel, fecha_hora, origen, id_evento, categoria_tarea))
            else:
               api_registrarseguridad()
        conn.commit()
        response = {
            'code': 1,
            'data': {},
            'message': 'Evento registrado correctamente'
        }
    except Exception as e:
        response = {
            'code': 0,
            'data': {},
            'message': 'Error al registrar evento: ' + str(e)
        }
    finally:
        conn.close()

    return jsonify(response)

@app.route('/api_registrarseguridad', methods=['POST'])
@jwt_required()
def api_registrarseguridad():
    try:
        palabras_clave = request.json["palabras_clave"]
        fecha_hora = request.json["fecha_hora"]
        origen = request.json["origen"]
        id_evento = request.json["id_evento"]
        categoria_tarea = request.json["categoria_tarea"]
        conn = obtenerconexion()
        with conn.cursor() as cursor:
            sql = "INSERT INTO seguridad (palabras_clave, fecha_hora, origen,id_evento, categoria_tarea) VALUES (%s, %s, %s, %s, %s)"
            cursor.execute(sql, (palabras_clave, fecha_hora, origen, id_evento, categoria_tarea))
        conn.commit()
        response = {
            'code': 1,
            'data': {},
            'message': 'Evento registrado correctamente'
        }
    except Exception as e:
        response = {
            'code': 0,
            'data': {},
            'message': 'Error al registrar evento: ' + str(e)
        }
    finally:
        conn.close()

    return jsonify(response)


@app.route('/api_registraraplicacion', methods=['POST'])
@jwt_required()
def api_registraraplicacion():
    try:
        nivel = request.json["nivel"]
        fecha_hora = request.json["fecha_hora"]
        origen = request.json["origen"]
        id_evento = request.json["id_evento"]
        categoria_tarea = request.json["categoria_tarea"]
        conn = obtenerconexion()
        with conn.cursor() as cursor:
            sql = "INSERT INTO aplicacion (nivel, fecha_hora, origen,id_evento, categoria_tarea) VALUES (%s, %s, %s, %s, %s)"
            cursor.execute(sql, (nivel, fecha_hora, origen, id_evento, categoria_tarea))
        conn.commit()
        response = {
            'code': 1,
            'data': {},
            'message': 'Evento registrado correctamente'
        }
    except Exception as e:
        response = {
            'code': 0,
            'data': {},
            'message': 'Error al registrar evento: ' + str(e)
        }
    finally:
        conn.close()

    return jsonify(response)

@app.route('/api_registrarinstalacion', methods=['POST'])
@jwt_required()
def api_registrarinstalacion():
    try:
        nivel = request.json["nivel"]
        fecha_hora = request.json["fecha_hora"]
        origen = request.json["origen"]
        id_evento = request.json["id_evento"]
        categoria_tarea = request.json["categoria_tarea"]
        conn = obtenerconexion()
        with conn.cursor() as cursor:
            sql = "INSERT INTO instalacion (nivel, fecha_hora, origen,id_evento, categoria_tarea) VALUES (%s, %s, %s, %s, %s)"
            cursor.execute(sql, (nivel, fecha_hora, origen, id_evento, categoria_tarea))
        conn.commit()
        response = {
            'code': 1,
            'data': {},
            'message': 'Evento registrado correctamente'
        }
    except Exception as e:
        response = {
            'code': 0,
            'data': {},
            'message': 'Error al registrar evento: ' + str(e)
        }
    finally:
        conn.close()

    return jsonify(response)

@app.route('/api_registrarsistema', methods=['POST'])
@jwt_required()
def api_registrarsistema():
    try:
        nivel = request.json["nivel"]
        fecha_hora = request.json["fecha_hora"]
        origen = request.json["origen"]
        id_evento = request.json["id_evento"]
        categoria_tarea = request.json["categoria_tarea"]
        conn = obtenerconexion()
        with conn.cursor() as cursor:
            sql = "INSERT INTO sistema (nivel, fecha_hora, origen,id_evento, categoria_tarea) VALUES (%s, %s, %s, %s, %s)"
            cursor.execute(sql, (nivel, fecha_hora, origen, id_evento, categoria_tarea))
        conn.commit()
        response = {
            'code': 1,
            'data': {},
            'message': 'Evento registrado correctamente'
        }
    except Exception as e:
        response = {
            'code': 0,
            'data': {},
            'message': 'Error al registrar evento: ' + str(e)
        }
    finally:
        conn.close()

    return jsonify(response)

@app.route('/api_registrarsqlserver', methods=['POST'])
@jwt_required()
def api_registrarsqlserver():
    try:
        date = request.json["date"]
        source = request.json["source"]
        message  = request.json["message"]
        log_type = request.json["log_type"]
        log_source = request.json["log_source"]
        conn = obtenerconexion()
        with conn.cursor() as cursor:
            sql = "INSERT INTO sqlserver (date, source, message, log_type, log_source) VALUES ( %s, %s, %s, %s, %s)"
            cursor.execute(sql, (date, source, message, log_type, log_source))
        conn.commit()
        response = {
            'code': 1,
            'data': {},
            'message': 'sql registrado correctamente'
        }
    except Exception as e:
        response = {
            'code': 0,
            'data': {},
            'message': 'Error al registrar sql: ' + str(e)
        }
    finally:
        conn.close()

    return jsonify(response)

@app.route('/obtenerregistros', methods=['GET'])
@jwt_required()
def obtener_registros():
    rpta = dict()
    try:
        conn = obtenerconexion()
        if conn is not None:
            tablas = ['eventos', 'sqlserver']
            registros = {}
            for tabla in tablas:
                with conn.cursor() as cursor:
                    cursor.execute(f'SELECT * FROM {tabla}')
                    registros[tabla] = cursor.fetchall()
            conn.close()
            rpta["code"] = 1
            rpta["message"] = "Registros obtenidos exitosamente"
            rpta["data"] = registros
        else:
            rpta["code"] = 0
            rpta["message"] = "Problemas en la conexión MySQL"
    except Exception as e:
        rpta["code"] = -1
        rpta["message"] = "Problemas en la función del sistema. " + repr(e)
    return jsonify(rpta)

