from pyspark import SparkContext
import sys
input_file = sys.argv[1]  # Gets the input file path from command-line arguments

# Initialize SparkContext
sc = SparkContext("local", "WordCount")

# Load the file into an RDD using the argument
text_file = sc.textFile(input_file)

# Perform WordCount
word_counts = text_file.flatMap(lambda line: line.split(" ")) \
                       .map(lambda word: (word, 1)) \
                       .reduceByKey(lambda a, b: a + b)

# Save output to a file
word_counts.saveAsTextFile("file:///tmp/wordcount_output")

# Stop SparkContext
sc.stop()