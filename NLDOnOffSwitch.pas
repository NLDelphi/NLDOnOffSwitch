unit NLDOnOffSwitch;

interface

uses
  Classes, Controls, Windows, Messages, Graphics, Themes;

type
  TNLDOnOffSwitch = class(TCustomControl)
  private
    FMouseHover: Boolean;
    FOff: Boolean;
    FSliderRect: TRect;
    procedure SetMouseHover(Value: Boolean);
    procedure SetOff(Value: Boolean);
    procedure UpdateSliderRect;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged);
      message WM_WINDOWPOSCHANGED;
    procedure CMEnabledChanged(var Message: TMessage);
      message CM_ENABLEDCHANGED;
    procedure CMFocusChanged(var Message: TCMFocusChanged);
      message CM_FOCUSCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Anchors;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Off: Boolean read FOff write SetOff default True;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property ParentFont default False;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
  end;

implementation

{ TNLDOnOffSwitch }

resourcestring
  SOff = 'No';
  SOn = 'Yes';

procedure TNLDOnOffSwitch.CMEnabledChanged(var Message: TMessage);
begin
  Invalidate;
  inherited;
end;

procedure TNLDOnOffSwitch.CMFocusChanged(var Message: TCMFocusChanged);
begin
  Invalidate;
  inherited;
end;

procedure TNLDOnOffSwitch.CMMouseLeave(var Message: TMessage);
begin
  SetMouseHover(False);
  inherited;
end;

constructor TNLDOnOffSwitch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  FOff := True;
  Caption := SOff;
  Width := 75;
  Height := 25;
  TabStop := True;
  Font.Name := 'Tahoma';
  Font.Style := [fsBold];
end;

procedure TNLDOnOffSwitch.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_SPACE then
    SetOff(not FOff);
  inherited KeyUp(Key, Shift);
end;

procedure TNLDOnOffSwitch.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if (Shift = [ssLeft]) and PtInRect(FSliderRect, Point(X, Y)) then
    SetOff(not FOff);
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TNLDOnOffSwitch.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if GetCaptureControl = nil then
    SetMouseHover(PtInRect(FSliderRect, Point(X, Y)));
  inherited MouseMove(Shift, X, Y);
end;

procedure TNLDOnOffSwitch.Paint;
var
  Button: TThemedButton;
  PaintRect: TRect;
  Details: TThemedElementDetails;
begin
  if ThemeServices.ThemesAvailable then
  begin
    if not Enabled then
      Button := tbPushButtonDisabled
    else if not FOff then
      Button := tbPushButtonPressed
    else
      Button := tbPushButtonNormal;
    PaintRect := ClientRect;
    Details := ThemeServices.GetElementDetails(Button);
    ThemeServices.DrawElement(Canvas.Handle, Details, PaintRect);
    if FOff then
      Inc(PaintRect.Left, Round(2 / 5 * Width))
    else
      Dec(PaintRect.Right, Round(2 / 5 * Width));
    Canvas.Brush.Style := bsClear;
    Canvas.Font := Self.Font;
    if not Enabled then
      Canvas.Font.Color := $00A0A0A0
    else
      Canvas.Font.Color := $00555555;
    DrawText(Canvas.Handle, PChar(Caption), -1, PaintRect, DT_CENTER or
      DT_VCENTER or DT_SINGLELINE);
    if Enabled and not FOff then
    begin
      OffsetRect(PaintRect, 0, 1);
      Canvas.Font.Color := clWhite;
      DrawText(Canvas.Handle, PChar(Caption), -1, PaintRect, DT_CENTER or
        DT_VCENTER or DT_SINGLELINE);
    end;
    if not Enabled then
      Button := tbPushButtonDisabled
    else if Focused then
      Button := tbPushButtonDefaulted
    else if FMouseHover then
      Button := tbPushButtonHot
    else
      Button := tbPushButtonNormal;
    PaintRect := FSliderRect;
    Details := ThemeServices.GetElementDetails(Button);
    ThemeServices.DrawElement(Canvas.Handle, Details, PaintRect);
    if Focused then
    begin
      PaintRect := ThemeServices.ContentRect(Canvas.Handle, Details, PaintRect);
      SetTextColor(Canvas.Handle, clWhite);
      DrawFocusRect(Canvas.Handle, PaintRect);
    end;
  end;
end;

procedure TNLDOnOffSwitch.SetMouseHover(Value: Boolean);
begin
  if FMouseHover <> Value then
  begin
    FMouseHover := Value;
    Invalidate;
  end;
end;

procedure TNLDOnOffSwitch.SetOff(Value: Boolean);
begin
  if FOff <> Value then
  begin
    FOff := Value;
    if FOff then
      Caption := SOff
    else
      Caption := SOn;
    UpdateSliderRect;
    Invalidate;
  end;
end;

procedure TNLDOnOffSwitch.UpdateSliderRect;
begin
  if FOff then
    SetRect(FSliderRect, 0, 0, Round(2 / 5 * Width), Height)
  else
    SetRect(FSliderRect, Round(3 / 5 * Width), 0, Width, Height);
end;

procedure TNLDOnOffSwitch.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  inherited;
  UpdateSliderRect;
  Font.Size := Round(Height div 3) + 1;
end;

end.
