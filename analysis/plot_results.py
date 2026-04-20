import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("data/results.csv")
df.groupby(["algorithm", "depth"]).mean().plot()
plt.savefig("figures/latency.png")
