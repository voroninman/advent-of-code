import re


def solve1(input_file):
    lines = [line.strip() for line in open(input_file).readlines()]
    digits_lists = [list(filter(str.isdigit, line)) for line in lines]
    first_last = [(digits[0], digits[-1]) for digits in digits_lists]
    ints = [int(f"{first}{last}") for first, last in first_last]
    return sum(ints)


def solve2(input_file):
    spelling = {
        "one": "1",
        "two": "2",
        "three": "3",
        "four": "4",
        "five": "5",
        "six": "6",
        "seven": "7",
        "eight": "8",
        "nine": "9",
    }

    lines = [line.strip() for line in open(input_file).readlines()]

    for i in range(len(lines)):
        if match := re.match(rf".*?({'|'.join(spelling.keys())})", lines[i]):
            lines[i] = lines[i].replace(match.group(1), spelling[match.group(1)])
        if match := re.match(rf".*({'|'.join(spelling.keys())}).*?$", lines[i]):
            lines[i] = lines[i].replace(match.group(1), spelling[match.group(1)])

    digits_lists = [list(filter(str.isdigit, line)) for line in lines]
    first_last = [(digits[0], digits[-1]) for digits in digits_lists]
    ints = [int(f"{first}{last}") for first, last in first_last]
    return sum(ints)


print(solve1("example.txt"))
print(solve1("input.txt"))
print(solve2("example2.txt"))
print(solve2("input.txt"))
