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

    minimum = 9999999999999
    needle = None
    for seed in seeds:
        needle = seed
        for mappings in layers:
            for mapping in mappings:
                source_start = mapping[1]
                destination_start = mapping[0]
                range_length = mapping[2]
                source_end = source_start + range_length - 1
                offset = needle - source_start
                if source_start <= needle <= source_end:
                    new_needle = destination_start + offset
                    needle = new_needle
                    break
        minimum = min(minimum, needle)
    return minimum


print(solve1("example.txt"))
print(solve1("input.txt"))
# print(solve2("example.txt"))
# print(solve2("input.txt"))
