unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  ExtCtrls,
  uIniManager,
  Clipbrd,
  System.Math,
  System.UITypes,
  System.RegularExpressions;

type
  TFormMain = class(TForm)
    HotKeyPaste: THotKey;
    LabelHotKeyPaste: TLabel;
    ButtonSave: TButton;
    EditMatch: TEdit;
    EditReplace: TEdit;
    LabelMatch: TLabel;
    LabelReplace: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ButtonApplyAndSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure WMHotKey(var CurWMHotKey: TWMHotKey); message WM_HOTKEY;
    procedure TransformAndPaste;
    procedure RegisterGlobalHotkeys;
    procedure UnregisterGlobalHotkeys;

    var
      HotKeyPasteAtomCode: Word;

    const
      CSettingsIniShortFileName     = 'Settings.ini';
      CHotKeyPasteAtomName          = 'HK_Paste';
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses MapReduce, uGlobalHotKeys;

procedure TFormMain.RegisterGlobalHotkeys;
begin
  HotKeyPasteAtomCode := RegisterGlobalHotKey(IniSettings.HotKeysPaste, CHotKeyPasteAtomName, FormMain.Handle);
end;

procedure TFormMain.UnregisterGlobalHotkeys;
begin
  RemoveGlobalHotKey(HotKeyPasteAtomCode, FormMain.Handle);
end;

procedure TFormMain.ButtonApplyAndSaveClick(Sender: TObject);
begin
  UnregisterGlobalHotkeys;

  IniSettings.HotKeysPaste := HotKeyPaste.HotKey;
  IniSettings.SaveToFile(ExtractFilePath(Application.ExeName) + CSettingsIniShortFileName);

  RegisterGlobalHotkeys;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnregisterGlobalHotkeys;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  IniSettings.LoadFromFile(ExtractFilePath(Application.ExeName) + CSettingsIniShortFileName);
  HotKeyPaste.HotKey := IniSettings.HotKeysPaste;

  RegisterGlobalHotkeys;
end;

procedure TFormMain.WMHotKey(var CurWMHotKey: TWMHotKey);
begin
  if CurWMHotKey.HotKey = HotKeyPasteAtomCode then
    TransformAndPaste();
end;


procedure TFormMain.TransformAndPaste();
var
  foregroundWindow: HWND;
  clipboardStrings, modClipboardStrings: TArray<System.string>;
  modClipboardString: string;
  KeyInputs: array of TInput;

  procedure KeybdInput(VKey: Byte; Flags: DWORD);
  begin
    SetLength(KeyInputs, Length(KeyInputs) + 1);
    KeyInputs[high(KeyInputs)].Itype := INPUT_KEYBOARD;
    with  KeyInputs[high(KeyInputs)].ki do
    begin
      wVk := VKey;
      wScan := MapVirtualKey(wVk, 0);
      dwFlags := Flags;
    end;
  end;

  function GetClipboardText: string;
  var i: Integer;
  begin
      i := 0;
      while i <= 100 do
      begin
        try
          Inc(i);
          result := Clipboard.AsText;
          break;
        except
          on E: Exception do
          begin
            sleep(10);
          end;
        end;
      end;
  end;

  procedure SetClipboardText(newText: string);
  var i: Integer;
  begin
      i := 0;
      while i <= 100 do
      begin
        try
          Inc(i);
          Clipboard.AsText := newText;
          break;
        except
          on E: Exception do
          begin
            sleep(10);
          end;
        end;
      end;
  end;

begin
  foregroundWindow := GetForegroundWindow();
  if foregroundWindow > 0 then
  begin
    // split
    clipboardStrings := GetClipboardText().Split([sLineBreak]);

    // modify
    modClipboardStrings := TMapReduce<string>.Map(clipboardStrings,
      function(const X: string): string
      begin
        Result := TRegEx.Replace(X, EditMatch.Text, EditReplace.Text);
      end);

    // concat
    modClipboardString := TMapReduce<string>.Reduce(modClipboardStrings,
      function (const Accumulator, X: string): string
      begin
        Result := Accumulator + sLineBreak + X;
      end);

    // copy-paste
    SetClipboardText(modClipboardString);
    KeybdInput(VK_CONTROL, 0);
    KeybdInput(vkV, 0);
    KeybdInput(vkV, KEYEVENTF_KEYUP);
    KeybdInput(VK_CONTROL, KEYEVENTF_KEYUP);
    SendInput(Length(KeyInputs), KeyInputs[0], SizeOf(KeyInputs[0]));
  end
  else
    ShowMessage('Window not found');
end;

end.
