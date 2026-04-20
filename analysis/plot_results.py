import pandas as pd
import matplotlib.pyplot as plt


df = pd.read_csv("data/results.csv")

for proto in df.protocol.unique():
    sub = df[df.protocol == proto]
    for algo in sub.algorithm.unique():
        s = sub[sub.algorithm == algo].groupby("depth").mean()
        plt.plot(s.index, s.time_s, marker="o", label=f"{algo}-{proto}")

plt.xlabel("Certificate chain length")
plt.ylabel("Handshake time (s)")
plt.legend()
plt.savefig("figures/latency.png")
