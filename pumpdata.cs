using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Configuration;
using System.Threading;
using System.Diagnostics;

namespace ConsoleApplication1
{
	class Program
	{
		
		
		static int counter = 0;
		
		//static string strDBConnectionString = null;
		
		static String METHOD_DEFAULT = "4";
		static String sqlCleanTable = @"[primaryKeyViolation].[usp_CleanTable]";
		static String sqlAddData = @"[primaryKeyViolation].[usp_IncrementData_Base]";
		static String sqlSummary = @"select [primaryKeyViolation].[ufn_getCounterSum]()";

		static string FORMAT_SUMMARY_OF_RECORDS
						= @"Summary - Number of Completed Transaction(s): {0}";


		static String FORMAT_TIME_STARTED   = "Started on   {0}";						
		static String FORMAT_TIME_COMPLETED = "Completed on {0}";
		
		static String FORMAT_TIME = "{0:00}:{1:00}:{2:00}.{3:00}";
		static String FORMAT_TIME_ELAPSED = "Time Elapsed {0}";
		
		static String FORMAT_METHOD_ATTEMPTED =
						"Method Attempted {0}";
		
		static string strDBServer = null;		
		static string strDBInitialCatalog = null;				
		static int    iMethod = 0;
		static int    iNumberofIterations =0;
		static int    iNumberofIterationsAttempted =0;
		
						
		static Stopwatch stopWatch;
		static TimeSpan  ts;

		static DateTime localDateStarted;
		static DateTime localDateCompleted;
		
		static void Main(string[] args)
		{
			SqlConnectionStringBuilder cs = new SqlConnectionStringBuilder();
			
			try
			{    
			
				readConfigFile();

				cs.DataSource = strDBServer;
				cs.InitialCatalog = strDBInitialCatalog;

				cs.IntegratedSecurity = true;
				cs.AsynchronousProcessing = true;
				string connectionString = cs.ToString();

				stopWatch = new Stopwatch();
				stopWatch.Start();
		
				SqlConnection connCleanDB = new SqlConnection(connectionString);
				connCleanDB.Open();				
				SqlCommand cmdCleanTable = new SqlCommand(sqlCleanTable, connCleanDB);
				cmdCleanTable.CommandType = System.Data.CommandType.StoredProcedure;
				cmdCleanTable.ExecuteNonQuery();
				connCleanDB.Close();				
								

				localDateStarted = DateTime.Now;
								
				for (int i = 1; i <= iNumberofIterations; i++)
				{
					SqlConnection conn = new SqlConnection(connectionString);
					conn.Open();
					SqlCommand cmd = new SqlCommand(sqlAddData, conn);
					cmd.CommandType = System.Data.CommandType.StoredProcedure;
					cmd.Parameters.Add("@method", System.Data.SqlDbType.Int).Value = iMethod;					
					cmd.Parameters.Add("@id", System.Data.SqlDbType.Int).Value = i / 10;
					cmd.BeginExecuteNonQuery(new AsyncCallback(EndExecution), cmd);
				}

				/*
					Wait on all threads to complete
				*/
				while (iNumberofIterationsAttempted < iNumberofIterations)
				{
					Thread.Yield();
				}
				
				
				localDateCompleted = DateTime.Now;
				
				stopWatch.Stop();
				
				
				
				// Get the elapsed time as a TimeSpan value.
				ts = stopWatch.Elapsed;
				
				summarize(
							  connectionString
							, ts
						 );
				
			}

			catch (Exception e)
			{
				Console.WriteLine("{0} Exception caught.", e);
			}			
			
		}


		static void EndExecution(IAsyncResult c)
		{
			SqlCommand endCmd = (c.AsyncState as SqlCommand);
			try
			{
				endCmd.EndExecuteNonQuery(c);
			}
			catch (Exception ex)
			{
				//http://mono.1490590.n4.nabble.com/Conditional-quot-DEBUG-quot-td4662067.html
				//counter++;

				//counter = counter+1;
				
				Interlocked.Increment(ref counter);
				
				Console.WriteLine(ex.Message);
				//#endif
			}
			finally
			{
				endCmd.Connection.Close();
				
				Interlocked.Increment(ref iNumberofIterationsAttempted);
				
			}
		} // method
		
		
		static private void readConfigFile()
		{
			
			string strMethod
				= ConfigurationManager.AppSettings["Method"];

			if (strMethod == null)			
			{
				strMethod = METHOD_DEFAULT;
			}

			iMethod	= Int32.Parse(strMethod);					
			
			string strNumberofIterations
				= ConfigurationManager.AppSettings["NumberofIterations"];

			if (strNumberofIterations == null)			
			{
				strNumberofIterations = "1";
			}
			
			iNumberofIterations	= Int32.Parse(strNumberofIterations);								

			strDBServer	= ConfigurationManager.AppSettings["DBServer"];
			strDBInitialCatalog	= ConfigurationManager.AppSettings["DBInitialCatalog"];
			
			Console.WriteLine("DB Server {0} ", strDBServer);
			Console.WriteLine("DB Initial Catalog {0} ", strDBInitialCatalog);
			Console.WriteLine("Method {0} ", strMethod);		
			Console.WriteLine("Number of Iterations {0} ", iNumberofIterations);			
				
		} //readConfigFile


		static private void summarize
							(
								  String connectionString
								, TimeSpan  ts
							)
		{
			
			SqlConnection connSummary = null;
			SqlCommand 	  cmdSummary = null;
			System.Int64  lSummary = -1;			
			Object 		  objSummary = null;
			string 		  elapsedTime = null;
			string        strLog = "";
			
			
			connSummary = new SqlConnection(connectionString);
			
			connSummary.Open();			
			
			cmdSummary = new SqlCommand(sqlSummary, connSummary);
			
			objSummary = cmdSummary.ExecuteScalar();
			
			connSummary.Close();	

			if 	(objSummary != null)
			{
				lSummary = (System.Int64) objSummary;
				
			}
			
			strLog = string.Format(
									  FORMAT_METHOD_ATTEMPTED
									, iMethod
								  );
		
			Console.WriteLine(strLog);
			
			strLog = string.Format(
									  FORMAT_SUMMARY_OF_RECORDS
									, lSummary
								  );
		
			Console.WriteLine(strLog);
			
			strLog = string.Format(@"Error count: {0}", counter);
			
			Console.WriteLine(strLog);

			// Format and display the TimeSpan value.
			elapsedTime = String.Format(
											  FORMAT_TIME
											, ts.Hours
											, ts.Minutes
											, ts.Seconds
											, ts.Milliseconds / 10
									    );

			strLog = String.Format( 
									  FORMAT_TIME_STARTED
									, localDateStarted.ToLongTimeString()
								  );			
			
			Console.WriteLine(strLog);			

			strLog = String.Format( 
									  FORMAT_TIME_COMPLETED
									, localDateCompleted.ToLongTimeString()
								  );			
								  
			Console.WriteLine(strLog);			
			
			strLog = String.Format(
									 FORMAT_TIME_ELAPSED
									, elapsedTime
								  );
								  
			Console.WriteLine(strLog);			
			
			
		}
		
	} 
	
	
	
	
}
