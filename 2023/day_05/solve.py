import re
from collections import defaultdict
from pathlib import Path
from pprint import pprint

dir = Path(__file__).parent


def solve1(input_file):
    data = open(dir / input_file).read().strip()
    seeds = data[7 : data.find("\n")].split(" ")
    seeds = [int(seed) for seed in seeds]

    layers = [
        [list(map(int, numbers.split(" "))) for numbers in match.strip().split("\n")]
        for match in re.findall(r"map:\n((?:\d+ \d+ \d+\n?)+)", data, re.DOTALL)
    ]

    niddle = None
    for seed in seeds:
        niddle = seed
        for mappings in layers:
            found = False
            for mapping in mappings:
                print(f"{mapping[1]} <= {seed} <= {mapping[1] + mapping[2] - 1}")
                if mapping[1] <= seed <= mapping[0] + mapping[2] - 1:
                    found = True

                    niddle = seed + mapping[2] + 1
                    print("new niddle", niddle)
                    break
        print(niddle)


print(solve1("example.txt"))
# print(solve1("input.txt"))
# print(solve2("example.txt"))
# print(solve2("input.txt"))
