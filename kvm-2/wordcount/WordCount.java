import java.util.Arrays;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;

import scala.Tuple2;

public class WordCount { 
	 
	public static void main(String[] args) { 
	    String input_path = "file:///home/ubuntu/wordcount/input.txt"; 
	    String output_path = "file:///home/ubuntu/wordcount/output"; 

	    SparkConf conf = new SparkConf().setAppName("WordCount"); 
	    JavaSparkContext sc = new JavaSparkContext(conf); 
	    
	    long t1 = System.currentTimeMillis(); 

	    // Read the input file and split text into words, removing punctuation
	    JavaRDD<String> data = 
	        sc.textFile(input_path)
	          .flatMap(s -> Arrays.asList(s.replaceAll("[^a-zA-Z]", " ").toLowerCase().split("\\s+")).iterator()); 
	   
		// // V0 Hagimont like
		// JavaRDD<String> data = 
		// sc.textFile(input_path)
		//   .flatMap(s -> Arrays.asList(s.replaceAll("[^a-zA-Z]", " ").toLowerCase().split("\\s+")).iterator()); 


	    // Map words to (word, 1) pairs and count their occurrences
	    JavaPairRDD<String, Integer> counts = 
	        data.filter(word -> !word.isEmpty())  // Remove empty strings
	            .mapToPair(word -> new Tuple2<>(word, 1))
	            .reduceByKey(Integer::sum); 
	    
		// // V0 Hagimont like
		// JavaPairRDD<String, Integer> counts = 
		// 	data.mapToPair(w -> new Tuple2<String, Integer>(w,1)).
		// 	reduceByKey((c1,c2) -> c1 + c2); 

	    counts.saveAsTextFile(output_path); 
	    
	    long t2 = System.currentTimeMillis(); 
	    
	    System.out.println("======================"); 
	    System.out.println("Time in ms: " + (t2 - t1)); 
	    System.out.println("======================"); 

	} 
}
