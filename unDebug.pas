Unit unDebug;
Interface

Var
  LogFile: Text;

Implementation

Initialization
  Assign(LogFile, 'logfile.log');
  Rewrite(LogFile);

Finalization
  Close(LogFile);

End.
