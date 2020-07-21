# Write-Log

###Description
Creates a log entry with timestamp and message passed thru a parameter $Message or thru pipeline, and saves the log entry to log file, to report log file, and writes the same entry to console. $Configuration parameter contains path to Configuration.inf file in witch paths to report log and permanent log file are contained, and option to turn on or off whether a report log, permanent log and console write should be written. This function can be called to write a log separator, and this entries do not have a timestamp. Format of the timestamp is "yyyy.MM.dd. HH:mm:ss:fff" and this function adds " - " after timestamp and before the main message.

### Credits
Script developer:  [Zoran Jankov](https://www.linkedin.com/in/zoran-jankov-b1054b196/)
<a href="https://stackexchange.com/users/12947676/zoran-jankov"><img src="https://stackexchange.com/users/flair/12947676.png" width="208" height="58" alt="profile for Zoran Jankov on Stack Exchange, a network of free, community-driven Q&amp;A sites" title="profile for Zoran Jankov on Stack Exchange, a network of free, community-driven Q&amp;A sites" /></a>

