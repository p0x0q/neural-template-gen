
import csv
def load_csv(filename):
    dataset = list()
    with open(filename, 'r', encoding='utf8') as file:
        csv_reader = csv.reader(file)
        for row in csv_reader:
            if not row:
                continue
            dataset.append(row)
    return dataset

train_tgt_lines = []
src_train = []
tempTexts = ""
for line in load_csv("2022-09-20.csv"):
    tkey, start_template, text, end_template, rawText = line[0], line[1], line[2], line[3], line[5]
    if start_template == "start_sentences":
        continue
    if rawText:
        # print(rawText)
        if tempTexts:
            src_train.append(tempTexts)
        tempTexts = ""
        train_tgt_lines.append(rawText)
    
    if start_template and text and end_template:
        tempTexts = tempTexts + " " + start_template + " " + text + " " + end_template + " "
    else:
        tempTexts = tempTexts + text
    # __start_name__ 一成というお店 __end_name__ __start_eatType__ よく天ぷら __end_eatType__ __start_action__ 食べます ___end_action__

def lines_to_file(filename, lines):
    with open(filename, 'w', encoding='utf8') as f:
        for line in lines:
            f.write(line + '\n')
            
lines_to_file("train_tgt_lines.txt", train_tgt_lines)
lines_to_file("src_train.txt", src_train)
