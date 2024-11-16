Unit unitgl;

{$mode objfpc}{$H+}

interface
uses
  gl, glu, glut;

const
     LIST_OBJECT=1;
     theta:single=0;
     phi:single=60;
     stop:boolean=false;

  AppWidth = 640;
  AppHeight = 480;
  {VertexBuffer: array [0..5] of TVertex3f = (
    (X : 1; Y : 1; Z : 1),
    (X : -1; Y : 1; Z : 0),
    (X : -1; Y : -1; Z : 0),
    (X : 1; Y : 1; Z : 0),
    (X : -1; Y : -1; Z : 0),
    (X : 1; Y : -1; Z : 0)
  );
  ColorBuffer: array [0..5] of TColor3f = (
    (R : 1; G : 0; B : 1),
    (R : 0; G : 0; B : 1),
    (R : 0; G : 1; B : 0),
    (R : 1; G : 0; B : 1),
    (R : 0; G : 1; B : 0),
    (R : 1; G : 1; B : 0)
  );

var
  Mesh: TMesh;}

var  ScreenWidth, ScreenHeight: Integer;

Implementation

procedure InitializeGL;
const
  DiffuseLight: array[0..3] of GLfloat = (0.8, 0.8, 0.8, 0.6);
begin
  glClearColor(0.18, 0.20, 0.66, 0.5);
  glShadeModel(GL_SMOOTH);
  glEnable(GL_DEPTH_TEST);

  glEnable(GL_LIGHTING);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, DiffuseLight);
  glEnable(GL_LIGHT0);

  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);

  //Mesh := TMesh.Create;
  //Mesh.LoadMesh('Mesh.dat');
end;


function modpi(x:single):single;
begin
     if x>2*pi then result:=x-2*pi
     else if x<0 then result:=x+2*pi;
end;

procedure DrawGLScene; cdecl;
begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

 // glLoadIdentity;
 // glTranslatef(-1.5, 0, -6);

  {glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_COLOR_ARRAY);
  glVertexPointer(3, GL_FLOAT, 0, @VertexBuffer[0]);
  glColorPointer(3, GL_FLOAT, 0, @ColorBuffer[0]);

  glDrawArrays(GL_TRIANGLES, 0, Length(VertexBuffer));

  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_COLOR_ARRAY);}

  //glLoadIdentity;
  //glTranslatef(0, 0, -7);

 //gluLookAt(5, 5, 5, 0, 0, 0, 0, 0, 1);
 glLoadIdentity;
 glrotatef(-60,1,0,0);
 glrotatef(theta,0,0,1);

 glBegin(GL_Lines);
     glColor3f(1, 0, 0);
     glVertex3f(-5, 0, 0);
     glVertex3f(5, 0, 0);

     glColor3f(0, 1, 0);
     glVertex3f(0, -5, 0);
     glVertex3f(0, 5, 0);

     glColor3f(0, 0, 1);
     glVertex3f(0, 0, -5);
     glVertex3f(0, 0, 5);
   glEnd;

   {glColor3f(0.74,1, 0.73);
   glBegin(GL_TRIANGLES);
     glNormal3f(0,-1,0);
     glVertex3f(0, 0, 4);
     glVertex3f(0, 0, 0);
     glVertex3f(4, 0, 0);

     glNormal3f(1/sqrt(3),1/sqrt(3),1/sqrt(3));
     glVertex3f(0, 0, 4);
     glVertex3f(4, 0, 0);
     glVertex3f(0, 4, 0);

     glNormal3f(-1,0,0);
     glVertex3f(0, 0, 4);
     glVertex3f(0, 4, 0);
     glVertex3f(0, 0, 0);

     glNormal3f(0,0,-1);
     glVertex3f(0, 0, 0);
     glVertex3f(4, 0, 0);
     glVertex3f(0, 4, 0);

   glEnd;}

  //Mesh.DrawMesh;
  glColor3f(0.74, 0.73,1);
  //glutSolidCube(2);

  glutSwapBuffers;
end;

procedure ReSizeGLScene(Width, Height: Integer); cdecl;
begin
  if Height = 0 then
    Height := 1;

  glViewport(0, 0, Width, Height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  //gluPerspective(45, Width / Height, 0.1, 1000);
  glortho(-5,5,-5,5,-5,5);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  //glulookat(15,15,15,0,0,0,0,0,1)

end;

procedure GLFPSTimer(Value: Integer); cdecl;
begin
  theta:=modpi(theta+5);
  DrawGLScene;
  if not stop then
     glutTimerFunc(25, @GLFPSTimer, 0);
end;

procedure GLKeyboard(Key: Byte; X, Y: Longint); cdecl;
begin
  case Key of
  27: begin
           Halt(0);
      end;
  13: begin
          stop:=not stop;
          if not stop then
             glutTimerFunc(25, @GLFPSTimer, 0);
      end;
  end;

end;


procedure glutInitPascal(ParseCmdLine: Boolean);
var
  Cmd: array of PChar;
  CmdCount, I: Integer;
begin
  if ParseCmdLine then
    CmdCount := ParamCount + 1
  else
    CmdCount := 1;
  SetLength(Cmd, CmdCount);
  for I := 0 to CmdCount - 1 do
    Cmd[I] := PChar(ParamStr(I));
  glutInit(@CmdCount, @Cmd);
end;

Initialization


  glutInitPascal(false);
  glutInitDisplayMode(GLUT_DOUBLE or GLUT_RGB or GLUT_DEPTH);
  glutInitWindowSize(AppWidth, AppHeight);
  ScreenWidth := glutGet(GLUT_SCREEN_WIDTH);
  ScreenHeight := glutGet(GLUT_SCREEN_HEIGHT);
  glutInitWindowPosition((ScreenWidth - AppWidth) div 2, (ScreenHeight - AppHeight) div 2);
  glutCreateWindow('OpenGL Tutorial :: Vertex Array');

  InitializeGL;

  glutDisplayFunc(@DrawGLScene);
  glutReshapeFunc(@ReSizeGLScene);
  glutKeyboardFunc(@GLKeyboard);
  glutTimerFunc(25, @GLFPSTimer, 0);
  glutMainLoop;
end.
