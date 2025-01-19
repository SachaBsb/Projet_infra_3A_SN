# -*- coding: utf-8 -*-
from pyspark import SparkContext

def main(input_file):
    # Initialiser SparkContext
    sc = SparkContext("spark://spark-master:7077", "Word Count")

    # Lire le fichier
    text_file = sc.textFile(input_file)

    # Transformer et compter les mots
    counts = (text_file
              .flatMap(lambda line: line.split(" "))
              .map(lambda word: (word, 1))
              .reduceByKey(lambda a, b: a + b))

    # Afficher les résultats
    for word, count in counts.collect():
        print(f"{word}: {count}")

    # Arrêter SparkContext
    sc.stop()

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python wordcount.py <file>", file=sys.stderr)
        sys.exit(-1)

    main(sys.argv[1])
