import sqlite3
# from selenium import webdriver
import sys

"""
구조체 구조.

기사올라온곳
기사 카테고리
작성자
기사이름
-> 단어
-> 단어분석
기사입력
-> 단어
-> 단어분석
최종수정



"""


dbpath="test.sqlite"
conn=sqlite3.connect(dbpath)


# 테이블 생성하기 --- (※2)
cur = conn.cursor()
cur.execute("DROP TABLE IF EXISTS items") 
cur.execute("""CREATE TABLE items (
    item_id INTEGER PRIMARY KEY,
    name    TEXT,
    price   INTEGER)""")
conn.commit()





# 데이터 넣기 --- (※3)
cur = conn.cursor()
cur.execute(
    "INSERT INTO items (name,price) VALUES (?,?)",
    ("Orangeㅁ", 5200))
conn.commit()
# 여러 데이터 연속으로 넣기 --- (※4)
cur = conn.cursor()
data = [("Mango",7700), ("Kiwi",4000), ("Grape",8000),
    ("Peach",9400),("Persimmon",7000),("Banana", 4000)]
cur.executemany(
    "INSERT INTO items(name,price) VALUES (?,?)",
    data)
conn.commit()
# 4000-7000원 사이의 데이터 추출하기 --- (※5)
cur = conn.cursor()
price_range = (4000, 7000)
cur.execute(
    "SELECT * FROM items WHERE price>=? AND price<=?",
    price_range)
fr_list = cur.fetchall()
for fr in fr_list:
    print(fr)


