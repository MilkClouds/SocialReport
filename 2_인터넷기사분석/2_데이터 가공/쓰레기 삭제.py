import re,os,sys

rootDir="../B_크롤링 데이터(Filtered)/"

index=0
for i in os.walk(rootDir):
	for e in i[2]:
		f=i[0]+"/"+e
		# print(f)
		with open(f,encoding='utf-8') as file:
			r=file.read()
			r=re.sub(r"\d\d\d\d\.\d\d\.\d\d",'',r)
			r=re.sub(r'【(.*?)】','',r)
			r=re.sub(r'\[(.*?)\]','',r)
			r=re.sub(r'[\w.]+@[\w.]+','',r)    # 이메일
			r=re.sub(r'<저작권(.*?)>','',r)
			r=re.sub(r'< Copyright(.*?)>','',r)
			r=re.sub(r'[ㄱ-ㅎ가-힣ㅏ-ㅣ]{2,4} 기자','',r)
			print(r)
		index+=1
		# if index>5:sys.exit()
		with open(f,'w',encoding='utf-8') as file:
			file.write(r)
		print(e)

