import re
from functools import reduce
from pathlib import Path

dir = Path(__file__).parent


def distance(game_t, press_t):
    return (game_t - press_t) * press_t


def solve1(input_file):
    line1, line2 = open(dir / input_file).read().splitlines()
    (_, *times) = re.split(r"\s+", line1)
    (_, *distances) = re.split(r"\s+", line2)
    times = list(map(int, times))
    distances = list(map(int, distances))
    pairs = list(zip(times, distances))
    return reduce(
        lambda a, b: a * b,
        (
            sum(
                1
                for press_t in range(0, game_t + 1)
                if distance(game_t=game_t, press_t=press_t) > d
            )
            for game_t, d in pairs
        ),
    )


def solve2(input_file):
    line1, line2 = open(dir / input_file).read().splitlines()
    time = int("".join(filter(str.isdigit, line1)))
    game_distance = int("".join(filter(str.isdigit, line2)))
    return reduce(
        lambda a, b: a * b,
        (
            sum(
                1
                for press_t in range(0, game_t + 1)
                if distance(game_t=game_t, press_t=press_t) > d
            )
            for game_t, d in [[time, game_distance]]
        ),
    )


print(solve1("example.txt"))
print(solve1("input.txt"))
print(solve2("example.txt"))
print(solve2("input.txt"))
