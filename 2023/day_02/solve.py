from functools import reduce
from pathlib import Path


def read_lines(input_file):
    with open(Path(__file__).parent / input_file) as f:
        return [line.strip() for line in f.readlines()]


def solve1(input_file):
    sum_ = 0
    for line in read_lines(input_file):
        game, sets = line.split(":")
        possible = True
        for set_ in sets.split(";"):
            for color_cubes in set_.split(","):
                count, color = color_cubes.strip().split(" ")
                count = int(count)
                if color == "red" and count > 12:
                    possible = False
                if color == "green" and count > 13:
                    possible = False
                if color == "blue" and count > 14:
                    possible = False
        if possible:
            sum_ += int(game.split(" ")[1])
    return sum_


def solve2(input_file):
    sum_ = 0
    for line in read_lines(input_file):
        _, sets = line.split(":")
        maximum = {}
        for set_ in sets.split(";"):
            for color_cubes in set_.split(","):
                count, color = color_cubes.strip().split(" ")
                count = int(count)

                if color == "red":
                    maximum["red"] = max(maximum.get("red", 0), count)
                if color == "green":
                    maximum["green"] = max(maximum.get("green", 0), count)
                if color == "blue":
                    maximum["blue"] = max(maximum.get("blue", 0), count)

        sum_ += reduce(lambda x, y: x * y, maximum.values())
    return sum_


print(solve1("example.txt"))
print(solve1("input.txt"))
print(solve2("example.txt"))
print(solve2("input.txt"))
