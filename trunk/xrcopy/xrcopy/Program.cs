using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;
using System.IO;
using System.Collections;

namespace xrcopy
{
	class Program
	{
		// Constants
		private const string srcFile = "source.txt";
		private const string dstFile = "target.txt";
		private const string slhFile = "slash.txt";

		static void Main(string[] args)
		{
#if DEBUG
			System.Environment.CurrentDirectory = @"C:\!Backup";
#endif

			// Just a string var for stuff
			string info = string.Empty;

			// Set the title of the window
			Console.Title = "xrcopy";

			// Make sure we have everything we need!
			if (InValid())
				return;

			ArrayList Sources = TextlistToArray(srcFile);
			ArrayList Destinations = TextlistToArray(dstFile);
			ArrayList Slashes = TextlistToArray(slhFile);

			string slash = string.Empty;
			foreach (string slh in Slashes)
			{
				if (ValidSlash(slh))
					slash += slh + " ";
			}
			
			foreach (string dst in Destinations)
			{
				info = string.Format("Backing files to: {0}", dst);
				Console.WriteLine(info);
				Console.WriteLine(new String('-', info.Length));

				if (!Directory.Exists(dst))
					Directory.CreateDirectory(dst);

				string log = Path.Combine(dst, DateTime.Now.ToString("yyyyMMdd_HHmmss"));

				foreach (string src in Sources)
				{
					if (Directory.Exists(src))
					{
						Console.WriteLine("* Backing directory: {0}", src);
						string dstC = Path.Combine(dst, src.Replace(":", "_(HDD)"));
						info = string.Format("\"{0}\" \"{1}\" {2}/LOG+:\"{3}.log\"", src, dstC, slash, log);
						Exec("robocopy", info);
					}
					else if (File.Exists(src))
					{
						FileInfo fi = new FileInfo(src);

						string srcPath = fi.Directory.FullName;
						string srcName = fi.Name;

						Console.WriteLine("* Backing file: {0}", src);
						string dstC = Path.Combine(dst, srcPath.Replace(":", "_(HDD)"));
						info = string.Format("\"{0}\" \"{1}\" {2}/LOG+:\"{3}.log\" /IF {4}", srcPath, dstC, slash, log, srcName);
						Exec("robocopy", info);
					}
					else
					{
						Console.WriteLine("* file/directory not found, skipping \"{0}\"", src);
					}
				}

				DateTime.Now.ToString("");

				Console.WriteLine(string.Empty);
			}

			Console.WriteLine("Exiting in 20 seconds");
			DateTime killTime = DateTime.Now.AddSeconds(20);
			while (DateTime.Now < killTime)
			{
				// Do Nothing
			}
		}

		private static ArrayList TextlistToArray(string fileName)
		{
			ArrayList lines = new ArrayList();
			StreamReader sr = new StreamReader(fileName);
			while (sr.Peek() != -1)
			{
				string line = sr.ReadLine().Trim();

				if (!line.StartsWith("#") && line.Length > 1)
					lines.Add(line);

			}
			sr.Close(); sr.Dispose();

			return lines;
		}

		private static ArrayList ValidSlashes = ArrayList.Adapter("S:E:LEV:Z:B:ZB:COPY:SEC:COPYALL:NOCOPY:PURGE:MIR:MOV:MOVE:A+:A-:CREATE:FAT:FFT:256:MON:MOT:RH:PF:IPG:A:M:IA:XA:MAX:MIN:MAXAGE:MINAGE:MAXLAD:MINLAD:XJ:R:W:TBD:L:X:V:TS:FP:NS:NC:NFL:NDL:NP:ETA:TEE:NJH:NJS".Split(char.Parse(":")));
		private static bool ValidSlash(string slash)
		{
			string slh = slash.Trim(char.Parse("/")).Trim();
			slh = slh.Split(char.Parse(":"))[0];

			if (ValidSlashes.Contains(slh))
				return true;
			
			return false;
		}

		private static bool InValid()
		{
			if (!File.Exists(srcFile))
			{
				Console.WriteLine("Could not find \"{0}\"", srcFile);
				Console.WriteLine(string.Empty);
				Console.WriteLine("Create the file \"{0}\"", Path.Combine(System.Environment.CurrentDirectory, srcFile));
				Console.WriteLine("And specify files/directories to backup (one per line)");
				Console.WriteLine("Rows beginning with # will be skipped");
				Console.WriteLine(string.Empty);
				Console.WriteLine("Press any key to exit");
				Console.ReadKey();
				return true;
			}

			if (!File.Exists(dstFile))
			{
				Console.WriteLine("Could not find \"{0}\"", dstFile);
				Console.WriteLine(string.Empty);
				Console.WriteLine("Create the file \"{0}\"", Path.Combine(System.Environment.CurrentDirectory, dstFile));
				Console.WriteLine("And specify where to backup any valid directories in it will be backed up to");
				Console.WriteLine("Rows beginning with # will be skipped");
				Console.WriteLine(string.Empty);
				Console.WriteLine("Press any key to exit");
				Console.ReadKey();
				return true;
			}

			if (!File.Exists(slhFile))
			{
				StreamWriter sw = new StreamWriter(slhFile);
				sw.WriteLine("#                  /S :: copy Subdirectories, but not empty ones.");
				sw.WriteLine("#                  /E :: copy subdirectories, including Empty ones.");
				sw.WriteLine("#              /LEV:n :: only copy the top n LEVels of the source directory tree.");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#                  /Z :: copy files in restartable mode.");
				sw.WriteLine("#                  /B :: copy files in Backup mode.");
				sw.WriteLine("#                 /ZB :: use restartable mode; if access denied use Backup mode.");
				sw.WriteLine("# ");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#   /COPY:copyflag[s] :: what to COPY (default is /COPY:DAT).");
				sw.WriteLine("#                        (copyflags : D=Data, A=Attributes, T=Timestamps).");
				sw.WriteLine("#                        (S=Security=NTFS ACLs, O=Owner info, U=aUditing info).");
				sw.WriteLine("/COPY:DAT");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#                /SEC :: copy files with SECurity (equivalent to /COPY:DATS).");
				sw.WriteLine("#            /COPYALL :: COPY ALL file info (equivalent to /COPY:DATSOU).");
				sw.WriteLine("#             /NOCOPY :: COPY NO file info (useful with /PURGE).");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#              /PURGE :: delete dest files/dirs that no longer exist in source.");
				sw.WriteLine("#                /MIR :: MIRror a directory tree (equivalent to /E plus /PURGE).");
				sw.WriteLine("#                /MOV :: MOVe files (delete from source after copying).");
				sw.WriteLine("#               /MOVE :: MOVE files AND dirs (delete from source after copying).");
				sw.WriteLine("/MIR");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#        /A+:[RASHNT] :: add the given Attributes to copied files.");
				sw.WriteLine("#        /A-:[RASHNT] :: remove the given Attributes from copied files.");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#             /CREATE :: CREATE directory tree and zero-length files only.");
				sw.WriteLine("#                /FAT :: create destination files using 8.3 FAT file names only.");
				sw.WriteLine("#                /FFT :: assume FAT File Times (2-second granularity).");
				sw.WriteLine("#                /256 :: turn off very long path (> 256 characters) support.");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#              /MON:n :: MONitor source; run again when more than n changes seen.");
				sw.WriteLine("#              /MOT:m :: MOnitor source; run again in m minutes Time, if changed.");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#       /RH:hhmm-hhmm :: Run Hours - times when new copies may be started.");
				sw.WriteLine("#                 /PF :: check run hours on a Per File (not per pass) basis.");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#              /IPG:n :: Inter-Packet Gap (ms), to free bandwidth on slow lines.");
				sw.WriteLine(string.Empty);
				sw.WriteLine(string.Empty);
				sw.WriteLine("# File Selection Options :");
				sw.WriteLine("#");
				sw.WriteLine("#                  /A :: copy only files with the Archive attribute set.");
				sw.WriteLine("#                  /M :: copy only files with the Archive attribute and reset it.");
				sw.WriteLine("#     /IA:[RASHCNETO] :: Include only files with any of the given Attributes set.");
				sw.WriteLine("#     /XA:[RASHCNETO] :: eXclude files with any of the given Attributes set.");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#              /MAX:n :: MAXimum file size - exclude files bigger than n bytes.");
				sw.WriteLine("#              /MIN:n :: MINimum file size - exclude files smaller than n bytes.");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#           /MAXAGE:n :: MAXimum file AGE - exclude files older than n days/date.");
				sw.WriteLine("#           /MINAGE:n :: MINimum file AGE - exclude files newer than n days/date.");
				sw.WriteLine("#           /MAXLAD:n :: MAXimum Last Access Date - exclude files unused since n.");
				sw.WriteLine("#           /MINLAD:n :: MINimum Last Access Date - exclude files used since n.");
				sw.WriteLine("#                        (If n < 1900 then n = n days, else n = YYYYMMDD date).");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#                 /XJ :: eXclude Junction points. (normally included by default).");
				sw.WriteLine(string.Empty);
				sw.WriteLine(string.Empty);
				sw.WriteLine("# Retry Options :");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#                /R:n :: number of Retries on failed copies: default 1 million.");
				sw.WriteLine("#                /W:n :: Wait time between retries: default is 30 seconds.");
				sw.WriteLine("/R:7");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#                /TBD :: wait for sharenames To Be Defined (retry error 67).");
				sw.WriteLine(string.Empty);
				sw.WriteLine(string.Empty);
				sw.WriteLine("# Logging Options :");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#                  /L :: List only - don't copy, timestamp or delete any files.");
				sw.WriteLine("#                  /X :: report all eXtra files, not just those selected.");
				sw.WriteLine("#                  /V :: produce Verbose output, showing skipped files.");
				sw.WriteLine("#                 /TS :: include source file Time Stamps in the output.");
				sw.WriteLine("#                 /FP :: include Full Pathname of files in the output.");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#                 /NS :: No Size - don't log file sizes.");
				sw.WriteLine("#                 /NC :: No Class - don't log file classes.");
				sw.WriteLine("#                /NFL :: No File List - don't log file names.");
				sw.WriteLine("#                /NDL :: No Directory List - don't log directory names.");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#                 /NP :: No Progress - don't display % copied.");
				sw.WriteLine("#                /ETA :: show Estimated Time of Arrival of copied files.");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#                /TEE :: output to console window, as well as the log file.");
				sw.WriteLine("/TEE");
				sw.WriteLine(string.Empty);
				sw.WriteLine("#                /NJH :: No Job Header.");
				sw.WriteLine("#                /NJS :: No Job Summary.");
				sw.Flush();
				sw.Close(); sw.Dispose();
			}

			return false;
		}

		private static void Exec(string fileName)
		{
			Exec(fileName, string.Empty);
		}
		private static void Exec(string fileName, string arguments)
		{
			bool redirect = true;

			ProcessStartInfo psi = new ProcessStartInfo(fileName, arguments);
			psi.CreateNoWindow = false;
			psi.UseShellExecute = false;

			Process proc = new Process();
			proc.StartInfo = psi;
			proc.Start();
			proc.WaitForExit();
		}
	}
}
