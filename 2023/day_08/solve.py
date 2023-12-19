from math import lcm
from pathlib import Path

dir = Path(__file__).parent


def solve1(input_file):
    turns, _, *nodes = open(dir / input_file).read().splitlines()
    nodes = dict([[node[0:3], (node[7:10], node[12:15])] for node in nodes])

    node = nodes["AAA"]
    count = 0
    while True:
        for turn in turns:
            count += 1
            if turn == "R":
                if node[1] == "ZZZ":
                    return count
                node = nodes[node[1]]
            else:
                if node[0] == "ZZZ":
                    return count
                node = nodes[node[0]]


def solve2(input_file):
    turns, _, *nodes = open(dir / input_file).read().splitlines()
    nodes = dict([[node[0:3], (node[7:10], node[12:15])] for node in nodes])

    current_nodes = [k for k in nodes.keys() if k.endswith("A")]

    epochs = {}
    for current_node in current_nodes:
        count = 0
        node = nodes[current_node]
        while True:
            for turn in turns:
                count += 1
                left, right = node
                if turn == "L":
                    node = nodes[node[0]]
                else:
                    node = nodes[node[1]]
            if left.endswith("Z") or right.endswith("Z"):
                epochs[current_node] = count
                break

    return lcm(*epochs.values())


print(solve1("example.txt"))
print(solve1("input.txt"))
print(solve2("example2.txt"))
print(solve2("input.txt"))
