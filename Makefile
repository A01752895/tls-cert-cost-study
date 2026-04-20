PYTHON=python3

install:
$(PYTHON) -m pip install -r requirements.txt

experiment:
$(PYTHON) experiments/run_experiments.py --config experiments/configs.yaml

plots:
$(PYTHON) analysis/plot_results.py --input data/results.csv --output-dir figures
