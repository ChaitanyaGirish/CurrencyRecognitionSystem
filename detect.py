from utils import *
from matplotlib import pyplot as plt
from playsound import playsound
import subprocess
import requests
#from gtts import gTTS

def det():
        max_val = 8
        max_pt = -1
        max_kp = 0
        orb = cv2.ORB_create()

#test_img = read_img('files/test_100_2.jpg')
        test_img = read_img('test.jpg')

# resizing must be dynamic
#original = resize_img(test_img, 0.4)
#test_img=original
        #display('original', test_img)

# keypoints and descriptors
        (kp1, des1) = orb.detectAndCompute(test_img, None)

        training_set = ['files/20.jpeg', 'files/50.jpeg', 'files/100.jpeg', 'files/500.jpeg',
                        'files/50.jpg','files/20.jpg','files/100.jpg',
                        'files/10.jpg','files/10..jpg','files/2000.jpg','files/20..jpg' ]

        for i in range(0, len(training_set)):
	# train image
                train_img = cv2.imread(training_set[i])

                (kp2, des2) = orb.detectAndCompute(train_img, None)

	# brute force matcher
                bf = cv2.BFMatcher()
                all_matches = bf.knnMatch(des1, des2, k=2)

                good = []
	# give an arbitrary number -> 0.789
	# if good -> append to list of good matches
                for (m, n) in all_matches:
                        if m.distance < 0.789 * n.distance:
                                good.append([m])

                if len(good) > max_val:
                        max_val = len(good)
                        max_pt = i
                        max_kp = kp2

                print(i, ' ', training_set[i], ' ', len(good))

        if max_val != 8:
                print(training_set[max_pt])
                print('good matches ', max_val)

                train_img = cv2.imread(training_set[max_pt])
                img3 = cv2.drawMatchesKnn(test_img, kp1, train_img, max_kp, good,None,flags=2)

                if max_val > 16:
                        note = str(training_set[max_pt])[6:-4]
                        val=('\n REAL NOTE \n Detected denomination is Rs.'+ note+'    ')
                       #playsound('C:/Users/Chaitanya/Desktop/PROJECT/speech/'+note+'.mp3')
        
                        url = 'https://v3.exchangerate-api.com/bulk/3c8b18ac9e50c2ebba1c6323/INR'
                        response = requests.get(url)
                        data = response.json()
                        resp = data['rates']['USD']
                        resp = resp * (float(note))
                        val+=('                     US Dollars: ')
                        val+=(' '+str(resp))    
        
                            

                        resp = data['rates']['JPY']
                        resp = resp * (float(note))
                        val+=('                                           Japanese Yen: ')
                        val+=(' '+str(resp))
                       
	
                        resp = data['rates']['EUR']
                        resp = resp * (float(note))
                        val+=('                                              Euro: ')
                        val+=(' '+str(resp))
                        

                        resp = data['rates']['GBP']
                        resp = resp * (float(note))
                        val+=('                                                   Pound: ')
                        val+=(' '+str(resp))
                        
	
	
                        resp = data['rates']['CNY']
                        resp = resp * (float(note))
                        val+=('                                       Chinese Renminbi: ')
                        val+=(' '+str(resp))
                        
	
                        resp = data['rates']['AED']
                        resp = resp * (float(note))
                        val+=('                                  UAE Dirham: ')
                        val+=(' '+str(resp))
                        
	
                        return(val)
                else:
                        val=('FAKE NOTE')
                        return(val)		

