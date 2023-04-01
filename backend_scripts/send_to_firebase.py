import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage
import requests
from io import BytesIO
import time
from PIL import Image

# Initialize Firebase Admin SDK
cred = credentials.Certificate('.\\serviceAccountKey.json')
firebase_admin.initialize_app(cred)

# Get a reference to the Firebase Storage bucket
bucket = storage.bucket("hackprinceton2023-2.appspot.com")

def send_to_firebase_storage(img_path):
    image_blob = bucket.blob(img_path)
    image_blob.upload_from_filename(img_path)
    

send_to_firebase_storage("output.jpg")