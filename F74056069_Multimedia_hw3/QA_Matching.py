import logging
import jieba
from gensim.models import word2vec
from gensim.test.utils import common_texts

logging.getLogger().setLevel(logging.INFO)
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s')

model = "data/wiki.word2vec_50.bin"
model_w2v = word2vec.Word2Vec.load(model)
candidates = []
with open("data/wiki_seg.txt", encoding='utf-8')as f:
    for line in f:
        candidates.append(line.strip().split())
text = "兇的女生484都很胸"
words = list(jieba.cut(text.strip()))
word = []
for w in words:
    if w not in model_w2v.wv.vocab:
        print("input word %s not in dict. skip this turn" % w)
    else:
        word.append(w)
flag = False
res = []
index = 0
for candidate in candidates:
    for c in candidate:
        if c not in model_w2v.wv.vocab:
            print("candidate word %s not in dict. Skip this turn" % c)
            flag = True
    if flag: 
        break
    score = model_w2v.n_similarity(word, candidate)
    resultInfo = {'id': index, "score": score, "text": " ".join(candidate)}
    res.append(resultInfo)
    index += 1
res.sort(key=lambda x: x['score'], reverse=True)
result = []
for i in range(len(res)):
    if res[i]['score'] > 0.65:
        dict_temp = {res[i]['id']: res[i]['text'], 'score': res[i]['score']}
        result.append(dict_temp)
print(result)
