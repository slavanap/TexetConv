Unit pl_T72X;
Interface

Uses
  Windows, SysUtils, unManager;

Const
  PlayerMetric: TPoint = (X:160; Y:120);
  MPlayer = 'mplayer.exe';
  MEncoder = 'mencoder.exe';
  FFmpeg = 'ffmpeg.exe';

Type
  T72X = class(TCustomConverter)
  Public
    Constructor Create(const FileName: string); override;
    Procedure AnalyseMEncoder(s: string; var progress: integer);
    Procedure AnalyseFFmpeg(s: string; var progress: integer);
    Procedure Convert; override;
  End;

Function GetVideoSize(const S: string): TPoint;
Procedure GetAutoScale(const run: string; var ptScale: TPoint; const ptExpand: TPoint);
Procedure Add(var s: string; const a: string);

Implementation

Function GetVideoSize(const S: string): TPoint;
Const
  szW = 'ID_VIDEO_WIDTH=';
  szH = 'ID_VIDEO_HEIGHT=';
Var
  i,j: integer;
Begin
  Result.x := 0;
  Result.y := 0;
  Try
    i := Pos(szW, S);
    IF i <> 0 then
    Begin
      Inc(i, length(szW));
      For j:=i to length(S) do
        IF S[j] in [#13,#10,#0] then
          Break;
      Result.X := StrToInt(Copy(S, i, j-i));
    End;
    i := Pos(szH, S);
    IF i <> 0 then
    Begin
      Inc(i, length(szH));
      For j:=i to length(S) do
        IF S[j] in [#13,#10,#0] then
          Break;
      Result.Y := StrToInt(Copy(S, i, j-i));
    End;
  Except End;
End;

Procedure GetAutoScale(const run: string; var ptScale: TPoint; const ptExpand: TPoint);
Var
  P: TPoint;
  X, Y: integer;
Begin
  P := GetVideoSize(run);
  IF (P.X = 0) or (P.Y = 0) then Exit;

  X := ptExpand.X;
  Y := Round((P.Y*X)/P.X);
  IF Y > ptExpand.Y then
  Begin
    Y := ptExpand.Y;
    X := Round((P.X*Y)/P.Y);
    IF X > ptExpand.X then Exit;
  End;
  ptScale.X := X;
  ptScale.Y := Y;
End;

Procedure Add(var s: string; const a: string);
Begin
  s := s + a;
End;

Function GetMencoderLine(const FileName, OutFileName: string): string;
Var
  ptScale: TPoint;
Begin
  Result := '-noodml -of avi "'+FileName+'"  -o "'+OutFileName+'" '+
    '-oac pcm -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=3000 ';
  GetAutoScale(
      RunAndReadAll(MPlayer, '-slave -idx -identify -quiet -frames 0 "'+FileName+'"'),
      ptScale, PlayerMetric);
  Add(Result, Format('-vf-add scale=%d:%d ', [ptScale.X, ptScale.Y]));
  Add(Result, Format('-vf-add expand=%d:%d:-1:-1:1 ', [PlayerMetric.X, PlayerMetric.Y]));
  // Add(Result, '-endpos 10');     {$MESSAGE WARN 'to delete'}
End;

Function GetFFMpegLine(const FileName, OutFileName: string): string;
Begin
  Result := Format('-v -i "%s" -f amv -r 16 -s %dx%d -ac 1 -ar 22050 -y "%s"',
    [FileName, PlayerMetric.X, PlayerMetric.Y, OutFileName]);
End;



{ *** T72X *** }

Constructor T72X.Create(const FileName: string);
Begin
  inherited;
  FOutFileName := ChangeFileExt(FOutFileName, '.amv');
End;

Procedure T72X.AnalyseMEncoder(s: string; var progress: integer);
Var
  i: integer;
Begin
 // Поиск наличия ошибки
  I := Pos('Exiting', S);
  IF I <> 0 then
    IF Pos('error', Copy(S, i, length(S)-i+1)) <> 0 then
      raise Exception.Create('Ошибка в процессе конвертации');

  // Поиск процента выполнения ...
  Try
    I := Pos('%)', S);
    IF I >= 3 then
    Begin
      S := Copy(S, I-3, 3);
      Delete(S, 1, Pos('(', S));
      While (Length(S) > 0) and (S[1]=' ') do Delete(S, 1, 1);
      progress := (StrToInt(S)*90) div 100;
    End;
  Except End;
End;

Procedure T72X.AnalyseFFmpeg(s: string; var progress: integer);
Begin
//  inc(progress);
//  LogStr(s);
End;

Procedure T72X.Convert;
Var
  TempName: string;
Begin
  TempName := CreateTempFileName('mcoder_') + '.avi';
  Try
    Run(MEncoder, GetMEncoderLine(FInFileName, TempName), AnalyseMEncoder);
    // LogStr( GetFFMpegLine(TempName, FOutFileName) );
    Run(FFmpeg, GetFFMpegLine(TempName, FOutFileName), AnalyseFFmpeg);
  Finally
    DeleteFile(PChar(TempName));
  End;
End;

End.

