import logging
from lib.langconv import Converter
import jieba

logging.getLogger().setLevel(logging.INFO)
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s')

jieba.set_dictionary('extra_dict/dict.txt.big')
stopword_set = set()
with open('extra_dict/stop_words.txt','r', encoding='utf-8') as stopwords:
    for stopword in stopwords:
        stopword_set.add(stopword.strip('\n'))
output = open('data/wiki_seg.txt', 'w', encoding='utf-8')
with open('data/Gossiping-QA-Dataset.txt', 'r', encoding='utf-8') as content :
    for texts_num, line in enumerate(content):
        line = line.strip('\n')
        words = jieba.cut(line, cut_all=True)
        for word in words:
            if word not in stopword_set:
                output.write(word + ' ')
        output.write('\n')
        if (texts_num + 1) % 10000 == 0:
            logging.info("已完成前 %d 行的斷詞" % (texts_num + 1))

