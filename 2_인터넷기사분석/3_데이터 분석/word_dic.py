from konlpy.tag import Komoran
komoran = Komoran()
def word_dic(text):
	# komoran = Komoran()
	word_dic = {}
	lines = text.split("\n")
	for line in lines:
		if not line.strip(): continue
		malist = komoran.pos(line)
		for word in malist:
			if word[1] in ("NNG","NNP"): #  명사 확인하기 --- (※3)
				if not (word[0] in word_dic):
					word_dic[word[0]] = 0
				word_dic[word[0]] += 1 # 카운트하기
	# 많이 사용된 명사 출력하기 --- (※4)
	keys = sorted(word_dic.items(), key=lambda x:x[1], reverse=True)
	r=''
	for word, count in keys:
		r+="{0},{1}".format(word, count)+'\n'
	return r.rstrip()