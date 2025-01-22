#!/bin/bash
# Paths for input and output
INPUT_FILE="file:///home/ubuntu/wordcount/input.txt"
OUTPUT_DIR="file:///home/ubuntu/wordcount/output"
SPARK_JAR="/home/ubuntu/wordcount/WordCount.jar"

############################
## Remove existing output directory
# Version with HDFS
# hdfs dfs -rm -r "$OUTPUT_DIR" 2>/dev/null

# Version with local storing
rm -rf /home/ubuntu/wordcount/output

############################
# Run the WordCount program
$SPARK_HOME/bin/spark-submit \
    --class WordCount \
    --master local[2] \
    "$SPARK_JAR" \
    "$INPUT_FILE" \
    "$OUTPUT_DIR"

############################
# Check if the job succeeded
if [ $? -eq 0 ]; then
    echo "WordCount job completed successfully!"
else
    echo "WordCount job failed!"
    exit 1
fi
