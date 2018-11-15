from word_dic import *
import os

rootDir="../B_크롤링 데이터(Filtered)/"
MAX=500

for i in os.listdir(rootDir):
	if os.path.isfile(rootDir+i): continue
	read='';index=0
	print(i,"시작")
	for e in os.listdir(rootDir+i):
		index+=1
		if index>MAX: break
		with open(rootDir+i+"/"+e,encoding='utf-8') as file:
			r=file.read()
			read+=r+'\n'
	with open("1__"+i+".csv","w") as file:
		file.write(word_dic(read))
