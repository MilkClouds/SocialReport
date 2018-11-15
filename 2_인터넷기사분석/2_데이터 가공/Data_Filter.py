import os,pickle
from bs4 import BeautifulSoup

# var ga_dimension3 = 'Money,Economy';

rootDirA="../A_크롤링 데이터(Raw)/"
rootDirB="../B_크롤링 데이터(Filtered)/"

for i in ['경제','국제','정치','사회','문화','스포츠','스타','지구촌','IT소식','사설·칼럼','브랜드뉴스','글로벌','라이프','여행·레저','평양&','SUNDAY','리빙']:
	if not os.path.exists(rootDirB+i): os.mkdir(rootDirB+i)

try: filtered=pickle.load(open('filtered.list','rb'))
except: filtered=[];
# print(filtered)
# filtered=[]

index=0
for i in os.listdir(rootDirA):
	if filtered.count(i) != 0: continue
	# if os.path.isfile(rootDir+"A_크롤링 데이터(Raw)/"+i)==False: continue
	if index>1000000:
		break
	index+=1
	with open(rootDirA+i,encoding='utf-8') as file:
		r=file.read()
		soup=BeautifulSoup(r,'html.parser')
		try: article_body=soup.select_one('#article_body').text
		except: continue
		category=soup.select_one("head > meta[property='article:section']")['content']
		print(i,category)
	with open(rootDirB+category+"/"+i,'w',encoding='utf-8') as file:
		file.write(article_body)
		filtered.append(i)
	if index%100==0:
		pickle.dump(filtered,open('filtered.list','wb'))

pickle.dump(filtered,open('filtered.list','wb'))



