import datetime
import random


pi_day = datetime.datetime(2020, 3, 14)
print(pi_day)
print(type(pi_day))
today = datetime.datetime.now()
print(today)
print(type(today))
today = datetime.datetime.now()
pi_day = datetime.datetime(2020, 3, 14, 13, 6, 15)
print(today - pi_day)
print(type(today - pi_day))
today = datetime.datetime.now()
my_timedelta = datetime.timedelta(days=5, hours=3, minutes=10, seconds=50)

print(today)
print(today + my_timedelta)
print(today)
print(today.year)  # 연도
print(today.month)  # 월
print(today.day)  # 일
print(today.hour)  # 시
print(today.minute)  # 분
print(today.second)  # 초
print(today.microsecond)  # 마이크로초
today = datetime.datetime.now()

print(today)
print(today.strftime("%A, %B %dth %Y"))


while chance > 0:
    chance = 4
    x = input(f"기회가 {chance}번 남았습니다. 1-20 사이의 숫자를 맞혀 보세요:")
    number = random.randient(1,20)
    if x == number:
        print(f'축하합니다.{4-i}번 만에 숫자를 맞히셨습니다.')
        break
    elif x < 0:
        print(f'아쉽습니다. 정답은 {x}입니다.')
        break
    else:
        if x>number:
            print('Down')
        elif x<number:
            print('Up'.strip)

with open('vocabulary.txt', 'w') as f:
    while True:
        english_word = input('영어 단어를 입력하세요: ')
        if english_word == 'q':
            break

        korean_word = input('한국어 뜻을 입력하세요: ')
        if korean_word == 'q':
            break

        f.write('{}: {}\n'.format(english_word, korean_word))
with open('vocabulary.txt', 'r') as f:
    for line in f:
        data = line.strip().split(": ")
        english_word, korean_word = data[0], data[1]

        # 유저 입력값 받기
        guess = input("{}: ".format(korean_word))

        # 정답 확인하기
        if guess == english_word:
            print("맞았습니다!\n")
        else:
            print("아쉽습니다. 정답은 {}입니다.\n".format(english_word))
import random

# 사전 만들기
vocab = {}
with open('vocabulary.txt', 'r') as f:
    for line in f:
        data = line.strip().split(": ")
        english_word, korean_word = data[0], data[1]
        vocab[english_word] = korean_word

# 목록 가져오기
keys = list(vocab.keys())

# 문제 내기
while True:
    # 랜덤한 문제 받아오기
    index = random.randint(0, len(keys) - 1)
    english_word = keys[index]
    korean_word = vocab[english_word]

    # 유저 입력값 받기
    guess = input("{}: ".format(korean_word))

    # 프로그램 끝내기
    if guess == 'q':
        break

    # 정답 확인하기
    if guess == english_word:
        print("정답입니다!\n")
    else:
        print("아쉽습니다. 정답은 {}입니다.\n".format(english_word))