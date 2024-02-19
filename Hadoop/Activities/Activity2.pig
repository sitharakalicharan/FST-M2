-- Load input file from HDFS
inputFile = LOAD 'hdfs:///user/sithara/file01.txt' AS (line);

-- Tokeize each word 
words = FOREACH inputFile GENERATE FLATTEN(TOKENIZE(line)) AS word;

-- Combine the words from the above stage
grouped = GROUP words BY word;

-- Count the occurence of each word (Reduce)
word_count = FOREACH grouped GENERATE $0, COUNT($1);

--Delete the output folder
rmf hdfs:///user/sithara/PigResults

-- Store the result in HDFS
STORE word_count INTO 'hdfs:///user/sithara/pigResults';