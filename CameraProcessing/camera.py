# import the opencv library 
import cv2 

# define a video capture object 
vid = cv2.VideoCapture(0) 
  
 
# Capture the video frame 
# by frame 
ret, image = vid.read() 
  
# write
cv2.imwrite("0.png",image)
  
# After the loop release the cap object 
vid.release()