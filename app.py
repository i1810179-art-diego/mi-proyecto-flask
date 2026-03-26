import os
from flask import Flask, render_template, request, redirect, url_for, session, jsonify
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity, set_access_cookies, unset_access_cookies
from functools import wraps
from db import get_connection

app = Flask(__name__)

# Configuración de Seguridad
app.secret_key = "clave_secreta_segura"
bcrypt = Bcrypt(app)
app.config["JWT_SECRET_KEY"] = "clave_apis_tokens"
app.config["JWT_TOKEN_LOCATION"] = ["cookies"] 
app.config["JWT_COOKIE_CSRF_PROTECT"] = False 
jwt = JWTManager(app)

# --- 1. AQUÍ DEFINIMOS EL DECORADOR (IMPORTANTE) ---
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "usuario_id" not in session:
            return redirect(url_for("login_web"))
        return f(*args, **kwargs)
    return decorated_function

# --- 2. RUTA PARA REPARAR EL ADMIN ---
@app.route('/', methods=['GET', 'POST'])
def inicio():
    nombre = None
    if request.method == 'POST':
        nombre = request.form['nombre']
    return render_template('index.html', nombre=nombre)
# -------------------------------
# RUTAS DE INTERFAZ WEB
# -------------------------------
@app.route("/login", methods=["GET", "POST"])
def login_web():
    if request.method == "POST":
        correo = request.form["correo"]
        clave = request.form["clave"]
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM usuarios_sistema WHERE correo = %s", (correo,))
        usuario = cursor.fetchone()
        conn.close()
        if usuario and bcrypt.check_password_hash(usuario['clave'], clave):
            session["usuario_id"] = usuario["id"]
            session["rol"] = usuario["rol"]
            session["nombre"] = usuario["nombre"]
            return redirect(url_for("usuarios"))
        return "Credenciales incorrectas"
    return render_template("login.html") 

@app.route("/logout")
@login_required
def logout():
    session.clear()
    return redirect(url_for("login_web"))

@app.route('/usuarios')
@login_required
def usuarios():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM usuarios")
    lista_usuarios = cursor.fetchall()
    conn.close()
    return render_template('usuarios.html', usuarios=lista_usuarios)

# -------------------------------
# API REST
# -------------------------------

@app.route("/api/login", methods=["POST"])
def api_login():
    data = request.get_json()
    correo = data.get('correo')
    clave = data.get('clave')
    
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM usuarios_sistema WHERE correo = %s", (correo,))
    usuario = cursor.fetchone()
    conn.close()

    if usuario and bcrypt.check_password_hash(usuario['clave'], clave):
        access_token = create_access_token(identity=str(usuario["id"]))
        resp = jsonify({
            "status": "ok", 
            "msg": "Login exitoso",
            "access_token": access_token 
        })
        set_access_cookies(resp, access_token)
        return resp, 200
    else:
        return jsonify({"status": "error", "msg": "Usuario o clave incorrecta"}), 401

@app.route("/api/usuarios", methods=["GET"])
def api_listar_usuarios():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM usuarios")
    data = cursor.fetchall()
    conn.close()
    return jsonify({"status": "ok", "data": data})

@app.route("/api/usuarios", methods=["POST"])
@jwt_required()
def api_crear_usuario():
    usuario_id_token = get_jwt_identity() 
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT rol FROM usuarios_sistema WHERE id = %s", (usuario_id_token,))
    usuario_que_pide = cursor.fetchone()
    
    if not usuario_que_pide or usuario_que_pide["rol"] != "administrador":
        conn.close()
        return jsonify({
            "status": "error", 
            "msg": "Acceso denegado. Solo administradores pueden agregar alumnos."
        }), 403

    data = request.get_json()
    nombre = data.get("nombre")
    email = data.get("email")
    
    try:
        cursor.execute("INSERT INTO usuarios (nombre, email) VALUES (%s, %s)", (nombre, email))
        conn.commit()
        return jsonify({"status": "ok", "message": "Usuario creado"}), 201
    except Exception as e:
        return jsonify({"status": "error", "msg": str(e)}), 500
    finally:
        conn.close()

@app.route("/api/logout", methods=["POST"])
def api_logout():
    resp = jsonify({"status": "ok", "msg": "Sesión de API cerrada"})
    unset_access_cookies(resp)
    return resp, 200

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port)