#!/bin/bash
# Path to WordCount directory
WORDCOUNT_DIR="/home/ubuntu/wordcount"

# Create the JAR file
cd "$WORDCOUNT_DIR"
jar -cvf WordCount.jar -C "$WORDCOUNT_DIR" .

# Check if JAR creation succeeded
if [ $? -eq 0 ]; then
    echo "JAR file created successfully!"
else
    echo "Failed to create JAR file!"
    exit 1
fi
