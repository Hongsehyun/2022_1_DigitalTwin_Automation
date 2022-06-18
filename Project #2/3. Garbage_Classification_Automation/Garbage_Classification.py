import warnings
warnings.filterwarnings('ignore')
from pathlib import Path
import os
import cv2 as cv
import numpy as np

import fastai
import tensorflow as tf

import time

from fastai.vision import *

def DeleteAllFiles(filePath):
    if os.path.exists(filePath):
        for file in os.scandir(filePath):
            os.remove(file.path)
        return 'Remove All File'
    else:
        return 'Directory Not Found'
        
# 플로 결과 그리기 + 물체 Tracking하며 중심좌표 출력하기
def drawFlow(img, flow, flag_change_ok, step=10):                                                  # step = 그리드 한 칸 한 칸의 간격 지정
    h, w = img.shape[:2]
    flag = 0
    x_center = 0
    y_center = 0
    
    # 10픽셀 간격의 그리드 인덱스 구하기
    idx_y, idx_x = np.mgrid[step/2 : h : step , step/2 : w : step].astype(np.int) 
    indices = np.stack((idx_x, idx_y), axis=-1).reshape(-1, 2)                    # 각 포인트의 좌표를 모두 생성
    
    
    # 인덱스 순회
    for x, y in indices:
        # 각 그리드 인덱스 위치에 점 그리기
        cv.circle(img, (x, y), 1, (0, 212, 255), 1)                                 # img, center, radius, color, thickness

        # 각 그리드 인덱스에 해당하는 플로 결과 값(이동 거리)
        dx, dy = flow[y, x].astype(np.int)
        
        # Thres Val [1] - 충분히 이동하였는가 :: 노이즈, 먼지 등을 탐지하는 경우를 1차로 방지!
        if dx > 5 or dx < -5 or dy > 5 or dy < -5:           
            x_idx.append(x)                                
            y_idx.append(y)
            
            x_center = sum(x_idx)/len(x_idx)                                    
            y_center = sum(y_idx)/len(y_idx)
            
        # 각 그리드 인덱스 위치에서 이동한 거리만큼 선 그리기
        cv.line(img, (x, y), (x+dx, y+dy), (0, 212, 255), 2, cv.LINE_AA)              # img, center, radius, color, thickness
    
    
    # Thres Val [2] - 물체가 실존하는가 :: 노이즈, 먼지 등을 탐지하는 경우를 2차로 방지!
    
    if len(x_idx)>15 and len(y_idx)>15 and x_center > 400:                                     
        if flag_change_ok == 1:
            # print('x_center: {},   y_center: {}\n'.format(x_center, y_center))
            flag = 1
    
    
    return flag, x_center, y_center

path = Path(os.getcwd())      # dir = Path(dir_name)
path = path/"data"            # file = dir / sub_dir_name / file_name     즉, '/'를 통해 파일을 하나하나 들어갈 수 있다.

width = 600
height = 300

# 영상 기록을 위한 변수 선언
fourcc  = cv.VideoWriter_fourcc(*'DIVX')
frame1  = cv.VideoWriter("frame_src.avi", fourcc, 30, (width, height))
frame2  = cv.VideoWriter("frame_with_motion_detection.avi", fourcc, 30, (width, height))

# pip install --user opencv-contrib-python
x_idx = []
y_idx = []
  

prev   = None # 이전 프레임 저장 변수

cap   = cv.VideoCapture(0)
if cap.isOpened():
    print("Camera connected")

bFlip = 0
flag  = 0
x_center = 0
y_center = 0
    
model_file_name = 'garbage_classification_model'

while cap.isOpened():
    ret, frame  =  cap.read()
    frame       = cv.resize(frame,(width, height))
    
    frame_src       =  cv.flip(frame, 1)
    frame_dst       =  cv.flip(frame, 1)
    
    # x축 방향의 위치 정보를 pixel 단위로 출력하기
    cv.putText(frame_dst, 'Cam ON', (10, 55), cv.FONT_HERSHEY_PLAIN, 2, (0, 0, 255), 2)
    cv.putText(frame_dst, '100', (100, 290), cv.FONT_HERSHEY_PLAIN, 1, (0, 0, 255), 1)
    cv.putText(frame_dst, '200', (200, 290), cv.FONT_HERSHEY_PLAIN, 1, (0, 0, 255), 1)
    cv.putText(frame_dst, '300', (300, 290), cv.FONT_HERSHEY_PLAIN, 1, (0, 0, 255), 1)
    cv.putText(frame_dst, '400', (400, 290), cv.FONT_HERSHEY_PLAIN, 1, (0, 0, 255), 1)
    cv.putText(frame_dst, '500', (500, 290), cv.FONT_HERSHEY_PLAIN, 1, (0, 0, 255), 1)
    
    cv.putText(frame_dst, '100', (20, 100), cv.FONT_HERSHEY_PLAIN, 1, (0, 0, 255), 1)
    cv.putText(frame_dst, '200', (20, 200), cv.FONT_HERSHEY_PLAIN, 1, (0, 0, 255), 1)
    
    
    x_idx = []
    y_idx = []
    max_idxs_li = []
    yhat = []
    y = []
  

    if not ret:
        break

    gray   = cv.cvtColor(frame_src, cv.COLOR_BGR2GRAY)
    gray   = cv.blur(gray,(11,11))
    
    f_robot = open("robot_state.txt", "r")
    robot_state = f_robot.readline()
    f_robot.close()
    
    # 로봇이 대기모드인지 확인하기
    if  robot_state == '0':   flag_change_ok = 1
    else                  :   flag_change_ok = 0

     
    # print("robot_state, flag_change: ", robot_state, flag_change_ok)

    # 최초 프레임의 경우
    if prev is None:
        prev = gray # 첫 이전 프레임
        
    else:
        # 이전, 이후 프레임으로 옵티컬 플로 계산
        flow = cv.calcOpticalFlowFarneback(prev, gray, None, 0.5, 3, 15, 3, 5, 1.1, cv.OPTFLOW_FARNEBACK_GAUSSIAN)
               # input array prev, input array next, input ouput array, pyramid scale, levels, window size, iterations, poly_n, poly_sigma, flags
        
        # 계산 결과 그리기, 선언한 함수 호출
        flag, x_center, y_center = drawFlow(frame_dst, flow, flag_change_ok)

        # 다음 프레임을 위해 이월
        prev = gray
    
    # When object Detected
    if flag == 1:
        # Folder Clearing
        cv.putText(frame_dst, 'Detected!', (210, 55), cv.FONT_HERSHEY_PLAIN, 2, (0, 0, 255), 2)
        
        print(DeleteAllFiles('data/test_real'))
        print(DeleteAllFiles('RealTime_Test_Input_Image'))
        
        # Get Cam Image and Resizing
        cv.imwrite("RealTime_Test_Input_Image/test_image.jpg",frame_src)
        src = cv.imread('RealTime_Test_Input_Image/test_image.jpg')
        dst = cv.resize(src, dsize=(512, 384), interpolation=cv.INTER_AREA)
        cv.imwrite('data/test_real/test_image.jpg', dst)
        
        flag = 2
    
    # Predict
    if flag == 2:
        # Test Data Define
        data = ImageDataBunch.from_folder(path, test="test_real")
        
        # Model Define (Get Pre-Trained Model)
        learn = cnn_learner(data, models.resnet34, metrics=error_rate)
        learn.load(model_file_name)
        
        img = learn.data.test_ds[0][0]
        
        # Predict Test Data
        preds = learn.predict(img)
        
        max_idxs = np.argmax(preds[2])
        max_idxs = np.array(max_idxs)
        max_idxs_li.append(max_idxs)
        
        # 부여된 번호를 토대로 class의 이름을 부여
        yhat.append(data.classes[max_idxs])
        
        # 출력
        # print("predict = {}\n\n".format(yhat[0]))
        cv.putText(frame_dst, yhat[0], (410, 55), cv.FONT_HERSHEY_PLAIN, 2, (0, 0, 255), 2)
        cv.putText(frame_src, yhat[0], (410, 55), cv.FONT_HERSHEY_PLAIN, 2, (0, 0, 255), 2)

        # 재활용품 분류 정보를 텍스트 파일에 
        f = open('garbage_type.txt', 'w')
        f.write(yhat[0])
        f.close()

        for i in range(5):
            print(yhat[0])

        flag = 0
        time.sleep(1)
            
    # Cam Printing
    cv.imshow('OpticalFlow-Farneback', frame_dst)
    cv.imshow('Original_Cam', frame_src)

    # 영상 기록하기
    frame1.write(frame_src)
    frame2.write(frame_dst)
    
    # Break Cam when ESC Pushed
    k = cv.waitKey(5) & 0xFF
    if k == 27:
        break

cap.release()
frame1.release()
frame2.release()
cv.destroyAllWindows()
