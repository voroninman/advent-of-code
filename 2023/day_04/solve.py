import re
from collections import defaultdict
from pathlib import Path
from pprint import pprint

dir = Path(__file__).parent


def solve1(input_file):
    with open(dir / input_file) as f:
        lines = f.read().strip().splitlines()
    sum_ = 0
    for line in lines:
        (_, numbers) = line.split(":")
        (won, mine) = numbers.split("|")

        won = set(map(int, map(str.strip, re.split(r"\s+", won.strip()))))
        mine = set(map(int, map(str.strip, re.split(r"\s+", mine.strip()))))

        if len(won & mine) > 0:
            sum_ += 2 ** (len(won & mine) - 1)

    return sum_


def solve2(input_file):
    with open(dir / input_file) as f:
        lines = f.read().strip().splitlines()

    matches = {}
    for line in lines:
        (card, numbers) = line.split(":")
        (won, mine) = numbers.split("|")
        won = set(map(int, map(str.strip, re.split(r"\s+", won.strip()))))
        mine = set(map(int, map(str.strip, re.split(r"\s+", mine.strip()))))
        matches[card] = len(won & mine)

    cards = list(matches.keys())
    pile = list(reversed(cards.copy()))
    win_more_cards = {}
    while pile:
        card = pile.pop(0)
        new_cards = cards[cards.index(card) + 1 : cards.index(card) + matches[card] + 1]
        if card not in win_more_cards:
            win_more_cards[card] = len(new_cards)
        win_more_cards[card] += sum(win_more_cards[card] for card in new_cards)
    return sum(win_more_cards.values()) + len(cards)

``
print(solve1("example.txt"))
print(solve1("input.txt"))
print(solve2("example.txt"))
print(solve2("input.txt"))
