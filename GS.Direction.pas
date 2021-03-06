{ -----------------------------------------------------------------------------
    This program is free software: Under statement of join file README - LGPL.txt
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
{-----------------------------------------------------------------------------
 Unit Name : GS.Direction
 Author    : Vincent Gsell (vincent dot gsell at gmail dot com)
 Purpose   : basic "Directional Vector" routines - TDirectionalObject helper class.
 Date:     : 20070102
 History   :
 20070102 - Creating unit.
 20091120 - Clearing code v1.0
 20180426 - Put this unit in GS collection. Freeing from Types dependancy.
-----------------------------------------------------------------------------}
Unit GS.Direction;

interface

Const GLB_Math_PrecisionTolerance = 1.0E-12;
      GLB_PrecisionTolerance: Double = 1.0E-6;
      GLB_Pi = 3.141592654;
      GLB_TwoPi: Double   = 6.283185307179586476925286766559;
      GLB_PiOn2: Double   = 1.5707963267948966192313216916398;
      GLB_GripTolerance = 5.0;
      GLB_DegreeCst : Double = 180 / Pi;
      GLB_RadianCst : Double = Pi / 180;

Type
TPoint = Record
  X,Y,Z : Single;
end;

TLine = Record
case integer of
0: (A, B : TPoint);
1: (X1, Y1, Z1, X2, Y2, Z2 : Single)
end;

TRect = Record
case integer of
0: (Left, Top, Right, Bottom : TPoint);
1: ( X1, Y1, Z1,
     X2, Y2, Z2,
     X3, Y3, Z3,
     X4, Y4, Z4 : Single)
end;

TVectorArray = array [0..2] of Single;
TVector = Record
case Integer of
  0: (V :TVectorArray);
  1: (X,Y,Z : Single);
end;

TVectorObject = class
Public
  Origin : TPoint;
  Direction : TVector;
  Constructor Create(X,Y,Norm : Double);
end;

TDirectionalObject =Class(TVectorObject)
Private
  function GetAngle: Double;
  function GetNorm: Double;
  procedure SetAngle(const Value: Double);
  procedure SetNorm(const Value: Double);
    function GetPositionX: Double;
    procedure SetPositionX(const Value: Double);
    function GetPositionY: Double;
    procedure SetPositionY(const Value: Double);

  Procedure ResetDirection;
    function GetAngleInDegree: Double;
    procedure SetAngleInDegree(const Value: Double); //20090723 - VG - For certain operation, it seems to be a "must have" to set right Direction vector initialisation. (Origin<>Direction before vpointat)
                            //This is valid for Norm-independant operation.
Public
  Procedure TurnLeft; Virtual;
  Procedure TurnRight; Virtual;
  Procedure TurnHalf; Virtual;

  Procedure TurnBy(AmountInDegree : Double); Virtual;

  Procedure MoveAhead; Virtual;
  Procedure MoveAheadBy(Amount : Double); Virtual;

  Procedure LookAt(aPoint : TPoint); Overload; Virtual;
  Procedure PointAt(aPoint : TPoint); Virtual;

  Function GetPointedCoord : TPoint; Virtual;
  Procedure SetPointedCoord(aPoint : TPoint); Virtual;
  Procedure SetOrigin(x,y,z : Double); Virtual;

  Property Norm : Double read GetNorm Write SetNorm;
  Property Angle : Double read GetAngle Write SetAngle;
  Property AngleInDegree : Double read GetAngleInDegree Write SetAngleInDegree;
  Property X : Double read GetPositionX Write SetPositionX;
  Property Y : Double read GetPositionY Write SetPositionY;
end;

function Line(var P1, P2: TPoint): TLine; Overload;
function Line(X, Y, Z, X1, Y1, Z1: Single): TLine; Overload;
function Point(X, Y, Z: Single): TPoint; Overload;
function Point(X,Y : Single) : TPoint; Overload;

Procedure vInit(var vector : TVector);
Function vNorm(var Vector : TVector) : Double; OVerload;
Function vAngle(var Vector : TVector) : Double; Overload; {$IFDEF D2009UP} Inline {$ENDIF}
procedure vReset(var Point: TPoint);Overload;
procedure vReset(var Point: TVector);Overload;


Procedure vNormalyze(var Vector : TVector);

Procedure vNorm(var Vector : TVector; NewNorm : Double); Overload;
Procedure vNormOn2(var Vector : TVector); Overload;
Procedure vNormDec(var Vector : TVector; PercentAmount : Integer);
Procedure vAngle(var Vector : TVector; Const NewAngle : Extended); Overload; //inline;

Procedure vStepPoint(Var aP : TPoint; Vector : TVector); Overload;
Procedure vStepPoint(Var X,Y,Z : Double; Vector : TVector); Overload;
Procedure vStepPointby(Var X,Y,Z : Double; Vector : TVector; Amount : Double);
Procedure vRotate(Var Vector : TVector; Const ByAngle : Double);
Procedure vTurnLeft(Var Vector : TVector); OVerload;
Procedure vTurnRight(Var Vector : TVector); Overload;
Procedure vTurnLeft(Var Vector : TVector; Amount : Double); Overload;
Procedure vTurnRight(Var Vector : TVector; Amount : Double); Overload;
Procedure vHalfTurn(Var Vector : TVector);
Procedure vLookAt(var Vector : TVector; X,Y,Z : Double); Overload;
Procedure vLookAt(var Vector : TVector; P : TPoint); Overload;
Procedure vLookAt(Origin : TPoint; var Vector : TVector; P : TPoint); Overload;
Procedure vPointTo(Origin : TPoint; var Vector : TVector; P : TPoint); Overload;
function vSimulStep(var Vector: TVector): TPoint; Overload;
function vSimulStepBy(var Vector : TVector; Amount: Double): TPoint; Overload;


  //Compute the normal : The given normal will be turn in trigo positive way.
Procedure vNormal(Var Line : TLine; Var ResultVector : TVector); Overload;
Function vNormal(Var Line : TLine) : TVector; Overload;
Procedure vNormal(Var Vector : TVector; Var ResultVector : TVector); Overload;
Function vNormal(Var Vector : TVector) : TVector; Overload;

  //Standart Operation
Procedure vMultiply(Var ResultVector, VectorA,VectorB : TVector);
Procedure vAdd(Var ResultVector, VectorA,VectorB : TVector); Overload;
Procedure vAdd(Var AddedVector, VectorA : TVector); Overload;
Procedure vSub(Var ResultVector, VectorA,VectorB : TVector); Overload;
Function vSub(VectorA,VectorB : TVector) : TVector; Overload;
Procedure vInvert(var Vector : TVector);
Function vEqualNorm(Tolerance : Double; v1,v2 : TVector) : Boolean;

// for TPointVector
//Procedure ovStep(var ov : TPointVector);
//Procedure ovTurnBy(var ov : TPointVector; amount : Double);

Procedure PolarToCartesian(const R, Phi: Double; var X, Y: Single);   {$IFDEF D2009UP} Inline {$ENDIF}
Procedure CartesianToPolar(const X, Y: Double; var R, Phi: Single); {$IFDEF D2009UP} Inline {$ENDIF}
function Sgn(const X: Double): Integer; {$IFDEF D2009UP} Inline {$ENDIF}


// math
function vIntersect(const x1,y1,x2,y2,x3,y3,x4,y4:Double; out ix,iy:Double):Boolean;
procedure vMirror(const Px,Py,x1,y1,x2,y2:Double;out Nx,Ny:Double);

implementation

uses Math;

{ TofEngineVector }

procedure vHalfTurn(var Vector: TVector);
begin
  vRotate(vector,Pi)
end;

procedure vNormal(var Vector, ResultVector: TVector);
begin

end;

procedure vNormal(var Line: TLine;
  var ResultVector: TVector);
begin

end;

function vNormal(var Line: TLine): TVector;
begin

end;

procedure vLookAt(var Vector: TVector; X,
  Y, Z: Double);
var n : Double;
begin
  n:=vNorm(Vector);
  Vector.X:=X;
  Vector.Y:=Y;
  Vector.Z:=Z;
  vNorm(Vector,n);
end;

procedure vLookAt(var Vector: TVector; P: TPoint);
var n : Double;
begin
  n:=vNorm(Vector);
  Vector.X:=P.X;
  Vector.Y:=P.Y;
  Vector.Z:=P.Z;
  vNorm(Vector,n);
end;

function vNormal(var Vector: TVector): TVector;
begin

end;

procedure vRotate(var Vector: TVector;
  Const ByAngle: Double);
var n : Double;
begin
  n:=vAngle(Vector);
  n:=n+ByAngle;
  vAngle(Vector,n);
end;

procedure vTurnLeft(var Vector: TVector);
begin
  vRotate(Vector,-GLB_PiOn2);
end;

procedure vTurnRight(var Vector: TVector);
begin
  vRotate(Vector,GLB_PiOn2);
end;



function vSimulStep(var Vector: TVector): TPoint;
begin
  Result.X:=Vector.X+Vector.X;
  Result.Y:=Vector.Y+Vector.Y;
  Result.Z:=Vector.Z+Vector.Z;
end;

function vSimulStepBy(var Vector : TVector; Amount: Double): TPoint;
begin
  Result.X:=Vector.X+Amount;
  Result.Y:=Vector.Y+Amount;
  Result.Z:=Vector.Z+Amount;
end;


function Sgn(const X: Double): Integer;
begin
  if X > 0.0 then
    Result := 1
  else
  if X < 0.0 then
    Result := -1
  else
    Result := 0;
end;

Procedure CartesianToPolar(const X, Y: Double; var R, Phi: Single);
begin
  R := Sqrt(Sqr(X) + Sqr(Y));

  if Abs(X) > GLB_PrecisionTolerance then
  begin
    Phi := ArcTan(Abs(Y) / Abs(X));
    if (x>=0) then begin
      if (y>=0) then begin
        Phi:=GLB_TwoPi-Phi;
      end
      else begin
      end;
    end
    else
    begin
      if (y>=0) then begin
        Phi:=Pi+Phi;
      end
      else begin
        Phi:=Pi-Phi;
      end;
    end;
  end
  else
  if Abs(Y) > GLB_PrecisionTolerance then
  begin
    Phi := Sgn(Y) * GLB_PiOn2 * -1;
    Phi := GLB_TwoPi - Phi * -1;
  end
  else
  begin
    R := 0;
    Phi := 0;
  end;
end;

Procedure PolarToCartesian(const R, Phi: Double; var X, Y: Single);
var
  Sine, CoSine: Double;
begin
  SinCos(Phi, Sine, CoSine);
  X := R * CoSine;
  Y := R * Sine *-1;
end;


function Line(var P1, P2: TPoint): TLine;
begin
  Result.A:=P1;
  Result.B:=P2;
end;

function Line(X, Y, Z, X1, Y1, Z1: Single): TLine;
begin
  Result.A.X:=X;
  Result.A.Y:=Y;
  Result.A.Z:=Z;
  Result.B.X:=X1;
  Result.B.Y:=Y1;
  Result.B.Z:=Z1;
end;

function Point(X, Y, Z: Single): TPoint;
begin
  Result.X:=X;
  Result.Y:=Y;
  Result.Z:=Z;
end;

function Point(X,Y : Single) : TPoint;
begin
  Result.X:=X;
  Result.Y:=Y;
  Result.Z:=0;
end;



procedure vAngle(var Vector: TVector;
  Const NewAngle: Extended);
var n : Double;
begin
  n:=Sqrt(Vector.X*Vector.X+Vector.Y*Vector.Y);
  PolarToCartesian(n,NewAngle,Vector.X,Vector.Y);
  //Get Vector coords with the new angle.
end;

Procedure vStepPoint(Var aP : TPoint; Vector : TVector);
begin
  aP.X:=aP.X+Vector.X;
  aP.Y:=aP.Y+Vector.Y;
  aP.Z:=aP.Z+Vector.Z;
end;

Procedure vStepPoint(Var X,Y,Z : Double; Vector : TVector);
begin
  X:=X+Vector.X;
  Y:=Y+Vector.Y;
  Z:=Z+Vector.Z;
end;

Procedure vStepPointby(Var X,Y,Z : Double; Vector : TVector; Amount : Double);
var v : TVector;
begin
  v:=Vector;
  vNorm(v,amount);
  X:=X+V.X;
  Y:=Y+V.Y;
  Z:=Z+V.Z;
end;


function vAngle(var Vector: TVector): Double;
var r,n : Single;
begin
  CartesianToPolar(Vector.x,Vector.y,n,r);
  result:=r;
end;

procedure vReset(var Point: TPoint);
begin
  Point.X:=0;
  Point.Y:=0;
  Point.Z:=0;
end;

procedure vReset(var Point: TVector);
begin
  Point.X:=0;
  Point.Y:=0;
  Point.Z:=0;
end;

procedure vNorm(var Vector: TVector;
  NewNorm: Double);
var a : Double;
begin
  //Set new norm.
  a:=vangle(Vector);
  vReset(vector);
  Vector.X:=Abs(NewNorm);
  vAngle(Vector,a);
  if NewNorm<0 then
    vHalfTurn(Vector);
end;

Procedure vInit(var vector : TVector);
begin
  With Vector do
  begin
    x:=0;
    y:=0;
    z:=0;
  end;
end;

function vNorm(var Vector: TVector): Double;
begin
  With Vector do
    Result:=Sqrt(x*x+y*y+z*z);
end;

Procedure vNormalyze(var Vector : TVector);
var d : Double;
begin
  d := vNorm(Vector);
  if d<>0 then
  begin
    Vector.X := Vector.X / d;
    Vector.Y := Vector.Y / d;
    Vector.Z := Vector.Z / d;
  end;

end;

procedure vTurnLeft(var Vector: TVector;
  Amount: Double);
begin
  vRotate(Vector,-Amount);
end;

procedure vTurnRight(var Vector: TVector;
  Amount: Double);
begin
  vRotate(Vector,Amount);
end;

procedure vAdd(var ResultVector, VectorA, VectorB : TVector);
begin
  ResultVector.X:=VectorA.X+Vectorb.X;
  ResultVector.Y:=VectorA.Y+Vectorb.Y;
  ResultVector.Z:=VectorA.Z+Vectorb.Z;
end;

procedure vMultiply(var ResultVector, VectorA,  VectorB : TVector);
begin
  ResultVector.X:=VectorA.X*Vectorb.X;
  ResultVector.Y:=VectorA.Y*Vectorb.Y;
  ResultVector.Z:=VectorA.Z*Vectorb.Z;
end;

procedure vSub(var ResultVector, VectorA, VectorB : TVector);
begin
  ResultVector.X:=VectorA.X-Vectorb.X;
  ResultVector.Y:=VectorA.Y-Vectorb.Y;
  ResultVector.Z:=VectorA.Z-Vectorb.Z;
end;

Function vSub(VectorA,VectorB : TVector) : TVector;
begin
  Result.X:=VectorA.X-Vectorb.X;
  Result.Y:=VectorA.Y-Vectorb.Y;
  Result.Z:=VectorA.Z-Vectorb.Z;
end;

procedure vNormOn2(var Vector: TVector);
begin
  Vector.X:=Vector.X /2;
  Vector.Y:=Vector.Y /2;
end;

Procedure vNormDec(var Vector : TVector; PercentAmount : Integer);
begin
  Vector.X:= Vector.X-(PercentAmount * Vector.X /100);
  Vector.Y:= Vector.Y-(PercentAmount * Vector.Y /100);
end;


procedure vLookAt(Origin: TPoint;
  var Vector: TVector; P: TPoint);
var n : Double;
begin
  n:=vNorm(Vector);
  Vector.X:=P.X-Origin.x;
  Vector.Y:=P.Y-Origin.Y;
  Vector.Z:=P.Z-Origin.Z;
  vNorm(Vector,n);
end;

Procedure vPointTo(Origin : TPoint; var Vector : TVector; P : TPoint); Overload;
var a,b : double;
begin
  vLookAt(Origin,Vector,P);
  a:=P.x-Origin.X;
  b:=P.y-Origin.y;
  a:=a*a;
  b:=b*b;
  vNorm(Vector,Sqrt(a+b));
end;

procedure vInvert(var Vector: TVector);
begin
  Vector.X:=Vector.X*-1;
  Vector.Y:=Vector.Y*-1;
  Vector.Z:=Vector.Z*-1;
end;

procedure vAdd(var AddedVector, VectorA: TVector);
begin
  AddedVector.X:=AddedVector.X+VectorA.X;
  AddedVector.Y:=AddedVector.Y+VectorA.Y;
  AddedVector.Z:=AddedVector.Z+VectorA.Z;
end;

function vEqualNorm(Tolerance: Double; v1,
  v2: TVector): Boolean;
var a,b : Double;
begin
  a:=Abs(vNorm(v1));
  b:=Abs(vNorm(v2));

  Result:=(a>(b-tolerance)) and (a<=(b+tolerance));
end;

{ TDirectionalObject }

procedure TDirectionalObject.LookAt(aPoint: TPoint);
begin
  //ResetDirection;
  vLookAt(Origin,Direction,aPoint);
end;

procedure TDirectionalObject.MoveAhead;
//var a : TPoint;
begin
  //a:=vSimulStep(Direction);
  //origin.X:=Origin.X+a.X;
  //origin.Y:=Origin.Y+a.Y;
  //origin.Z:=Origin.Z+a.Z;
  origin.X:=Origin.X+Direction.X;
  origin.Y:=Origin.Y+Direction.Y;
  origin.Z:=Origin.Z+Direction.Z;
end;

procedure TDirectionalObject.MoveAheadBy(Amount: Double);
begin
  //Origin:=vSimulStep(Direction);
  origin.X:=Origin.X+Direction.X*Amount;
  origin.Y:=Origin.Y+Direction.Y*Amount;
  origin.Z:=Origin.Z+Direction.Z*Amount;
end;

procedure TDirectionalObject.TurnBy(AmountInDegree: Double);
begin
  vRotate(Direction,AmountInDegree*Pi/180);
end;

procedure TDirectionalObject.TurnHalf;
begin
  vHalfTurn(Direction);
end;

procedure TDirectionalObject.TurnLeft;
begin
  vTurnLeft(Direction);
end;

procedure TDirectionalObject.TurnRight;
begin
   vTurnRight(Direction);
end;

function TDirectionalObject.GetAngle: Double;
begin
  Result:=vAngle(Direction);
end;

function TDirectionalObject.GetAngleInDegree: Double;
begin
  result := GetAngle * GLB_DegreeCst;
end;

function TDirectionalObject.GetNorm: Double;
begin
  result:=vNorm(Direction);
end;

function TDirectionalObject.GetPointedCoord: TPoint;
begin
  Result:=Point(Origin.X+Direction.X,Origin.Y+Direction.Y,Origin.Z+Direction.Z);
end;

procedure TDirectionalObject.SetAngle(const Value: Double);
begin
  vAngle(Direction,Value);
end;

procedure TDirectionalObject.SetAngleInDegree(const Value: Double);
begin
  Angle := Value / GLB_DegreeCst;
end;

procedure TDirectionalObject.SetNorm(const Value: Double);
begin
  vNorm(Direction,Value);
end;


procedure TDirectionalObject.SetPointedCoord(aPoint: TPoint);
var a,b : double;
begin
  LookAt(aPoint);
  a:=aPoint.x-Origin.X;
  b:=aPoint.y-Origin.y;
  a:=a*a;
  b:=b*b;
  vNorm(direction,Sqrt(a+b));
end;

procedure TDirectionalObject.SetOrigin(x, y, z : Double);
begin
  Origin.X:=x;
  Origin.Y:=Y;
  Origin.Z:=Z;
end;

procedure TDirectionalObject.PointAt(aPoint: TPoint);
begin
  ResetDirection;
  vPointTo(Origin,Direction,aPoint);
end;

function TDirectionalObject.GetPositionX: Double;
begin
  Result := Origin.X;
end;

procedure TDirectionalObject.SetPositionX(const Value: Double);
begin
  Origin.X := Value;
end;

function TDirectionalObject.GetPositionY: Double;
begin
  Result := Origin.Y;
end;

procedure TDirectionalObject.SetPositionY(const Value: Double);
begin
  Origin.Y:=Value;
end;

procedure TDirectionalObject.ResetDirection;
begin
  Direction.X :=Origin.X;
  Direction.y :=Origin.y;
end;

function InternalNotEqual(const Val1,Val2,aPrecisionTolerance:double):Boolean;
var
  lDiff : single;
begin
  lDiff := Val1 - Val2;
  Result := ((-aPrecisionTolerance > lDiff) or (lDiff > aPrecisionTolerance));
end;

function vNotEqual(const Val1,Val2:double):Boolean;
begin
  Result := InternalNotEqual(Val1,Val2,GLB_Math_PrecisionTolerance);
end;

function InternalIsEqual(const Val1,Val2,aPrecisionTolerance:double):Boolean;
var
  lDiff : Single;
begin
  lDiff := Val1 - Val2;
  Result := ((-aPrecisionTolerance <= lDiff) and (lDiff <= aPrecisionTolerance));
end;

function vIsEqual(const Val1,Val2:double):Boolean;
begin
  Result := InternalIsEqual(Val1,Val2,GLB_Math_PrecisionTolerance);
end;



function vIntersect(const x1,y1,x2,y2,x3,y3,x4,y4:double; out ix,iy:double):Boolean;
var
  UpperX    : Single;
  UpperY    : Single;
  LowerX    : Single;
  LowerY    : Single;
  Ax        : Single;
  Bx        : Single;
  Cx        : Single;
  Ay        : Single;
  By        : Single;
  Cy        : Single;
  D         : Single;
  F         : Single;
  E         : Single;
  Ratio     : Single;
begin
  Result := false;

  Ax := x2 - x1;
  Bx := x3 - x4;

  if Ax < 0.0 then
  begin
    LowerX := x2;
    UpperX := x1;
  end
  else
  begin
    UpperX := x2;
    LowerX := x1;
  end;

  if Bx > 0.0 then
  begin
    if (UpperX < x4) or (x3 < LowerX) then
      Exit;
  end
  else if (Upperx < x3) or (x4 < LowerX) then
    Exit;

  Ay := y2 - y1;
  By := y3 - y4;

  if Ay < 0.0 then
  begin
    LowerY := y2;
    UpperY := y1;
  end
  else
  begin
    UpperY := y2;
    LowerY := y1;
  end;

  if By > 0.0 then
  begin
  if (UpperY < y4) or (y3 < LowerY) then
    Exit;
  end
  else if (UpperY < y3) or (y4 < LowerY) then
    Exit;

  Cx := x1 - x3;
  Cy := y1 - y3;
  d  := (By * Cx) - (Bx * Cy);
  f  := (Ay * Bx) - (Ax * By);

  if f > 0.0 then
  begin
    if (d < 0.0) or (d > f) then
      Exit;
  end
  else if (d > 0.0) or  (d < f) then
    Exit;

  e := (Ax * Cy) - (Ay * Cx);

  if f > 0.0 then
  begin
    if (e < 0.0) or (e > f) then
      Exit;
  end
  else if (e > 0.0) or (e < f) then
    Exit;

  Result := true;

  (*

    From IntersectionPoint Routine

    dx1 := x2 - x1; ->  Ax
    dx2 := x4 - x3; -> -Bx
    dx3 := x1 - x3; ->  Cx

    dy1 := y2 - y1; ->  Ay
    dy2 := y1 - y3; ->  Cy
    dy3 := y4 - y3; -> -By

  *)

  Ratio := (Ax * -By) - (Ay * -Bx);

  if vNotEqual(Ratio,0.0) then
  begin
    Ratio := ((Cy * -Bx) - (Cx * -By)) / Ratio;
    ix    := x1 + (Ratio * Ax);
    iy    := y1 + (Ratio * Ay);
  end
  else
  begin
    //if Collinear(x1,y1,x2,y2,x3,y3) then
    if vIsEqual((Ax * -Cy),(-Cx * Ay)) then
    begin
      ix := x3;
      iy := y3;
    end
    else
    begin
      ix := x4;
      iy := y4;
    end;
  end;
end;
(* End of SegmentIntersect *)

procedure vMirror(const Px,Py,x1,y1,x2,y2:Double;out Nx,Ny:Double);
var
  Vx    : Double;
  Vy    : Double;
  Wx    : Double;
  Wy    : Double;
  c1    : Double;
  c2    : Double;
  Ratio : Double;
begin
  Vx := x2 - x1;
  Vy := y2 - y1;
  Wx := Px - x1;
  Wy := Py - y1;

  c1 := Vx * Wx + Vy * Wy;
  c2 := Vx * Vx + Vy * Vy;

  Ratio := c1 / c2;

  Nx := x1 + Ratio * Vx;
  Ny := y1 + Ratio * Vy;

  Nx := Px + 2 * (Nx - Px);
  Ny := Py + 2 * (Ny - Py);
end;

{ TVectorObject }

constructor TVectorObject.Create(X, Y, Norm: Double);
begin
  Origin.X:=X;
  Origin.Y:=Y;
  Origin.Z:=0;
  Direction.X:=Norm;
  Direction.Y:=0;
  Direction.Z:=0;
end;

end.

