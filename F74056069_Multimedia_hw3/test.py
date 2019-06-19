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

test = 0
total_ans = ""
file_name = input('File name: ')
output_file = "./test_data/" + file_name + "_out.txt"
input_file = "./test_data/" + file_name + ".txt"
with open(input_file, encoding='utf-8') as questions: 
    for eachQ in questions: 
        [question, ans1, ans2, ans3, ans4] = eachQ.rstrip().split('\t')
        ans = [ans1, ans2, ans3, ans4]
        words = list(jieba.cut(question.strip()))
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
        found_best_res = False
        for i in range(len(res)):
            for j in range(0, 4):
                if all(res_seg in (question + ans[j]) for res_seg in res[i]['text'].replace(" ", "")) :
                    found_best_res = True
                    dict_temp = {res[i]['id']: res[i]['text'], 'score': res[i]['score']}
                    result.append(dict_temp)
                    total_ans += "[%d]\n" % (j+1)
                    break
            if found_best_res == True:
                break
        if found_best_res == False and i == len(res)-1:
            total_ans += "[]\n"
        print(result)
        test += 1
        if test >= 125:
            break
with open(output_file, 'w', encoding='utf-8') as ans_txt:
    ans_txt.write(total_ans)
