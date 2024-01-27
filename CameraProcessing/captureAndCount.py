# import the opencv library 
import cv2
import numpy as np 

def mse(img1, img2):
   diff = cv2.subtract(img1, img2)
   err = np.sum(diff**2)
   mse = err/(float(480*640))
   return mse

# define a video capture object 
vid = cv2.VideoCapture(0) 

# read base
zero = cv2.imread("0.png", cv2.IMREAD_COLOR)
#capture image
ret, image = vid.read() 
# After the capture release the cap object 
vid.release()
result = mse(zero,image)
print(result)
with open('../error.txt', 'w') as fh:
    fh.write(str(result))