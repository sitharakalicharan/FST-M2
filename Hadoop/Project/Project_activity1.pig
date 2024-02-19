-- Load data from HDFS
inputDialogue4 = LOAD 'hdfs://user/sithara/inputs/episodeIV_dialogues.txt' USING PigStorage('\t') AS (name:chararray, line:chararray);
inputDialogue5 = LOAD 'hdfs://user/sithara/inputs/episodeV_dialogues.txt' USING PigStorage('\t') AS (name:chararray, line:chararray);
inputDialogue6 = LOAD 'hdfs://user/sithara/inputs/episodeVI_dialogues.txt' USING PigStorage('\t') AS (name:chararray, line:chararray);


--Filter out the first 2 lines from each Filter
ranked4 = RANK inputDialogue4;
OnlyDialogues4= FILTER ranked4 BY (rank_inputDialogues4 > 2);

ranked5 = RANK inputDialogue5;
OnlyDialogues5= FILTER ranked5 BY (rank_inputDialogues5 > 2);

ranked6 = RANK inputDialogue6;
OnlyDialogues6= FILTER ranked6 BY (rank_inputDialogues6 > 2);

--merge the above outputs
inputData = UNION OnlyDialogues4, OnlyDialogues5, OnlyDialogues6;

-- group them by name
groupByName = GROUP inputData BY name;


-- count the lines by each character
names = FOREACH groupByName GENERATE $0 as name, COUNT($1) as no_of_lines;
namesOrdered = ORDER names BY no_of_lines DESC;

--Store the results in hdfs
STORE namesOrdered INTO 'hdfs:///user/sithara/outputs' USING PigStorage('\t);
