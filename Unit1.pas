unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  StrUtils;

type
  TForm1 = class(TForm)
    btnWrite: TBitBtn;
    memLog: TMemo;
    Label1: TLabel;
    edtPacketSize: TEdit;
    Label2: TLabel;
    cbCommunicationModes: TComboBox;
    Label3: TLabel;
    edtDeveloperCode: TEdit;
    Label4: TLabel;
    edtDeveloperID: TEdit;
    Label5: TLabel;
    edtWritePassword: TEdit;
    Label6: TLabel;
    edtOverwritePassword1: TEdit;
    Label7: TLabel;
    edtOverwritePassword2: TEdit;
    Label8: TLabel;
    edtAccessCode: TEdit;
    Label9: TLabel;
    edtData: TEdit;
    Label10: TLabel;
    btnRead: TBitBtn;
    Label11: TLabel;
    edtDataIndex: TEdit;
    procedure btnWriteClick(Sender: TObject);
    procedure btnReadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  DongleMemory : array [0..63] of UInt16;

  RNBOsproFormatPacket : function(apiPacket : Pointer; PacketSize : UInt16) : UInt16;StdCall;
  RNBOsproSetDeveloperCode : function(apiPacket : Pointer; developerCode : POINTER; size : integer) : UInt16; StdCall;
  RNBOsproInitialize : function(apiPacket : Pointer) : UInt16;StdCall;
  RNBOsproFindFirstUnit : function(apiPacket : Pointer; value : UInt16) : UInt16; StdCall;
  RNBOsproSetContactServer : function(apiPacket : Pointer; ServerName : AnsiString) : UInt16; StdCall;
  RNBOsproRead : function(apiPacket : Pointer; address : UInt16; data : POINTER) : UInt16; StdCall;
  RNBOsproWrite : function(apiPacket : Pointer; writePassword : UInt16; address : UInt16; data : UInt16; accessCode : BYTE) : UInt16; StdCall;
  RNBOsproOverwrite : function(apiPacket : Pointer; writePassword : UInt16; overwritePassword1 : UInt16; overwritePassword2 : UInt16; address : UInt16; data : UInt16; accessCode : BYTE) : UInt16; StdCall;

implementation

{$R *.dfm}

function InitFunctionsDll : Boolean;
var
  ImageBase : NativeUInt;
begin
  Result := False;

  ImageBase := LoadLibrary('sx32w.dll');
  if ImageBase = 0 then
    Exit;

  @RNBOsproFormatPacket := GetProcAddress(ImageBase, 'RNBOsproFormatPacket');
  @RNBOsproSetDeveloperCode := GetProcAddress(ImageBase, 'RNBOsproSetDeveloperCode');
  @RNBOsproInitialize := GetProcAddress(ImageBase, 'RNBOsproInitialize');
  @RNBOsproFindFirstUnit := GetProcAddress(ImageBase, 'RNBOsproFindFirstUnit');
  @RNBOsproSetContactServer := GetProcAddress(ImageBase, 'RNBOsproSetContactServer');
  @RNBOsproRead := GetProcAddress(ImageBase, 'RNBOsproRead');
  @RNBOsproWrite := GetProcAddress(ImageBase, 'RNBOsproWrite');
  @RNBOsproOverwrite := GetProcAddress(ImageBase, 'RNBOsproOverwrite');
  //@ := GetProcAddress(ImageBase, '');
  Result := True;
end;

function ReadDongleMemory(apiPacket : Pointer) : Boolean;
var
  cnt, data, Status : UInt16;
begin
  for cnt := Low(DongleMemory) to High(DongleMemory) do
  begin
    Status := RNBOsproRead(apiPacket, cnt, @data);
    if Status = 0 then
      DongleMemory[cnt] := data;
  end;
end;

function StatusErrorCodesStr(Status  : UInt16) : string;
begin
  case Status of
    0: Result := 'SUCCESS (no error)';
    1: Result :='INVALID FUNCTION CODE';
    2: Result := 'INVALID PACKET';
    3: Result := 'UNIT NOT FOUND';
    4: Result := 'ACCESS DENIED';
    5: Result := 'INVALID MEMORY ADDRESS';
    6: Result := 'INVALID ACCESS CODE';
    7: Result := 'PORT IS BUSY';
    8: Result := 'WRITE NOT READY';
    9: Result := 'NO PORT FOUND';
    10: Result := 'ALREADY ZERO';
    11: Result := 'DRIVER OPEN ERROR';
    12: Result := 'DRIVER NOT INSTALLED';
    13: Result := 'IO COMMUNICATIONS ERROR';
    15: Result := 'PACKET TOO SMALL';
    16: Result := 'INVALID PARAMETER';
    17: Result := 'MEM ACCESS ERROR';
    18: Result := 'VERSION NOT SUPPORTED';
    19: Result := 'OS NOT SUPPORTED';
    20: Result := 'QUERY TOO LONG';
    21: Result := 'INVALID COMMAND';
    29: Result := 'MEM ALIGNMENT ERROR';
    30: Result := 'DRIVER IS BUSY';
    31: Result := 'PORT ALLOCATION FAILURE';
    32: Result := 'PORT RELEASE FAILURE';
    39: Result := 'ACQUIRE PORT TIMEOUT';
    42: Result := 'SIGNAL NOT SUPPORTED';
    44: Result := 'UNKNOWN MACHINE';
    45: Result := 'SYS API ERROR';
    46: Result := 'UNIT IS BUSY';
    47: Result := 'INVALID PORT TYPE';
    48: Result := 'INVALID MACH TYPE';
    49: Result := 'INVALID IRQ MASK';
    50: Result := 'INVALID CONT METHOD';
    51: Result := 'INVALID PORT FLAGS';
    52: Result := 'INVALID LOG PORT CFG';
    53: Result := 'INVALID OS TYPE';
    54: Result := 'INVALID LOG PORT NUM';
    56: Result := 'INVALID ROUTER FLGS';
    57: Result := 'INIT NOT CALLED';
    58: Result := 'DRVR TYPE NOT SUPPORTED';
    59: Result := 'FAIL ON DRIVER COMM';
    60: Result := 'SERVER PROBABLY NOT UP';
    61: Result := 'UNKNOWN HOST';
    62: Result := 'SENDTO FAILED';
    63: Result := 'SOCKET CREATION FAILED';
    64: Result := 'NORESOURCES';
    65: Result := 'BROADCAST NOT SUPPORTED';
    66: Result := 'BAD SERVER MESSAGE';
    67: Result := 'NO SERVER RUNNING';
    68: Result := 'NO NETWORK';
    69: Result := 'NO SERVER RESPONSE';
    70: Result := 'NO LICENSE AVAILABLE';
    71: Result := 'INVALID LICENSE';
    72: Result := 'INVALID OPERATION';
    73: Result := 'BUFFER TOO SMALL';
    74: Result := 'INTERNAL ERROR';
    75: Result := 'PACKET ALREADY INITIALIZED';
    76: Result := 'PROTOCOL NOT INSTALLED';
    101: Result := 'NO LEASE FEATURE';
    102: Result := 'LEASE EXPIRED';
    103: Result := 'COUNTER LIMIT REACHED';
    104: Result := 'NO DIGITAL SIGNATURE';
    105: Result := 'SYS FILE CORRUPTED';
    106: Result := 'STRING BUFFER TOO LONG';
    107: Result := 'INVALID DEV CODE';
    108: Result := 'DEVID DOES NOT MATCH';
    109: Result := 'DEVICE SHARING DETECTED';
    110: Result := 'SERVER VERSION NOT SUPPORTED';
    111: Result := 'FILE NOT FOUND';
    112: Result := 'PATH TOO LONG';
    113: Result := 'SOFT DB CORRUPT';
    114: Result := 'SOFT DB RESTORE DETECTED';
    115: Result := 'PRST DATA CORRUPT';
    116: Result := 'SECURITY RUNTIME NOT DETECTED';
    117: Result := 'TIME TAMPER DETECTED';
    118: Result := 'END DATE REACHED';
    119: Result := 'START DATE NOT REACHED';
    120: Result := 'HOST ID ERROR';
    121: Result := 'LIC INVALID';
    122: Result := 'LIC RUN TIME ERROR';
    123: Result := 'LIC MEMORY CORRUPTED';
    124: Result := 'NOT ENOUGH MEMORY';
    125: Result := 'IP ADDRESS BLOCKED';
    126: Result := 'SERVER OUT OF WORKING TIME';
    127: Result := 'SECURITY RUNTIME VERSION MISMATCH';
    401: Result :='BAD ALGO';
    402: Result := 'LONG MSG';
    403: Result := 'READ ERROR';
    404: Result := 'NOT ENOUGH MEMORY';
    405: Result := 'CANNOT OPEN';
    406: Result := 'WRITE ERROR';
    407: Result := 'CANNOT OVERWRITE';
    408: Result := 'INVALID HEADER';
    409: Result := 'TMP CREATE ERROR';
    410: Result := 'PATH NOT THERE';
    411: Result := 'BAD FILE INFO';
    412: Result := 'NOT WIN32 FILE';
    413: Result := 'INVALID MACHINE';
    414: Result := 'INVALID SECTION';
    415: Result := 'INVALID RELOC';
    416: Result := 'CRYPT ERROR';
    417: Result := 'SMARTHEAP ERROR';
    418: Result := 'IMPORT OVERWRITE ERROR';
    420: Result := 'NO PESHELL';
    421: Result := 'FRAMEWORK REQUIRED';
    422: Result := 'CANNOT HANDLE FILE';
    423: Result := 'IMPORT DLL ERROR';
    424: Result := 'IMPORT FUNCTION ERROR';
    425: Result := 'X64 SHELL ENGINE';
    426: Result := 'STRONG NAME';
    427: Result := 'FRAMEWORK 10';
    428: Result := 'FRAMEWORK SDK 10';
    429: Result := 'FRAMEWORK 11';
    430: Result := 'FRAMEWORK SDK 11';
    431: Result := 'FRAMEWORK 20 OR 30';
    432: Result := 'FRAMEWORK SDK 20';
    433: Result := 'APP NOT SUPPORTED';
    434: Result := 'FILE COPY';
    435: Result := 'HEADER SIZE EXCEED';
    436: Result := 'SGEN';
    437: Result := 'CODE MORPHING';
  else
    Result := 'Error number : ' + IntToStr(Status);
  end;
end;

function HexStr2ByteArray(DeveloperCode : string) : TBytes;
var
  cnt : DWORD;
  b : byte;
begin
  Result := nil;
  DeveloperCode := ReplaceStr(DeveloperCode, ' ', '');
  if (Length(DeveloperCode) mod 2) <> 0 then Exit;

  SetLength(Result, Length(DeveloperCode) div 2);
  cnt := 0;

  while Length(DeveloperCode) <> 0 do
  begin
    b := StrToUInt('$' + LeftStr(DeveloperCode, 2)) and $FF;
    DeveloperCode := RightStr(DeveloperCode, Length(DeveloperCode) - 2);

    Result[cnt] := b;
    Inc(cnt);
  end;
end;

procedure TForm1.btnWriteClick(Sender: TObject);
var
  apiPacket : Pointer;
  data, Status, PacketSize, devID, wp, op1, op2, di : UInt16;
  ac : Byte;
  s : string;
  DeveloperCode0 : TBytes;
begin
  memLog.Lines.Clear;

  if edtPacketSize.Text = '' then
  begin
    memLog.Lines.Add('Please enter Packet size first !!!');
    Exit;
  end;

  try
    PacketSize := StrToUInt('$' + edtPacketSize.Text) and $FFFF;
  except
    memLog.Lines.Add('Invalid Packet size !!!');
    Exit;
  end;

  if edtDeveloperCode.Text = '' then
  begin
    memLog.Lines.Add('Please enter Developer Code first !!!');
    Exit;
  end;

  if edtDeveloperID.Text = '' then
  begin
    memLog.Lines.Add('Please enter Developer ID first !!!');
    Exit;
  end;

  if edtDeveloperID.Text = '' then
  begin
    memLog.Lines.Add('Please enter Developer ID first !!!');
    Exit;
  end;

  try
    devID := StrToUInt('$' + edtDeveloperID.Text) and $FFFF;
  except
    memLog.Lines.Add('Invalid Developer ID string !!!');
    Exit;
  end;

  if edtWritePassword.Text = '' then
  begin
    memLog.Lines.Add('Please enter Write Password first !!!');
    Exit;
  end;

  try
    wp := StrToUInt('$' + edtWritePassword.Text) and $FFFF;
  except
    memLog.Lines.Add('Invalid Write Password string !!!');
    Exit;
  end;

  if edtOverwritePassword1.Text = '' then
  begin
    memLog.Lines.Add('Please enter Overwrite Password 1 first !!!');
    Exit;
  end;

  try
    op1 := StrToUInt('$' + edtOverwritePassword1.Text) and $FFFF;
  except
    memLog.Lines.Add('Invalid Overwrite Password 1 string !!!');
    Exit;
  end;

  if edtOverwritePassword2.Text = '' then
  begin
    memLog.Lines.Add('Please enter Overwrite Password 2 first !!!');
    Exit;
  end;

  try
    op2 := StrToUInt('$' + edtOverwritePassword2.Text) and $FFFF;
  except
    memLog.Lines.Add('Invalid Overwrite Password 2 string !!!');
    Exit;
  end;

  if edtAccessCode .Text = '' then
  begin
    memLog.Lines.Add('Please enter Access Code first !!!');
    Exit;
  end;

  try
    ac := StrToUInt('$' + edtAccessCode.Text) and $FF;
  except
    memLog.Lines.Add('Invalid Access Code string !!!');
    Exit;
  end;

  if edtDataIndex.Text = '' then
  begin
    memLog.Lines.Add('Please enter Data Index first !!!');
    Exit;
  end;

  try
    di := StrToUInt('$' + edtDataIndex.Text) and $FFFF;
  except
    memLog.Lines.Add('Invalid Data Index string !!!');
    Exit;
  end;

  if edtData.Text = '' then
  begin
    memLog.Lines.Add('Please enter Data first !!!');
    Exit;
  end;

  try
    data := StrToUInt('$' + edtData.Text) and $FFFF;
  except
    memLog.Lines.Add('Invalid Data string !!!');
    Exit;
  end;

  if not InitFunctionsDll then
  begin
    memLog.Lines.Add('"sx32w.dll" not found or corrupted (or mismatch architecture) !!!');
    Exit;
  end;

  GetMem(apiPacket, PacketSize);
  Status := RNBOsproFormatPacket(apiPacket, PacketSize);
  if Status <> 0 then
  begin
    memLog.Lines.Add(StatusErrorCodesStr(Status));
    Exit;
  end;

  Status := RNBOsproInitialize(apiPacket);
  if Status <> 0 then
  begin
    memLog.Lines.Add(StatusErrorCodesStr(Status));
    Exit;
  end;

  Status := RNBOsproSetContactServer(apiPacket, cbCommunicationModes.Text);
  if Status <> 0 then
  begin
    memLog.Lines.Add(StatusErrorCodesStr(Status));
    Exit;
  end;

  DeveloperCode0 := HexStr2ByteArray(edtDeveloperCode.Text);
  Status := RNBOsproSetDeveloperCode(apiPacket, @DeveloperCode0[0], Length(DeveloperCode0));
  if Status <> 0 then
  begin
    memLog.Lines.Add(StatusErrorCodesStr(Status));
    Exit;
  end;

  Status := RNBOsproFindFirstUnit(apiPacket, devID);
  if Status <> 0 then
  begin
    memLog.Lines.Add(StatusErrorCodesStr(Status));
    Exit;
  end;

  Status := RNBOsproWrite(apiPacket, wp, di, data, ac);
  if Status <> 0 then
  begin
    memLog.Lines.Add('Returned status from : RNBOsproWrite');
    memLog.Lines.Add(StatusErrorCodesStr(Status));
    memLog.Lines.Add('Trying RNBOsproOverwrite');
    memLog.Lines.Add('');

    Status := RNBOsproOverwrite(apiPacket, wp, op1, op2, di, data, ac);
    if Status <> 0 then
      memLog.Lines.Add(StatusErrorCodesStr(Status))
    else
      memLog.Lines.Add('Done.');
  end
  else
    memLog.Lines.Add('Done.');

end;

procedure TForm1.btnReadClick(Sender: TObject);
var
  apiPacket : Pointer;
  cnt, data, Status, PacketSize, devID  : UInt16;
  s : string;
  DeveloperCode0 : TBytes;
begin
  memLog.Lines.Clear;

  if edtPacketSize.Text = '' then
  begin
    memLog.Lines.Add('Please enter Packet size first !!!');
    Exit;
  end;

  try
    PacketSize := StrToUInt('$' + edtPacketSize.Text) and $FFFF;
  except
    memLog.Lines.Add('Invalid Packet size !!!');
    Exit;
  end;

  if edtDeveloperCode.Text = '' then
  begin
    memLog.Lines.Add('Please enter Developer Code first !!!');
    Exit;
  end;

  if edtDeveloperID.Text = '' then
  begin
    memLog.Lines.Add('Please enter Developer ID first !!!');
    Exit;
  end;

  if edtDeveloperID.Text = '' then
  begin
    memLog.Lines.Add('Please enter Developer ID first !!!');
    Exit;
  end;

  try
    devID := StrToUInt('$' + edtDeveloperID.Text) and $FFFF;
  except
    memLog.Lines.Add('Invalid Developer ID string !!!');
    Exit;
  end;

  if not InitFunctionsDll then
  begin
    memLog.Lines.Add('"sx32w.dll" not found or corrupted (or mismatch architecture) !!!');
    Exit;
  end;

  GetMem(apiPacket, PacketSize);
  Status := RNBOsproFormatPacket(apiPacket, PacketSize);
  if Status <> 0 then
  begin
    memLog.Lines.Add(StatusErrorCodesStr(Status));
    Exit;
  end;

  Status := RNBOsproInitialize(apiPacket);
  if Status <> 0 then
  begin
    memLog.Lines.Add(StatusErrorCodesStr(Status));
    Exit;
  end;

  Status := RNBOsproSetContactServer(apiPacket, cbCommunicationModes.Text);
  if Status <> 0 then
  begin
    memLog.Lines.Add(StatusErrorCodesStr(Status));
    Exit;
  end;

  DeveloperCode0 := HexStr2ByteArray(edtDeveloperCode.Text);
  Status := RNBOsproSetDeveloperCode(apiPacket, @DeveloperCode0[0], Length(DeveloperCode0));
  if Status <> 0 then
  begin
    memLog.Lines.Add(StatusErrorCodesStr(Status));
    Exit;
  end;

  Status := RNBOsproFindFirstUnit(apiPacket, devID);
  if Status <> 0 then
  begin
    memLog.Lines.Add(StatusErrorCodesStr(Status));
    Exit;
  end;

  ReadDongleMemory(apiPacket);

  memLog.Text := '';
  for cnt := Low(DongleMemory) to High(DongleMemory) do
  begin
    s := s + IntToHex(DongleMemory[cnt]) + ', ';
  end;

  memLog.Text := LeftStr(s, Length(s) - 2);
end;

end.
