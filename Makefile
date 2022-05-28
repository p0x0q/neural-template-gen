install:
	conda create -n pytorch27 python=2.7 anaconda
	conda activate pytorch27
	pip install http://download.pytorch.org/whl/cu80/torch-0.3.1.post5-cp27-none-linux_x86_64.whl
	pip install torchvision

	python -c "import torch"
	python -c "import torchvision"

sample:
	python chsmm.py -data data/labee2e/ -emb_size 300 -hid_size 300 -layers 1 -K 55 -L 4 -log_interval 200 -thresh 9 -emb_drop -bsz 16 -max_seqlen 55 -lr 0.5  -sep_attn -max_pool -unif_lenps -one_rnn -Kmul 5 -mlpinp -onmt_decay -cuda -load models/e2e-55-5.pt -label_train | tee segs/seg-e2e-300-55-5.txt

convert:
	2to3 -w chsmm.py
