unit QSRQuadraticBezierCurve; //quasi standard rational quadratic Bezier curve 
{
 A QSRQBC is defined with three points (or two points and a vector) and a number:
 p1 = starting point
 c = control point or vector control
 p2 = ending point
 weight = a real number
 When weight <> 0 the curve is defined with the function (t in [0;1]):
   f: t -> ((1-t)^2*p1 + 2*t*(1-t)*weight*c + t^2*p2) / (1-t)^2 + 2*t*(1-t)*weight + t^2)
 if this case, the curve is an arc of :
    - parabola when weight = 1 (classical quadratic Bezier curve)
    - ellipse when  weight in ]-1;1[
    - hyperbola when weight > 1
 but when weight <= -1 the curve is not connex : infinite branch of parabola (weight = -1) or
 of hyperbola (weight < -1).

 When weight = 0 the curve is defined with the function (t in [0;1]):
   f:t -> ((1-t)^2*p1 + 2*t*(1-t)*c + t^2*p2) / (1-t)^2 + 2*t*(1-t)*weight + t^2)
 if this case the curve is an half-ellipse et c is interpreted as a vector,
 this vector is tangent to the curve at points p1 and p2, and we have the property :
      (p1+p2)/2 + c = f(1/2)

To transform a QSRQBC with an affin transformation, you only have to transform
the three points when weight <> 0 (properties of the barycentric calculation).
But when weight = 0, c is interpreted as a vector and then c must be transformed
with the linear part of the transformation only (not the translation).
}
INTERFACE 
USES BGRABitmapTypes;
TYPE
     TQSRQuadraticBezierCurve = object
     //** Starting, control and ending points
     p1, c, p2 : TPointF;
     //** Weight of control point
     weight : single;
     private
     function SimpleComputePoints(AAcceptedDeviation: single = 0.1; AIncludeFirstPoint: boolean = true): ArrayOfTPointF;
     public
     function ComputePointAt(t: single): TPointF;
     function ComputeLength(AAcceptedDeviation: single): single;
     function ToPoints(AAcceptedDeviation: single = 0.1; AIncludeFirstPoint: boolean = true): ArrayOfTPointF;
     function GetBounds: TRectF;
     procedure Split(out ALeft, ARight: TQSRQuadraticBezierCurve);
     end;

     function BezierCurve(origin, control, destination: TPointF; Aweight:single) : TQSRQuadraticBezierCurve; overload;

IMPLEMENTATION
uses math;

function BezierCurve(origin, control, destination: TPointF; Aweight:single) : TQSRQuadraticBezierCurve;
 begin
      result.p1 := origin;
      result.c := control;
      result.p2 := destination;
      result.weight := Aweight;
      //if weight=0 : c is a control vector, the tangents at p1 and p2 are directed by c
      //in this case the curve is an half-ellipse, and if there is a transform, c must not be translated.
 end;

function ComputeRQSBezierCurvePrecision(p1, c, p2: TPointF; weight: single; AAcceptedDeviation : single = 0.1): integer;
var len: real;
begin
      if weight >= 0 then //small arc in triangle p1,c,p2
     begin
          len := sqr(p1.x - c.x) + sqr(p1.y - c.y);
          len := max(len, sqr(c.x - p2.x) + sqr(c.y - p2.y));
          result := round(sqrt(sqrt(len)/ AAcceptedDeviation));
     end
  else //long arc
       begin
          len := sqr(p1.x - c.x) + sqr(p1.y - c.y);
          len := max(len, sqr(c.x - p2.x) + sqr(c.y - p2.y));
          result := 5*round(sqrt(sqrt(len)/ AAcceptedDeviation));
       end;
  if result <= 1 then result := 2;
end;

function TQSRQuadraticBezierCurve.SimpleComputePoints(AAcceptedDeviation: single;
  AIncludeFirstPoint: boolean = true): ArrayOfTPointF;
const precision = 1e-12;
var
  t,step,den: real;
  i,nb: Integer;
  pA,pB,pC,c2 : TpointF;
  a1,b1,c1:real;
begin
  nb:=ComputeRQSBezierCurvePrecision(p1,c,p2,weight,AAcceptedDeviation);
  if weight <> 0 then
     begin
          c1 := 2*weight; c2 := c1*c;
     end
  else // demi-ellipse, c dirige la tangente en p1 et p2
       begin
           c1 := 0; c2 := 2*c;
       end;
  pA := p2+p1-c2; pB := -2*p1+c2;
  a1 :=2-c1; b1 := -a1;
  if AIncludeFirstPoint then
  begin
    setlength(result,nb);
    result[0] := p1;
    result[nb-1] := p2;
    step := 1/(nb-1);
    t := 0;
    for i := 1 to nb-2 do
    begin
      t += step;
      den := (1+t*(b1+t*a1));
      if abs(den)>=precision then
         result[i] := (p1+t*(pB+t*pA))*(1/den)
      else
         result[i] := EmptyPointF
    end;
  end else
  begin
    setlength(result,nb-1);
    result[nb-2] := p2;
    step := 1/(nb-1);
    t := 0;
    for i := 0 to nb-3 do
    begin
      t += step;
      den := (1+t*(b1+t*a1));
      if abs(den)>=precision then
         result[i] := (p1+t*(pB+t*pA))*(1/den)
      else
         result[i] := EmptyPointF
    end;
  end;
end;

function TQSRQuadraticBezierCurve.ComputePointAt(t: single): TPointF;
const precision = 1e-12;
var
  rev_t,f2,t2,den: real;
begin
  rev_t := (1-t);
  t2 := t*t;
  if weight=0 then f2:=rev_t*t*2 else f2 := weight*rev_t*t*2;
  rev_t *= rev_t;
  if weight=0 then den:=rev_t+t2 else den := rev_t+f2+t2;
  if abs(den)>=precision then
     begin
          result.x := (rev_t*p1.x + f2*c.x + t2*p2.x)/den;
          result.y := (rev_t*p1.y + f2*c.y + t2*p2.y)/den;
     end
     else
     result := EmptyPointF
end;

function TQSRQuadraticBezierCurve.ToPoints(AAcceptedDeviation: single;
  AIncludeFirstPoint: boolean = true): ArrayOfTPointF;
begin
  if weight=1 then
     result := BezierCurve(p1,c,p2).ToPoints(AAcceptedDeviation, AIncludeFirstPoint)
  else
     result := SimpleComputePoints(AAcceptedDeviation, AIncludeFirstPoint)
end;

function TQSRQuadraticBezierCurve.GetBounds: TRectF;
const precision = 1e-12;
var a,delta,sqrtDelta,t1,t2,den:real;
    A_,B_,p2_,c_:TPointF;

    procedure Include(pt: TPointF);
    begin
      if pt.x < result.Left then result.Left := pt.x
      else if pt.x > result.Right then result.Right := pt.x;
      if pt.y < result.Top then result.Top := pt.y
      else if pt.y > result.Bottom then result.Bottom := pt.y;
    end;

begin
  if weight=1 then
     begin
       result := BezierCurve(p1,c,p2).GetBounds;
       exit
     end;
  if weight <= -1 then
     begin
       // no bounds in this case
       exit;
     end;
  result.TopLeft := p1;
  result.BottomRight := p1;
  Include(p2);
  p2_ := p2-p1; c_ := c-p1; //translation with -p1
  if weight<>0 then
     begin
      B_ := 2*weight*c_; A_ := p2_-B_;
     end
  else
      begin
       B_ := 2*c; A_ := p2_-B_; //when weight=0 c is a control vector and must not be translated
      end;
  a := 2*(1-weight);
  //on Ox
  den := a*p2_.x;
  if abs(den) >= precision then
     begin
          delta := sqr(A_.x)+den*B_.x;
          if delta >= 0 then
             begin
               sqrtDelta := sqrt(delta);
               t1 := (A_.x-sqrtDelta)/den; t2 := (A_.x+sqrtDelta)/den;
               if (t1 <= 1) and (t1 >= 0) then Include(p1+t1*(B_+t1*A_)*(1/(1+t1*(-a+t1*a))));
               if (t2 <= 1) and (t2 >= 0) then Include(p1+t2*(B_+t2*A_)*(1/(1+t2*(-a+t2*a))));
             end;
     end
  else //den=0
      if abs(A_.x) >= precision  then
      begin
           t1 := -B_.x/A_.x/2;
           Include(p1+t1*(B_+t1*A_)*(1/(1+t1*(-a+t1*a))));
      end;
  //on Oy
  den := a*p2_.y;
  if abs(den) >= precision then
     begin
          delta := sqr(A_.y)+den*B_.y;
          if delta >= 0 then
             begin
               sqrtDelta := sqrt(delta);
               t1 := (A_.y-sqrtDelta)/den; t2 := (A_.y+sqrtDelta)/den;
               if (t1 <= 1) and (t1 >= 0) then Include(p1+t1*(B_+t1*A_)*(1/(1+t1*(-a+t1*a))));
               if (t2 <= 1) and (t2 >= 0) then Include(p1+t2*(B_+t2*A_)*(1/(1+t2*(-a+t2*a))));
             end;
     end
  else //den=0
      if abs(A_.y) >= precision  then
      begin
           t1 := -B_.y/A_.y/2;
           Include(p1+t1*(B_+t1*A_)*(1/(1+t1*(-a+t1*a))));
      end;
end;

function TQSRQuadraticBezierCurve.ComputeLength(AAcceptedDeviation: single): single;
var  i: Integer;
     curCoord,nextCoord: TPointF;
     Liste: ArrayOfTPointF;
begin
   if weight = 1 then
      begin
        result := BezierCurve(p1,c,p2).ComputeLength;
        exit
      end;
   if weight <= -1 then
      begin
        // no bounds in this case
        exit;
      end;
  Liste := SimpleComputePoints(AAcceptedDeviation, true);
  curCoord := p1; result:=0;
  for i := 1 to high(Liste) do
  begin
    nextCoord := Liste[i];
    if (nextCoord <> EmptyPointF) and (curCoord <> EmptyPointF) then
       result += VectLen(nextCoord-curCoord);
    curCoord := nextCoord;
  end;
  finalize(Liste)
end;

procedure TQSRQuadraticBezierCurve.Split(out ALeft, ARight: TQSRQuadraticBezierCurve);
const precision=1E-6;
var M, D, E, H, c1, c2: TPointF;
    alpha, sg, w: real;
    function Intersec(): TPointF; //dichotomie
    var t, t1, t2: real;
        U, V: TPointF;
    begin
         t1 := 0; t2 := 0.5; U := E-c1;
         if VectDet(U,p1-c1)>0 then sg := 1 else sg := -1;
         while (t2-t1) > precision do //19 iterations
               begin
                 t := (t1+t2)/2;
                 V := ComputePointAt(t)-c1;
                 if VectDet(U,V)*sg>0 then t1 := t else t2 := t;
               end;
         result := ComputePointAt((t1+t2)/2)
    end;

begin
  if weight <= -1 then
     begin
       //in this case splitting has not really a sense
       exit
     end;
  M := ComputePointAt(0.5);
  ALeft.p1 := p1;
  ALeft.p2 := M;
  ARight.p1 := M;
  ARight.p2 := p2;
  ALeft.weight := 1;
  ARight.weight := 1;
  D := 0.5*(p1+p2);
  if (weight = 1) or (D = c) then
     begin
          ALeft.c := 0.5*(p1+c);
          ARight.c := 0.5*(p2+c);
          exit;
     end;
  if weight = 0 then
     begin
          c1 := p1 + c;
          c2 := p2 + c;
     end
  else
      begin
           if weight > 0 then
              alpha := VectLen(D-M)/VectLen(D-c)
           else
               alpha := -VectLen(D-M)/VectLen(D-c);
           c1 := p1 + alpha*(c-p1);
           c2 := p2 + alpha*(c-p2);
      end;
  ALeft.c := c1;
  ARight.c := c2;
  E := 0.5*(p1+M);
  H := Intersec(); //between [c1;E] and the curve
  w := VectLen(E-c1)/VectLen(H-c1)-1; // new weight
  ALeft.weight := w;
  ARight.weight := w;
end;

end.
