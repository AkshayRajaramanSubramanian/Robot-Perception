import cv2
import os
import numpy as np
import time
subjects = ["", "Akshay"]
x = []
y= []
w =[]
h =[]
def detect_face(img):
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    face_cascade = cv2.CascadeClassifier('opencv-files/lbpcascade_frontalface.xml')
    faces = face_cascade.detectMultiScale(gray, scaleFactor=1.2, minNeighbors=5);
    if (len(faces) == 0):
        return None, None
    for i in range (0,len(faces)):
        (x[i], y[i], w[i], h[i]) = faces[i]
    return gray[y:y+w, x:x+h], faces
def prepare_training_data(data_folder_path):
    dirs = os.listdir(data_folder_path)
    faces = []
    labels = []
    for dir_name in dirs:
        if not dir_name.startswith("s"):
            continue;
        label = int(dir_name.replace("s", ""))
        subject_dir_path = data_folder_path + "/" + dir_name
        subject_images_names = os.listdir(subject_dir_path)
        for image_name in subject_images_names:
            if image_name.startswith("."):
                continue;
            image_path = subject_dir_path + "/" + image_name
            image = cv2.imread(image_path)
            cv2.imshow("Training on image...", cv2.resize(image, (400, 500)))
            cv2.waitKey(100)
            face, rect = detect_face(image)
            if face is not None:
                faces.append(face)
                labels.append(label)
    cv2.destroyAllWindows()
    cv2.waitKey(1)
    cv2.destroyAllWindows()
    
    return faces, labels
faces, labels = prepare_training_data("training-data")
print("Total faces: ", len(faces))
print("Total labels: ", len(labels))
face_recognizer = cv2.face.createLBPHFaceRecognizer()
face_recognizer.train(faces, np.array(labels))
def draw_rectangle(img, rect):
    (x, y, w, h) = rect
    cv2.rectangle(img, (x, y), (x+w, y+h), (0, 255, 0), 2)
def draw_text(img, text, x, y):
    cv2.putText(img, text, (x, y), cv2.FONT_HERSHEY_PLAIN, 1.5, (0, 255, 0), 2)
def predict(test_img):
    img = test_img
    face, rect = detect_face(img)
    if not face is None:
        for j in range(0,len(face)):
            label = face_recognizer.predict(face[j])
            label_text[j] = subjects[label]
            draw_rectangle(img, rect[j])
            draw_text(img, label_text[j], rect[j], rect[j+1]-5)
        return (img,rect)
    return (test_img,None)
cap = cv2.VideoCapture(0)
while(True): 
    ret, frame = cap.read()
    time.sleep(0.01)
    if not frame is None:
            image_test = frame
            predicted_img,rect = predict(image_test)
            if not rect is None:
                for k in range(0,len(rect)):
                    (x, y, w, h) = rect
                    centrex = x + (w/2)
                    centrey = y + (h/2)
                    if(centrex>300):
                        print("left")
                    elif(centrex<300):
                        print("right")
            time.sleep(0.01)
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            cv2.imshow(subjects[1],image_test)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
cap.release()
cv2.destroyAllWindows()