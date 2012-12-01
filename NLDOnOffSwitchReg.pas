unit NLDOnOffSwitchReg;

interface

uses
  Classes, NLDOnOffSwitch;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('NLDelphi', [TNLDOnOffSwitch]);
end;

end.
