Unit unParams;
Interface

Uses
  Windows, SysUtils, unProControl;

Type
  TVideoQuality = (vcHigh, vcMedium, vcLow);
  TAudioQuality = (acHigh, acMedium, acLow);
  TSizeType = (stAuto, stFull, st4x3, st16x9);
  TModel = (plT59X);

  PConvParams = ^TConvParams;
  TConvParams = record
    szInFile, szOutFile: string;
    nDVDTrack: integer;
    VideoQuality: TVideoQuality;
    AudioQuality: TAudioQuality;
    SizeType: TSizeType;
    ptScale: TPoint;
    ptExpand: TPoint;
    Model: TModel;
    run: string;
  End;

  TCharacteristic = record
    vBitrate: array [TVideoQuality] of integer;
    aBitrate: array [TAudioQuality] of integer;
    ExpSize: TPoint;
    VidSize: array [TSizeType] of TPoint;
    ACodec: string;
    VCodec: string;
  End;

Const
  ZeroParams: TConvParams = (
    szInFile: '';
    szOutFile: '';
    nDVDTrack: -1;
    VideoQuality: vcMedium;
    AudioQuality: acMedium;
    SizeType: stAuto;
    ptScale: (X:0;Y:0);
    ptExpand: (X:0;Y:0);
    Model: plT59X;
    run: '' );
    
  Players: array [TModel] of TCharacteristic =
   ( ( vBitrate: (800, 550, 300);
       aBitrate: (128, 64, 32);
       ExpSize: (X:160; Y:128);
       VidSize: ((X:160;Y:-2), (X:160;Y:128), (X:160;Y:120), (X:160;Y:90));
       ACodec: '-oac lavc -srate 44100 -lavcopts acodec=mp2:abitrate=%d -channels 2 ';
       VCodec: '-ovc xvid -xvidencopts bitrate=%d:max_bframes=0:quant_type=h263:vhq=0:me_quality=0:rc_buffer=1000000 '+
         '-ofps 15 ' )
   );

Function GetCmdLine(var Params: TConvParams): string;
Function GetPlayerCmdLine(var Params: TConvParams): string;

Implementation

Function GetInName(const Params: TConvParams): string;
Begin
  IF Params.nDVDTrack < 0 then
    Result := '"'+Params.szInFile+'"'
  else
    Result := 'dvd://'+IntToStr(Params.nDVDTrack)+' -dvd-device "'+Params.szInFile+'"';
End;

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

Procedure GetNewScale(const run: string; var cp: TConvParams);
Var
  P: TPoint;
  X, Y: integer;
Begin
  P := GetVideoSize(run);
  IF (P.X = 0) or (P.Y = 0) then Exit;
  With cp do
  Begin
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
End;

Function GetCmdLine(var Params: TConvParams): string;

  Procedure Add(const s: string);
  Begin
    Result := Result + s;
  End;

Begin
  Result := '';
  With Params do
  Begin
    Result := '-noodml -of avi '; //-bps ';
    Add(GetInName(Params));
    Add(' -o "'+szOutFile+'" ');

    Add(Format(Players[Model].ACodec, [ Players[Model].aBitrate[AudioQuality] ]));
    Add(Format(Players[Model].VCodec, [ Players[Model].vBitrate[VideoQuality] ]));

    ptExpand := Players[Model].ExpSize;
    ptScale := Players[Model].VidSize[SizeType];
    IF SizeType = stAuto then
    Begin
      IF ptScale.X*ptScale.Y < 0 then
      Begin
        IF run = '' then
          run := RunAndReadAll(ExtractFilePath(ParamStr(0))+'mplayer.exe',
            '-slave -idx -identify -quiet -frames 0 '+GetInName(Params));
        GetNewScale(run, Params);
      End;
    End;
    Add(Format('-vf-add scale=%d:%d ', [ptScale.X, ptScale.Y]));
    Add(Format('-vf-add expand=160:128:-1:-1:1 ', [ptExpand.X, ptExpand.Y]));
  End;
End;

Function GetPlayerCmdLine(var Params: TConvParams): string;

  Procedure Add(const s: string);
  Begin
    Result := Result + s;
  End;

Begin
  Result := '';
  With Params do
  Begin
    Add(GetInName(Params)+' ');

    ptExpand := Players[Model].ExpSize;
    ptScale := Players[Model].VidSize[SizeType];
    IF SizeType = stAuto then
    Begin
      IF ptScale.X*ptScale.Y < 0 then
      Begin
        IF run = '' then
          run := RunAndReadAll(ExtractFilePath(ParamStr(0))+'mplayer.exe',
            '-slave -idx -identify -quiet -frames 0 '+GetInName(Params));
        GetNewScale(run, Params);
      End;
    End;
    Add(Format('-vf-add scale=%d:%d ', [ptScale.X, ptScale.Y]));
//    Add(Format('-vf-add dsize=%d:%d ', [ptExpand.X, ptExpand.Y]));
  End;
End;

End.
