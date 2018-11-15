import urllib,urllib3,pickle,sys
from bs4 import BeautifulSoup as bs

def opendict(text):
	openApiURL = "http://opendict.korean.go.kr/api/view"
	accessKey = "147DD99A80AD2E7A9CEBBEF1DFCE5B62"
	 
	requestJson = {
	    "key": accessKey,
	    "method":'word_info',
	    "q":text+"001"
	}

	openApiURL+="?"+urllib.parse.urlencode(requestJson)
	# print(openApiURL)
	http = urllib3.PoolManager()
	response = http.request(
	    "GET",
	    openApiURL
	)
	# print(response.data.decode('utf-8'))
	# print(response.status)
	if response.status!=200:
		raise Exception(text+"분석 도중 오류가 발생하였습니다.")
	if response.data.decode('utf-8').find('error')!=-1:
		raise Exception(text+"분석 오류")

	soup=bs(response.data,'lxml')
	if soup.find('total').text=='0':
		return '0'
	t=soup.find('word_type').text
	# if(t=="외래어"):
		# res=re.findall(r'<type>순화</type>.*?<desc><!\[CDATA\[(.*?)\]\]></desc>',response.data.decode('utf-8').replace('\t','').replace('\n',''))
	# else:
		# res=''
	return t


def getCategory(text):
	global wordDB
	if wordDB.get(text)==None:
		wordDB[text]=opendict(text)
	pickle.dump(wordDB,open("wordDB.db",'bw'))
	return wordDB[text]

# targets=["국제","스포츠","스타"] #"라이프"
targets=["경제","국제","정치","사회","문화","스포츠","스타"] #"라이프"
# targets=["국제"]

try: wordDB=pickle.load(open("wordDB.db",'br'))
except: wordDB={}

for target in targets:
	name="1__"+target+".csv"
	toname="2__"+target+".csv"
	print(name,"시작")
	with open(name) as file:
		r=file.read().split('\n');entire=''
	index=0
	for i in r:
		index+=1
		s=i.split(',')
		if len(s)==2:
			o=getCategory(s[0])
			i+=","+o
			try:
				print("[ %.2f%% ]"%(index/len(r)*100),s[0],o)
			except Exception as e:
				print(e)
		entire+=i+"\n"
	with open(toname,'w') as file:
		file.write(entire.rstrip())
	# print(opendict('페리카나'))
	