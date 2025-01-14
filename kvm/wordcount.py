#!/usr/bin/env python3

import sys
from collections import Counter

def word_count(file_path):
    with open(file_path, 'r') as file:
        words = file.read().split()
        counts = Counter(words)
        return counts

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 wordcount.py <file_path>")
        sys.exit(1)

    file_path = sys.argv[1]
    word_counts = word_count(file_path)
    for word, count in word_counts.items():
        print(f"{word}: {count}")
