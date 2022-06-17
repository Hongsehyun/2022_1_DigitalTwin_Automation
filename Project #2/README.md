# 2022-1_DTA_Garbage_Classification

**2022.06.17. Fri**

​	

**Handong Global University, School of Mechanical and Control Engineering, 2022-1 DigitalTwin&Automation**

21500018 | 강희윤

21700791 | 홍세현

21900726 | 지현빈


![image](https://user-images.githubusercontent.com/84533279/173822161-78baf6a8-6bdf-46b9-a990-63b9ed181984.png)


​	

## Introduction

이 Repository는 한동대학교 2022년 1학기에 진행된 DigitalTwin & Automation 수업의 기말 프로젝트인, **생활 폐기물 재활용률 향상을 위한 재활용 쓰레기 분류 로봇의 설계 및 구현** (Design and Implementation of Garbage Classification Robot to Improve Recycling Rate of Household Waste) 에 대한 **튜토리얼**이 포함되어 있습니다.

재활용 쓰레기 자동 분류 공정 구현이 목적이었기에, **컨베이어 벨트 구동 및 하드웨어 설계 파트**, **재활용 쓰레기 분류 및 영상 처리 파트**, **Indy-10(Neuro-Meka)를 활용한 재활용 쓰레기 분류 자동화 파트**로 세분화하여 이번 프로젝트를 진행하였습니다.

​	

**컨베이어 벨트 구동 및 하드웨어 설계 파트**에서는 

​	

**재활용 쓰레기 분류 및 영상 처리 파트**에서는 **Kaggle**에서 제공된 **Garbage Classification Dataset**을 바탕으로 *Can, Plastic, Cardboard*에 대한 Multi-Classification을 진행하였으며, 보다 효과적인 학습과 높은 정확도의 분류를 위해 **FastAI** Library 와 **Resnet34** 알고리즘을 사용하였습니다. 또한, Test Data는 임의로 촬영한 재활용품 사진으로 구성함으로써 무작위 사진에 대한 모델의 성능을 검증하였습니다. 이후에는, 학습된 모델과 Python OpenCV Library를 이용하여 Web camera을 통한 실시간 재활용품 분류를 진행하였습니다.

​	

**Indy-10(Neuro-Meka)를 활용한 재활용 쓰레기 분류 자동화 파트**에서는 

​	

**이 프로젝트는 한동대학교 김영근 교수님의 지도아래 진행되었습니다.**

​	

​	

​	

## Requirements

본 프로젝트에서는 **Python 3.9.7 버전**, **OpenCV 4.5.5 버전**, **Tensorflow 2.9.0 버전**, **Torch 1.11.0 버전**을 사용하였습니다. 특히, 이 프로젝트에서 사용하고 있는  FastAI의 Library를 사용하기 위해서는 **FastAI 1.0.61. 버전**이 필요합니다.

한편, **Resnet34**를 이용한 Model Train과정에서는 **NVIDIA GeForce RTX 3060 Laptop GPU cuda device** 환경에서 15 epochs 학습에 평균 20분이 소모되었습니다. 따라서, 고성능의 GPU 환경을 갖춘뒤 Model Train을 진행하길 권장합니다. 딥러닝 학습 환경이 갖추어지지 못한 경우라면, 이번 프로젝트에서 pre-trained된 model파일을 같이 첨부하였으므로 이를 참고하시면 되겠습니다. 

​	

​	

​	

## File Description

![image](https://user-images.githubusercontent.com/84533279/174224313-cc17a366-6973-43c0-802f-f85579121361.png)

​	1. Conveyor_Belt_Driving :: 

​	2. Garbage_Classification_ImageProcessing ::

​	3. Garbage_Classification_Automation ::

​	md_files ::

​	Pre-trained Data and Model.zip ::

​

​

​
## Contents

​	

### ■ Demo Scenario  

​		[Reference Link](https://github.com/Hongsehyun/2022_1_DigitalTwin_Automation/blob/main/Project%20%232/md_files/1.%20Demo_Scenario.md)

​	

### ■ Garbage Classification Hardware Setting

​		[Reference Link](https://github.com/Hongsehyun/2022_1_DigitalTwin_Automation/blob/main/Project%20%232/md_files/2.%20Garbage_Classification_Hardware_Setting.md)

​	

### ■ Garbage Classification Image Processing

​		[Reference Link](https://github.com/Hongsehyun/2022_1_DigitalTwin_Automation/blob/main/Project%20%232/md_files/3.%20Garbage_Classification_Image_Processing.md)

​	

### ■ Garbage Classification Automation

​		[Reference Link](https://github.com/Hongsehyun/2022_1_DigitalTwin_Automation/blob/main/Project%20%232/md_files/4.%20Garbage_Classification_Automation.md)

​	

### ■ Demonstrate Project Results

​		[Reference Link](https://github.com/Hongsehyun/2022_1_DigitalTwin_Automation/blob/main/Project%20%232/md_files/5.%20Demonstrate_Project_Result.md)

​	

​	

​	

## Reference

​		[Reference Link - Kaggle Garbage Classification Dataset](https://www.kaggle.com/datasets/asdasdasasdas/garbage-classification)

​		[Reference Link - Prior Research of Garbage Image Training](https://github.com/gibiee/Trash_Classification)
