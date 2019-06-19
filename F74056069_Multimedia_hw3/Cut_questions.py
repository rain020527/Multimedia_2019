input_file = input('Input the file you want to spilt: ')
input_file = "./test_data/" + input_file + ".txt"
with open(input_file, encoding='utf-8') as questions: 
    for i in range(0, 5):
        spilt_question = ""
        for files in range(0, 100):     
            eachQ = str(questions.readline())
            spilt_question += eachQ
        with open(('./test_data/answers/%d.txt' % (i+1)), 'w', encoding='utf-8') as spilt_file:
            spilt_file.write(spilt_question)