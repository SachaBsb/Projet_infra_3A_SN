#!/bin/bash
# Path to WordCount.java
WORDCOUNT_DIR="/home/ubuntu/wordcount"
SPARK_JARS="$SPARK_HOME/jars/*"

# Compile WordCount.java
javac -cp "$SPARK_JARS" -d "$WORDCOUNT_DIR" "$WORDCOUNT_DIR/WordCount.java"

# Check if compilation succeeded
if [ $? -eq 0 ]; then
    echo "Compilation successful!"
else
    echo "Compilation failed!"
    exit 1
fi
