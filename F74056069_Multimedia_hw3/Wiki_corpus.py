import logging
from gensim.corpora import WikiCorpus

logging.getLogger().setLevel(logging.INFO)
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s')

wiki_corpus = WikiCorpus('data/zhwiki-20190520-pages-articles-multistream.xml.bz2', dictionary={})
texts_num = 0
with open("data/wiki_texts.txt", 'w', encoding='utf-8') as output:
    for text in wiki_corpus.get_texts():
        output.write(' '.join(text) + '\n')
        texts_num += 1
        if texts_num % 10000 == 0:
            logging.info("已處理 %d 篇文章" % texts_num)
