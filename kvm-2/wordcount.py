from pyspark import SparkContext

sc = SparkContext("local", "WordCount")

# Load text file
text_file = sc.textFile("/home/lousteau/Desktop/Projets/learn-terraform-docker-container/kvm-2/text_sample.txt")

# Perform WordCount
word_counts = text_file.flatMap(lambda line: line.split(" ")) \
                       .map(lambda word: (word, 1)) \
                       .reduceByKey(lambda a, b: a + b)

# Save output to a file
word_counts.saveAsTextFile("file:///tmp/wordcount_output")
