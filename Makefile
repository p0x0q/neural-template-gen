install:
	conda create -n pytorch27 python=2.7 anaconda
	conda activate pytorch27
	pip install http://download.pytorch.org/whl/cu80/torch-0.3.1.post5-cp27-none-linux_x86_64.whl
	pip install torchvision

	python -c "import torch"
	python -c "import torchvision"

command:
	docker-compose exec server bash

train:
	python chsmm.py -data data/labee2e/ -emb_size 30 -hid_size 30 -layers 1 -K 55 -L 4 -log_interval 20 -thresh 9 -emb_drop -bsz 15 -max_seqlen 55 -lr 0.5 -sep_attn -max_pool -unif_lenps -one_rnn -Kmul 5 -mlpinp -onmt_decay -cuda -seed 5 -save models/chsmm-e2e-300-55-5-0shotV2.pt
train-ja:
	python chsmm.py -data data/labee2e-ja/ -emb_size 300 -hid_size 300 -layers 1 -K 55 -L 4 -log_interval 200 -thresh 9 -emb_drop -bsz 15 -max_seqlen 55 -lr 0.5 -sep_attn -max_pool -unif_lenps -one_rnn -Kmul 5 -mlpinp -onmt_decay -cuda -seed 5 -save models/chsmm-e2e-300-55-5-0shotV2-ja.pt
pre-train:
	python chsmm.py -data data/labee2e/ -emb_size 300 -hid_size 300 -layers 1 -K 55 -L 4 -log_interval 200 -thresh 9 -emb_drop -bsz 16 -max_seqlen 55 -lr 0.5  -sep_attn -max_pool -unif_lenps -one_rnn -Kmul 5 -mlpinp -onmt_decay -load models/e2e-55-5.pt -label_train | tee segs/seg-e2e-300-55-5.txt
# generate:
# 	python chsmm.py -data data/labewiki/ -emb_size 300 -hid_size 300 -layers 1 -K 45 -L 4 -log_interval 1000 -thresh 29 -emb_drop -bsz 5 -max_seqlen 55 -lr 0.5 -sep_attn -max_pool -unif_lenps -one_rnn -Kmul 3 -mlpinp -onmt_decay -gen_from_fi wikipedia-biography-dataset/test/test.box -load models/wb-45-3-war.pt -tagged_fi segs/seg-wb-300-45-3-war.txt -beamsz 5 -ntemplates 100 -gen_wts '1,1' -min_gen_tokes 20 > gens/gen-wb-45-3-war.txt
generate:
	python chsmm.py -data data/labee2e/ -emb_size 300 -hid_size 300 -layers 1 -dropout 0.3 -K 1 -L 4 -log_interval 100 -thresh 9 -lr 0.5 -sep_attn -unif_lenps -emb_drop -mlpinp -onmt_decay -one_rnn -max_pool -gen_from_fi data/labee2e/src_uniq_valid.txt -load models/chsmm-e2e-300-55-5-0shot.pt.1 -tagged_fi segs/seg-e2e-60-1-far.txt -beamsz 5 -ntemplates 100 -gen_wts 1,1 -min_gen_tokes 0
generate-ja:
	python chsmm.py -data data/labee2e-ja/ -emb_size 300 -hid_size 300 -layers 1 -dropout 0.3 -K 1 -L 4 -log_interval 100 -thresh 9 -lr 0.5 -sep_attn -unif_lenps -emb_drop -mlpinp -onmt_decay -one_rnn -max_pool -gen_from_fi data/labee2e/src_uniq_valid.txt -load models/chsmm-e2e-300-55-5-0shotV2-ja.pt.0 -tagged_fi segs/seg-e2e-60-1-far.txt -beamsz 5 -ntemplates 100 -gen_wts 1,1 -min_gen_tokes 0
generate-full:
	python chsmm.py -data data/labee2e-full/ -emb_size 300 -hid_size 300 -layers 1 -dropout 0.3 -K 1 -L 4 -log_interval 100 -thresh 9 -lr 0.5 -sep_attn -unif_lenps -emb_drop -mlpinp -onmt_decay -one_rnn -max_pool -gen_from_fi data/labee2e-full/src_uniq_valid.txt -load models/e2e-60-1-far.pt -tagged_fi segs/seg-e2e-60-1-far.txt -beamsz 5 -ntemplates 100 -gen_wts 1,1 -min_gen_tokes 0

train-full:
	python chsmm.py -data data/labee2e-full/ -emb_size 300 -hid_size 300 -layers 1 -K 55 -L 4 -log_interval 200 -thresh 9 -emb_drop -bsz 15 -max_seqlen 55 -lr 0.5 -sep_attn -max_pool -unif_lenps -one_rnn -Kmul 5 -mlpinp -onmt_decay -cuda -seed 5 -save models/chsmm-e2e-full.pt

serve:
	docker-compose up

convert:
	2to3 -w infc.py
	2to3 -w labeled_data.py
	2to3 -w template_extraction.py
	2to3 -w utils.py
	


reload:
	git reset --hard HEAD && git pull
	docker pull p0x0q/cupy-ocr-from-images:master
	@make python-secure
	docker-compose -f docker-compose_deploy.yaml stop && docker-compose -f docker-compose_deploy.yaml up -d --build

run:
	@make start-script
	while :; do sleep 60; make start-script; done
start-script:
	python3 cupy-ocr-from-images.py

python-secure:
	rm -Rf python-secure/
	git clone git@github.com:p0x0q-dev/python-secure.git

logs:
	docker-compose -f docker-compose_deploy.yaml logs --follow

submodule:
	git submodule add https://github.com/p0x0q-dev/python-secure.git python-secure

generate-label:
	cd data && python make_e2e_labedata.py "train" > ./labee2e/train.txt
	cd data && python make_e2e_labedata.py "valid" > ./labee2e/valid.txt

generate-label-ja:
	cd data && python make_e2e_labedata_ja.py "train" > ./labee2e-ja/train.txt
	cd data && python make_e2e_labedata_ja.py "valid" > ./labee2e-ja/valid.txt
