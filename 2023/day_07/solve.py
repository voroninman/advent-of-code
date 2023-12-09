import re
from collections import Counter, OrderedDict
from functools import reduce
from pathlib import Path
from pprint import pprint

dir = Path(__file__).parent


"""
253486220 is too low
253638586 correct
253688621 is too high
253702560 it too high
253830133
"""


def my_sorter(hand_bid):
    CARDS = list(reversed("AKQJT98765432"))

    hand_bid = [
        (
            hand,
            "".join(sorted(hand, key=lambda x: -CARDS.index(x))),
            bid,
        )
        for hand, bid in hand_bid
    ]
    hand_bid = [
        (
            hand,
            hand_sorted,
            bid,
            list(map(lambda x: CARDS.index(x), hand)),
        )
        for hand, hand_sorted, bid in hand_bid
    ]
    hand_bid = [
        (
            hand,
            hand_sorted,
            bid,
            indexed,
            sorted(Counter(indexed).items(), key=lambda x: (-x[1], -x[0])),
        )
        for hand, hand_sorted, bid, indexed in hand_bid
    ]

    ranked = sorted(
        hand_bid,
        key=lambda x: (-len(x[4]), [(count, card_rank) for (card_rank, count) in x[4]]),
    )
    ranked_plays = [[hard, bid] for hard, _, bid, _, _ in ranked]
    print_ranked_hands("my_sorter", ranked_plays)
    return ranked_plays


def accepted_sorter(plays):
    # https://github.com/Tyranties/AOC-2023/blob/main/day_07/day_07_part_1.py
    CARD_MAPPING = {"T": "A", "J": "B", "Q": "C", "K": "D", "A": "E"}

    def get_type(hand):
        counts = Counter(hand)
        if len(counts) == 1:
            return 6
        if len(counts) == 2:
            if 4 in counts.values():
                return 5
            if 3 in counts.values() and 2 in counts.values():
                return 4
        if len(counts) == 3:
            if 3 in counts.values() and list(counts.values()).count(1) == 2:
                return 3
            if list(counts.values()).count(2) == 2:
                return 2
        if len(counts) == 4:
            return 1
        return 0

    def get_order(hand):
        return [CARD_MAPPING.get(card, card) for card in hand]

    def sorting(hand):
        return get_type(hand), get_order(hand)

    ranked_plays = sorted(plays, key=lambda play: sorting(play[0]))
    print_ranked_hands("accepted_sorter", ranked_plays)
    return ranked_plays


def print_ranked_hands(prefix, ranked_plays):
    for hand, _ in ranked_plays:
        print(prefix, hand)


def solver(input_file, sorter):
    plays = [
        (hand, int(bid))
        for hand, bid in [
            line.split() for line in open(dir / input_file).read().splitlines() if line
        ]
    ]
    return sum(bid * rank for rank, (_, bid) in enumerate(sorter(plays), start=1))


print("example.txt my_sorter", solver("example.txt", my_sorter) == 6440)
print("example.txt accepted_sorter", solver("example.txt", accepted_sorter) == 6440)

print("input.txt my_sorter", solver("input.txt", my_sorter) == 253638586)
print("input.txt accepted_sorter", solver("input.txt", accepted_sorter) == 253638586)
