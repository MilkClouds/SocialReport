import pickle
wordDB=pickle.load(open("wordDB.db","rb"))

# 0 자료 출력
# for i,e in wordDB.items():
# 	if e=='0':
# 		print(i)


print(wordDB)

# r=""""""
# for i in r.split('\n'):
	# s=i.split(':')
	# if len(s)>=2:
		# wordDB[s[0]]=s[1]

# print(wordDB)

# pickle.dump(wordDB,open("wordDB.db","wb"))