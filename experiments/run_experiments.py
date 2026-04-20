import csv

with open("data/results.csv", "w") as f:
    writer = csv.writer(f)
    writer.writerow(["algorithm", "depth", "time"])
