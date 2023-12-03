from pathlib import Path

dir = Path(__file__).parent


def solve1(input_file):
    with open(dir / input_file) as f:
        lines = f.read().splitlines()
    line_length = len(lines[0])
    sum_ = 0
    for line_idx in range(len(lines)):
        char_idx = 0
        while char_idx <= line_length - 1:
            if lines[line_idx][char_idx].isdigit():
                number_width = 0
                while (
                    char_idx + number_width + 1 <= line_length - 1
                    and lines[line_idx][char_idx + number_width + 1].isdigit()
                ):
                    number_width += 1

                around = ""
                if line_idx != 0:
                    around += lines[line_idx - 1][
                        max(0, char_idx - 1) : min(
                            char_idx + number_width + 2, line_length
                        )
                    ]
                around += lines[line_idx][
                    max(0, char_idx - 1) : min(char_idx + number_width + 2, line_length)
                ]
                if line_idx != len(lines) - 1:
                    around += lines[line_idx + 1][
                        max(0, char_idx - 1) : min(
                            char_idx + number_width + 2, line_length
                        )
                    ]
                if set("+&$*#\n-/=@%") & set(around):
                    sum_ += int(lines[line_idx][char_idx : char_idx + number_width + 1])

                char_idx += number_width
            char_idx += 1
    return sum_


def find_two_numbers_close_to_gear(lines, gear_line_idx, gear_char_idx):
    from_line_idx = max(0, gear_line_idx - 1)
    to_line_idx = min(len(lines) - 1, gear_line_idx + 1)
    from_char_idx = max(0, gear_char_idx - 3)
    to_char_idx = min(len(lines[gear_line_idx]) - 1, gear_char_idx + 3)
    char_idx = from_char_idx
    line_idx = from_line_idx

    around_gear = set(
        (gear_line_idx + i, gear_char_idx + j)
        for (i, j) in [
            (-1, -1),
            (-1, 0),
            (-1, 1),
            (0, -1),
            (0, 0),
            (0, 1),
            (1, -1),
            (1, 0),
            (1, 1),
        ]
    )

    while line_idx <= to_line_idx:
        while char_idx <= to_char_idx:
            if lines[line_idx][char_idx].isdigit():
                number_coordinates = set()
                number_width = 0
                number_coordinates.add((line_idx, char_idx))
                while (
                    char_idx + number_width + 1 <= to_char_idx
                    and lines[line_idx][char_idx + number_width + 1].isdigit()
                ):
                    number_width += 1
                    number_coordinates.add((line_idx, char_idx + number_width))
                if number_coordinates & around_gear:
                    yield lines[line_idx][char_idx : char_idx + number_width + 1]
                char_idx += number_width
            char_idx += 1
        char_idx = from_char_idx
        line_idx += 1


def solve2(input_file):
    with open(dir / input_file) as f:
        lines = f.read().splitlines()
    line_length = len(lines[0])
    sum_ = 0
    for line_idx in range(len(lines)):
        char_idx = 0
        while char_idx <= line_length - 1:
            if lines[line_idx][char_idx] == "*":
                neighbor_numbers = list(
                    find_two_numbers_close_to_gear(lines, line_idx, char_idx)
                )
                if len(neighbor_numbers) == 2:
                    a, b = neighbor_numbers
                    sum_ += int(a) * int(b)
            char_idx += 1
    return sum_


print(solve1("example.txt"))
print(solve1("input.txt"))
print(solve2("example.txt"))
print(solve2("input.txt"))
