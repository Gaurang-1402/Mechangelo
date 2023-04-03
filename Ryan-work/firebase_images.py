import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage
import requests
from io import BytesIO
import time
from PIL import Image


if 'cred' not in dir():
    # Initialize Firebase Admin SDK
    cred = credentials.Certificate('serviceAccountKey.json')
    firebase_admin.initialize_app(cred)
    
    # Get a reference to the Firebase Storage bucket
    bucket = storage.bucket("hackprinceton2023-2.appspot.com")

    # Keep track of the last modified time of the image file
    last_modified = None

def get_new_image():
    global last_modified,bucket,firebase_admin,cred
    while True:
        # List all files in the bucket
        blobs = bucket.list_blobs()
    
        filename='image.png'
        # Find the image file
        for blob in blobs:
            if blob.name ==filename:
                # Check if the file has been modified
                if not last_modified or blob.updated > last_modified:
                    # Update the last modified time
                    last_modified = blob.updated
                    
                    # Download the blob as bytes
                    blob_bytes = blob.download_as_bytes()
    
                    # Open the bytes as an image using Pillow
                    image = Image.open(BytesIO(blob_bytes))
    
                    # Save the image to a local file
                    image.save(filename)
    
                    print("Image file has been modified")
                    return rp.load_image(filename)
        print('Polling!')
        sleep(.5)
        
