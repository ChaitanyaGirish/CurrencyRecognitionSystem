import socket
from flask import Flask, request,jsonify
from io import BytesIO
import flask
import base64
import re
import json
from detect import *

app=flask.Flask(__name__)

@app.route('/',methods=['POST','GET'])

def image():
#if request.method == 'POST':
    
    data = request.json
    
    with open("test.jpg","wb") as save:
        im = base64.b64decode(data['image'])
        save.write(im)
    value=det()
    mess=('Image Uploaded Successfully '+ value )
    return value
        
	
if __name__ == '__main__':
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    print(f"Hostname: {hostname}")
    print(f"IP address: {ip_address}")
    app.run(host="0.0.0.0", port=5000, debug=True)
	
