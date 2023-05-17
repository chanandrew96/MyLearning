SELECT DB_NAME (a.database_id) AS dbname,
	a.io_stall / NULLIF (a.num_of_reads + a.num_of_writes, 0) AS average_tot_latency,
	Round ((a.size_on_disk_bytes / square (1024.0)), 1) AS size_mb,
	b.physical_name AS [fileName]
FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS a,
	sys.master_files AS b
WHERE a.database_id = b.database_id
	AND a.FILE_ID = b.FILE_ID
ORDER BY average_tot_latency DESC
