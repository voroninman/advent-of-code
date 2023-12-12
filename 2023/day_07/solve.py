from pathlib import Path

dir = Path(__file__).parent


def solve1(input_file):
    order = "23456789TJQKA"

    plays = [
        (hand, int(bid))
        for hand, bid in [
            line.split() for line in open(dir / input_file).read().splitlines() if line
        ]
    ]

    def get_type(hand):
        counter = Counter(hand)
        sorted_counter = sorted(counter.items(), key=lambda x: -x[1])
        match sorted_counter:
            case [(_, 5)]:
                return 6
            case [(_, 4), (_, 1)]:
                return 5
            case [(_, 3), (_, 2)]:
                return 4
            case [(_, 3), (_, 1), (_, 1)]:
                return 3
            case [(_, 2), (_, 2), (_, 1)]:
                return 2
            case [(_, 2), (_, 1), (_, 1), (_, 1)]:
                return 1
            case [(_, 1), (_, 1), (_, 1), (_, 1), (_, 1)]:
                return 0

    sorted_plays = sorted(
        plays,
        key=lambda play: (get_type(play[0]), [order.index(card) for card in play[0]]),
    )
    return sum(bid * rank for rank, (_, bid) in enumerate(sorted_plays, start=1))


def solve2(input_file):
    order = "J23456789TQKA"

    plays = [
        (hand, int(bid))
        for hand, bid in [
            line.split() for line in open(dir / input_file).read().splitlines() if line
        ]
    ]

    def get_type(hand):
        counter = Counter(hand)
        sorted_counter = sorted(counter.items(), key=lambda x: -x[1])
        match sorted_counter:
            case [("J", 4), (_, 1)]:
                return 6
            case [(_, 4), ("J", 1)]:
                return 6

            case [("J", 3), (_, 2)]:
                return 6
            case [(_, 3), ("J", 2)]:
                return 6

            case [("J", 3), (_, 1), (_, 1)]:
                return 5
            case [(_, 3), ("J", 1), (_, 1)]:
                return 5
            case [(_, 3), (_, 1), ("J", 1)]:
                return 5

            case [("J", 2), (_, 2), (_, 1)]:
                return 5
            case [(_, 2), ("J", 2), (_, 1)]:
                return 5
            case [(_, 2), (_, 2), ("J", 1)]:
                return 4

            case (
                [("J", 2), (_, 1), (_, 1), (_, 1)]
                | [(_, 2), ("J", 1), (_, 1), (_, 1)]
                | [(_, 2), (_, 1), ("J", 1), (_, 1)]
                | [(_, 2), (_, 1), (_, 1), ("J", 1)]
            ):
                return 3
            case (
                [("J", 1), (_, 1), (_, 1), (_, 1), (_, 1)]
                | [(_, 1), ("J", 1), (_, 1), (_, 1), (_, 1)]
                | [(_, 1), (_, 1), ("J", 1), (_, 1), (_, 1)]
                | [(_, 1), (_, 1), (_, 1), ("J", 1), (_, 1)]
                | [(_, 1), (_, 1), (_, 1), (_, 1), ("J", 1)]
            ):
                return 1

            case [(_, 5)]:
                return 6
            case [(_, 4), (_, 1)]:
                return 5
            case [(_, 3), (_, 2)]:
                return 4
            case [(_, 3), (_, 1), (_, 1)]:
                return 3
            case [(_, 2), (_, 2), (_, 1)]:
                return 2
            case [(_, 2), (_, 1), (_, 1), (_, 1)]:
                return 1
            case [(_, 1), (_, 1), (_, 1), (_, 1), (_, 1)]:
                return 0

    sorted_plays = sorted(
        plays,
        key=lambda play: (get_type(play[0]), [order.index(card) for card in play[0]]),
    )
    return sum(bid * rank for rank, (_, bid) in enumerate(sorted_plays, start=1))


print(solve1("example.txt"))
print(solve1("input.txt"))
print(solve2("example.txt"))
print(solve2("input.txt"))
