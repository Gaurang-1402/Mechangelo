import cv2
import numpy as np


cap = cv2.VideoCapture(3)
# set the frame size to 640x480
cap.set(3, 640)
cap.set(4, 480)

# initialize the accumulated image
accumulated_image = np.zeros((480, 640, 3), np.uint8)

# set exposure time to 10 seconds
cap.set(cv2.CAP_PROP_EXPOSURE, 10)

while True:
    # read a frame from the video stream
    ret, frame = cap.read()
    
    # add the current frame to the accumulated image
    accumulated_image = cv2.addWeighted(accumulated_image, 0.5, frame, 0.5, 0)
    
    # display the accumulated image
    cv2.imshow('Accumulated Image', accumulated_image)
    
    # check if the user wants to exit
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break



# save the accumulated image
cv2.imwrite('light_painting.jpg', accumulated_image)
