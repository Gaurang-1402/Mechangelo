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

# Keep track of the last modified time of the image file
last_modified = None


while True:
    # List all files in the bucket
    blobs = bucket.list_blobs()

    # Find the image file
    for blob in blobs:
        if blob.name == "image.jpg":
            # Check if the file has been modified
            if not last_modified or blob.updated > last_modified:
                # Update the last modified time
                last_modified = blob.updated
                
                print("Image file has been modified")

    # Wait for 5 seconds before checking again
    time.sleep(5)


