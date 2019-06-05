import logging
from gensim.models import word2vec
from gensim.test.utils import common_texts

logging.getLogger().setLevel(logging.INFO)
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s')

sentences = word2vec.LineSentence('data/wiki_seg.txt')
model = word2vec.Word2Vec(sentences, size = 100, alpha=0.025, window = 5, workers = 12, sg = 0, min_count = 1)
model.save('data/wiki.word2vec_50.bin')
