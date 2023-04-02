import cv2
import numpy as np

# https://stackoverflow.com/questions/66200036/pi-camera-exposure-control-using-opencv

# https://kelvinsp.medium.com/long-exposure-with-python-and-opencv-a242e1f1e42f

cap = cv2.VideoCapture(3)

# set exposure time to 10 seconds
cap.set(cv2.CAP_PROP_EXPOSURE, 0.01)

cap.set(cv2.CAP_PROP_AUTO_EXPOSURE, 0.75)

# read the first frame from the webcam
ret, image = cap.read()
image = image.astype(np.float32) / 255.0
while True:
    # read a new frame from the webcam
    ret, new_image = cap.read()
    new_image = new_image.astype(np.float32) / 255.0
    
    # # blend the images
    max_image = np.maximum(image, new_image)

    # display the blended image
    cv2.imshow('Blended Image', max_image)
    
    # exit on 'q' keypress
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
