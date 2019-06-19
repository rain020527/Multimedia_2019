import logging
import jieba
from gensim.models import word2vec
from gensim.test.utils import common_texts

logging.getLogger().setLevel(logging.INFO)
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s')

model = "data/wiki.word2vec_50_2.bin"
model_w2v = word2vec.Word2Vec.load(model)
# candidates = []
# with open("data/wiki_seg.txt", encoding='utf-8')as f:
#     for line in f:
#         candidates.append(line.strip().split())

jieba.set_dictionary('extra_dict/dict.txt.big')
stopword_set = set()
with open('extra_dict/stop_words.txt','r', encoding='utf-8') as stopwords:
    for stopword in stopwords:
        stopword_set.add(stopword.strip('\n'))
test = 0
total_ans = ""
file_name = input('File name: ')
output_file = "./test_data/answers/" + file_name + "_out.txt"
input_file = "./test_data/questions/" + file_name + ".txt"
with open(input_file, encoding='utf-8') as questions: 
    for eachQ in questions: 
        [question, ans1, ans2, ans3, ans4] = eachQ.rstrip().split('\t')
        ans = [ans1, ans2, ans3, ans4]
        words = list(jieba.cut(question.strip(), cut_all=False))
        word = []
        for w in words:
            if w not in model_w2v.wv.vocab or w in stopword_set:
                print("input word %s not in dict. skip this turn" % w)
            else:
                word.append(w)
        if word == []:
            total_ans += "[]\n"
            continue
        res = []
        index = 0
        candidates = []
        for eachA in ans: 
            temp = ""
            eachA = jieba.cut(eachA.split(")")[1], cut_all=False) # Get the part after selection index
            for seg_word in eachA:
                if seg_word not in stopword_set:
                    temp += seg_word
                temp += "\n"
            candidates.append(temp.strip().split())
        print(candidates)
        for candidate in candidates:     
            reset_candiate = candidate.copy()
            for c in candidate: 
                print(c)
                if c not in model_w2v.wv.vocab:
                    print("candidate word %s not in dict. Skip this turn" % c)
                    reset_candiate.remove(c)
            candidate = reset_candiate.copy() 
            if len(candidate) == 0:
                continue
            score = model_w2v.n_similarity(word, candidate)
            resultInfo = {'id': index, "score": score, "text": " ".join(candidate)}
            print(resultInfo)
            res.append(resultInfo)
            index += 1
        res.sort(key=lambda x: x['score'], reverse=True)
        total_ans += "[%d]\n" % (res[0]['id']+1)
        test += 1
        if test >= 500:
            break
with open(output_file, 'w', encoding='utf-8') as ans_txt:
    ans_txt.write(total_ans)

correct_num = 0
failure_num = 0
with open(output_file, 'r', encoding='utf-8') as my_ans, open('./test_data/correct_answer_file.txt', 'r', encoding='utf-8') as correct_ans:
    for each_myA, each_correctA in zip(my_ans, correct_ans):
        if each_myA == each_correctA:
            correct_num += 1
        else:
            failure_num += 1
print("correct: %d\nfailure: %d\ncorrect percentage: %lf" % (correct_num, failure_num, correct_num/500))

