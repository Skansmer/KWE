unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GLWin32Viewer, GLMisc, GLScene, GLObjects, GLMesh, StdCtrls,
  GLTexture, VectorTypes, VectorGeometry, ExtCtrls, GLVectorFileObjects,
  GLNavigator, GLCadencer, Keyboard, Menus, KalClientMap,GLGraph, XPMan,
  ComCtrls, GLFile3ds, Buttons,INIFiles, math, GLWaterPlane, GLHUDObjects,
  GLGui, GLWindows, GLBitmapFont, GLWindowsFont, ShellApi, ToolWin, ClipBrd,
  XPStyleActnCtrls, ActnList, ActnMan, StdActns, ActnCtrls, ActnMenus, Registry,
  jpeg, dds, GLGeomObjects, GLSkyBox, GLMultiMaterialShader,
  GLTexCombineShader, ImagingClasses, ImagingTypes, Imaging, ImagingComponents,
  ColorGrd, GLTerrainRenderer,            
  //Shaders
  OpenGL1x, GLState, FileCtrl, ImgList;

var
 CurPos:Integer;

    { Clamp function restricts Value to [0..255] range }
    function Clamp(Value: Integer): TColor32;
    { Blend function blends 2 colors based on alpha value}
    function Blend(Color1, Color2: TColor; A: Byte): TColor;

type
  TKWETool=( tKSM_HeightBased ,tKSM_PaintBrush  ,tKSM_OPLBased
            ,tKCM_HeightBrush ,tKCM_SetHeight   ,tKCM_Flatten     ,tKCM_Smooth   ,tKCM_BrushPaint
            ,tKCM_TexturePaint,tKCM_WholeMap    ,tKCM_GrassPaint  ,tKCM_Colormap
            ,tOPL_Position    ,tOPL_Scale       ,tOPL_AddNode
            ,tOPL_RotateX     ,tOPL_RotateY     ,tOPL_RotateZ     ,tOPL_RotateXYZ
            ,tOPL_X           ,tOPL_Y           ,tOPL_Z           ,tOPL_XYZ
            ,null);
  TSelected_OPL=record
    Index:Integer;
    Tex:String;
  end;
  TSelected_OPLs=Array of TSelected_OPL;
  TForm_Main = class(TForm)
    GLScene: TGLScene;
    GLSceneViewer: TGLSceneViewer;
    GLDummyCube: TGLDummyCube;
    Panel_General: TPanel;
    //Image_Texture: TImage;
    Image_General: TImage;
    ListBox_File: TListBox;
    ListBox_FileAspect: TListBox;
    GroupBox_AspectToChange: TGroupBox;
    GroupBox_KSMDRAW: TGroupBox;
    GroupBox_KSMDraw_GeneralValues: TGroupBox;
    GroupBox_KSMDraw_SpecifiedValues: TGroupBox;
    Image_ColorDraw1: TImage;
    TrackBar_IndicatorHeight: TTrackBar;

    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;

    GLFreeForm_Indicator: TGLFreeForm;
    GLFreeForm_water: TGLFreeForm;
    GLHeightField: TGLHeightField;
    KSMHEIGHT_ButtonDown: TBitBtn;
    KSMHEIGHT_ButtonUp: TBitBtn;

    GroupBox_KCMTexturePaint: TGroupBox;

    //KCM Height panel
    GroupBox_KCMHEIGHT: TGroupBox;
    TrackBar_KCMHEIGHT_Diameter: TTrackBar;
    TrackBar_KCMHEIGHT_Intensity: TTrackBar;
    Label_Size: TLabel;
    Label_Intensity: TLabel;
    TrackBar_KCMSetHeight_Height: TTrackBar;

    //KCM Texture paint components
    Label_KCMTexturePaint_TextureMap: TLabel;
    TrackBar_KCMTexturePaint_InnerDiameter: TTrackBar;

    //OPL general
    GroupBox_OPL: TGroupBox;
    Edit_OPL_Model: TEdit;

    //ToolBar
    ToolBar_3DShow: TToolBar;
    CoolBar_3DShow: TCoolBar;
    Panel_ToolBar: TPanel;
    CheckBox_OPL_Position_STM: TCheckBox;
    CheckBox_LockBorders: TCheckBox;
    CheckBox_StickOPLtoKCM: TCheckBox;
    CheckBox_CoordSys: TCheckBox;
    TrackBar_KSMOpl_PaintSize: TTrackBar;
    Button_KSMOpl_Paint: TButton;

    MainMenu: TMainMenu;
    MainMenu_File: TMenuItem;
    MainMenu_File_LoadKCMFile: TMenuItem;
    MainMenu_File_SaveKCMFile: TMenuItem;
    MainMenu_File_SaveKCMFileAs: TMenuItem;
    N1: TMenuItem;
    MainMenu_File_LoadKSMFile: TMenuItem;
    MainMenu_File_SaveKSMFile: TMenuItem;
    MainMenu_File_SaveKSMFileAs: TMenuItem;
    MainMenu_File_NewKSMFile: TMenuItem;
    N2: TMenuItem;
    MainMenu_File_LoadOPLFile: TMenuItem;
    MainMenu_File_SaveOPLFile: TMenuItem;
    MainMenu_File_SaveOPLFileAs: TMenuItem;
    GLDummyCube_OPLObjects: TGLDummyCube;
    MainMenu_KCMFile: TMenuItem;
    MainMenu_KCMFile_BorderCenter: TMenuItem;
    MainMenu_KCMFile_HeaderInfo: TMenuItem;
    MainMenu_KCMFile_RenderColorMap: TMenuItem;
    MainMenu_OPLFile: TMenuItem;
    GLSphere1: TGLSphere;
    GLHUDTextX: TGLHUDText;
    GLHUDTextY: TGLHUDText;
    GLHUDTextZ: TGLHUDText;
    Font: TGLWindowsBitmapFont;
    XPManifest1: TXPManifest;
    GLCamera: TGLCamera;
    PopupMenu_CoordinateSys: TPopupMenu;
    PopUp_CoordSys_CopyXY: TMenuItem;
    PopUp_CoordSys_CopyXYZ: TMenuItem;
    PopUp_CoordSys_CopyXYSpawn: TMenuItem;
    PopUp_CoordSys_CopyX: TMenuItem;
    PopUp_CoordSys_CopyY: TMenuItem;
    PopUp_CoordSys_CopyZ: TMenuItem;
    PopupMenu_CoordSys_CopyXYZ: TMenuItem;
    MainMenu_KCM_NewKCMFile: TMenuItem;
    MainMenu_OPLFile_HeaderInfo: TMenuItem;
    MainMenu_OPLFile_AddNode: TMenuItem;
    MainMenu_OPLFile_DeleteNode: TMenuItem;
    MainMenu_OPLFile_DeleteAll: TMenuItem;
    N3: TMenuItem;
    Button_LayerCenter: TButton;
    N4: TMenuItem;
    MainMenu_File_NewOPLFile: TMenuItem;
    TrackBar_KCMSetHeight_Height2: TTrackBar;
    Button_OPL_BrowseModel: TButton;
    GLLightSource1: TGLLightSource;
    CheckBox_ShowOPLModels: TCheckBox;
    GLMaterialLibrary: TGLMaterialLibrary;
    CheckBox_ShowOPLTextures: TCheckBox;
    Timer_AutoSave: TTimer;
    Trackbar_KCMGrassPaint_Type: TTrackBar;
    Trackbar_KCMGrassPaint_Intensity: TTrackBar;
    GLDummyCube_Center: TGLDummyCube;
    Edit_KCMHEIGHT_BrushSize: TEdit;
    Edit_KCMHEIGHT_Intensity: TEdit;
    GLSkyBox1: TGLSkyBox;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLMaterialLibrary2: TGLMaterialLibrary;
    GLTexCombineShader1: TGLTexCombineShader;
    GLMultiMaterialShader1: TGLMultiMaterialShader;
    GLHeightFieldTwo: TGLHeightField;
    Chk_KCMTexture: TCheckBox;
    Label_Hardness: TLabel;
    ListBox_TextureMap: TListBox;
    Image_TexturePreview: TImage;
    TrackBar_KCMTEX_Diameter: TTrackBar;
    TrackBar_KCMTEX_Intensity: TTrackBar;
    Import1: TMenuItem;
    Import_Heightmap: TMenuItem;
    Import_Colormap: TMenuItem;
    Import_Alphamap: TMenuItem;
    Export1: TMenuItem;
    Export_Heightmap: TMenuItem;
    Export_Colormap: TMenuItem;
    Export_Alphamap: TMenuItem;
    About1: TMenuItem;
    Edit_KCMHEIGHT_Hardness: TEdit;
    SpdBtn_OPL_X: TSpeedButton;
    SpdBtn_OPL_Y: TSpeedButton;
    SpdBtn_OPL_Z: TSpeedButton;
    SpdBtn_OPL_XYZ: TSpeedButton;
    Button_TextureCenter: TButton;
    Chk_Random: TCheckBox;
    ColorDialog1: TColorDialog;
    ColorPicker: TBitBtn;
    BrushPreview: TPaintBox;
    MainMenu_Options: TMenuItem;
    GLLightSource2: TGLLightSource;
    Edit_XCoordinate: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit_YCoordinate: TEdit;
    Label3: TLabel;
    Edit_ZCoordinate: TEdit;
    TreeView1: TTreeView;
    FileBox: TFileListBox;
    GLFreeForm: TGLFreeForm;
    ImageList1: TImageList;
    Btn_Add_Node: TButton;
    Label4: TLabel;
    Btn_DeleteAllNodes: TButton;
    Btn_ResetScale: TButton;
    View1: TMenuItem;
    Chk_ShowWater: TMenuItem;
    Chk_Wireframe: TMenuItem;
    Chk_CameraAxis: TMenuItem;
    CheckBox_ShowOPLNodes: TMenuItem;
    Chk_Reset: TMenuItem;
    N5: TMenuItem;
    NewKSMFile1: TMenuItem;
    DuplicateMap: TMenuItem;

    //General
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CreateIndicator;
    procedure CreateWater;
    procedure Image_GeneralMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);

    //HeightField Painters
    procedure GLHeightField1PaintWireframe(const x, y: Single; var z: Single;var color: TVector4f; var texPoint: TTexPoint);
    procedure GLHeightFieldPaintWireframe(const x, y: Single; var z: Single;var color: TVector4f; var texPoint: TTexPoint);
    procedure GLHeightFieldPaintColorMap(const x, y: Single; var z: Single;var color: TVector4f; var texPoint: TTexPoint);
    procedure GLHeightFieldPaintColorMap2(const x, y: Single; var z: Single;var color: TVector4f; var texPoint: TTexPoint);
    procedure GLHeightFieldPaintKSMMap(const x, y: Single; var z: Single;var color: TVector4f; var texPoint: TTexPoint);
    procedure GLHeightFieldPaintTextureMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
    procedure GLHeightFieldPaintMiniMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
    procedure GLHeightFieldPaintCustomPic(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
    procedure GLHeightFieldPaintObjectMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);

    //View controls
    procedure GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;X, Y: Integer);
    procedure GLSceneViewerMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);

    //MainMenu_Click Events
    procedure MainMenu_FileClick(Sender: TObject);
    procedure MainMenu_File_LoadKCMFileClick(Sender: TObject);
    procedure MainMenu_File_LoadKSMFileClick(Sender: TObject);
    procedure MainMenu_File_LoadOPLFileClick(Sender: TObject);
    procedure MainMenu_File_SaveKCMfileClick(Sender: TObject);
    procedure MainMenu_File_SaveKSMFileClick(Sender: TObject);
    procedure MainMenu_File_SaveOPLFileClick(Sender: TObject);
    procedure MainMenu_File_SaveKSMFileasClick(Sender: TObject);
    procedure MainMenu_File_ExitClick(Sender: TObject);
    procedure MainMenu_KCMFileClick(Sender: TObject);
    procedure MainMenu_KCMFile_TextureCenterClick(Sender: TObject);
    procedure MainMenu_KCMFile_RenderColorMapClick(Sender: TObject);
    procedure MainMenu_OptionsClick(Sender: TObject);

    //General tool requirements
    procedure ListBox_FileClick(Sender: TObject);
    procedure ListBox_FileAspectClick(Sender: TObject);
    procedure RadioButtons_ValuesClick(Sender: TObject);

    //KSMEdit_Brush
    procedure TrackBar_DiameterChange(Sender: TObject);

    //KSMEdit_HeightBased
    procedure KSMHEIGHT_ButtonUpClick(Sender: TObject);
    procedure KSMHEIGHT_ButtonDownClick(Sender: TObject);
    procedure TrackBar_IndicatorHeightChange(Sender: TObject);

    //KCM Set height
    procedure TrackBar_KCMSetHeight_HeightChange(Sender: TObject);
    procedure TrackBar_KCMHEIGHT_Intensitychange(Sender: TObject);

    //KCM texture paint
    procedure TrackBar_KCMTexturePaint_OuterDiameterChange(ender: TObject);
    procedure TrackBar_KCMTexturePaint_InnerDiameterChange(Sender: TObject);
    procedure TrackBar_KCMTexturePaint_IntensityChange(Sender: TObject);
    procedure BrushCreate(Brush:TBitmap;InWidth,OutWidth,Intensity:Integer;R,G,B:TColor);
    procedure ListBox_TextureMapClick(Sender: TObject);

    //OPL
    procedure OPLChange(Sender: TObject);
    procedure PositionOPL(UpdateModels,TrueModels,TrueTextures:Boolean);
    procedure PositionOPLNode(x1:Integer;UpdateModel:Boolean;TrueModel:Boolean = True;TrueTex:Boolean = True);
    procedure DisplayOPLNodeInfo(Nodes:TSelected_OPLs);

    //ToolBar
    procedure Chk_Wireframe2Click(Sender: TObject);
    procedure Chk_CameraAxis2Click(Sender: TObject);
    procedure Chk_KCMTextureClick(Sender: TObject);
    procedure CheckBox_ShowWaterClick(Sender: TObject);
    procedure CheckBox_ShowOPLNodes2Click(Sender: TObject);
    procedure Button_KSMOpl_PaintClick(Sender: TObject);
    procedure MainMenu_KCMFile_BorderCenterClick(Sender: TObject);
    procedure MainMenu_File_NewKSMFileClick(Sender: TObject);
    procedure MainMenu_OPLFileClick(Sender: TObject);
    procedure MainMenu_OPLFile_DeleteNodeClick(Sender: TObject);
    procedure MainMenu_OPLFile_DeleteAllClick(Sender: TObject);
    procedure MainMenu_OPLFile_AddNodeClick(Sender: TObject);
    procedure CheckBox_CoordSysClick(Sender: TObject);
    procedure PopUp_CoordSys_CopyXYClick(Sender: TObject);
    procedure PopUp_CoordSys_CopyXYZClick(Sender: TObject);
    procedure PopUp_CoordSys_CopyXYSpawnClick(Sender: TObject);
    procedure PopUp_CoordSys_CopyXClick(Sender: TObject);
    procedure PopUp_CoordSys_CopyYClick(Sender: TObject);
    procedure PopUp_CoordSys_CopyZClick(Sender: TObject);
    procedure PopupMenu_CoordSys_CopyXYZClick(Sender: TObject);
    procedure MainMenu_File_SaveKCMFileAsClick(Sender: TObject);
    procedure MainMenu_MAP_HeaderInfoClick(Sender: TObject);
    procedure MainMenu_KCMFile_HeaderInfoClick(Sender: TObject);
    procedure MainMenu_OPLFile_HeaderInfoClick(Sender: TObject);
    procedure MainMenu_KCM_NewKCMFileClick(Sender: TObject);
    procedure Button_LayerCenterClick(Sender: TObject);

    procedure ResetRealm;
    procedure MainMenu_File_NewOPLFileClick(Sender: TObject);
    procedure MainMenu_File_SaveOPLFileAsClick(Sender: TObject);
    procedure Button_OPL_BrowseModelClick(Sender: TObject);
    procedure CheckBox_ShowOPLModelsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit_OPL_ModelKeyPress(Sender: TObject; var Key: Char);
    procedure Timer_AutoSaveTimer(Sender: TObject);
    procedure CheckBox_ShowOPLTexturesClick(Sender: TObject);
    procedure SpdBtn_OPL_XClick(Sender: TObject);
    procedure SpdBtn_OPL_YClick(Sender: TObject);
    procedure SpdBtn_OPL_ZClick(Sender: TObject);
    procedure SpdBtn_OPL_XYZClick(Sender: TObject);
    procedure Export_HeightmapClick(Sender: TObject);
    procedure Import_HeightmapClick(Sender: TObject);
    procedure Trackbar_KCMGrassPaint_TypeChange(Sender: TObject);
    procedure Trackbar_KCMGrassPaint_IntensityChange(Sender: TObject);
    procedure ColorPickerClick(Sender: TObject);
    procedure BrushPreviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BrushPreviewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BrushPreviewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BrushPreviewPaint(Sender: TObject);
    procedure About1Click(Sender: TObject);
    // MODEL VIEWER
    procedure DirectoryBoxChange(Sender: TObject);
    procedure FileBoxChange(Sender: TObject);
    function GetFiles(const Path, Mask: string; IncludeSubDir: boolean): TStrings;
    function GetSubDirs(const directory : string): TStrings;
    function GetMap(TreeNode:TTreeNode):String;
    procedure AddSubDirs(TreeNode:TTreeNode;Map:String);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1Expanding(Sender: TObject; Node: TTreeNode;var AllowExpansion: Boolean);
    procedure TreeView1Collapsing(Sender: TObject; Node: TTreeNode;var AllowCollapse: Boolean);
    procedure BuildNodes(FileLocation:String);
    procedure SelectFile(Model:Integer);
    procedure Chk_ResetClick(Sender: TObject);
    // MODEL VIEWER END
    procedure Delay(Milliseconds: Integer);
    procedure DuplicateMapClick(Sender: TObject);

  private
    Previous_KCM:Array[0..9] of TKCMHeightMap;
    Nilled_KCM:TKCMHeightMap;
    OPL_Node:Integer;
    //Previous_KSM:Array[0..9] of TKalServerMap;
    //Previous_OPL:Array[0..9] of TOPLFile;
  public
    FBrush,FPBrush,KCMMinimap,KCMCustomPic:TBitmap;

    KCM           :TKalClientMap;
    mapc           :TKCMMap;
    KSM           :TKalServerMap;
    env         :TKalEnvironmentFile;
    map           :TKSMMap;
    Client_Path, MainSvr_Path, KSMInital_Path,KCMInital_Path :String;
    CurTMap       :Integer;
    OPL           :TOPLFile;
    TOOL,Tool_Old: TKWETool;
    GroupBox_OPL_Position_Big,GroupBox_OPL_Model_Big,GroupBox_OPL_Rotation_Big,GroupBox_OPL_Scale_Big:Boolean;
    UseOldCenter:Boolean;
    rgbColor: TColor;
    mx, my : Integer;
  end;
var
  Form_Main: TForm_Main;
  ShowWireframe:Boolean;
  ViewX,Viewy:Integer;
  FMin, FMax,c   : TAffineVector;
  Values:TValues;
  CoordSys_X,CoordSys_Y,CoordSys_Z:Integer;
  Selected_OPLs: TSelected_OPLs;

  PaintActive, MaxVal: boolean;
  beginX,beginY,xGlobal,yGlobal: Integer;
  PaintColor: TColor;


implementation

uses Unit2, Unit3, Unit4, Unit5, Unit6, Unit7, Unit8, Unit9, Unit10, MapCoords;

{$R *.dfm}

type

   THiddenLineShader = class (TGLShader)
      private
         BackgroundColor, LineColor : TColorVector;
         PassCount : Integer;
      public
         procedure DoApply(var rci : TRenderContextInfo; Sender : TObject); override;
         function DoUnApply(var rci : TRenderContextInfo) : Boolean; override;
   end;

   TOutLineShader = class (TGLShader)
      private
         BackgroundColor, LineColor : TColorVector;
         OutlineSmooth, Lighting : Boolean;
         OutlineWidth, Oldlinewidth : Single;
         PassCount : Integer;
      public
         procedure DoApply(var rci : TRenderContextInfo; Sender : TObject); override;
         function DoUnApply(var rci : TRenderContextInfo) : Boolean; override;
   end;

procedure THiddenLineShader.DoApply(var rci : TRenderContextInfo; Sender : TObject);
begin
   // new object getting rendered, 1st pass
   PassCount:=1;

   // backup state
   glPushAttrib(GL_ENABLE_BIT);
   // disable lighting, this is a solid fill
   glDisable(GL_LIGHTING);
   rci.GLStates.SetGLPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
   // use background color
   glColor3fv(@BackgroundColor);
   // enable and adjust polygon offset
   glEnable(GL_POLYGON_OFFSET_FILL);
   glPolygonOffset(1, 2);
end;

function THiddenLineShader.DoUnApply(var rci : TRenderContextInfo) : Boolean;
begin
   case PassCount of
      1 : begin
         // 1st pass completed, we setup for the second
         PassCount:=2;

         // switch to wireframe and its color
         rci.GLStates.SetGLPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
         glColor3fv(@LineColor);
         // disable polygon offset
         glDisable(GL_POLYGON_OFFSET_LINE);

         Result:=True;
      end;
      2 : begin
         // restore state
         glPopAttrib;

         // we're done
         Result:=False;
      end;
   else
      // doesn't hurt to be cautious
      Assert(False);
      Result:=False;
   end;
end;

procedure TOutLineShader.DoApply(var rci : TRenderContextInfo; Sender : TObject);
begin
   PassCount:=1;
   glPushAttrib(GL_ENABLE_BIT);
   glDisable(GL_LIGHTING);

   if outlineSmooth then begin
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
      glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
      glEnable(GL_LINE_SMOOTH);
   end else glDisable(GL_LINE_SMOOTH);

   glGetFloatv(GL_LINE_WIDTH,@oldlinewidth);
   glLineWidth(OutLineWidth);
   glPolygonMode(GL_BACK, GL_LINE);
   glCullFace(GL_FRONT);
   glDepthFunc(GL_LEQUAL);
   glColor3fv(@lineColor);
end;

function TOutLineShader.DoUnApply(var rci : TRenderContextInfo) : Boolean;
begin
   case PassCount of
      1 : begin
         PassCount:=2;
         if lighting then
           glEnable(GL_LIGHTING)
         else glColor3fv(@backGroundColor);
         glDepthFunc(GL_LESS);
         glCullFace(GL_BACK);
         glPolygonMode(GL_BACK, GL_FILL);

         Result:=True;
      end;
      2 : begin
         glPopAttrib;
         glLineWidth(oldLineWidth);
         Result:=False;
      end;
   else
      Assert(False);
      Result:=False;
   end;
end;

function Clamp(Value: Integer): TColor32;
begin
  if Value < 0 then Result := 0
  else if Value > 255 then Result := 255
  else Result := Value;
end;

function Blend(Color1, Color2: TColor; A: Byte): TColor;
var
  c1, c2: LongInt;
  r, g, b, v1, v2: byte;
begin
  A:= Round(2.55 * A);
  c1 := ColorToRGB(Color1);
  c2 := ColorToRGB(Color2);
  v1:= Byte(c1);
  v2:= Byte(c2);
  r:= A * (v1 - v2) shr 8 + v2;
  v1:= Byte(c1 shr 8);
  v2:= Byte(c2 shr 8);
  g:= A * (v1 - v2) shr 8 + v2;
  v1:= Byte(c1 shr 16);
  v2:= Byte(c2 shr 16);
  b:= A * (v1 - v2) shr 8 + v2;
  Result := (b shl 16) + (g shl 8) + r;
end;

procedure TForm_Main.FormCreate(Sender: TObject);
var
  Size:Integer;
  x,y:Integer;
  //reg: TRegistry;
  //ProgressBarStyle: integer;
begin
  //Preparing the Brush, and the PreviewBrush for KCM Texture Paint purpose
  Width := Screen.Width;
  Height := Screen.Height;
  PaintActive := False;
  PaintColor := 14413224;
  FBrush := TBitmap.Create;
  FBrush.Width:=100;
  FBrush.Height:=100;
  FPBrush := TBitmap.Create;
  FPBrush.Width:=100;
  FPBrush.Height:=100;

  //Preparing Brush Size
  size:=TrackBar_KCMHEIGHT_Diameter.Position;
  
  //GLSphere1.Material.BlendingMode:=bmAdditive;
  //GLSphere1.Material.FrontProperties.PolygonMode:=pmPoints;
  GlSphere1.Rotation.X:=-90;
  GLSphere1.Rotation.Y:=0;
  GLSphere1.Rotation.Z:=0;
  GLSphere1.Scale.X:=size;
  GLSphere1.Scale.Y:=size;
  GLSphere1.Scale.Z:=size;

  //Water
  CreateWater;

  //Loading Settings
  try
    INIFile:=TINIFile.Create(ExtractFilePath(Application.ExeName)+Copy(ExtractFileName(Application.ExeName),0,Length(ExtractFileName(Application.ExeName))-Length(ExtractFileExt(Application.ExeName)))+'.ini');
    Client_Path:=INIFile.ReadString('Settings','Client_Path','');
    MainSvr_Path:=INIFile.ReadString('Settings','MainSvr_Path','');
    KCMInital_Path:=INIFile.ReadString('Settings','KCMInital_Path','');
    KSMInital_Path:=INIFile.ReadString('Settings','KSMInital_Path','');
    If INIFile.ReadInteger('Settings','AutoSaveInterval',30) <> 0 then
    begin
      Timer_AutoSave.Interval:= INIFile.ReadInteger('Settings','AutoSaveInterval',30)*1000;
      Timer_AutoSave.Enabled:=True;
    end;
    If MainSvr_Path[Length(MainSvr_Path)]<>'\' then
    begin
      MainSvr_Path:=MainSvr_Path+'\';
    end;
    If Client_Path[Length(Client_Path)]<>'\' then
    begin
      Client_Path:=Client_Path+'\';
    end;
    INIFIle.Free;
  except
  end;
  // Removed Vlad
  //MessageBox(Handle, pchar('Please check if these settings are correct, If not please go to ''Options'' otherwise you get shitloads of errors.'+#13+'Client Path = '+Client_Path+#13+'MainSvr Path = '+MainSvr_Path),PChar('Please verify these settings'),mb_OK);
  //Loading n.env
  If FileExists(Client_Path+'data\MAPS\n.env')then
  begin
    try
      env:=TKalEnvironmentFile.Create;
      env.LoadFromFile(Client_Path+'data\MAPS\n.env');
    except
      MessageBox(Handle,pchar('An error occured when trying to load n.env:'+#13+#13+'- Unknown'),PChar('Error while loading n.env'),mb_OK);
    end;
  end
  else
  begin
    MessageBox(Handle,pchar('An error occured when trying to load n.env:'+#13+#13+'- File doesn''t exisits'+#13+#13+'Please check if file '''+Client_Path+'data\MAPS\n.env'' exists'),PChar('File doesn''t exists'),mb_OK);
  end;
{
  reg := TRegistry.Create;
  reg.RootKey:=HKEY_CLASSES_ROOT;

  //KSM's file association
  reg.OpenKey('.kcm',True);
  reg.WriteString('','KalWorldEditor.KCM');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.kcm',True);
  reg.WriteString('','KalClientMap');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.KCM\shell\open\command', true);
  reg.WriteString('', '"'+Application.ExeName+'" "%1"');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.KCM\DefaultIcon', true);
  reg.WriteString('', ExtractFilePath(Application.ExeName)+'\Recources\kwe_file[red].ico');
  reg.CloseKey;

  //KSM's file association
  reg.OpenKey('.ksm',True);
  reg.WriteString('','KalWorldEditor.KSM');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.KSM',True);
  reg.WriteString('','KalServerMap');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.KSM\shell\open\command', true);
  reg.WriteString('', '"'+Application.ExeName+'" "%1"');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.KSM\DefaultIcon', true);
  reg.WriteString('', ExtractFilePath(Application.ExeName)+'\Recources\kwe_file[red].ico');
  reg.CloseKey;

  //OPL's file association
  reg.OpenKey('.opl',True);
  reg.WriteString('','KalWorldEditor.OPL');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.OPL',True);
  reg.WriteString('','ObjectPositioningList');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.OPL\shell\open\command', true);
  reg.WriteString('', '"'+Application.ExeName+'" "%1"');
  reg.CloseKey;

  reg.OpenKey('KalWorldEditor.OPL\DefaultIcon', true);
  reg.WriteString('', ExtractFilePath(Application.ExeName)+'\Recources\kwe_file[red].ico');
  reg.CloseKey;

  reg.free;
 }

  with GLMaterialLibrary1 do begin

    // Add the specular pass
    with AddTextureMaterial('specular',ExtractFilePath(Application.ExeName)+'\Recources\b_005.dds') do begin
      // tmBlend for shiny background
      //Material.Texture.TextureMode:=tmBlend;
      // tmModulate for shiny text
      Material.Texture.TextureMode:=tmModulate;
      Material.BlendingMode:=bmAdditive;
      Texture2Name:='specular_tex2';
    end;
    with AddTextureMaterial('specular_tex2',ExtractFilePath(Application.ExeName)+'\Recources\b_013.dds') do begin
      Material.Texture.MappingMode:=tmmCubeMapReflection;
      Material.Texture.ImageBrightness:=0.3;
    end;

  end;

  // GLMaterialLibrary2 is the source of the GLMultiMaterialShader
  // passes.

  with GLMaterialLibrary2 do begin
    // Pass 1 : Base texture
    with AddTextureMaterial('Pass1',ExtractFilePath(Application.ExeName)+'\Recources\b_002.dds') do begin
    end;//
    {
    // Pass 2 : Add a bit of detail
    with AddTextureMaterial('Pass2',ExtractFilePath(Application.ExeName)+'\Recources\b_004.dds') do begin
      Material.Texture.TextureMode:=tmBlend;
      Material.BlendingMode:=bmAdditive;
      Material.Texture.ImageAlpha:=tiaSuperBlackTransparent;
    end;//
    }
    // This isn't limited to 3, try adding some more passes!
  end;
{
  //Making sure KSM Brush color etc is filled;
  Values[1]:=0;
  Values[2]:=0;
  For x:=0 to Image_ColorDraw1.Width do
  begin
    For y:=0 to Image_ColorDraw1.Height do
    begin
      Image_ColorDraw1.Canvas.Pixels[x,y]:=KSM.ValuesToColor(Values[1],Values[2]);
      Image_ColorDraw2.Canvas.Pixels[x,y]:=KSM.ValuesToColor(Values[1],Values[2]);
      Image_KSMOPL_Color.Canvas.Pixels[x,y]:=KSM.ValuesToColor(Values[1],Values[2]);
    end;
  end;
  }
end;

procedure TForm_Main.FormShow(Sender: TObject);
var
  x1,y1,x2,x:Integer;
  //ext:Extended;
begin
  //Checking the parameters for files
  If ParamCount > 0 then
  begin
    For x1:=0 to ParamCount do
    begin
      If LowerCase(ExtractFileExt(ParamStr(x1)))='.kcm' then
      begin
        if KCM=nil then
        begin
          If FileExists(ParamStr(x1)) then
          begin
            KCM:=TKalClientMap.Create;
            KCM.LoadFromFile(ParamStr(x1), 1);
            If KSM<>nil then
            begin
              If MessageBox(Handle, pchar('An KSM file has been loaded, want to paint the KCM file with it?'),'Paint?',MB_YESNO) = IDYES then
              begin
                //Want to paint KSM on Heightmap
                GLHeightField.OnGetHeight:=GLHeightFieldPaintKSMmap;
                GLHeightField.StructureChanged;
              end
              else
              begin
                //Dont want to paint KSM on Heightmap
                GLHeightField.OnGetHeight:=GLHeightFieldPaintColormap;
                GLHeightField.StructureChanged;
              end;
            end
            else
            begin
              //If no KSM is loaded painting color map
              GLHeightField.OnGetHeight:=GLHeightFieldPaintColormap;
              GLHeightField.StructureChanged;
            end;
          end;
        end
        else
        begin
          MessageBox(Handle, pchar('An KCM File has already been loaded, can''t load 2 KCM files.'),'Error',MB_OK);
        end;
      end;
      If LowerCase(ExtractFileExt(ParamStr(x1)))='.ksm' then
      begin
        If FileExists(ParamStr(x1)) then
        begin
          If KSM=nil then
          begin
            KSM:=TKalServerMap.Create;
            KSM.LoadFromFile(ParamStr(x1));
            map:=KSM.map;
            {
            for x2:=0 to 256 do
            begin
              for y1:=0 to 256 do
              begin
                Image_General.Canvas.Pixels[x2,y1]:=KSM.map[x2][y1][2];
              end;
            end;
             }
            If KCM<>nil then
            begin
              //If MessageBox(Handle, pchar('An KCM file has been loaded, want to paint the KSM file over it?'),'Paint?',MB_YESNO) = IDYES then
              //begin
                GLHeightField.OnGetHeight:=GLHeightFieldPaintKSMmap;
                GLHeightField.StructureChanged;
              //end;
            end;
          //end
          //else
          //begin
          //  MessageBox(Handle, pchar('An KSM File has already been loaded, can''t load 2 KSM files.'),'Error',MB_OK);
          end;
        end;
      end;
      If LowerCase(ExtractFileExt(ParamStr(x1)))='.opl' then
      begin
        If FileExists(ParamStr(x1)) then
        begin
          If OPL=nil then
          begin
            OPL:=TOPLFile.Create;
            OPL.LoadFromFile(ParamStr(x1));
            CheckBox_StickOPLtoKCM.Enabled:=True;
            CheckBox_ShowOPLNodes.Enabled:=True;
            CheckBox_ShowOPLNodes.Checked:=True;


            PositionOPL(True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

          //end
          //else
          //begin
          //  MessageBox(Handle, pchar('An OPL File has already been loaded, can''t load 2 OPL files.'),'Error',MB_OK);
          end;
        end;
      end;
    end;
  end;
  ResetRealm;
end;

procedure TForm_Main.CreateIndicator;
var
  p1, p2, p3, p4: TVertexdata;
  col1, col2, col3, col4: TVector4F;
  lFaceGroup: TFGVertexIndexList;
  lMeshObj: TMeshObject;
begin
  GLFreeForm_Indicator.MeshObjects.Clear;

  lMeshObj := TMeshObject.CreateOwned(GLFreeForm_Indicator.MeshObjects);
  lMeshObj.Mode := momFaceGroups;

  lFaceGroup := TFGVertexIndexList.CreateOwned(lMeshObj.FaceGroups);

  p1.coord[0] := 0;
  p1.coord[1] := 0;
  p1.coord[2] := 0;
  col1[0] := 1 / 255;
  col1[1] := 255 / 255;
  col1[2] := 1 / 255;

  p2.coord[0] := 255;
  p2.coord[1] := 0;
  p2.coord[2] := 0;
  col2[0] := 1 / 255;
  col2[1] := 255 / 255;
  col2[2] := 1 / 255;

  p3.coord[0] := 0;
  p3.coord[1] := 0;
  p3.coord[2] := 255;
  col3[0] := 1 / 255;
  col3[1] := 255 / 255;
  col3[2] := 1 / 255;

  p4.coord[0] := 255;
  p4.coord[1] := 0;
  p4.coord[2] := 255;
  col4[0] := 1 / 255;
  col4[1] := 255 / 255;
  col4[2] := 1 / 255;

  lMeshObj.Vertices.Add(p1.coord);
  lMeshObj.Vertices.Add(p2.coord);
  lMeshObj.Vertices.Add(p3.coord);
  lMeshObj.Vertices.Add(p4.coord);

  lMeshObj.Colors.Add(col1);
  lMeshObj.Colors.Add(col2);
  lMeshObj.Colors.Add(col3);
  lMeshObj.Colors.Add(col4);

  lFaceGroup.Add(lMeshObj.Vertices.Count - 2);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 1);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 3);

  lFaceGroup.Add(lMeshObj.Vertices.Count - 3);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 4);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 2);

  GLFreeForm_Indicator.StructureChanged;
end;

procedure TForm_Main.CreateWater;
var
  p1, p2, p3, p4: TVertexdata;
  col1, col2, col3, col4: TVector4F;
  lFaceGroup: TFGVertexIndexList;
  lMeshObj: TMeshObject;
begin
  GLFreeForm_Water.MeshObjects.Clear;

  lMeshObj := TMeshObject.CreateOwned(GLFreeForm_Water.MeshObjects);
  lMeshObj.Mode := momFaceGroups;

  lFaceGroup := TFGVertexIndexList.CreateOwned(lMeshObj.FaceGroups);

  p1.coord[0] := 0;
  p1.coord[1] := 0;
  p1.coord[2] := 0;
  col1[0] := 1 / 255;
  col1[1] := 100 / 255;
  col1[2] := 255 / 255;

  p2.coord[0] := 256;
  p2.coord[1] := 0;
  p2.coord[2] := 0;
  col2[0] := 1 / 255;
  col2[1] := 100 / 255;
  col2[2] := 255 / 255;

  p3.coord[0] := 0;
  p3.coord[1] := 0;
  p3.coord[2] := 256;
  col3[0] := 1 / 255;
  col3[1] := 100 / 255;
  col3[2] := 255 / 255;

  p4.coord[0] := 256;
  p4.coord[1] := 0;
  p4.coord[2] := 256;
  col4[0] := 1 / 255;
  col4[1] := 100 / 255;
  col4[2] := 255 / 255;

  lMeshObj.Vertices.Add(p1.coord);
  lMeshObj.Vertices.Add(p2.coord);
  lMeshObj.Vertices.Add(p3.coord);
  lMeshObj.Vertices.Add(p4.coord);
  { //Removed
  lMeshObj.Colors.Add(col1);
  lMeshObj.Colors.Add(col2);
  lMeshObj.Colors.Add(col3);
  lMeshObj.Colors.Add(col4);
  }
  lFaceGroup.Add(lMeshObj.Vertices.Count - 2);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 1);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 3);

  lFaceGroup.Add(lMeshObj.Vertices.Count - 3);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 4);
  lFaceGroup.Add(lMeshObj.Vertices.Count - 2);
  
  GLFreeForm_Water.StructureChanged;
end;



procedure TForm_Main.GLSceneViewerMouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer);
var
  TixX,TixY       : Integer;
  v,u : TAffineVector;
  x1,y1:Integer;
  x2,y2,z2:single;
  TinT:byte;
  maxX,maxy,minX,minY:SmallInt;
  helling,invhelling,hellingZ,i,j,iZ,moveX,moveY,moveZ:single;
  s,w,g,multiply:single;
  KCMHeightMap:TKCMHeightMap;
  TextureMap:TKCMTextureMapList;
  cnt,selected:integer;
  OPLNode:TOPLNode;
  Vector3F:TVector3F;
  Vector4F:TVector4F;
  Point:TPoint;
  ObjMap:TKCMObjectMap;
  dX,dY:Single;
  Model:TGLFreeForm;
  Center:TVector3F;
  Mapc:TKCMColorMap;
  shader1: TOutLineShader;
  o:integer;
const
  PI:Extended=3.1415926535897932384626433;
begin
  //Getting mouse cursor position, and
  GLSceneViewer.Cursor:=crDefault;

  Try
    GLDummyCube_OPLObjects.Visible:=False;
    u:=GLSceneViewer.Buffer.PixelRayToWorld(x, y);
    v:=GLHeightField.AbsoluteToLocal(u);
    GLDummyCube_OPLObjects.Visible:=True;

    If KCM<>nil then
    begin
      CoordSys_X:=round((KCM.Header.MapX*8192)+(32*v[0]));
      CoordSys_Y:=round((KCM.Header.MapY*8192)+(8192-(32*v[1])));
      CoordSys_Z:=round(32*-v[2]); // Fix from 320 to 32
    end;

    Edit_XCoordinate.Text:=inttostr(CoordSys_X); // GLHudTextX.Text:='X '+
    Edit_YCoordinate.Text:=inttostr(CoordSys_Y);
    Edit_ZCoordinate.Text:=inttostr(CoordSys_Z); // +' '+inttostr(CurPos);

  except
    GLSphere1.Visible:=False;
  end;

  If (TOOL=tKCM_TexturePaint) or (TOOL=tKSM_PaintBrush) then
  begin
    GLHeightField.Material.MaterialOptions:=[moNoLighting];
  end
  else
  begin
    GLHeightField.Material.MaterialOptions:=[];
  end;

  // Removed Vlad
  //Making sure no crazy shit happends
  //If (ssRight in shift) and (ssLeft in shift) then
  //begin
  //  Abort;
  //end;
  //Positioning the Sphere

  If (ssCtrl in shift) then
  begin
    // Change Background color
    If Chk_Wireframe.Checked=True then
    begin
      // Do nothing
    end
    else
    begin
      GLSceneViewer.Buffer.BackgroundColor:=clBackground;
    end;

    if Chk_ShowWater.Checked=True then begin
      GLFreeForm_water.Visible:=False;
    end;
    GLSkyBox1.Visible:=False;
    If Chk_CameraAxis.Enabled=True then begin
      GLDummyCube.ShowAxes:=False;
    end;

    GlSphere1.Position.X:=v[0];
    GLSphere1.Position.Y:=v[1];

    //Working when GLSphere1.Owner = HeightField
    //GlSphere1.Position.X:=v[0];
    //GLSphere1.Position.Y:=v[1];
    If (v[0]>0) and (v[0]<255) and (v[1]>0) and (v[1]<255) then
    begin
      GlSphere1.Position.Z:=-KCM.HeightMap[round(v[0])][round(v[1])]/32; //-round(32*-v[2])/32;
      //GlSphere1.Position.Z:=-round(32*-v[2])/32; //-KCM.HeightMap[round(v[0])][round(v[1])]/32;
    end;

    //Showing or hiding the sphere, depending on the tool
    GLSphere1.Visible:=True;

    If (Tool=tOPL_X) or (Tool=tOPL_Y) or (Tool=null) or (tool=tOPL_AddNode) or (tool=tOPL_Z) or (tool=tOPL_XYZ) then
    begin
      GLSphere1.Visible:=False;
      for o:=0 to Length(Selected_OPLs)-1 do
            begin
              shader1:=TOutLineShader.Create(Self);
              with shader1 do begin
                BackgroundColor:=ConvertWinColor(GLSceneViewer.Buffer.BackgroundColor);
                Outlinesmooth:=false;
                OutLineWidth:=4;
                Lighting:=true;
                LineColor:=clrRed;
              end;
              model:=TGLFreeForm(GLDummyCube_OPLObjects.Children[Selected_OPLs[o].Index]);
              //model.Material.LibMaterialName:=Selected_OPLs[j].Tex;
              GLMaterialLibrary2.Materials[0].Shader:=shader1;
              //model.Material.LibMaterialName:='';
              //model.Material.frontproperties.emission.color:=clrBlue;
              model.Material.MaterialLibrary:=GLMaterialLibrary2;
              model.Material.LibMaterialName:='Outline';
              //model.Material.LibMaterialName:=Selected_OPLs[j].Tex;
      end;
    end;

    If TOOL=tKCM_TexturePaint then
    begin
      GLDummyCube_OPLObjects.Visible:=False;
    end;
    // Placing OPL Objects
    If (tool=tOPL_AddNode) then
    begin
    OPLNode:=TOPLNode.Create;

    Vector3F[0]:=u[0]/256;
    Vector3F[1]:=((256-u[2]))/256;
    Vector3F[2]:=KCM.HeightMap[round(u[0])][round(u[2])];
    OPLNode.Position:=Vector3F;

    Vector3F[0]:=1;
    Vector3F[1]:=1;
    Vector3F[2]:=1;
    OPLNode.Scale:=Vector3F;

    Vector4F[0]:=0;
    Vector4F[1]:=0;
    Vector4F[2]:=0;
    Vector4F[3]:=0;
    OPLNode.Rotation:=Vector4F;
    //If Edit_OPL_Model.Text<>nil then begin
      //OPL.Node
    //end;
    OPL.AddObject(OPLNode);
    OPL.ObjectCount;
    If (ssLeft in Shift) then
    begin
    PositionOPLNode(OPL.ObjectCount-1,True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
    end;

    // If the key: Control isnt pressed then terminate the tool.
    if (GetKeyState(vk_Control)and 128)<>128 then
    begin
      tool:=tool_Old;
    end;
    end;

    // OPL Positioning
    If (Tool=tOPL_X) or (Tool=tOPL_Y) or (Tool=tOPL_Z) or (Tool=tOPL_XYZ) then
    begin
      GLSceneViewer.Cursor:=crHandPoint;
      //Geting pos of first selected node...
      Vector3F:=OPL.Node[Selected_OPLs[0].Index].Position;

      //Detla x and y
      dx:=(u[0]/256)-(c[0]/256);//-Vector3F[0];
      dy:=(1-(u[2]/256))-(1-(c[2]/256));//-Vector3F[1];

      If (ssMiddle in shift) then
      begin
        //OPLScale----------------------------------------------------------------
        // If 1 Selected
        If Length(Selected_OPLs)=1 then
        begin
          //Loading the scale, editing it and applying it back at the node..
          Vector3F:=OPL.Node[Selected_OPLs[0].Index].Scale;
          If ((Vector3F[0]+((ViewX-X)*0.0001))>0) and ((Vector3F[1]+((ViewX-X)*0.0001))>0) and ((Vector3F[2]+((ViewX-X)*0.0001))>0)then
          begin
            Vector3F[0]:=Vector3F[0]+((ViewX-X)*0.0001);
            Vector3F[1]:=Vector3F[1]+((ViewX-X)*0.0001);
            Vector3F[2]:=Vector3F[2]+((ViewX-X)*0.0001);
          end
          else
          begin
            Vector3F[0]:=0;
            Vector3F[1]:=0;
            Vector3F[2]:=0;
          end;

          //Saving the new scale
          OPL.Node[Selected_OPLs[0].Index].Scale:=Vector3F;

          //Repositioning the node
          PositionOPLNode(Selected_OPLs[0].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

          //Displaying the new info;
          DisplayOPLNodeInfo(Selected_OPLs);
        end
        else
        begin
          If Length(Selected_OPLs)=0 then
          begin
            exit;
          end;

          //Caclculating new center if needed
          If UseOldCenter=False then
          begin
            UseOldCenter:=True;

            Center:=OPL.Node[Selected_OPLs[0].Index].Position;
            If Length(Selected_OPLs)>1 then
            begin
              For x1:=1 to Length(Selected_OPLs)-1 do
              begin
                Center[0]:=(Center[0]+OPL.Node[Selected_OPLs[x1].Index].Position[0])/2;
                Center[1]:=(Center[1]+OPL.Node[Selected_OPLs[x1].Index].Position[1])/2;
                Center[2]:=(Center[2]+OPL.Node[Selected_OPLs[x1].Index].Position[2])/2;
              end;
            end;
          end;

          //Appling to all nodes...
          For x1:=0 to Length(Selected_OPLs)-1 do
          begin
            Vector3F:=OPL.Node[Selected_OPLs[x1].Index].Scale;
            If ((Vector3F[0]+((ViewX-X)*0.0001))>0) and ((Vector3F[1]+((ViewX-X)*0.0001))>0) and ((Vector3F[2]+((ViewX-X)*0.0001))>0)then
            begin
              Vector3F[0]:=Vector3F[0]+((ViewX-X)*0.0001);
              Vector3F[1]:=Vector3F[1]+((ViewX-X)*0.0001);
              Vector3F[2]:=Vector3F[2]+((ViewX-X)*0.0001);

              //Calculating delta distance.. ( note the switched x/y because of the matrix... )
              y2:=OPL.Node[Selected_OPLs[x1].Index].Position[0]-Center[0];
              x2:=OPL.Node[Selected_OPLs[x1].Index].Position[1]-Center[1];
              z2:=OPL.Node[Selected_OPLs[x1].Index].Position[2]-Center[2];

              //Calculating the ratio between the old Distance to center, and Scale
              j:=OPL.Node[Selected_OPLs[x1].Index].Scale[0]/y2;
              i:=OPL.Node[Selected_OPLs[x1].Index].Scale[1]/x2;
              w:=OPL.Node[Selected_OPLs[x1].Index].Scale[2]/z2;

              //Saving the Scale, loading the position
              OPL.Node[Selected_OPLs[x1].Index].Scale:=Vector3F;
              Vector3F:=OPL.Node[Selected_OPLs[x1].Index].Position;

              //Editing the position thanks to the ratio...
              Vector3F[0]:=Center[0]+(j*OPL.Node[Selected_OPLs[x1].Index].Scale[0]);
              Vector3F[1]:=Center[1]+(i*OPL.Node[Selected_OPLs[x1].Index].Scale[1]);
              Vector3F[2]:=Center[2]+(w*OPL.Node[Selected_OPLs[x1].Index].Scale[2]);

              //Saving the position
              OPL.Node[Selected_OPLs[x1].Index].Position:=Vector3F;
            end
            else
            begin
              Vector3F[0]:=0;
              Vector3F[1]:=0;
              Vector3F[2]:=0;
            end;
            PositionOPLNode(Selected_OPLs[x1].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

          end;
        end;
      end;
      {
      If ((ssRight in shift) and not (ssLeft in shift)) and (Tool=tOPL_XYZ) then
      begin
        If Length(Selected_OPLs)=1 then
        begin
          //Creating new data
          Vector4F:=OPL.Node[Selected_OPLs[0].Index].Rotation;
          Vector4F[1]:=sin(ArcSin(Vector4F[1])+((ViewX-X)*0.00004));
          Vector4F[2]:=sin(ArcSin(Vector4F[2])+(-(ViewX-X)*0.00004));
          Vector4F[3]:=Cos(ArcSin(Vector4F[1]));

          If (Vector4F[1]>0.9999) then
          begin
            Vector4F[1]:=-0.9999;
            Vector4F[3]:=Cos(ArcSin(Vector4F[1]));
          end
          else
          begin
            If (Vector4F[1]<-0.9999) then
            begin
              Vector4F[1]:=0.9999;
              Vector4F[3]:=Cos(ArcSin(Vector4F[1]));
            end;
          end;
          //Saving the newly created data
          OPL.Node[Selected_OPLs[0].Index].Rotation:=Vector4F;

          PositionOPLNode(Selected_OPLs[0].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

          //Displaying the new info;
          DisplayOPLNodeInfo(Selected_OPLs);
        end
        else
        begin
          If Length(Selected_OPLs)=0 then
          begin
            exit;
          end;

          //Caclculating new center if needed
          If UseOldCenter=False then
          begin
            UseOldCenter:=True;

            Center:=OPL.Node[Selected_OPLs[0].Index].Position;
            If Length(Selected_OPLs)>1 then
            begin
              For x1:=1 to Length(Selected_OPLs)-1 do
              begin
                Center[0]:=(Center[0]+OPL.Node[Selected_OPLs[x1].Index].Position[0])/2;
                Center[1]:=(Center[1]+OPL.Node[Selected_OPLs[x1].Index].Position[1])/2;
                Center[2]:=(Center[2]+OPL.Node[Selected_OPLs[x1].Index].Position[2])/2;
              end;
            end;
          end;

          //GLDummyCube.Children[0].Move
          //Appling to all nodes...
          For x1:=0 to Length(Selected_OPLs)-1 do
          begin
            //GLDummyCube_OPLObjects.Children[Selected_OPLs[x1].Index].Dis
            Vector3F:=OPL.Node[Selected_OPLs[x1].Index].Position;

            //Calculating delta distance.. ( notce the switched x/y because of the matrix... )
            y2:=OPL.Node[Selected_OPLs[x1].Index].Position[0]-Center[0];
            x2:=OPL.Node[Selected_OPLs[x1].Index].Position[1]-Center[1];

            //Calculating the real distance between the points
            s:=Sqrt((x2*x2)+(y2*y2));

            //Calculating the current rotation around the center, and adding some...
            i:=1;
            j:=1;
            If x2<0 then
            begin
              i:=-1;
              j:=-1;
            end;
            Vector3F[0]:=Center[0]+(s*(i*Sin((ArcTan(y2/x2))+((ViewX-X)*0.00004))));
            Vector3F[1]:=Center[1]+(s*(j*Cos((ArcTan(y2/x2))+((ViewX-X)*0.00004))));


            //Updating the rotation
            Vector4F:=OPL.Node[Selected_OPLs[x1].Index].Rotation;
            Vector4F[1]:=sin(ArcSin(Vector4F[1])+((ViewX-X)*0.00002));
            Vector4F[3]:=Cos(ArcSin(Vector4F[1]));

            If (Vector4F[1]>0.9999) then
            begin
              Vector4F[1]:=-0.9999;
              Vector4F[3]:=Cos(ArcSin(Vector4F[1]));
            end
            else
            begin
              If (Vector4F[1]<-0.9999) then
              begin
                Vector4F[1]:=0.9999;
                Vector4F[3]:=Cos(ArcSin(Vector4F[1]));
              end;
            end;

            //Saving the infos
            OPL.Node[Selected_OPLs[x1].Index].Rotation:=Vector4F;
            OPL.Node[Selected_OPLs[x1].Index].Position:=Vector3F;

            //Positioning the node..
            PositionOPLNode(Selected_OPLs[x1].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
          end;

          //Saving the newly created data
          OPL.Node[Selected_OPLs[0].Index].Rotation:=Vector4F;

          PositionOPLNode(Selected_OPLs[0].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

          //Displaying the new info;
          DisplayOPLNodeInfo(Selected_OPLs);
        end;
      end;
      }
      // OPL ROTATE Y
      If ((ssRight in shift) and not (ssLeft in shift)) and ((Tool=tOPL_Y) or (Tool=tOPL_XYZ)) then
      begin
        If Length(Selected_OPLs)=1 then
        begin
          //Creating new data
          Vector4F:=OPL.Node[Selected_OPLs[0].Index].Rotation;
          Vector4F[1]:=sin(ArcSin(Vector4F[1])+((ViewX-X)*0.00004));
          Vector4F[3]:=Cos(ArcSin(Vector4F[1]));

          If (Vector4F[1]>0.9999) then
          begin
            Vector4F[1]:=-0.9999;
            Vector4F[3]:=Cos(ArcSin(Vector4F[1]));
          end
          else
          begin
            If (Vector4F[1]<-0.9999) then
            begin
              Vector4F[1]:=0.9999;
              Vector4F[3]:=Cos(ArcSin(Vector4F[1]));
            end;
          end;
          //Saving the newly created data
          OPL.Node[Selected_OPLs[0].Index].Rotation:=Vector4F;

          PositionOPLNode(Selected_OPLs[0].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

          //Displaying the new info;
          DisplayOPLNodeInfo(Selected_OPLs);
        end
        else
        begin
          If Length(Selected_OPLs)=0 then
          begin
            exit;
          end;

          //Caclculating new center if needed
          If UseOldCenter=False then
          begin
            UseOldCenter:=True;

            Center:=OPL.Node[Selected_OPLs[0].Index].Position;
            If Length(Selected_OPLs)>1 then
            begin
              For x1:=1 to Length(Selected_OPLs)-1 do
              begin
                Center[0]:=(Center[0]+OPL.Node[Selected_OPLs[x1].Index].Position[0])/2;
                Center[1]:=(Center[1]+OPL.Node[Selected_OPLs[x1].Index].Position[1])/2;
                Center[2]:=(Center[2]+OPL.Node[Selected_OPLs[x1].Index].Position[2])/2;
              end;
            end;
          end;

          //GLDummyCube.Children[0].Move
          //Appling to all nodes...
          For x1:=0 to Length(Selected_OPLs)-1 do
          begin
            //GLDummyCube_OPLObjects.Children[Selected_OPLs[x1].Index].Dis
            Vector3F:=OPL.Node[Selected_OPLs[x1].Index].Position;

            //Calculating delta distance.. ( notce the switched x/y because of the matrix... )
            y2:=OPL.Node[Selected_OPLs[x1].Index].Position[0]-Center[0];
            x2:=OPL.Node[Selected_OPLs[x1].Index].Position[1]-Center[1];

            //Calculating the real distance between the points
            s:=Sqrt((x2*x2)+(y2*y2));

            //Calculating the current rotation around the center, and adding some...
            i:=1;
            j:=1;
            If x2<0 then
            begin
              i:=-1;
              j:=-1;
            end;
            Vector3F[0]:=Center[0]+(s*(i*Sin((ArcTan(y2/x2))+((ViewX-X)*0.00004))));
            Vector3F[1]:=Center[1]+(s*(j*Cos((ArcTan(y2/x2))+((ViewX-X)*0.00004))));


            //Updating the rotation
            Vector4F:=OPL.Node[Selected_OPLs[x1].Index].Rotation;
            Vector4F[1]:=sin(ArcSin(Vector4F[1])+((ViewX-X)*0.00002));
            Vector4F[3]:=Cos(ArcSin(Vector4F[1]));

            If (Vector4F[1]>0.9999) then
            begin
              Vector4F[1]:=-0.9999;
              Vector4F[3]:=Cos(ArcSin(Vector4F[1]));
            end
            else
            begin
              If (Vector4F[1]<-0.9999) then
              begin
                Vector4F[1]:=0.9999;
                Vector4F[3]:=Cos(ArcSin(Vector4F[1]));
              end;
            end;

            //Saving the infos
            OPL.Node[Selected_OPLs[x1].Index].Rotation:=Vector4F;
            OPL.Node[Selected_OPLs[x1].Index].Position:=Vector3F;

            //Positioning the node..
            PositionOPLNode(Selected_OPLs[x1].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
          end;

          //Saving the newly created data
          OPL.Node[Selected_OPLs[0].Index].Rotation:=Vector4F;

          PositionOPLNode(Selected_OPLs[0].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

          //Displaying the new info;
          DisplayOPLNodeInfo(Selected_OPLs);
        end;
      end;
      //OPLRotate--------------------------------------------------------------
      If ((ssRight in shift) and not (ssLeft in shift)) and ((Tool=tOPL_X) or (Tool=tOPL_XYZ)) then
      begin
        If Length(Selected_OPLs)=1 then
        begin
          //Creating new data
          Vector4F:=OPL.Node[Selected_OPLs[0].Index].Rotation;
          Vector4F[0]:=sin(ArcSin(Vector4F[0])+(-(ViewY-Y)*0.00004));
          Vector4F[3]:=Cos(ArcSin(Vector4F[0]));

          If (Vector4F[0]>0.9999) then
          begin
            Vector4F[0]:=-0.9999;
            Vector4F[3]:=Cos(ArcSin(Vector4F[0]));
          end
          else
          begin
            If (Vector4F[0]<-0.9999) then
            begin
              Vector4F[0]:=0.9999;
              Vector4F[3]:=Cos(ArcSin(Vector4F[0]));
            end;
          end;

          //Saving the newly created data
          OPL.Node[Selected_OPLs[0].Index].Rotation:=Vector4F;

          PositionOPLNode(Selected_OPLs[0].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

          //Displaying the new info;
          DisplayOPLNodeInfo(Selected_OPLs);
        end
        else
        begin
          If Length(Selected_OPLs)=0 then
          begin
            exit;
          end;

          //Caclculating new center if needed
          If UseOldCenter=False then
          begin
            UseOldCenter:=True;

            Center:=OPL.Node[Selected_OPLs[0].Index].Position;
            If Length(Selected_OPLs)>1 then
            begin
              For x1:=1 to Length(Selected_OPLs)-1 do
              begin
                Center[0]:=(Center[0]+OPL.Node[Selected_OPLs[x1].Index].Position[0])/2;
                Center[1]:=(Center[1]+OPL.Node[Selected_OPLs[x1].Index].Position[1])/2;
                Center[2]:=(Center[2]+OPL.Node[Selected_OPLs[x1].Index].Position[2])/2;
              end;
            end;
          end;

          //GLDummyCube.Children[0].Move
          //Appling to all nodes...
          For x1:=0 to Length(Selected_OPLs)-1 do
          begin
            //GLDummyCube_OPLObjects.Children[Selected_OPLs[x1].Index].Dis
            Vector3F:=OPL.Node[Selected_OPLs[x1].Index].Position;

            //Calculating delta distance.. ( notce the switched x/y because of the matrix... )
            y2:=OPL.Node[Selected_OPLs[x1].Index].Position[0]-Center[0];
            x2:=OPL.Node[Selected_OPLs[x1].Index].Position[1]-Center[1];

            //Calculating the real distance between the points
            s:=Sqrt((x2*x2)+(y2*y2));

            //Calculating the current rotation around the center, and adding some...
            i:=1;
            j:=1;
            If x2<0 then
            begin
              i:=-1;
              j:=-1;
            end;
            Vector3F[0]:=Center[0]+(s*(i*Sin((ArcTan(y2/x2))+((ViewX-X)*0.00004))));
            Vector3F[1]:=Center[1]+(s*(j*Cos((ArcTan(y2/x2))+((ViewX-X)*0.00004))));


            //Updating the rotation
            Vector4F:=OPL.Node[Selected_OPLs[x1].Index].Rotation;
            Vector4F[0]:=sin(ArcSin(Vector4F[0])+((ViewX-X)*0.00002));
            Vector4F[3]:=Cos(ArcSin(Vector4F[0]));

            If (Vector4F[1]>0.9999) then
            begin
              Vector4F[0]:=-0.9999;
              Vector4F[3]:=Cos(ArcSin(Vector4F[0]));
            end
            else
            begin
              If (Vector4F[0]<-0.9999) then
              begin
                Vector4F[0]:=0.9999;
                Vector4F[3]:=Cos(ArcSin(Vector4F[0]));
              end;
            end;

            //Saving the infos
            OPL.Node[Selected_OPLs[x1].Index].Rotation:=Vector4F;
            OPL.Node[Selected_OPLs[x1].Index].Position:=Vector3F;

            //Positioning the node..
            PositionOPLNode(Selected_OPLs[x1].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
          end;
        end;
      end;
      //OPLRotate--------------------------------------------------------------
      If ((ssRight in shift) and not (ssLeft in shift)) and ((Tool=tOPL_Z) or (Tool=tOPL_XYZ)) then
      begin
        If Length(Selected_OPLs)=1 then
        begin
          //Creating new data
          Vector4F:=OPL.Node[Selected_OPLs[0].Index].Rotation;
          Vector4F[2]:=sin(ArcSin(Vector4F[2])+(-(ViewX-X)*0.00004));
          Vector4F[3]:=Cos(ArcSin(Vector4F[2]));

          If (Vector4F[2]>0.9999) then
          begin
            Vector4F[2]:=-0.9999;
            Vector4F[3]:=Cos(ArcSin(Vector4F[2]));
          end
          else
          begin
            If (Vector4F[2]<-0.9999) then
            begin
              Vector4F[2]:=0.9999;
              Vector4F[3]:=Cos(ArcSin(Vector4F[2]));
            end;
          end;

          //Saving the newly created data
          OPL.Node[Selected_OPLs[0].Index].Rotation:=Vector4F;

          PositionOPLNode(Selected_OPLs[0].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

          //Displaying the new info;
          DisplayOPLNodeInfo(Selected_OPLs);
        end
        else
        begin
          If Length(Selected_OPLs)=0 then
          begin
            exit;
          end;

          //Caclculating new center if needed
          If UseOldCenter=False then
          begin
            UseOldCenter:=True;

            Center:=OPL.Node[Selected_OPLs[0].Index].Position;
            If Length(Selected_OPLs)>1 then
            begin
              For x1:=1 to Length(Selected_OPLs)-1 do
              begin
                Center[0]:=(Center[0]+OPL.Node[Selected_OPLs[x1].Index].Position[0])/2;
                Center[1]:=(Center[1]+OPL.Node[Selected_OPLs[x1].Index].Position[1])/2;
                Center[2]:=(Center[2]+OPL.Node[Selected_OPLs[x1].Index].Position[2])/2;
              end;
            end;
          end;

          //GLDummyCube.Children[0].Move
          //Appling to all nodes...
          For x1:=0 to Length(Selected_OPLs)-1 do
          begin
            //GLDummyCube_OPLObjects.Children[Selected_OPLs[x1].Index].Dis
            Vector3F:=OPL.Node[Selected_OPLs[x1].Index].Position;

            //Calculating delta distance.. ( notce the switched x/y because of the matrix... )
            y2:=OPL.Node[Selected_OPLs[x1].Index].Position[0]-Center[0];
            x2:=OPL.Node[Selected_OPLs[x1].Index].Position[2]-Center[2];

            //Calculating the real distance between the points
            s:=Sqrt((x2*x2)+(y2*y2));

            //Calculating the current rotation around the center, and adding some...
            i:=1;
            j:=1;
            If x2<0 then
            begin
              i:=-1;
              j:=-1;
            end;
            Vector3F[0]:=Center[0]+(s*(i*Sin((ArcTan(y2/x2))+((ViewX-X)*0.00004))));
            Vector3F[2]:=Center[2]+(s*(j*Cos((ArcTan(y2/x2))+((ViewX-X)*0.00004))));


            //Updating the rotation
            Vector4F:=OPL.Node[Selected_OPLs[x1].Index].Rotation;
            Vector4F[2]:=sin(ArcSin(Vector4F[2])+((ViewX-X)*0.00002));
            Vector4F[3]:=Cos(ArcSin(Vector4F[2]));

            If (Vector4F[2]>0.9999) then
            begin
              Vector4F[2]:=-0.9999;
              Vector4F[3]:=Cos(ArcSin(Vector4F[2]));
            end
            else
            begin
              If (Vector4F[2]<-0.9999) then
              begin
                Vector4F[2]:=0.9999;
                Vector4F[3]:=Cos(ArcSin(Vector4F[2]));
              end;
            end;

            //Saving the infos
            OPL.Node[Selected_OPLs[x1].Index].Rotation:=Vector4F;
            OPL.Node[Selected_OPLs[x1].Index].Position:=Vector3F;

            //Positioning the node..
            PositionOPLNode(Selected_OPLs[x1].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
          end;
        end;
      end;
      //OPLPosition   UP-DOWN ----------------------------------------------------------------
      If (ssRight in shift) and (ssLeft in shift) and (ssLeft in Shift) and (v[0]>0) and (v[0]<255) and (v[1]>0) and (v[1]<255) then
      begin
        For x1:=0 to Length(Selected_OPLs)-1 do
            begin
              //Loading the position, editing it and applying it back at the node..
              Vector3F:=OPL.Node[Selected_OPLs[x1].Index].Position;

              Vector3F[2]:=Vector3F[2]+((ViewY-Y)/35);

              OPL.Node[Selected_OPLs[x1].Index].Position:=Vector3F;

              PositionOPLNode(Selected_OPLs[x1].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

              DisplayOPLNodeInfo(Selected_OPLs);
            end;
            c:=u;
      end // End if Left and Right Click pressed
      else
      //OPLPosition   LEFT-RIGHT ----------------------------------------------------------------
      If (ssLeft in shift) and not (ssRight in shift) and (ssLeft in Shift) and (v[0]>0) and (v[0]<255) and (v[1]>0) and (v[1]<255) then
      begin
        For x1:=0 to Length(Selected_OPLs)-1 do
            begin
              //Loading the position, editing it and applying it back at the node..
              Vector3F:=OPL.Node[Selected_OPLs[x1].Index].Position;

              Vector3F[0]:=Vector3F[0]+dX;
              Vector3F[1]:=Vector3F[1]+dY;

              If CheckBox_OPL_Position_STM.Checked=True then
              begin
                Vector3F[2]:=KCM.HeightMap[round(Vector3F[0]*256)][round(256-(Vector3F[1]*256))];
              end;

              OPL.Node[Selected_OPLs[x1].Index].Position:=Vector3F;

              PositionOPLNode(Selected_OPLs[x1].Index,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

              DisplayOPLNodeInfo(Selected_OPLs);
            end;
            c:=u;
      end;
    end  // End OPL
    else

    // If SHIFT and CLICK pressed
    If (ssShift in Shift) and (ssLeft in Shift) and (v[0]>0) and (v[0]<255) and (v[1]>0) and (v[1]<255) then
    begin
    //Getting all coords heights...
      maxX:= round(GLSphere1.Position.x+(GLSphere1.Radius*GLSphere1.Scale.X));
      maxY:= round(GLSphere1.Position.y+(GLSphere1.Radius*GLSphere1.Scale.Y));

      minX:= round(GLSphere1.Position.x-(GLSphere1.Radius*GLSphere1.Scale.X));
      minY:= round(GLSphere1.Position.y-(GLSphere1.Radius*GLSphere1.Scale.y));

      //Putting locks on the range
      If maxX>255 then begin
        maxX:=256;
        If CheckBox_LockBorders.Checked=True then
        begin
          maxX:=255;
        end;
        If Tool=tKSM_PaintBrush then
        begin
          maxX:=MaxX-1;
        end;
      end;
      If maxY>255 then begin
        maxY:=256;
        If CheckBox_LockBorders.Checked=True then
        begin
          maxY:=255;
        end;
        If Tool=tKSM_PaintBrush then
        begin
          maxY:=MaxY-1;
        end;
      end;
      If minX<1 then begin
        minX:=0;
        If CheckBox_LockBorders.Checked=True then
        begin
          minX:=1;
        end;
      end;
      If minY<1 then begin
        minY:=0;
        If CheckBox_LockBorders.Checked=True then
        begin
          minY:=1;
        end;
      end;
      If (TOOL=tKCM_HeightBrush) or (TOOL=tKCM_SetHeight) or (TOOL=tKCM_Flatten) then
      begin
        Try
          KCMHeightMap:=KCM.HeightMap;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;

              //Calculating the real distance between the points
              s:=Sqrt((x2*x2)+(y2*y2));

              If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s)then
              begin
                cnt:=0;
                w:=0;
                If (x1+1>=0) and (x1+1<=256) and (y1+1>=0) and (y1+1<=256)then
                begin
                  w:=w+KCM.HeightMap[x1+1][y1+1];
                  cnt:=cnt+1;
                end;
                If (x1  >=0) and (x1  <=256) and (y1+1>=0) and (y1+1<=256)then
                begin
                  w:=w+KCM.HeightMap[x1][y1+1];
                  cnt:=cnt+1;
                end;
                If (x1-1>=0) and (x1-1<=256) and (y1+1>=0) and (y1+1<=256)then
                begin
                  w:=w+KCM.HeightMap[x1-1][y1+1];
                  cnt:=cnt+1;
                end;
                If (x1+1>=0) and (x1+1<=256) and (y1  >=0) and (y1  <=256)then
                begin
                  w:=w+KCM.HeightMap[x1+1][y1];
                  cnt:=cnt+1;
                end;
                If (x1-1>=0) and (x1-1<=256) and (y1  >=0) and (y1  <=256)then
                begin
                  w:=w+KCM.HeightMap[x1-1][y1];
                  cnt:=cnt+1;
                end;
                If (x1+1>=0) and (x1+1<=256) and (y1-1>=0) and (y1-1<=256)then
                begin
                  w:=w+KCM.HeightMap[x1+1][y1-1];
                  cnt:=cnt+1;
                end;
                If (x1  >=0) and (x1  <=256) and (y1-1>=0) and (y1-1<=256)then
                begin
                  w:=w+KCM.HeightMap[x1][y1-1];
                  cnt:=cnt+1;
                end;
                If (x1-1>=0) and (x1-1<=256) and (y1-1>=0) and (y1-1<=256)then
                begin
                  w:=w+KCM.HeightMap[x1-1][y1-1];
                  cnt:=cnt+1;
                end;

                w:=w/cnt;
                KCMHeightMap[x1][y1]:=round(w);
              end;
            end;
          end;
          KCM.HeightMap:=KCMHeightMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
          GLHeightFieldTwo.StructureChanged;
        except
        end;
      end;
    end
    else

    // If Ctrl and Right mouse button click
    If (ssRight in Shift) and (v[0]>0) and (v[0]<255) and (v[1]>0) and (v[1]<255) then
    begin
      //Getting all coords heights...
      maxX:= round(GLSphere1.Position.x+(GLSphere1.Radius*GLSphere1.Scale.X));
      maxY:= round(GLSphere1.Position.y+(GLSphere1.Radius*GLSphere1.Scale.Y));

      minX:= round(GLSphere1.Position.x-(GLSphere1.Radius*GLSphere1.Scale.X));
      minY:= round(GLSphere1.Position.y-(GLSphere1.Radius*GLSphere1.Scale.y));

      //Putting locks on the range
      If maxX>255 then begin
        maxX:=256;
        If CheckBox_LockBorders.Checked=True then
        begin
          maxX:=255;
        end;
        If Tool=tKSM_PaintBrush then
        begin
          maxX:=MaxX-1;
        end;
      end;
      If maxY>255 then begin
        maxY:=256;
        If CheckBox_LockBorders.Checked=True then
        begin
          maxY:=255;
        end;
        If Tool=tKSM_PaintBrush then
        begin
          maxY:=MaxY-1;
        end;
      end;
      If minX<1 then begin
        minX:=0;
        If CheckBox_LockBorders.Checked=True then
        begin
          minX:=1;
        end;
      end;
      If minY<1 then begin
        minY:=0;
        If CheckBox_LockBorders.Checked=True then
        begin
          minY:=1;
        end;
      end;
    //KCMHeight------------------------------------------------------------------------------
      If TOOL=tKCM_HeightBrush then
      begin
        //x1 & y1 will make sure we run every point in the radius.
        Try
          KCMHeightMap:=KCM.HeightMap;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;

              //Calculating the real distance between the points
              s:=Sqrt((x2*x2)+(y2*y2));
              If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
              begin
                //Getting the formulla set up right multiplyer*(10-((W*S)*(W*S)));
                w:=(((GLSphere1.Scale.X*GLSphere1.Radius)/2)/Sqrt(2))/(((GLSphere1.Scale.X*GLSphere1.Radius)/2)*((GLSphere1.Scale.X*GLSphere1.Radius)/2));
                multiply:=TrackBar_KCMHEIGHT_Intensity.Position/100;

                //Check and apply
                If round(KCM.Heightmap[x1][y1]-(multiply*(2-(Power(W*S,2))))) <= 0 then
                begin
                  KCMHeightMap[x1][y1]:= 0;
                end
                else
                begin
                  KCMHeightMap[x1][y1]:=round(KCMHeightMap[x1][y1]-(multiply*(2-(Power(W*S,2)))));
                end;
              end;
            end;
          end;
          KCM.HeightMap:=KCMHeightMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
          GLHeightFieldTwo.StructureChanged;
        except
        end;
      end;
      // Flatten ----------------------------------------------------------------------
      if TOOL=tKCM_Flatten then
      begin
        Try
          CurPos:=CoordSys_Z;
        except
        end;
      end;
      //KCMTexturePaint----------------------------------------------------------------
      //x1 & y1 will make sure we run every point in the radius.
      If TOOL=tKCM_TexturePaint then
      begin
        Try
          TextureMap:=KCM.TextureMapList;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;

              try
                TextureMap[CurTMap][x1][y1]:=Clamp(TextureMap[CurTMap][x1][y1]-(255-getRValue(FBrush.Canvas.Pixels[25+round(x2),25+round(y2)])));
              except
              end;
            end;
          end;

          KCM.TextureMapList:=TextureMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
        except
        end;
      end;
      //KCMGrassPaint----------------------------------------------------------------
      //x1 & y1 will make sure we run every point in the radius.
      If TOOL=tKCM_GrassPaint then
      begin
        Try
          ObjMap:=KCM.ObjectMap;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;

              //Calculating the real distance between the points
              s:=Sqrt((x2*x2)+(y2*y2));

              If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
              begin
                  If Random(round(200-Trackbar_KCMGrassPaint_Intensity.Position*3.99))=0 then
                  begin
                    ObjMap[x1][y1]:=0;
                  end;
              end;
            end;
          end;

          KCM.ObjectMap:=ObjMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
        except
        end;
      end;
      If TOOL=tKSM_PaintBrush then
      begin
        For x1:=MinX to MaxX do
        begin
          For y1:=MinY to MaxY do
          begin
            //x2 & y2 will represend the delta ( diffrence in ) distance.
            x2:=GLSphere1.Position.x-x1;
            y2:=GLSphere1.Position.y-y1;

            //Calculating the real distance between the points
            s:=Sqrt((x2*x2)+(y2*y2));

            If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
            begin
              If (Values[1]=0) and (Values[2]=0) then begin
                map[x1][y1][0]:=65535;
                map[x1][y1][1]:=0;
                map[x1][y1][2]:=KSM.ValuesToColor(65535,0);
              end else
              If (Values[1]=65535) and (Values[2]=0) then begin
                map[x1][y1][0]:=0;
                map[x1][y1][1]:=0;
                map[x1][y1][2]:=KSM.ValuesToColor(0,0);
              end;

              If (Values[1]=0) and (Values[2]>0) then begin
                map[x1][y1][0]:=0;
                map[x1][y1][1]:=0;
                map[x1][y1][2]:=KSM.ValuesToColor(0,0);
              end else
              If (Values[1]=65535) and (Values[2]>0) then begin
                map[x1][y1][0]:=65535;
                map[x1][y1][1]:=0;
                map[x1][y1][2]:=KSM.ValuesToColor(65535,0);
              end;
              //Using this way instead of "ServerMapToImage(KSM.Map,Image_General);" Because its 25x faster :)
              Image_General.Canvas.Pixels[x1,y1]:= map[x1][y1][2];
            end;
          end;
        end;
        KSM.Map:=map;
        KSM.Saved:=False;

        GLHeightField.StructureChanged;
      end;
    end
    else
    //Activating the Tools, if its moving, and the coords are in bound;
    If (ssLeft in Shift) and (v[0]>0) and (v[0]<255) and (v[1]>0) and (v[1]<255) then
    begin
      //Getting all coords heights...
      maxX:= round(GLSphere1.Position.x+(GLSphere1.Radius*GLSphere1.Scale.X));
      maxY:= round(GLSphere1.Position.y+(GLSphere1.Radius*GLSphere1.Scale.Y));

      minX:= round(GLSphere1.Position.x-(GLSphere1.Radius*GLSphere1.Scale.X));
      minY:= round(GLSphere1.Position.y-(GLSphere1.Radius*GLSphere1.Scale.y));

      //Putting locks on the range
      If Tool=tOPL_Position then
      begin
        maxX:= round(GLSphere1.Position.x+2);
        maxY:= round(GLSphere1.Position.y+2);

        minX:= round(GLSphere1.Position.x-2);
        minY:= round(GLSphere1.Position.y-2);
      end;

      //Putting locks on the range
      If maxX>255 then begin
        maxX:=256;
        If CheckBox_LockBorders.Checked=True then
        begin
          maxX:=255;
        end;
        If Tool=tKSM_PaintBrush then
        begin
          maxX:=MaxX-1;
        end;
      end;
      If maxY>255 then begin
        maxY:=256;
        If CheckBox_LockBorders.Checked=True then
        begin
          maxY:=255;
        end;
        If Tool=tKSM_PaintBrush then
        begin
          maxY:=MaxY-1;
        end;
      end;
      If minX<1 then begin
        minX:=0;
        If CheckBox_LockBorders.Checked=True then
        begin
          minX:=1;
        end;
      end;
      If minY<1 then begin
        minY:=0;
        If CheckBox_LockBorders.Checked=True then
        begin
          minY:=1;
        end;
      end;

      //KSMBrush------------------------------------------------------------------------------
      If TOOL=tKSM_PaintBrush then
      begin
        For x1:=MinX to MaxX do
        begin
          For y1:=MinY to MaxY do
          begin
            //x2 & y2 will represend the delta ( diffrence in ) distance.
            x2:=GLSphere1.Position.x-x1;
            y2:=GLSphere1.Position.y-y1;

            //Calculating the real distance between the points
            s:=Sqrt((x2*x2)+(y2*y2));

            If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
            begin
              map[x1][y1][0]:=Values[1];
              map[x1][y1][1]:=Values[2];
              map[x1][y1][2]:=KSM.ValuesToColor(Values[1],Values[2]);

              //Using this way instead of "ServerMapToImage(KSM.Map,Image_General);" Because its 25x faster :)
              Image_General.Canvas.Pixels[x1,y1]:= map[x1][y1][2];
            end;
          end;
        end;
        KSM.Map:=map;
        KSM.Saved:=False;

        GLHeightField.StructureChanged;
      end;
      //KCMFlatten------------------------------------------------------------------------------
      If TOOL=tKCM_Flatten then
      begin
        Try
          KCMHeightMap:=KCM.HeightMap;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;

              //Calculating the real distance between the points
              s:=Sqrt((x2*x2)+(y2*y2));

              If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
              begin
                Try
                  //map[x1][y1]:=StrToInt(Edit_KCMSetHeight_Height.Text);
                  //if Chk_Ramp.Enabled then begin
                 //   g:=CoordSys_Z-KCMHeightMap[x1][y1]; //4500-KCMHeightMap[x1][y1];
                 // end else begin
                    g:=CurPos-KCMHeightMap[x1][y1];
                 // end;

                  KCMHeightMap[x1][y1]:=KCMHeightMap[x1][y1]+round(g*0.2);
                except
                end;
              end;
            end;
          end;
          KCM.HeightMap:=KCMHeightMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
          GLHeightFieldTwo.StructureChanged;
        except
        end;
      end;
      //KCMSetHeight------------------------------------------------------------------------------
      //x1 & y1 will make sure we run every point in the radius.
      If TOOL=tKCM_SetHeight then
      begin
        Try
          KCMHeightMap:=KCM.HeightMap;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;

              //Calculating the real distance between the points
              s:=Sqrt((x2*x2)+(y2*y2));
              If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
              begin
                Try
                  //map[x1][y1]:=StrToInt(Edit_KCMSetHeight_Height.Text);
                  g:=StrToInt(Edit_KCMHEIGHT_Hardness.Text)-KCMHeightMap[x1][y1];

                  KCMHeightMap[x1][y1]:=KCMHeightMap[x1][y1]+round(g*0.2);
                except
                end;
              end;
            end;
          end;
          KCM.HeightMap:=KCMHeightMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
          GLHeightFieldTwo.StructureChanged;
        except
        end;
      end;

      //KCMHeight------------------------------------------------------------------------------
      If TOOL=tKCM_HeightBrush then
      begin
        //x1 & y1 will make sure we run every point in the radius.
        Try
          KCMHeightMap:=KCM.HeightMap;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;

              //Calculating the real distance between the points
              s:=Sqrt((x2*x2)+(y2*y2));

              //If (RadioButton_KCMHEIGHT_UP.Checked=True) AND ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
              If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
              begin
                //Getting the formulla set up right multiplyer*(10-((W*S)*(W*S)));
                w:=(((GLSphere1.Scale.X*GLSphere1.Radius)/2)/Sqrt(2))/(((GLSphere1.Scale.X*GLSphere1.Radius)/2)*((GLSphere1.Scale.X*GLSphere1.Radius)/2));
                multiply:=TrackBar_KCMHEIGHT_Intensity.Position/100;

                //Check and apply
                If round(KCM.HeightMap[x1][y1]+(multiply*(2-(Power(W*S,2))))) > 65534 then
                begin
                  KCMHeightMap[x1][y1]:=  65534;
                end
                else
                begin
                  KCMHeightMap[x1][y1]:=round(KCMHeightMap[x1][y1]+(multiply*(2-(Power(W*S,2)))));    // +(255-getRValue(FBrush.Canvas.Pixels[25+round(x2),25+round(y2)]))
                end;
              end;
            end;
          end;
          KCM.HeightMap:=KCMHeightMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
          GLHeightFieldTwo.StructureChanged;
        except
        end;
      end;

      //KCMMove Map------------------------------------------------------------------------------
      If TOOL=tKCM_WholeMap then
      begin
        //x1 & y1 will make sure we run every point in the radius.
        Try
          KCMHeightMap:=KCM.HeightMap;
          If CheckBox_LockBorders.Checked=True then
          begin
            i:=1;
          end
          else
          begin
            i:=0;
          end;

          s:=(ViewY-Y)*1;

          For x1:=round(0+i) to round(256-i) do
          begin
            For y1:=round(0+i) to round(256-i) do
            begin
              If round(KCMHeightMap[x1][y1]+s)>=65534 then
              begin
                KCMHeightMap[x1][y1]:=65534;
              end
              else
              begin
                If round(KCMHeightMap[x1][y1]+s)<=0 then
                begin
                  KCMHeightMap[x1][y1]:=0;
                end
                else
                begin
                  KCMHeightMap[x1][y1]:=round(KCMHeightMap[x1][y1]+s);
                end;
              end;
            end;
          end;
          KCM.HeightMap:=KCMHeightMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
          GLHeightFieldTwo.StructureChanged;
        except
        end;
      end;
      //KCMColormap--------------------------------------------------------------------
      If TOOL=tKCM_Colormap then
      begin
        mapc:=KCM.ColorMap;
        For x1:=MinX to MaxX do
        begin
          For y1:=MinY to MaxY do
          begin
            //x2 & y2 will represend the delta ( diffrence in ) distance.
            x2:=GLSphere1.Position.x-x1;
            y2:=GLSphere1.Position.y-y1;

            //Calculating the real distance between the points
            s:=Sqrt((x2*x2)+(y2*y2));

            If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
            begin
              //Creating color map
              mapc[x1][y1][2]:=Blend( GetBValue(mapc[x1][y1][2]), GetBValue(rgbcolor), TrackBar_KCMTEX_Intensity.Position*8 ); //FBrush.Canvas.Pixels[25+round(x2),25+round(y2)]));
              mapc[x1][y1][1]:=Blend( GetGValue(mapc[x1][y1][1]), GetGValue(rgbcolor), TrackBar_KCMTEX_Intensity.Position*8 ); //FBrush.Canvas.Pixels[25+round(x2),25+round(y2)]));
              mapc[x1][y1][0]:=Blend( GetRValue(mapc[x1][y1][0]), GetRValue(rgbcolor), TrackBar_KCMTEX_Intensity.Position*8 ); //FBrush.Canvas.Pixels[25+round(x2),25+round(y2)]));
            end;
          end;
        end;
        KCM.ColorMap:=mapc;
        KCM.Saved:=False;
        //GLHeightField.OnGetHeight:=GLHeightFieldPaintColormap;
        GLHeightField.StructureChanged;
      end;
      //KCMTexturePaint----------------------------------------------------------------
      //x1 & y1 will make sure we run every point in the radius.
      If TOOL=tKCM_TexturePaint then
      begin
        Try
          TextureMap:=KCM.TextureMapList;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;
              try
                TextureMap[CurTMap][x1][y1]:=Clamp(TextureMap[CurTMap][x1][y1]+(255-getRValue(FBrush.Canvas.Pixels[25+round(x2),25+round(y2)])));
              except
              end;
            end;
          end;
          KCM.TextureMapList:=TextureMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
        except
        end;
      end;
      //KCMTexturePaint----------------------------------------------------------------
      //x1 & y1 will make sure we run every point in the radius.
      If TOOL=tKCM_GrassPaint then
      begin
        Try
          ObjMap:=KCM.ObjectMap;
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;

              //Calculating the real distance between the points
              s:=Sqrt((x2*x2)+(y2*y2));

              If ((GLSphere1.Scale.X*GLSphere1.Radius)>= s) then
              begin
                  If (Chk_Random.Checked=True) and (Random(200-Trackbar_KCMGrassPaint_Intensity.Position*3)=0) then
                  begin
                    cnt:=Random(TrackBar_KCMGrassPaint_Type.Position);
                    If cnt<>0 then
                    begin
                      ObjMap[x1][y1]:=cnt;
                    end;
                  end else
                  If (Chk_Random.Checked=False) and (Random(200-Trackbar_KCMGrassPaint_Intensity.Position*3)=0) then
                  begin
                    If TrackBar_KCMGrassPaint_Type.Position<>0 then
                    begin
                      ObjMap[x1][y1]:=TrackBar_KCMGrassPaint_Type.Position;
                    end;
                  end;
              end;
            end;
          end;

          KCM.ObjectMap:=ObjMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
        except
        end;
      end;
      //KCMBrushPaint----------------------------------------------------------------
      //x1 & y1 will make sure we run every point in the radius.
      If TOOL=tKCM_BrushPaint then
      begin
        Try
          KCMHeightMap:=KCM.HeightMap;
          Image_General.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'\Recources\Brush01.bmp');
          For x1:=MinX to MaxX do
          begin
            For y1:=MinY to MaxY do
            begin
              //x2 & y2 will represend the delta ( diffrence in ) distance.
              x2:=GLSphere1.Position.x-x1;
              y2:=GLSphere1.Position.y-y1;
              multiply:=TrackBar_KCMHEIGHT_Intensity.Position/100;
              try
                KCMHeightMap[x1][y1]:=round(multiply*getRValue(Image_General.Canvas.Pixels[round(x2),round(y2)])/256)+(round(KCMHeightMap[x1][y1]));
              except
              end;
            end;
          end;
          KCM.HeightMap:=KCMHeightMap;
          KCM.Saved:=False;
          GLHeightField.StructureChanged;
          GLHeightFieldTwo.StructureChanged;
        except
        end;
      end;

      //OPLAddNode--------------------------------------------------------------
      If Tool=tOPL_AddNode then
      begin
        GLSceneViewer.Hint:='Click here to place the new node';
        Point.X:=X;
        Point.Y:=Y;
        Point:=GLSceneViewer.ClientToScreen(Point);
        Application.ActivateHint(Point) ;
      end;

      //Sticking OPL's on KCM when editing KCM ---------------------------------
      If (tool=tKCM_HeightBrush) or (tool=tKCM_SetHeight) or (tool=tKCM_Flatten) or (tool=tKCM_Smooth) or (tool=tKCM_WholeMap) then
      begin
        If (CheckBox_StickOPLtoKCM.Checked=True) then
        begin
          for x1:=0 to OPL.Header.ObjectCount-1 do
          begin
            try
              Vector3F:=OPL.Node[x1].Position;
              Vector3F[2]:=KCM.HeightMap[round(OPL.Node[x1].Position[0]*256)][round(256-(OPL.Node[x1].Position[1]*256))];

              OPL.Node[x1].Position:=Vector3F;

              PositionOPLNode(x1,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
            except
            end;
          end;
        end;
      end;
    end;
  //No CTRL pressed...
  end
  else
  begin
    // Change Background color
    If Chk_Wireframe.Checked=True then
    begin
      // Do nothing
    end else begin
      GLSceneViewer.Buffer.BackgroundColor:=clBtnFace;
    end;

    if Chk_ShowWater.Checked=True then begin
      GLFreeForm_water.Visible:=True;
    end else begin
      GLFreeForm_water.Visible:=False;
    end;

    GLSkyBox1.Visible:=True;

    If CheckBox_ShowOPLNodes.Checked=True then begin
      GLDummyCube_OPLObjects.Visible:=True;
    end else begin
      GLDummyCube_OPLObjects.Visible:=False;
    end;

    If (Chk_CameraAxis.Checked=False) and (GLDummyCube.ShowAxes=True) then begin
      GLDummyCube.ShowAxes:=False
    end else
    If (Chk_CameraAxis.Checked=True) and (GLDummyCube.ShowAxes=False) then begin
      GLDummyCube.ShowAxes:=True
    end;
    
    // If Shift Pressed
    //If (GetKeyState(vk_Shift)and 128)=128 then
    //begin
      //Yeah.. Do nothing.
    //end
    // Else Control Camera
   // else
    //begin
    // Both Left and Right click are pressed
    If (ssLeft in Shift) AND (ssRight in Shift) then
      begin
         //Some security, before getting functions
          If ((GLCamera.Position.X-GLDummyCube.Position.X)=0) or ((GLCamera.Position.Z-GLDummyCube.Position.Z)=0) then
          begin
            //Security is needed to activate:
            If (GlCamera.Position.X-GLDummyCube.Position.X)=0 then
            begin
              helling:=999;
              invhelling:=0;
            end;


            If (GlCamera.Position.Z-GLDummyCube.Position.Z)=0 then
            begin
              invhelling:=999;
              helling:=0;
            end;
          end
          else
          begin
            //Getting the functions where the camera, and the dummy should move on
            helling     := ( GLCamera.Position.Z - GLDummyCube.Position.Z ) / ( GLCamera.Position.X - GLDummyCube.Position.X );
            invhelling  :=  - ( 1 / helling );
          end;

          //Getting the direction to move along the invfunction
          If (GLCamera.Position.X-GLDummyCube.Position.X)<0 then
          begin
            j:=-1;
          end
          else
          begin
            j:=1;
          end;

          //Calculating the amount as Y to put in the normal function,
          If helling=0 then
          begin
            moveY:=(ViewY-Y);
          end
          else
          begin
            moveY:=SQRT(Power((ViewY-Y),2)/(Power(helling,2)+1));
            If ((ViewY-Y) < 0) and (MoveY > 0) then
            begin
              moveY:=-moveY;
            end;
          end;

          //Zoom is involved too...
          moveY:=moveY*(GLCamera.DistanceToTarget/400);
        //Moving the camera and the dummy along the invfunction

        GlCamera.Position.Y:=GLCamera.Position.Y+(j*moveY);;
        GlDummyCube.Position.Y:=GLDummyCube.Position.Y+(j*moveY);
    end // End If both click are pressed
      // Else Move and rotate
    else
      // Rotate Camera (Sideways, X Y)
    If (ssRight in Shift) and not (ssLeft in Shift) then
      begin
        GLCamera.MoveAroundTarget((viewY - y)/2, (viewX - x)/2);  // GLCamera.DistanceToTarget/800
    end else
      // Move Camera (Left Click)
    if (ssLeft in Shift) and not (ssRight in Shift) then
      begin
          //Some security, before getting functions
          If ((GLCamera.Position.X-GLDummyCube.Position.X)=0) or ((GLCamera.Position.Z-GLDummyCube.Position.Z)=0) then
          begin
            //Security is needed to activate:
            If (GlCamera.Position.X-GLDummyCube.Position.X)=0 then
            begin
              helling:=999;
              invhelling:=0;
            end;


            If (GlCamera.Position.Z-GLDummyCube.Position.Z)=0 then
            begin
              invhelling:=999;
              helling:=0;
            end;
          end
          else
          begin
            //Getting the functions where the camera, and the dummy should move on
            helling     := ( GLCamera.Position.Z - GLDummyCube.Position.Z ) / ( GLCamera.Position.X - GLDummyCube.Position.X );
            invhelling  :=  - ( 1 / helling );
          end;

          //Getting the direction to move along the function
          If (GLCamera.Position.Z -GLDummyCube.Position.Z)<0 then
          begin
            i:=1;
          end
          else
          begin
            i:=-1;
          end;

          //Getting the direction to move along the invfunction
          If (GLCamera.Position.X -GLDummyCube.Position.X)<0 then
          begin
            j:=-1;
          end
          else
          begin
            j:=1;
          end;

          //Calculating the amount as X to put in the normal function,
          If helling=0 then
          begin
            moveY:=(ViewY-Y);
          end
          else
          begin
            moveY:=SQRT(Power((ViewY-Y),2)/(Power(helling,2)+1));
            If ((ViewY-Y) < 0) and (MoveY > 0) then
            begin
              moveY:=-moveY;
            end;
          end;

          //Calculating the amount as X to put in the invurse function,
          If invhelling=0 then
          begin
            moveX:=-(ViewX-X);
          end
          else
          begin
            moveX:=SQRT(Power((ViewX-X),2)/(Power(invhelling,2)+1));
            If ((ViewX-X) > 0) and (MoveX > 0) then
            begin
              moveX:=-moveX;
            end;
          end;

          //Zoom is involved too...
          moveX:=moveX*(GLCamera.DistanceToTarget/400);
          moveY:=moveY*(GLCamera.DistanceToTarget/400);

          //Moving the camera and the dummy along the function
          GLCamera.Position.Z:=GLCamera.Position.Z+(j*(helling*moveY));
          GlCamera.Position.X:=GLCamera.Position.X+(j*moveY);
          GLDummyCube.Position.Z:=GLDummyCube.Position.Z+(j*(helling*moveY));
          GlDummyCube.Position.X:=GLDummyCube.Position.X+(j*moveY);

          //Moving the camera and the dummy along the invfunction
          GLCamera.Position.Z:=GLCamera.Position.Z+(i*(invhelling*moveX));
          GlCamera.Position.X:=GLCamera.Position.X+(i*moveX);
          GLDummyCube.Position.Z:=GLDummyCube.Position.Z+(i*(invhelling*moveX));
          GlDummyCube.Position.X:=GLDummyCube.Position.X+(i*moveX);
      end;  // End if Left click
    //end;
    ViewX := X; ViewY := Y;
  end;
end;

procedure TForm_Main.GLSceneViewerMouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  x1:Integer;
  u,v:TAffineVector;
  Vector3F:TVector3F;
  Vector4F:TVector4F;
  OPLNode:TOPLNode;
  //Point:TPoint;
  //node:integer;

  pick:TGLSceneObject;

  model:TGLFreeForm;
  shader1: TOutLineShader;
  i,j:Integer;
begin
  mx:=x; my:=y;
  //For rotation and scale...
  UseOldCenter:=False;

  viewX := x;
  viewY := y;

  u:=GLSceneViewer.Buffer.PixelRayToWorld(x, y);
  c:=u;

  //Ctrl-Z ( previous ) option
  If (ssCtrl in shift ) then
  begin
    For x1:=9 downto 1 do
    begin
      Previous_KCM[x1]:=Previous_KCM[x1-1];
    end;
    Previous_KCM[0]:=KCM.Heightmap;
  end;

  If (tool=tOPL_AddNode) and (Button=mbLeft) then
  begin
    OPLNode:=TOPLNode.Create;

    Vector3F[0]:=u[0]/256;
    Vector3F[1]:=((256-u[2]))/256;
    Vector3F[2]:=KCM.HeightMap[round(u[0])][round(u[2])];
    OPLNode.Position:=Vector3F;

    Vector3F[0]:=1;
    Vector3F[1]:=1;
    Vector3F[2]:=1;
    OPLNode.Scale:=Vector3F;

    Vector4F[0]:=0;
    Vector4F[1]:=0;
    Vector4F[2]:=0;
    Vector4F[3]:=0;
    OPLNode.Rotation:=Vector4F;

    OPL.AddObject(OPLNode);
    OPL.ObjectCount;

    //If Edit_OPL_Model.text<>nil then begin
    //  PositionOPLNode(OPL.ObjectCount-1,True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
    //end else begin
      PositionOPLNode(OPL.ObjectCount-1,True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
    //end;

    // If the key: Control isnt pressed then terminate the tool.
    if (GetKeyState(vk_Control)and 128)<>128 then
    begin
      tool:=tool_Old;
    end;
  end;

  If (tool=tOPL_X) or (tool=tOPL_Y) or (tool=tOPL_Z) or (tool=tOPL_XYZ) then
  begin
    If ((GetKeyState(vk_rbutton)and 128)=128 ) or ((GetKeyState(vk_Control)and 128)=128) then
    begin
      exit;
    end;
    if ((GetKeyState(VK_MBUTTON)and 128)=128) then begin
      //Pick is the clicked object..
      pick:=(GLSceneViewer.Buffer.GetPickedObject(x, y) as TGLSceneObject);

        //Searching for index of the OPL..
        for x1:=0 to GLDummyCube_OPLObjects.Count-1 do
        begin
          if pick=TGLSceneObject(GLDummyCube_OPLObjects.Children[x1]) then
          begin
            if (GetKeyState(vk_Shift)and 128)=128 then
            begin
              for j:=0 to Length(Selected_OPLs)-1 do
              begin
                If x1=Selected_OPLs[j].Index then
                begin
                  //Already got this index... so no need to extract the following code
                  abort;
                end;
              end;
              //Shift is holded, adding a new 'slot' for the node.
              SetLength(Selected_OPLs,Length(Selected_OPLs)+1);
              Selected_OPLs[Length(Selected_OPLs)-1].Index:=x1;
              Selected_OPLs[Length(Selected_OPLs)-1].Tex:=pick.Material.LibMaterialName;
            end
            else
            begin
              //Shift is not holded, reseting all the textures
              for j:=0 to Length(Selected_OPLs)-1 do
              begin
                model:=TGLFreeForm(GLDummyCube_OPLObjects.Children[Selected_OPLs[j].Index]);
                model.Material.LibMaterialName:=Selected_OPLs[j].Tex;
                model.Material.frontproperties.emission.color:=clrblack;
              end;

              //Setting the selected Nodes info
              SetLength(Selected_OPLs,1);
              Selected_OPLs[0].Index:=x1;
              Selected_OPLs[0].Tex:=Pick.Material.LibMaterialName
            end;


            //Overiding a red color, which indicates its selection.
            for j:=0 to Length(Selected_OPLs)-1 do
            begin
              shader1:=TOutLineShader.Create(Self);
              with shader1 do begin
                BackgroundColor:=ConvertWinColor(GLSceneViewer.Buffer.BackgroundColor);
                Outlinesmooth:=false;
                OutLineWidth:=4;
                Lighting:=true;
                LineColor:=clrRed;
              end;
              model:=TGLFreeForm(GLDummyCube_OPLObjects.Children[Selected_OPLs[j].Index]);
              //model.Material.LibMaterialName:=Selected_OPLs[j].Tex;
              GLMaterialLibrary2.Materials[0].Shader:=shader1;
              //model.Material.LibMaterialName:='';
              //model.Material.frontproperties.emission.color:=clrBlue;
              model.Material.MaterialLibrary:=GLMaterialLibrary2;
              model.Material.LibMaterialName:='Outline';
              //model.Material.LibMaterialName:=Selected_OPLs[j].Tex;
            end;

            DisplayOPLNodeInfo(Selected_OPLs);

            Abort;
          end;
      end;
    end;
  end;
end;

procedure TForm_Main.FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  If Screen.ActiveControl<>nil then
  begin
    Self.ActiveControl:=nil;
  end;
    //GLCamera.AdjustDistanceToTarget(1.0+(((GLCamera.DistanceToTarget/25)-(GLCamera.DistanceToTarget/50))/100));
  If (ssCtrl in Shift) then
  begin
    // Do something
  end
  else
  If not (ssCtrl in Shift) then
  begin
    GLCamera.AdjustDistanceToTarget(1.0+((10-(GLCamera.DistanceToTarget/50))/100));
  end;
end;

procedure TForm_Main.FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  If Screen.ActiveControl<>nil then
  begin
    Self.ActiveControl:=nil;
  end;
  //GLCamera.AdjustDistanceToTarget(0.9+(((GLCamera.DistanceToTarget/25)-(GLCamera.DistanceToTarget/50))/100));
  If (ssCtrl in Shift) then
  begin
    // Do something
  end
  else
  If not (ssCtrl in Shift) then
  begin
    GLCamera.AdjustDistanceToTarget(0.85+((10-(GLCamera.DistanceToTarget/50))/100));
  end;
end;


/////////////////////////////////////////
/////////////MainMenu_Clicks/////////////
/////////////////////////////////////////

procedure TForm_Main.MainMenu_File_LoadKCMFileClick(Sender: TObject);
var
  Openfiledialog:TOpenDialog;
  x,y:Integer;
  //status:extended;
begin
  Try
    OpenFileDialog:=TOpenDialog.Create(nil);
    OpenFileDialog.Filter:='Kal Client Maps (*.kcm)|*.kcm;|All files|*.*';
    OpenFileDialog.Title:='Open file...';
    OpenFileDialog.Options:=[ofHideReadOnly,ofEnableSizing];
    OpenFileDialog.InitialDir:=KCMInital_Path;
    If OpenFileDialog.Execute Then
    begin
      If FileExists(OpenFileDialog.FileName) = True then
      begin
        Try
          KCM.Free;
        except
        end;
        KCM:=TKalClientMap.Create;
        KCM.LoadFromFile(OpenFileDialog.FileName, 1);
        //KCM.LoadFromFile(OpenFileDialog.FileName, 2);
        //KCM.LoadFromFile(OpenFileDialog.FileName, 3);
        //KCM.LoadFromFile(OpenFileDialog.FileName, 4);
        //If KSM<>nil then
        //begin
          //If MessageBox(Handle, pchar('An KSM file has been loaded, want to paint the KCM file with it?'),'Paint?',MB_YESNO) = IDYES then
          //begin
            //Want to paint KSM on Heightmap
         //   GLHeightField.OnGetHeight:=GLHeightFieldPaintKSMmap;
         //   GLHeightField.StructureChanged;
         // end
         // else
         // begin
            //Dont want to paint KSM on Heightmap
        //    GLHeightField.OnGetHeight:=GLHeightFieldPaintColormap;
        //    GLHeightField.StructureChanged;
         // end;
        //end
        //else
        //begin
          //If no KSM is loaded painting color map
          GLHeightField.OnGetHeight:=GLHeightFieldPaintColormap;
          GLHeightField.StructureChanged;
        //end;
        ResetRealm;
      end;
    end;
  finally
    //ShowMessage(  ExtractFilePath(OpenFileDialog.FileName)+Copy(ExtractFileName(OpenFileDialog.FileName),0,Length(ExtractFileName(OpenFileDialog.FileName))-Length(ExtractFileExt(OpenFileDialog.FileName)))+'.opl');
    If FileExists(ExtractFilePath(OpenFileDialog.FileName)+Copy(ExtractFileName(OpenFileDialog.FileName),0,Length(ExtractFileName(OpenFileDialog.FileName))-Length(ExtractFileExt(OpenFileDialog.FileName)))+'.OPL') = true then
    begin
     // If MessageBox(Handle, pchar('An OPL file has been found in the same folder, want to load it?'),'OPL loading',MB_YESNO) = IDYES then
     // begin
        try
          try
            OPL.Free;
          finally
            OPL:=TOPLFile.Create;

            OPL.LoadFromFile(ExtractFilePath(OpenFileDialog.FileName)+Copy(ExtractFileName(OpenFileDialog.FileName),0,Length(ExtractFileName(OpenFileDialog.FileName))-Length(ExtractFileExt(OpenFileDialog.FileName)))+'.OPL');

            CheckBox_StickOPLtoKCM.Enabled:=True;
            CheckBox_ShowOPLNodes.Enabled:=True;
            CheckBox_ShowOPLModels.Enabled:=True;
            CheckBox_ShowOPLTextures.Enabled:=True;
            CheckBox_ShowOPLNodes.Checked:=True;

            PositionOPL(True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
          end;
        finally
          GLDummyCube_OPLObjects.Visible:=True;
          GLSceneViewer.Enabled:=True;
        end;
      //end;
      end;
  ShowMessage('Map has been loaded.');
  end;
end;

procedure TForm_Main.MainMenu_File_LoadKSMFileClick(Sender: TObject);
var
  Openfiledialog:TOpenDialog;
  x1,y1:Integer;
begin

  Try
    OpenFileDialog:=TOpenDialog.Create(nil);
    OpenFileDialog.Filter:='Kal Server Maps (*.ksm)|*.ksm;All files|*.*';
    OpenFileDialog.Title:='Open file...';
    OpenFileDialog.Options:=[ofHideReadOnly,ofEnableSizing];
    OpenFileDialog.InitialDir:=KSMInital_Path;
    If OpenFileDialog.Execute Then
    begin
      Try
        KSM.Free;
      except
      end;
      KSM:=TkalServerMap.Create;
      KSM.LoadFromFile(OpenFileDialog.FileName);
      {
      for x2:=0 to 64 do
      begin
        for y1:=0 to 64 do
        begin
          Image_General.Canvas.Pixels[x2,y1]:=KSM.map[x2][y1][2];
        end;
      end;
      }
      map:=KSM.map;

      ResetRealm;

      If KCM<>nil then
      begin
        //If MessageBox(Handle, pchar('An KCM file has been loaded, want to paint the KSM file over it?'),'Paint?',MB_YESNO) = IDYES then
        //begin

        //end;
        GLHeightField.OnGetHeight:=GLHeightFieldPaintKSMmap;
        GLHeightField.StructureChanged;
      end else begin
        KCM:=TKalClientMap.Create;
        KCM.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\empty.kcm', 1);
        GLHeightField.OnGetHeight:=GLHeightFieldPaintKSMmap;
        GLHeightField.StructureChanged;
      end;
    end;
  finally
    OpenFileDialog.Free;
  end;
end;

procedure TForm_Main.MainMenu_File_SaveKSMFileClick(Sender: TObject);
begin
  KSM.SaveToFile(KSM.FileLocation);
  MessageBox(handle,PChar('Succesfully saved KSM file to '''+KSM.FileLocation+''''),'Saving succeed',mb_ok);
  KSM.Saved:=True;
end;

procedure TForm_Main.MainMenu_File_SaveKSMFileasClick(Sender: TObject);
var
  SaveDialog:TSaveDialog;
begin
  saveDialog:=TSaveDialog.Create(Form_Main);
  saveDialog.Title:='Save your KalServerMap';
  saveDialog.InitialDir:=ExtractFileDir(Application.ExeName);
  saveDialog.Filter := 'Kal Server Maps|*.ksm;';
  saveDialog.DefaultExt := 'ksm';
  If SaveDialog.Execute Then
  begin
    KSM.FileLocation:=SaveDialog.FileName;
    KSM.SaveToFile(KSM.FileLocation);
    MessageBox(handle,PChar('Succesfully saved KSM file to '''+KSM.FileLocation+''''),'Saving succeed',mb_ok);
    KSM.Saved:=True;
  end;
end;

procedure TForm_Main.ListBox_FileClick(Sender: TObject);
begin
  ListBox_FileAspect.Items.Clear;
  ListBox_FileAspect.Enabled:=false;
  GroupBox_KSMDRAW.Visible:=False;
  GroupBox_KCMHeight.Visible:=False;
  GroupBox_KCMTexturePaint.Visible:=False;
  GroupBox_OPL.Visible:=False;
  GLFreeForm_Indicator.Visible:=False;
  //TOOL:=nil;

  If ListBox_File.Selected[0]=true then
  begin
  {KCM}
    If KCM=nil then
    begin
      //MessageBox(Handle, pchar('Can''t edit KCM.'+#13+'- No KCM file has been loaded.'),'Can''t edit KCM',MB_OK);
      ListBox_FileAspect.Items.Add('[Please load KCM]');
      abort;
    end;
    ListBox_FileAspect.Items.Add('Brush');
    ListBox_FileAspect.Items.Add('Custom Brush');
    ListBox_FileAspect.Items.Add('Set Height'); // Set Height');
    ListBox_FileAspect.Items.Add('Flatten');
    ListBox_FileAspect.Items.Add('Move Whole Map');
    ListBox_FileAspect.Items.Add('Color map');
    ListBox_FileAspect.Items.Add('Texture map');
    ListBox_FileAspect.Items.Add('Grass map');
    ListBox_FileAspect.Enabled:=True;
    ListBox_FileAspect.ItemIndex:=0;
    ListBox_FileAspectClick(Self);
  end;

  If ListBox_File.Selected[1]=true then
  begin
  {KSM}
    If KSM=nil then
    begin
      //MessageBox(Handle, pchar('Can''t edit KSM.'+#13+'- No KSM file has been loaded.'),'Can''t edit KSM',MB_OK);
      ListBox_FileAspect.Items.Add('[Please load KSM]');
      abort;
    end;
    ListBox_FileAspect.Items.Add('Brush');
    ListBox_FileAspect.Items.Add('Height(KCM)');
    ListBox_FileAspect.Items.Add('Object(OPL)');
    ListBox_FileAspect.Enabled:=True;
    ListBox_FileAspect.ItemIndex:=0;
    ListBox_FileAspectClick(Self);
  end;

  If ListBox_File.Selected[2]=true then
  begin
  {OPL}
    If OPL=nil then
    begin
      //MessageBox(Handle, pchar('Can''t edit OPL.'+#13+'- No OPL file has been loaded.'),'Can''t edit OPL',MB_OK);
      ListBox_FileAspect.Items.Add('[Please load OPL]');
      abort;
    end;
    //ListBox_FileAspect.Items.Add('Add');
    ListBox_FileAspect.Items.Add('Modify');
    //ListBox_FileAspect.Items.Add('General - Rotate');
    ListBox_FileAspect.Enabled:=True;
    ListBox_FileAspect.ItemIndex:=0;
    ListBox_FileAspectClick(Self);
  end;
end;

procedure TForm_Main.ListBox_FileAspectClick(Sender: TObject);
var
  x,y:integer;
  size:Integer;
begin
  GroupBox_KSMDRAW.Visible:=False;
  GroupBox_KCMHeight.Visible:=True; // Brush
  GroupBox_KCMTexturePaint.Visible:=False;
  GroupBox_OPL.Visible:=False;
  GLFreeForm_Indicator.Visible:=False;
  ColorPicker.Visible:=False;

  // SIZE
  TrackBar_KCMHEIGHT_Diameter.Visible:=True;
  TrackBar_KCMTEX_Diameter.Visible:=False;
  TrackBar_IndicatorHeight.Visible:=False;
  TrackBar_KSMOpl_PaintSize.Visible:=False;

  // INTENSITY
  TrackBar_KCMHEIGHT_Intensity.Visible:=True;
  TrackBar_KCMTEX_Intensity.Visible:=False;
  Trackbar_KCMGrassPaint_Intensity.Visible:=False;
  Trackbar_KCMGrassPaint_Intensity.Visible:=False;
  TrackBar_KCMSetHeight_Height.Visible:=False;

  // HARDNESS
  TrackBar_IndicatorHeight.Visible:=False;
  Trackbar_KCMGrassPaint_Type.Visible:=False;
  Trackbar_KCMGrassPaint_Intensity.Visible:=False;
  TrackBar_KCMTexturePaint_InnerDiameter.Visible:=True;
  TrackBar_KCMSetHeight_Height2.Visible:=False;
  Chk_Random.Visible:=False;

  // ENABLES
  TrackBar_KCMHEIGHT_Diameter.Enabled:=True;
  TrackBar_KCMTexturePaint_InnerDiameter.Enabled:=False;

  // IMAGES
  Image_TexturePreview.Visible:=False;
  TrackBar_KCMHEIGHT_Intensity.Enabled:=True;
  BrushPreview.Visible:=False;

  // Description
  Label_Size.Caption:='Size:';
  Label_Intensity.Caption:='Intensity:';
  Label_Hardness.Caption:='Hardness:';

  // ListBoxes
  ListBox_TextureMap.Items.Clear;

  //TOOL:=nil;

  //KCM TOOls--------------
  If ListBox_File.Selected[0]=True then // BRUSH
  begin
    If ListBox_FileAspect.Selected[0]=true then
    begin
      TOOL:=tKCM_HeightBrush;
      GLHeightField.OnGetHeight:=GLHeightFieldPaintColorMap;
    end;
    If ListBox_FileAspect.Selected[1]=true then  // CUSTOM BRUSH
    begin
      BrushPreview.Visible:=True;
      TOOL:=tKCM_BrushPaint;
      GLHeightField.OnGetHeight:=GLHeightFieldPaintColorMap;
    end;
    If ListBox_FileAspect.Selected[2]=true then // SET HEIGHT
    begin
      Label_Intensity.Caption:='Height:';
      Label_Hardness.Caption:='Height2:';
      TrackBar_KCMSetHeight_Height.Visible:=True;
      TrackBar_KCMSetHeight_Height2.Visible:=True;
      TrackBar_KCMHEIGHT_Intensity.Visible:=False;
      TrackBar_KCMTexturePaint_InnerDiameter.Visible:=False;
      TOOL:=tKCM_SetHeight;
      GLHeightField.OnGetHeight:=GLHeightFieldPaintColorMap;
    end;
    If ListBox_FileAspect.Selected[3]=true then // FLATTEN
    begin
      TrackBar_KCMHEIGHT_Intensity.Enabled:=False;
      TOOL:=tKCM_Flatten;
    end;
    If ListBox_FileAspect.Selected[4]=true then // WHOLE MAP
    begin
      TrackBar_KCMHEIGHT_Diameter.Enabled:=False;
      TrackBar_KCMHEIGHT_Intensity.Enabled:=False;
      TOOL:=tKCM_WholeMap;
      GLHeightField.OnGetHeight:=GLHeightFieldPaintColorMap;
    end;

    If ListBox_FileAspect.Selected[5]=true then // COLOR MAP
    begin
      // Enabling stuff
      TrackBar_KCMTEX_Diameter.Visible:=True;
      TrackBar_KCMTEX_Intensity.Visible:=True;
      TrackBar_KCMHEIGHT_Diameter.Visible:=False;
      TrackBar_KCMHEIGHT_Intensity.Visible:=False;
      ColorPicker.Visible:=True;

      //Making and painting the brush
      BrushCreate(FBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position,GetRValue(rgbcolor),GetGValue(rgbcolor),GetBValue(rgbcolor));
      BrushCreate(FPBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position*10,GetRValue(rgbcolor),GetGValue(rgbcolor),GetBValue(rgbcolor));
      For x:=0 to 64 do
      begin
        For y:=0 to 64 do
        begin
          BrushPreview.Canvas.Pixels[(x*2),(y*2)]:=FPBrush.Canvas.Pixels[x,y];
          BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)]:=FPBrush.Canvas.Pixels[x,y];
          BrushPreview.Canvas.Pixels[(x*2),(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
          BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
        end;
      end;

      TrackBar_KCMTexturePaint_InnerDiameter.Enabled:=True;
      BrushPreview.Visible:=True;
      TOOL:=tKCM_Colormap;
    end;

    // TEXTURE MAP
    If ListBox_FileAspect.Selected[6]=true then // TEXTURE MAP
    begin
      GroupBox_KCMTexturePaint.Visible:=True;
      GroupBox_KCMTexturePaint.Enabled:=True;
      //Putting in the right size
      size:=TrackBar_KCMTEX_Diameter.Position*2; //TrackBar_KCMTexturePaint_OuterDiameter.Position*2;
      GLSphere1.Scale.X:=size;
      GLSphere1.Scale.Y:=size;
      GLSphere1.Scale.Z:=size;
      TrackBar_KCMTexturePaint_InnerDiameter.Max:=TrackBar_KCMTEX_Diameter.Position; //TrackBar_KCMTexturePaint_OuterDiameter.Position;

      //Making and painting the brush
      BrushCreate(FBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position,255,255,255);
      BrushCreate(FPBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position*10,255,255,255);
      For x:=0 to 64 do
      begin
        For y:=0 to 64 do
        begin
          BrushPreview.Canvas.Pixels[(x*2),(y*2)]:=FPBrush.Canvas.Pixels[x,y];
          BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)]:=FPBrush.Canvas.Pixels[x,y];
          BrushPreview.Canvas.Pixels[(x*2),(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
          BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
        end;
      end;

      // Enabling stuff
      TrackBar_KCMTEX_Diameter.Visible:=True;
      TrackBar_KCMTEX_Intensity.Visible:=True;
      TrackBar_KCMHEIGHT_Diameter.Visible:=False;
      TrackBar_KCMHEIGHT_Intensity.Visible:=False;
      TrackBar_KCMTexturePaint_InnerDiameter.Enabled:=True;
      BrushPreview.Visible:=True;
      Image_TexturePreview.Visible:=True;
      // Done enabling

      ListBox_TextureMap.Items.Clear;
      For x:=0 to 6 do
      begin
        If KCM.Header.TextureList[x]<>0 then
        begin
          ListBox_TextureMap.Items.Add('Texture Map #'+IntToStr(x));
        end;
      end;
      TOOL:=tKCM_TexturePaint;
    end;
    If ListBox_FileAspect.Selected[7]=true then // GRASS MAP
    begin
      If env<>nil then
      begin
        Label_Hardness.Caption:='Type:';
        Chk_Random.Visible:=True;
        Trackbar_KCMGrassPaint_Intensity.Visible:=True;
        Trackbar_KCMGrassPaint_Type.Visible:=True;
        TrackBar_KCMTexturePaint_InnerDiameter.Visible:=False;
        TrackBar_KCMGrassPaint_Type.Max:=env.GrassCount;
        TOOL:=tKCM_GrassPaint;
        GLHeightField.OnGetHeight:=GLHeightFieldPaintObjectMap;
      For x:=0 to 64 do
      begin
        For y:=0 to 64 do
        begin
          If KCM.ObjectMap[x][y]<> 0 then
          begin
            Image_General.Canvas.Pixels[x,y]:=RGB(50+KCM.ObjectMap[x][y]*10,0,0);
          end
          else
          begin
            Image_General.Canvas.Pixels[x,y]:=RGB(KCM.ColorMap[x][y][0],KCM.ColorMap[x][y][1],KCM.ColorMap[x][y][2]);
          end;
        end;
      end;
      end
      else
      begin
        ShowMessage('n.env is required for this option, appearntly its not loaded.'+#13+#13+'Please set your settings proporly and restart kwe, it will be loaded on startup');
      end;
    end;
  end;

  //KSM TOOls--------------
  If ListBox_File.Selected[1]=True then

  begin
    GroupBox_KSMDRAW.Visible:=True;
    GLHeightField.OnGetHeight:=GLHeightFieldPaintKSMMap;
    If ListBox_FileAspect.Selected[0]=true then
    begin
      TOOL:=tKSM_PaintBrush;
    end;
    If ListBox_FileAspect.Selected[1]=true then
    begin
      If KCM<>Nil then
      begin
        TrackBar_IndicatorHeight.Visible:=True;
        TOOL:=tKSM_HeightBased;

        //Creating Indicator
        CreateIndicator;
        GLFreeForm_Indicator.Visible:=True;
      end
      else
      begin
        MessageBox(Handle, pchar('Please load a KCM file first when preforming this function'),'Can''t preform this function...',MB_OK);
      end;
    end;
    If ListBox_FileAspect.Selected[2]=true then
    begin
      If OPL<>Nil then
      begin
      TOOL:=tKSM_OPLBased;
      end
      else
      begin
        MessageBox(Handle, pchar('Please load a OPL file first when preforming this function'),'Can''t preform this function...',MB_OK);
      end;
    end;
  end;

  //OPL TOOLS--------------
  If ListBox_File.Selected[2]=True then
  begin
    If OPL<>Nil then
    begin
      GroupBox_OPL.Visible:=True;
      SelectFile(GLDummyCube_OPLObjects.Children[0].Index); //selected_OPLs[0].Index);
      {
      If ListBox_FileAspect.Selected[0]=true then
      begin
        TOOL:=tOPL_AddNode; //tOPL_Position;
      end;
      }
      If ListBox_FileAspect.Selected[0]=true then
      begin
        //TOOL:=tOPL_Modify//tOPL_Scale;
        TOOL:=null;
        If SpdBtn_OPL_X.Down=true then
        begin
          TOOL:=tOPL_X;
        end;
        If SpdBtn_OPL_Y.Down=true then
        begin
          TOOL:=tOPL_Y;
        end;
        If SpdBtn_OPL_Z.Down=true then
        begin
          TOOL:=tOPL_Z;
        end;
        If SpdBtn_OPL_XYZ.Down=true then
        begin
          TOOL:=tOPL_XYZ;
        end;
      end;
      //If ListBox_FileAspect.Selected[2]=true then
      //begin
      //end;
    end
    else
    begin
        MessageBox(Handle, pchar('Please load an OPL file first when preforming this function'),'Can''t preform this function...',MB_OK);
    end;
  end;
end;

procedure TForm_Main.TrackBar_DiameterChange(Sender: TObject);
var
  size:Extended;
  trackbar:TTrackBar;
begin
  If sender = TrackBar_KCMHEIGHT_Diameter then
  begin
    TrackBar:=TrackBar_KCMHEIGHT_Diameter;
    Edit_KCMHEIGHT_BrushSize.Text:=IntToStr(TrackBar_KCMHEIGHT_Diameter.Position*2);
  end;

  TrackBar_KCMHEIGHT_Diameter.Position:=TrackBar.Position;

  //Setting the sphere his size
  size:=Trackbar.Position;
  GLSphere1.Scale.X:=size;
  GLSphere1.Scale.Y:=size;
  GLSphere1.Scale.Z:=size;
end;

procedure TForm_Main.RadioButtons_ValuesClick(Sender: TObject);
var
  Value1,Value2:word;
  x,y:Integer;
begin
  If GroupBox_KSMDRAW.Visible=True then
  begin
    If (RadioButton1.Checked=True) then
    begin
      Value1:=0;
    end;
    If (RadioButton2.Checked=True) then
    begin
      Value1:=65535;
    end;
    If (RadioButton3.Checked=True) then
    begin
      Value2:=0;
    end;
    If (RadioButton4.Checked=True) then
    begin
      Value2:=1;
    end;
    If (RadioButton5.Checked=True) then
    begin
      Value2:=2;
    end;
    If (RadioButton6.Checked=True) then
    begin
      Value2:=6;
    end;
    If (RadioButton7.Checked=True) then
    begin
      Value2:=4;
    end;
    If (RadioButton8.Checked=True) then
    begin
      Value2:=16;
    end;
  end;

  Values[1]:=Value1;
  Values[2]:=Value2;
  For x:=0 to Image_ColorDraw1.Width do
  begin
    For y:=0 to Image_ColorDraw1.Height do
    begin
      Image_ColorDraw1.Canvas.Pixels[x,y]:=KSM.ValuesToColor(Value1,Value2);
    end;
  end;

end;


procedure TForm_Main.Image_GeneralMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var
  Point:TPoint;
  //Value:TValues;
begin
  If KSM<>nil then
  begin
    //Values:=KSM.ColorToValues(Image_General.Canvas.Pixels[x,y]);
    Image_General.Hint:='KSM info:'+#13+'Value1 : '+IntToStr(KSM.Map[x][y][0])+#13+'Value2 : '+IntToStr(KSM.Map[x][y][1]);
    Point.X:=X;
    Point.Y:=Y;
    Point:=Image_General.ClientToScreen(Point);
    Application.ActivateHint(Point) ;
  end;
end;


procedure TForm_Main.TrackBar_IndicatorHeightChange(Sender: TObject);
begin
  GLFreeForm_Indicator.Position.Y:=TrackBar_IndicatorHeight.Position;
  Edit_KCMHEIGHT_BrushSize.Text:=IntToStr(TrackBar_IndicatorHeight.Position*2);
end;

procedure TForm_Main.KSMHEIGHT_ButtonUpClick(Sender: TObject);
var
  X,Y:Integer;
  //Values:TValues;
begin
  If GLFreeForm_Indicator<>nil then
  begin
    If MessageBox(Handle, pchar('Are you sure you want to paint everything above the Indicator your selected color?'),'Continue?',MB_YESNO) = IDYES then
    begin
      For x:=0 to 255 do
      begin
        For Y:=0 to 255 do
        begin
          If (KCM.HeightMap[x][y]/32)>GLFreeForm_Indicator.Position.Y then
          begin
            map[x][y][0]:=Values[1];
            map[x][y][1]:=Values[2];
            map[x][y][2]:=KSM.ValuesToColor(Values[1],Values[2]);
          end;
          Image_General.Canvas.Pixels[x,y]:=map[x][y][2]
        end;
      end;
    end;
  end;
  KSM.Map:=Map;
  KSM.Saved:=False;
  //KSM.ServerMapToImage(KSM.Map,Image_General);
  GLHeightField.StructureChanged;
end;

procedure TForm_Main.KSMHEIGHT_ButtonDownClick(Sender: TObject);
var
  X,Y:Integer;
  //Values:TValues;
begin
  If GLFreeForm_Indicator<>nil then
  begin
    If MessageBox(Handle, pchar('Are you sure you want to paint everything under the Indicator your selected color?'),'Continue?',MB_YESNO) = IDYES then
    begin
      For x:=0 to 255 do
      begin
        For Y:=0 to 255 do
        begin
          If (KCM.HeightMap[x][y]/32)<GLFreeForm_Indicator.Position.Y then
          begin
            map[x][y][0]:=Values[1];
            map[x][y][1]:=Values[2];
            map[x][y][2]:=KSM.ValuesToColor(Values[1],Values[2]);
            Image_General.Canvas.Pixels[x,y]:=map[x][y][2];
          end;
        end;
      end;
      KSM.Map:=map;
      KSM.Saved:=False;
      GLHeightField.StructureChanged;
    end;
  end;
end;

procedure TForm_Main.GLHeightField1PaintWireframe(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
begin
  If KCM<>nil then
  begin
    z:=-KCM.HeightMap[round(x)][round(y)]/32;
    Color[0]:=169/255;
    Color[1]:=169/255;
    Color[2]:=169/255;
  end;
end;

procedure TForm_Main.GLHeightFieldPaintWireframe(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
begin
  If KCM<>nil then
  begin
    z:=-KCM.HeightMap[round(x)][round(y)]/32;
    Color[0]:=255/255;
    Color[1]:=20/255;
    Color[2]:=147/255;
  end;
end;

procedure TForm_Main.GLHeightFieldPaintColorMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
begin
  If KCM<>nil then
  begin
    z:=-KCM.HeightMap[round(x)][round(y)]/32;
    Color[0]:=KCM.ColorMap[round(x)][round(y)][0]/255;
    Color[1]:=KCM.ColorMap[round(x)][round(y)][1]/255;
    Color[2]:=KCM.ColorMap[round(x)][round(y)][2]/255;
  end;
end;

procedure TForm_Main.GLHeightFieldPaintColorMap2(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
var
  i:Integer;
begin
  If KCM<>nil then
  begin
    z:=-KCM.HeightMap[round(x)][round(y)]/32;
  end;
  If KSM<>nil then
  begin
    i:=KCM.ValuesToColor(KCM.Map[round(x)][round(y)][0],KCM.Map[round(x)][round(y)][1]);
    Color[0]:=GetRValue(i)/255;
    Color[1]:=GetGValue(i)/255;
    Color[2]:=GetBValue(i)/255;
  end;
end;

procedure TForm_Main.GLHeightFieldPaintKSMMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
var
  i:Integer;
begin
  If KCM<>nil then
  begin
    z:=-KCM.HeightMap[round(x)][round(y)]/32;
  end;
  If KSM<>nil then
  begin
   //Color[0]:=GetRValue(FCanvas.Canvas.Pixels[round(x),round(y)])/255;
    //Color[1]:=GetGValue(FCanvas.Canvas.Pixels[round(x),round(y)])/255;
    //Color[2]:=GetBValue(FCanvas.Canvas.Pixels[round(x),round(y)])/255;
    i:=KSM.ValuesToColor(KSM.Map[round(x)][round(y)][0],KSM.Map[round(x)][round(y)][1]);
    Color[0]:=GetRValue(i)/255;
    Color[1]:=GetGValue(i)/255;
    Color[2]:=GetBValue(i)/255;
  end;
end;

procedure TForm_Main.GLHeightFieldPaintTextureMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
begin
  z:=-KCM.HeightMap[round(x)][round(y)]/32;

  Color[0]:=KCM.TextureMapList[CurTmap][round(x)][round(y)]/255;
  Color[1]:=KCM.TextureMapList[CurTmap][round(x)][round(y)]/255;
  Color[2]:=KCM.TextureMapList[CurTmap][round(x)][round(y)]/255;
end;

procedure TForm_Main.GLHeightFieldPaintMiniMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
begin
  z:=-KCM.HeightMap[round(x)][round(y)]/32;

  Color[0]:=GetRValue(KCMMinimap.Canvas.Pixels[round(x),round(y)])/255;
  Color[1]:=GetGValue(KCMMinimap.Canvas.Pixels[round(x),round(y)])/255;
  Color[2]:=GetBValue(KCMMinimap.Canvas.Pixels[round(x),round(y)])/255;
end;

procedure TForm_Main.GLHeightFieldPaintCustomPic(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
begin
  z:=-KCM.HeightMap[round(x)][round(y)]/32;

  Color[0]:=GetRValue(KCMCustomPic.Canvas.Pixels[round(x),round(y)])/255;
  Color[1]:=GetGValue(KCMCustomPic.Canvas.Pixels[round(x),round(y)])/255;
  Color[2]:=GetBValue(KCMCustomPic.Canvas.Pixels[round(x),round(y)])/255;
end;
procedure TForm_Main.GLHeightFieldPaintObjectMap(const x, y: Single; var z: Single; var color: TVector4f; var texPoint: TTexPoint);
var
  i:Integer;
begin
  If KCM<>nil then
  begin
    z:=-KCM.HeightMap[round(x)][round(y)]/32;

    If KCM.ObjectMap[round(x)][round(y)]<>0 then
    begin
      Color[0]:=(50+(KCM.ObjectMap[round(x)][round(y)]*10))/255;
      Color[1]:=0;
      Color[2]:=0;
    end
    else
    begin
      Color[0]:=KCM.ColorMap[round(x)][round(y)][0]/255;
      Color[1]:=KCM.ColorMap[round(x)][round(y)][1]/255;
      Color[2]:=KCM.ColorMap[round(x)][round(y)][2]/255;
    end;

  end;
end;


procedure TForm_Main.MainMenu_File_SaveKCMfileClick(Sender: TObject);
begin
  KCM.SaveToFile(KCM.FileLocation);
  OPL.SaveToFile(OPL.FileLocation);
  //MessageBox(handle,PChar('Succesfully saved KCM file to '''+KCM.FileLocation+''''),'Saving succeed',mb_ok);
  KCM.Saved:=True;
  OPL.Saved:=True;
end;

procedure TForm_Main.TrackBar_KCMSetHeight_HeightChange(Sender: TObject);
begin
  Edit_KCMHEIGHT_Hardness.Text:=IntToStr((TrackBar_KCMSetHeight_Height.Position*128)+(TrackBar_KCMSetHeight_Height2.Position));
end;

procedure TForm_Main.TrackBar_KCMHEIGHT_IntensityChange(Sender: TObject);
begin
  Edit_KCMHEIGHT_Intensity.Text:=IntToStr(round(TrackBar_KCMHEIGHT_Intensity.Position/10));
end;

procedure TForm_Main.MainMenu_KCMFile_TextureCenterClick(Sender: TObject);
begin
  Form_KCMTextureCenter.Show;
end;

procedure TForm_Main.MainMenu_OptionsClick(Sender: TObject);
begin
  Form_Options.Show;
end;

procedure TForm_Main.MainMenu_KCMFileClick(Sender: TObject);
begin
  MainMenu_KCMFile_HeaderInfo.Enabled:=False;
  MainMenu_KCMFile_BorderCenter.Enabled:=False;
  MainMenu_KCMFile_RenderColorMap.Enabled:=False;
  If KCM<>nil then
  begin
    MainMenu_KCMFile_RenderColorMap.Enabled:=True;
    MainMenu_KCMFile_BorderCenter.Enabled:=True;
    MainMenu_KCMFile_HeaderInfo.Enabled:=True;
  end;
end;

procedure TForm_Main.MainMenu_FileClick(Sender: TObject);
begin
  MainMenu_File_SaveKCMFile.Enabled:=False;
  MainMenu_File_SaveKCMFileAs.Enabled:=False;
  MainMenu_File_SaveKSMFile.Enabled:=False;
  MainMenu_File_SaveKSMFileAs.Enabled:=False;
  MainMenu_File_SaveOPLFile.Enabled:=False;
  MainMenu_File_SaveOPLFileAs.Enabled:=False;
  Try
    If KCM<>nil then
    begin
      If KCM.FileLocation<>'' then
      begin
        MainMenu_File_SaveKCMFile.Enabled:=True;
      end;
      MainMenu_File_SaveKCMFileAs.Enabled:=True;
    end;
  except
  end;
  Try
    If KSM<>nil then
    begin
      MainMenu_File_SaveKSMFile.Enabled:=True;
      MainMenu_File_SaveKSMFileAs.Enabled:=True;
    end;
  except
  end;
  Try
    If OPL<>nil then
    begin
      MainMenu_File_SaveOPLFile.Enabled:=True;
      MainMenu_File_SaveOPLFileAs.Enabled:=True;
    end;
  except
  end;
end;

procedure TForm_Main.TrackBar_KCMTexturePaint_OuterDiameterChange(ender: TObject);
var
  x,y:Integer;
  size:Single;
begin
  If TOOL=tKCM_Colormap then begin
    BrushCreate(FBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position,GetRValue(rgbcolor),GetGValue(rgbcolor),GetBValue(rgbcolor));
    BrushCreate(FPBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position*10,GetRValue(rgbcolor),GetGValue(rgbcolor),GetBValue(rgbcolor));
  end else begin
    BrushCreate(FBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position,255,255,255);
    BrushCreate(FPBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position*10,255,255,255);
  end;
  For x:=0 to 64 do
  begin
    For y:=0 to 64 do
    begin
      BrushPreview.Canvas.Pixels[(x*2),(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      BrushPreview.Canvas.Pixels[(x*2),(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
      BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
    end;
  end;
  TrackBar_KCMTexturePaint_InnerDiameter.Max:=TrackBar_KCMTEX_Diameter.Position;
  Edit_KCMHEIGHT_BrushSize.Text:=IntToStr(round((TrackBar_KCMTEX_Diameter.Position*2)*2));

  size:=TrackBar_KCMTEX_Diameter.Position*2;
  GLSphere1.Scale.X:=size;
  GLSphere1.Scale.Y:=size;
  GLSphere1.Scale.Z:=size;
end;

procedure TForm_Main.TrackBar_KCMTexturePaint_InnerDiameterChange(Sender: TObject);
var
  x,y:Integer;
begin
  If TOOL=tKCM_Colormap then begin
    BrushCreate(FBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position,GetRValue(rgbcolor),GetGValue(rgbcolor),GetBValue(rgbcolor));
    BrushCreate(FPBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position*10,GetRValue(rgbcolor),GetGValue(rgbcolor),GetBValue(rgbcolor));
  end else begin
    BrushCreate(FBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position,255,255,255);
    BrushCreate(FPBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position*10,255,255,255);
  end;
  For x:=0 to 64 do
  begin
    For y:=0 to 64 do
    begin
      BrushPreview.Canvas.Pixels[(x*2),(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      BrushPreview.Canvas.Pixels[(x*2),(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
      BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
    end;
  end;
  Edit_KCMHEIGHT_Hardness.Text:=IntToStr(round((TrackBar_KCMTexturePaint_InnerDiameter.Position*2)*2));
end;

procedure TForm_Main.TrackBar_KCMTexturePaint_IntensityChange(Sender: TObject);
var
  x,y:Integer;
begin
  If TOOL=tKCM_Colormap then begin
    BrushCreate(FBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position,GetRValue(rgbcolor),GetGValue(rgbcolor),GetBValue(rgbcolor));
    BrushCreate(FPBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position*10,GetRValue(rgbcolor),GetGValue(rgbcolor),GetBValue(rgbcolor));
  end else begin
    BrushCreate(FBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position,255,255,255);
    BrushCreate(FPBrush,TrackBar_KCMTexturePaint_InnerDiameter.Position,TrackBar_KCMTEX_Diameter.Position,TrackBar_KCMTEX_Intensity.Position*10,255,255,255);
  end;
  For x:=0 to 64 do
  begin
    For y:=0 to 64 do
    begin
      BrushPreview.Canvas.Pixels[(x*2),(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      BrushPreview.Canvas.Pixels[(x*2),(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
      BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
    end;
  end;
  Edit_KCMHEIGHT_Intensity.Text:=IntToStr(round((TrackBar_KCMTEX_Intensity.Position*2)*2));
end;

procedure TForm_Main.BrushCreate(Brush:TBitmap;InWidth,OutWidth,Intensity:Integer;R,G,B:TColor);
var
  x1,x2:Integer;
  y1,y2:Integer;
  s,u:single;
  c,uR,uG,uB:Integer;
begin
  //Painting inner cicle
  For x1:=0 to 64 do
  begin
    For y1:=0 to 64 do
    begin
      Brush.Canvas.Pixels[x1,y1]:=rgb(255,255,255);
    end;
  end;
  //if InWidth >= 64 then begin InWidth:=64; end;
  //if OutWidth >= 64 then begin OutWidth:=64; end;
  For x1:=25-OutWidth to 25+OutWidth do
  begin
    For y1:=25-OutWidth to 25+OutWidth do
    begin
      //x2 & y2 will represend the delta ( diffrence in ) distance.
      x2:=25-x1;
      y2:=25-y1;

      //Calculating the real distance between the points
      s:=Sqrt((x2*x2)+(y2*y2));

      If s <= InWidth then
      begin
        //Disance to center is smaller then inner circle
        Brush.Canvas.Pixels[x1,y1]:=rgb(R-Intensity,G-Intensity,B-Intensity);
      end
      else
      begin
        //Distance to center is bigger then inner circle
        If (s<= OutWidth) and (s> InWidth)  then
        begin
          uR:=round((R-Intensity)+((s-InWidth)*((Intensity)/(OutWidth-InWidth))));
          uG:=round((G-Intensity)+((s-InWidth)*((Intensity)/(OutWidth-InWidth))));
          uB:=round((B-Intensity)+((s-InWidth)*((Intensity)/(OutWidth-InWidth))));
          Brush.Canvas.Pixels[x1,y1]:=rgb(uR,uG,uB);
        end;
      end;
    end;
  end;
end;

procedure TForm_Main.ListBox_TextureMapClick(Sender: TObject);
var
  x,y:Integer;
  GTXLoc,DDSLoc:STring;
  TID:Integer;
begin
  For x:=0 to ListBox_TextureMap.Items.Count-1 do
  begin
    If ListBox_TextureMap.Selected[x] then
    begin
      CurTMap:=x;

      TID := x;
      If TID > -1 then
      begin
        Try
          DDSLoc:=ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(Form_Main.env.TextureIndexList[Form_Main.KCM.Header.TextureList[x]],1,Length(Form_Main.env.TextureIndexList[Form_Main.KCM.Header.TextureList[x]])-4)+'.dds';
          if fileexists(DDSLoc)=false then
          begin
            GTXLoc:=Form_Main.Client_Path+'data\MAPS\Tex\'+Form_Main.env.TextureIndexList[Form_Main.KCM.Header.TextureList[x]];
            ConvertGTX2DDS(GTXLoc,DDSLoc,ExtractFilePath(Application.Exename)+'Recources\encrypt.dat',ExtractFilePath(Application.Exename)+'Recources\decrypt.dat');
          end;
          Image_TexturePreview.Picture.LoadFromFile(DDSLoc);
        except
        end;
      end
      else
      begin
        TID:=$FF;
      end;
      break;
    end;
  end;
  Form_Main.GLHeightField.OnGetHeight:=Form_Main.GLHeightFieldPaintTextureMap;
  Form_Main.GLHeightField.StructureChanged;
  {
  For x:=0 to 64 do
  begin
    For y:=0 to 64 do
    begin
      Image_General.Canvas.Pixels[x,y]:=RGB(Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y],Form_Main.KCM.TextureMapList[Form_Main.CurTMap][x][y]);
    end;
  end;

  ListBox_TextureMap.Items.Clear;
  For x:=0 to 6 do
  begin
    If KCM.Header.TextureList[x]<>0 then
    begin
      ListBox_TextureMap.Items.Add('Texture Map #'+IntToStr(x));
    end;
  end;
  }
  //ShowMEssage(IntToStr(CurTMap));
end;

procedure TForm_Main.MainMenu_KCMFile_RenderColorMapClick(Sender: TObject);
begin
  Form_Colormap.Show;
end;

procedure TForm_Main.DisplayOPLNodeInfo(Nodes:TSelected_OPLs);
begin
  //Displaying the notify event, to prevent infinitif loops;
  Edit_OPL_Model.OnChange:=nil;

  //Displaying the new info,
  If Length(Nodes)>1 then
  begin
    Edit_OPL_Model.Text:='[Multiple objects]';
    Edit_OPL_Model.Enabled:=False;
    Button_OPL_BrowseModel.Enabled:=False;
  end
  else
  begin
    //ShowMessage('max index = '+IntToStr(OPL.ObjectCount-1)+#13+
                //'selected index = '+IntToStr(Nodes[0].Index));
    Edit_OPL_Model.Text:=OPL.Node[Nodes[0].Index].Path;
    Edit_OPL_Model.Enabled:=True;
    Button_OPL_BrowseModel.Enabled:=True;
  end;

  //Displaying the notify event, to prevent infinitif loops;
  Edit_OPL_Model.OnChange:=OPLChange;

end;

// OPL Model
procedure TForm_Main.PositionOPLNode(x1:Integer;UpdateModel:Boolean;TrueModel:Boolean = True;TrueTex:Boolean = True);
var
  model:TGLFreeForm;
  DDSLoc,GTXLoc:String;
  libMat:TGLLibMaterial;
  j:integer;
  S:boolean;
begin
  If x1<(GLDummYCube_OPLObjects.Count) then
  begin
    model:=TGLFreeForm.Create(nil) ;
    model:=TGLFreeForm(GLDummyCube_OPLObjects.Children[x1]);
  end
  else
  begin
    model:=TGLFreeForm.Create(nil) ;
    model:=TGLFreeForm(GLDummyCube_OPLObjects.AddNewChild(TGLFreeForm));
  end;

  //model.name:='OPLNode'+IntToStr(x1);
  model.Visible:=True;

  //Updating position
  model.position.x:=OPL.node[x1].position[0]*256;
  model.position.y:=OPL.node[x1].position[2]/32;
  model.position.z:=256-(OPL.node[x1].position[1]*256);

  //Updating rotation
  model.Rotation.X:=((ArcSin(OPL.Node[x1].Rotation[0])*2)*57.2957795)+90;
  model.Rotation.Y:=((ArcSin(OPL.Node[x1].Rotation[2])*2)*57.2957795)+180;
  model.Rotation.Z:=((ArcSin(OPL.Node[x1].Rotation[1])*2)*57.2957795)+180;
  If ((ArcSin(OPL.Node[x1].Rotation[3])*2)*57.2957795)<0 then
  begin
    model.Rotation.z:=(-(ArcSin(OPL.Node[x1].Rotation[1])*2)*57.2957795)+180;
  end;

  //Updating Scale
  If TrueModel=True then
  begin
    model.Scale.X:=OPL.node[x1].scale[0]/32;
    model.scale.Y:=OPL.node[x1].scale[2]/32;
    model.scale.Z:=OPL.node[x1].scale[1]/32;
  end
  else
  begin
    model.Scale.X:=OPL.node[x1].scale[0];
    model.scale.Y:=OPL.node[x1].scale[2];
    model.scale.Z:=OPL.node[x1].scale[1];
  end;

  If UpdateModel=True then
  begin
    If TrueModel=True  then
    begin
      if (FileExists(ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(OPL.Node[x1].Path,6,Length(OPL.Node[x1].Path))+'.3ds')=true) then
      begin
        model.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(OPL.Node[x1].Path,6,Length(OPL.Node[x1].Path))+'.3ds');
        model.NormalsOrientation:=mnoDefault;//mnoDefault;//mnoInvert;
      end
      else
      begin
        model.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\model.3ds');
        model.NormalsOrientation:=mnoDefault;
        model.Scale.X:=OPL.node[x1].scale[0];
        model.scale.Y:=OPL.node[x1].scale[2];
        model.scale.Z:=OPL.node[x1].scale[1];
      end;
    end
    else
    begin
      model.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\model.3ds');
      model.NormalsOrientation:=mnoDefault;
    end;
    model.Material.Texture.Disabled:=True;
  end;

  If (TrueTex=True) and (TrueModel=True) then
  begin
    try
      GTXLoc:=Client_Path+ExtractFilePath(OPL.Node[x1].Path)+'tex\'+GetTextureName(Client_Path+OPL.Node[x1].Path+'.gb');
      GTXLoc:=Copy(GTXLoc,1,Length(GTXLoc)-4)+'.gtx';

      If FileExists(GTXLoc) then
      begin
        DDSLoc:=ExtractFileDir(Application.ExeName)+'\Recources\'+GetTextureName(Client_Path+OPL.Node[x1].Path+'.gb');

        If FileExists(DDSLoc)=false then
        begin
          ConvertGTX2DDS(GTXLoc,DDSLoc,ExtractFilePath(Application.Exename)+'Recources\encrypt.dat',ExtractFilePath(Application.Exename)+'Recources\decrypt.dat');
        end;

        libmat:=nil;
        libmat:=GLMaterialLibrary.Materials.GetLibMaterialByName(ExtractFileName(DDSLoc));
        If libmat=nil then
        begin
          libmat:=GLMaterialLibrary.AddTextureMaterial(ExtractFileName(DDSLoc),DDSLoc);
        end;

        s:=False;
        for j:=0 to Length(Selected_OPLs)-1 do
        begin
          If Selected_OPLs[j].Index=x1 then
          begin
            s:=True;
            break;
          end;
        end;
        If s=True then
        begin
          Selected_OPLs[j].Tex:=libMat.Name;
        end
        else
        begin
          model.Material.Texture.Disabled:=False;
          model.Material.MaterialLibrary:=GLMaterialLibrary;
          model.Material.LibMaterialName:=libMat.Name;
        end;
      end
      else
      begin
        model.Material.Libmaterialname:='';
        model.Material.Texture.Disabled:=True;
      end;
    except
    end;
  end
  else
  begin
    model.Material.Libmaterialname:='';
    model.Material.Texture.Disabled:=True;
  end;
end;

procedure TForm_Main.PositionOPL(UpdateModels,TrueModels,TrueTextures:Boolean);
var
  x1:Integer;
begin
  GLDummyCube_OPLObjects.DeleteChildren;
  SetLength(Selected_OPLs,0);
  For x1:=0 to OPL.Header.ObjectCount-1 do
  begin
    try
      PositionOPLNode(x1,UpdateModels,TrueModels,TrueTextures);
    except
    end;
  end;
end;

// Wireframe
procedure TForm_Main.Chk_Wireframe2Click(Sender: TObject);
begin
  If Chk_Wireframe.Checked=True then
  begin
    GLHeightFieldTwo.Visible:=True;
    //GLHeightField.Material.FrontProperties.PolygonMode:=pmLines;
    GLHeightFieldTwo.OnGetHeight:=GLHeightField1PaintWireframe;
    GLSceneViewer.Buffer.BackgroundColor:=clBackground;
    GLHeightFieldTwo.StructureChanged;
  end
  else
  begin
    GLHeightFieldTwo.Visible:=False;
    //GLHeightField.Material.FrontProperties.PolygonMode:=pmFill;
    GLHeightFieldTwo.OnGetHeight:=GLHeightField1PaintWireframe;
    GLSceneViewer.Buffer.BackgroundColor:=clBtnFace;
    GLHeightFieldTwo.StructureChanged;
  end;
end;

// CameraAxis
procedure TForm_Main.Chk_CameraAxis2Click(Sender: TObject);
begin
  GLDummyCube.ShowAxes:=False;
  If Chk_CameraAxis.Checked=True then
  begin
    GLDummyCube.ShowAxes:=True;
  end;
end;

// KCM Texture
procedure TForm_Main.Chk_KCMTextureClick(Sender: TObject);
var
  MultiMaterial:String;
begin
  If Chk_KCMTexture.Checked=True then
  begin
    GLHeightField.Material.MaterialLibrary:=GLMaterialLibrary1;
    If GLHeightField.Material.MaterialLibrary<>nil then begin
      GLHeightField.Material.LibMaterialName:=MultiMaterial;
    end;
  end else begin
    GLHeightField.Material.MaterialLibrary:=nil;
  end;
  GLHeightField.StructureChanged;
end;

procedure TForm_Main.CheckBox_ShowWaterClick(Sender: TObject);
begin
  GLFreeForm_Water.Visible:=False;
  If Chk_ShowWater.Checked=True then
  begin
    GLFreeForm_Water.Visible:=True;
  end;
end;

procedure TForm_Main.CheckBox_ShowOPLNodes2Click(Sender: TObject);
begin
  GLDummyCube_OPLObjects.Visible:=False;
  If CheckBox_ShowOPLNodes.Checked=True then
  begin
    GLDummyCube_OPLObjects.Visible:=True;
  end;
end;

procedure TForm_Main.MainMenu_File_ExitClick(Sender: TObject);
begin
  Form_ShutDown.Show;
  Abort;
end;

procedure TForm_Main.MainMenu_File_LoadOPLFileClick(Sender: TObject);
var
  Openfiledialog:TOpenDialog;
  status:Extended;
  x:Integer;
begin
  Try
    OpenFileDialog:=TOpenDialog.Create(nil);
    OpenFileDialog.Filter:='Object Position List files (*.opl)|*.opl;|All files|*.*';
    OpenFileDialog.Title:='Open file...';
    OpenFileDialog.Options:=[ofHideReadOnly,ofEnableSizing];
    OpenFileDialog.InitialDir:=KCMInital_Path;
    If OpenFileDialog.Execute Then
    begin
      If FileExists(OpenFileDialog.FileName) = True then
      begin
        try
          try
            OPL.Free;
          finally
            OPL:=TOPLFile.Create;

            OPL.LoadFromFile(ExtractFilePath(OpenFileDialog.FileName)+Copy(ExtractFileName(OpenFileDialog.FileName),0,Length(ExtractFileName(OpenFileDialog.FileName))-Length(ExtractFileExt(OpenFileDialog.FileName)))+'.OPL');

            CheckBox_StickOPLtoKCM.Enabled:=True;
            CheckBox_ShowOPLNodes.Enabled:=True;
            CheckBox_ShowOPLModels.Enabled:=True;
            CheckBox_ShowOPLTextures.Enabled:=True;
            CheckBox_ShowOPLNodes.Checked:=True;

            PositionOPL(True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
          end;
        finally
          GLDummyCube_OPLObjects.Visible:=True;
          GLSceneViewer.Enabled:=True;
        end;
      end;
    end;
  except

  end;
end;

procedure TForm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
var
  saveDialog:TSaveDialog;
  Choice:Integer;
begin
  Application.CreateForm(TForm_Shutdown, Form_Shutdown);
  Form_Shutdown.Show;
  Abort;
end;

procedure TForm_Main.OPLChange(Sender: TObject);
var
  Vector4F:TVector4F;
  Vector3F:TVector3F;
begin
  //Saving path
  OPL.Node[selected_OPLs[0].Index].Path:=Edit_OPL_Model.text;

  //Saving Scale
  OPL.Node[selected_OPLs[0].Index].Scale:=Vector3F;

  PositionOPLNode(selected_OPLs[0].Index,True,CheckBox_ShowOPLModels.Checked);
  DisplayOPLNodeInfo(selected_OPLs)

end;

procedure TForm_Main.MainMenu_File_SaveOPLFileClick(Sender: TObject);
begin
  OPL.SaveToFile(OPL.FileLocation);
  MessageBox(handle,PChar('Succesfully saved OPL file to '''+OPL.FileLocation+''''),'Saving succeed',mb_ok);
  OPL.Saved:=True;
end;

procedure TForm_Main.MainMenu_File_SaveOPLFileAsClick(Sender: TObject);
var
  saveDialog:TSaveDialog;
begin
  saveDialog:=TSaveDialog.Create(Form_Main);
  saveDialog.Title:='Save your ObjectPositionList';
  saveDialog.InitialDir:=KCMInital_Path;
  saveDialog.Filter := 'Object Position List|*.opl;';
  saveDialog.DefaultExt := 'opl';
  saveDialog.FileName:='n_0'+IntToStr(OPL.Header.MapX)+'_0'+IntToStr(OPL.Header.MapY)+'.opl';
  If SaveDialog.Execute Then
  begin
    OPL.SaveToFile(saveDialog.FileName);
    MessageBox(handle,PChar('Succesfully saved OPL file to '''+OPL.FileLocation+''''),'Saving succeed',mb_ok);
    OPL.Saved:=True;
  end;
end;

procedure TForm_Main.Button_KSMOpl_PaintClick(Sender: TObject);
var
  x,x1,y1:Integer;
  Xmax,Xmin,Ymax,Ymin:Integer;
  //Values:TValues;
  //map:TKSMMap;
begin
  If Tool=tKSM_OPLBased then begin
  For x:=0 to OPL.Header.ObjectCount-1 do
  begin
    //Security
    Xmin:=round((OPL.Node[x].Position[0]*256)-(TrackBar_KCMHEIGHT_Diameter.Position/2));
    Xmax:=round((OPL.Node[x].Position[0]*256)+(TrackBar_KCMHEIGHT_Diameter.Position/2));

    ymin:=round(((1-OPL.Node[x].Position[1])*256)-(TrackBar_KCMHEIGHT_Diameter.Position/2));
    Ymax:=round(((1-OPL.Node[x].Position[1])*256)+(TrackBar_KCMHEIGHT_Diameter.Position/2));

    If Xmin<0 then
    begin
      Xmin:=0;
    end;
    If Xmax>255 then
    begin
      XMax:=255
    end;

    If Ymin<0 then
    begin
      Ymin:=0;
    end;
    If Ymax>255 then
    begin
      Ymax:=255
    end;

    //The painting
    For x1:=Xmin to Xmax do
    begin
      For y1:=Ymin to Ymax  do
      begin
        try
          map[x1][y1][0]:=Values[1];
          map[x1][y1][1]:=Values[2];
          map[x1][y1][2]:=KSM.ValuesToColor(Values[1],Values[2]);
          Image_General.canvas.Pixels[x1,y1]:=map[x1][y1][2]
        except
        end;
      end;
    end;
  end;

  KSM.Map:=map;
  KSM.Saved:=False;
  GLHeightField.StructureChanged;
  end;
end;

procedure TForm_Main.MainMenu_KCMFile_BorderCenterClick(Sender: TObject);
begin
  //Form_BorderCenter.Execute(KCM.Heightmap);
  Form_BorderCenter.Show;
end;

procedure TForm_Main.MainMenu_File_NewKSMFileClick(Sender: TObject);
var
  x1,y1:Integer;
  map:TKSMMap;
begin
  KSM:=TKalServerMap.Create;

  For x1:=0 to 255 do
  begin
    for y1:=0 to 255 do
    begin
      Map[x1][y1][0]:=0;
      Map[x1][y1][1]:=0;
      //Image_General.Canvas.Pixels[x1,y1]:=KSM.ValuesToColor(0,0);
    end;
  end;
  KSM.Map:=Map;
  If KCM<>nil then
  begin
  //If MessageBox(Handle, pchar('An KCM file has been loaded, want to paint the KSM file over it?'),'Paint?',MB_YESNO) = IDYES then
  //begin

  //end;
    GLHeightField.OnGetHeight:=GLHeightFieldPaintKSMmap;
    GLHeightField.StructureChanged;
  end else begin
    KCM:=TKalClientMap.Create;
    KCM.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Recources\empty.kcm', 1);
    GLHeightField.OnGetHeight:=GLHeightFieldPaintKSMmap;
    GLHeightField.StructureChanged;
  end;
  GlHeightField.OnGetHeight:=GLHeightFieldPaintKSMMap;
  GLHeightField.StructureChanged;

end;

procedure TForm_Main.MainMenu_OPLFileClick(Sender: TObject);
begin
  MainMenu_OPLFile_HeaderInfo.Enabled:=False;
  Mainmenu_OPLFile_AddNode.Enabled:=False;
  MainMenu_OPLFile_DeleteNode.Enabled:=False;
  MainMenu_OPLFile_DeleteAll.Enabled:=False;
  If OPL<>Nil then
  begin
    MainMenu_OPLFile_HeaderInfo.Enabled:=True;
    If KCM<>Nil then
    begin
      Mainmenu_OPLFile_AddNode.Enabled:=True;
    end;
    MainMenu_OPLFile_DeleteAll.Enabled:=True;
    If (Length(selected_OPLs)>0) and (Length(selected_OPLs)<>OPL.ObjectCount-1) then
    begin
      MainMenu_OPLFile_DeleteNode.Enabled:=True;
    end;
  end;
end;

procedure TForm_Main.MainMenu_OPLFile_DeleteNodeClick(Sender: TObject);
var
  x1,x2:Integer;
  Selected_OPL:TSelected_OPL;
  NotChanged:Boolean;
begin
      If MessageBox(0,PChar('Are you sure you want to delete the selected node?'),Pchar('Delete this node?'),mb_YesNo)=IDYES then
      begin
        If Length(Selected_OPLs)=0 then
        begin
          exit;
        end;

        //Ordening From lowest index to hieghest
        For x2:=0 to Length(selected_OPLs)-1 do
        begin
          NotChanged:=True;
          For x1:=0 to Length(Selected_OPLs)-2 do
          begin
            If (Selected_OPLs[x1+1].index<Selected_OPLs[x1].index) then
            begin
              //Backing up the record;
              Selected_OPL.Index:=Selected_OPLs[x1+1].Index;
              Selected_OPL.Tex:=Selected_OPLs[x1+1].Tex;

              //Shifting the other record
              Selected_OPLs[x1+1].Index:=Selected_OPLs[x1].Index ;
              Selected_OPLs[x1+1].Tex:=Selected_OPLs[x1].Tex;

              //Reentering the backed up record
              Selected_OPLs[x1].Index:=Selected_OPL.Index;
              Selected_OPLs[x1].Tex:=Selected_OPL.Tex;

              //We changed it, so notchanged = false
              NotChanged:=False;
            end;
          end;
          //If the array hasn't been change then everything is alligned...
          If NotChanged=True then
          begin
            Break;
          end;
        end;

        //The actual deleting
        For x1:=Length(Selected_OPLs)-1 downto 0 do
        begin
          //Deleting the Node in the OPL file...
          OPL.RemoveObject(Selected_OPLs[x1].Index);

          //Shifting the other models;
          For x2:=Selected_OPLs[x1].Index to OPL.ObjectCount-2 do
          begin
            GlDummyCube_OPLObjects.Children[x2].Assign(GLDummyCube_OPLObjects.Children[x2+1]);
          end;
          GLDummyCube_OPLObjects.Children[OPL.ObjectCount].Free;
        end;

        //Reseting the selected OPLs info
        SetLength(Selected_OPLs,0);
      end;
end;

procedure TForm_Main.MainMenu_OPLFile_DeleteAllClick(Sender: TObject);
var
  x1:Integer;
  //OPLNodeList:TOPLNodeList;
begin
  If OPL<>nil then
  begin
    //clearing all the models
    for x1:=0 to 3999 do
    begin
      try
        GLDummyCube.Children[x1].Destroy;
      except
      end;
    end;

    //Faster than 0 to 3999
    for x1:=3999 downto 0 do
    begin
      try
        OPL.RemoveObject(x1);
      except
      end;
    end;

    PositionOPL(True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

  end;
end;

procedure TForm_Main.MainMenu_OPLFile_AddNodeClick(Sender: TObject);
begin
 Tool_Old:=Tool;
 Tool:=tOPL_AddNode;
end;

procedure TForm_Main.CheckBox_CoordSysClick(Sender: TObject);
begin
  GLSceneViewer.PopupMenu:=nil;
  If CheckBox_CoordSys.Checked=True then
  begin
    GLSceneViewer.PopupMenu:=PopupMenu_CoordinateSys;
  end;
end;

procedure TForm_Main.PopUp_CoordSys_CopyXYClick(Sender: TObject);
begin
  Clipboard.AsText:=IntToStr(CoordSys_X)+' ; '+IntToStr(CoordSys_Y);
end;

procedure TForm_Main.PopUp_CoordSys_CopyXYZClick(Sender: TObject);
begin
  Clipboard.AsText:='(xy '+IntToStr(CoordSys_X)+' '+IntToStr(CoordSys_Y)+' '+IntToStr(CoordSys_Z)+')';
end;

procedure TForm_Main.PopUp_CoordSys_CopyXYSpawnClick(Sender: TObject);
begin
  Clipboard.AsText:=IntToStr(round(CoordSys_X/32))+' '+IntToStr(round(CoordSys_Y/32));
end;

procedure TForm_Main.PopUp_CoordSys_CopyXClick(Sender: TObject);
begin
  Clipboard.AsText:=IntToStr(CoordSys_X);
end;

procedure TForm_Main.PopUp_CoordSys_CopyYClick(Sender: TObject);
begin
  Clipboard.AsText:=IntToStr(CoordSys_Y);
end;

procedure TForm_Main.PopUp_CoordSys_CopyZClick(Sender: TObject);
begin
  Clipboard.AsText:=IntToStr(CoordSys_Z);
end;

procedure TForm_Main.PopupMenu_CoordSys_CopyXYZClick(Sender: TObject);
begin
  Clipboard.AsText:=IntToStr(CoordSys_X)+' ; '+IntToStr(CoordSys_Y)+' ; '+IntToStr(CoordSys_Z);
end;

procedure TForm_Main.MainMenu_File_SaveKCMFileAsClick(Sender: TObject);
var
  saveDialog:TSaveDialog;
  oplPath:String;
begin
  saveDialog:=TSaveDialog.Create(Form_Main);
  saveDialog.Title:='Save your KalClientMap';
  saveDialog.InitialDir:=KCMInital_Path;
  saveDialog.Filter := 'Kal Client Maps|*.kcm;';
  saveDialog.DefaultExt := '';
  saveDialog.FileName:='n_0'+IntToStr(KCM.Header.MapX)+'_0'+IntToStr(KCM.Header.MapY);

  If SaveDialog.Execute Then
  begin
    KCM.SaveToFile(saveDialog.FileName+'.kcm');
    OPL.SaveToFile(saveDialog.FileName+'.opl');
    MessageBox(handle,PChar('Succesfully saved MAP file to '''+KCM.FileLocation+''''),'Saving succeed',mb_ok);
    KCM.Saved:=True;
    OPL.Saved:=True;
  end;
end;

procedure TForm_Main.MainMenu_MAP_HeaderInfoClick(Sender: TObject);
begin
  Form_SetMapXY.SetMapXY;
end;

procedure TForm_Main.MainMenu_KCMFile_HeaderInfoClick(Sender: TObject);
begin
  Form_MapXY.SetKCMMapXY;
end;

procedure TForm_Main.MainMenu_OPLFile_HeaderInfoClick(Sender: TObject);
begin
  Form_MapXY.SetOPLMapXY;
end;

procedure TForm_Main.MainMenu_KCM_NewKCMFileClick(Sender: TObject);
var
  x1,y1:Integer;
  HeightMap:TKCMHeightMap;
  ColorMap:TKCMColorMap;
begin
  //Cleaning old data
  If (KCM<>nil) or (OPL<>nil) then
  begin
    KCM.Free;
    //clearing all the models
    for x1:=0 to 3999 do
    begin
      try
        GLDummyCube.Children[x1].Destroy;
      except
      end;
    end;

    //Faster than 0 to 3999
    for x1:=3999 downto 0 do
    begin
      try
        OPL.RemoveObject(x1);
      except
      end;
    end;

    PositionOPL(True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
    OPL.Free;
  end;

  //Creating new KCM
  KCM:=TKalClientMap.Create;
  KCM.Header:=TKCMHeader.Create;

  OPL:=TOPLFile.Create;
  Form_MapXY.SetKCMMapXY;

  //Creating heightmap
  For x1:=0 to 256 do
  begin
    For y1:=0 to 256 do
    begin
      HeightMap[x1][y1]:=1400;
    end;
  end;

  //Creating color map
  For x1:=0 to 255 do
  begin
    For y1:=0 to 255 do
    begin
      ColorMap[x1][y1][0]:=100;
      ColorMap[x1][y1][1]:=100;
      ColorMap[x1][y1][2]:=100;
    end;
  end;
  KCM.ColorMap:=ColorMap;
  KCM.Saved:=False;

  //MessageBox(Handle,PChar('KCM succesfully created, a few things for you to set:'+#13+#13'- Texture layers( for now its filled in as Grey)'+#13+'- Color Map'),'Succesfully Created a new KCM',mb_ok);

  GlHeightField.OnGetHeight:=GLHeightFieldPaintColorMap;
  GLHeightField.StructureChanged
end;

procedure TForm_Main.Button_LayerCenterClick(Sender: TObject);
begin
  Form_LayerCenter.Show;
end;

procedure TForm_Main.ResetRealm;
begin
  //Resetting Camera Positions
  GlCamera.Position.X:=127;
  GlCamera.Position.Y:=250;
  GlCamera.Position.Z:=300;

  //Resetting DummyCube's Positions
  GlDummyCube.Position.X:=128;
  GlDummyCube.Position.Y:=0;
  GlDummyCube.Position.Z:=128;

  //Reseting the KCM
  GlHeightField.Position.X:=0;
  GlHeightField.Position.Y:=0;
  GlHeightField.Position.Z:=0;

  //Resetting the OPL Objects
  GlDummyCube_OPLObjects.Position.X:=0;
  GlDummyCube_OPLObjects.Position.Y:=0;
  GlDummyCube_OPLObjects.Position.Z:=0;
end;

procedure TForm_Main.MainMenu_File_NewOPLFileClick(Sender: TObject);
begin
        Try
         // OPL.Free;
        except
        end;
  OPL:=TOPLFile.Create;
  Form_MapXY.SetKCMMapXY; //SetOPLMapXY;
end;


procedure TForm_Main.Button_OPL_BrowseModelClick(Sender: TObject);
begin
  //Form_BrowseModel.SelectFile(selected_OPLs[0].Index);

  SelectFile(selected_OPLs[0].Index);
end;

procedure TForm_Main.CheckBox_ShowOPLModelsClick(Sender: TObject);
begin
  If OPL<>nil then
  begin
    PositionOPL(True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
  end;
end;

procedure TForm_Main.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  x1,x2,x3:Integer;
  x,y:byte;
  NotNil:Boolean;
  OPLnode:TOPLNode;
  Model:TGLFreeForm;
  Selected_OPL:TSelected_OPL;
  Nodes:TSelected_OPLs;
  NotChanged:Boolean;
  Vector3F:TVector3F;
  v,u : TAffineVector;
  shader1: TOutLineShader;
  j: Integer;
begin
  If (tool=tOPL_XYZ) or (tool=tOPL_X) or (tool=tOPL_Y) or (tool=tOPL_Z) then
  begin
    If (Screen.ActiveControl<>TWinControl(Edit_OPL_Model)) and ((GetKeyState(VK_Delete) AND 128)=128)  then
    begin
      If MessageBox(0,PChar('Are you sure you want to delete the selected node?'),Pchar('Delete this node?'),mb_YesNo)=IDYES then
      begin
        If Length(Selected_OPLs)=0 then
        begin
          exit;
        end;

        //Ordening From lowest index to highest
        For x2:=0 to Length(selected_OPLs)-1 do
        begin
          NotChanged:=True;
          For x1:=0 to Length(Selected_OPLs)-2 do
          begin
            If (Selected_OPLs[x1+1].index<Selected_OPLs[x1].index) then
            begin
              //Backing up the record;
              Selected_OPL.Index:=Selected_OPLs[x1+1].Index;
              Selected_OPL.Tex:=Selected_OPLs[x1+1].Tex;

              //Shifting the other record
              Selected_OPLs[x1+1].Index:=Selected_OPLs[x1].Index ;
              Selected_OPLs[x1+1].Tex:=Selected_OPLs[x1].Tex;

              //Reentering the backed up record
              Selected_OPLs[x1].Index:=Selected_OPL.Index;
              Selected_OPLs[x1].Tex:=Selected_OPL.Tex;

              //We changed it, so notchanged = false
              NotChanged:=False;
            end;
          end;
          //If the array hasn't been change then everything is alligned...
          If NotChanged=True then
          begin
            Break;
          end;
        end;

        //The actual deleting
        For x1:=Length(Selected_OPLs)-1 downto 0 do
        begin
          //Deleting the Node in the OPL file...
          OPL.RemoveObject(Selected_OPLs[x1].Index);

          //Shifting the other models;
          For x2:=Selected_OPLs[x1].Index to OPL.ObjectCount-2 do
          begin
            GlDummyCube_OPLObjects.Children[x2].Assign(GLDummyCube_OPLObjects.Children[x2+1]);
          end;
          GLDummyCube_OPLObjects.Children[OPL.ObjectCount].Free;
        end;

        //Reseting the selected OPLs info
        SetLength(Selected_OPLs,0);
      end;
    end;
  end;

  If ((GetKeyState(VK_CONTROL) AND 128)=128)  and ((GetKeyState(Ord('Z')) AND 128)=128)  then
  begin
    NotNil:=False;
    for x:=0 to 255 do
    begin
      for y:=0 to 255 do
      begin
        If  Previous_KCM[0][x][y]>0 then
        begin
          NotNil:=True;
          break;
          break;
        end;
      end;
    end;
    If Notnil=True then
    begin
      KCM.Heightmap:=Previous_KCM[0];

      GLHeightField.StructureChanged;
      For x1:=0 to 8 do
      begin
        Previous_KCM[x1]:=Previous_KCM[x1+1];
        //Previous_KSM[x1]:=Previous_KSM[x1+1];
        //Previous_OPL[x1]:=Previous_OPL[x1+1];
      end;
      Previous_KCM[9]:=Nilled_KCM;
      //Previous_KSM[9]:=nil;
      //Previous_OPL[9]:=nil;
    end;
  end;

  If TOOL=tKCM_HeightBrush then begin
    If ((GetKeyState(Ord('1')) AND 128)=128) then begin GLHeightField.XSamplingScale.Step:=1; GLHeightField.YSamplingScale.Step:=1; GLHeightField.StructureChanged;
                                                        GLHeightFieldTwo.XSamplingScale.Step:=1; GLHeightFieldTwo.YSamplingScale.Step:=1; GLHeightFieldTwo.StructureChanged; end else
    If ((GetKeyState(Ord('2')) AND 128)=128) then begin GLHeightField.XSamplingScale.Step:=2; GLHeightField.YSamplingScale.Step:=2; GLHeightField.StructureChanged;
                                                        GLHeightFieldTwo.XSamplingScale.Step:=2; GLHeightFieldTwo.YSamplingScale.Step:=2; GLHeightFieldTwo.StructureChanged; end else
    If ((GetKeyState(Ord('3')) AND 128)=128) then begin GLHeightField.XSamplingScale.Step:=4; GLHeightField.YSamplingScale.Step:=4; GLHeightField.StructureChanged;
                                                        GLHeightFieldTwo.XSamplingScale.Step:=4; GLHeightFieldTwo.YSamplingScale.Step:=4; GLHeightFieldTwo.StructureChanged; end else
    If ((GetKeyState(Ord('4')) AND 128)=128) then begin GLHeightField.XSamplingScale.Step:=8; GLHeightField.YSamplingScale.Step:=8; GLHeightField.StructureChanged;
                                                        GLHeightFieldTwo.XSamplingScale.Step:=8; GLHeightFieldTwo.YSamplingScale.Step:=8; GLHeightFieldTwo.StructureChanged; end;
  end;

  If (TOOL=tOPL_X) or (TOOL=tOPL_Y) or (TOOL=tOPL_Z)  or (TOOL=tOPL_XYZ) then
  begin
    If ((GetKeyState(Ord('F')) AND 128)=128) then begin
      If Length(Selected_OPLs)=0 then
      begin
        exit;
      end;
      If Length(Selected_OPLs)=1 then begin
      Vector3F:=OPL.Node[Selected_OPLs[0].Index].Position;
      GLDummyCube.Position.X:=round((Vector3F[0]+(1/256))*256);
      GLDummyCube.Position.Y:=Vector3F[2]/32;
      GLDummyCube.Position.Z:=round(256-((Vector3F[1]+(1/256))*256));
      end;
    end
    else
    If ((GetKeyState(Ord('X')) AND 128)=128) then
    begin
      If Length(Selected_OPLs)=0 then
      begin
        exit;
      end;
        //Ordening From lowest index to highest
        For x2:=0 to Length(selected_OPLs)-1 do
        begin
          NotChanged:=True;
          If Length(Selected_OPLs)>1 then
          begin
            For x1:=0 to Length(Selected_OPLs)-2 do
            begin
              If (Selected_OPLs[x1+1].index<Selected_OPLs[x1].index) then
              begin
                //Backing up the record;
                Selected_OPL.Index:=Selected_OPLs[x1+1].Index;
                Selected_OPL.Tex:=Selected_OPLs[x1+1].Tex;

                //Shifting the other record
                Selected_OPLs[x1+1].Index:=Selected_OPLs[x1].Index ;
                Selected_OPLs[x1+1].Tex:=Selected_OPLs[x1].Tex;

                //Reentering the backed up record
                Selected_OPLs[x1].Index:=Selected_OPL.Index;
                Selected_OPLs[x1].Tex:=Selected_OPL.Tex;

                //We changed it, so notchanged = false
                NotChanged:=False;
              end;
            end;
            //If the array hasn't been change then everything is alligned...
            If NotChanged=True then
            begin
              Break;
            end;
          end;
        end;
      For x1:=0 to Length(Selected_OPLs)-1 do
      begin
        //Creating new OPL
        OPLNode:=TOPLNode.Create;

        //Setting info
        OPLNode.Path:=OPL.Node[Selected_OPLs[x1].Index].Path;
        OPLNode.PathLength:=Length(OPL.Node[Selected_OPLs[x1].Index].Path);
        Vector3F[0]:=OPL.Node[Selected_OPLs[x1].Index].Position[0]+(1/256);
        VEctor3F[1]:=OPL.Node[Selected_OPLs[x1].Index].Position[1]+(1/256);
        If CheckBox_OPL_Position_STM.Checked=true then
        begin
          Vector3F[2]:=KCM.HeightMap[round((OPL.Node[Selected_OPLs[x1].Index].Position[0]+(1/256))*256)][round(256-((OPL.Node[Selected_OPLs[x1].Index].Position[1]+(1/256))*256))];
        end
        else
        begin
          Vector3F[2]:=OPL.Node[Selected_OPLs[x1].Index].Position[2];
        end;

        //OPLNode.Position:=Vector3F(OPL.Node[Selected_OPLs[x1].Index].Position[0]+(1/256),OPL.Node[Selected_OPLs[x1].Index].Position[1]+(1/256),KCM.HeightMap[round((OPL.Node[Selected_OPLs[x1].Index].Position[0]+(1/256))*256)][round(256-((OPL.Node[Selected_OPLs[x1].Index].Position[1]+(1/256))*256))]);
        OPLNode.Position:=Vector3F;
        OPLNode.Scale:=OPL.Node[Selected_OPLs[x1].Index].Scale;
        OPLNode.Rotation:=OPL.Node[Selected_OPLs[x1].Index].Rotation;

        //Adding the node
        OPL.AddObject(OPLNode);

        //Displaying the node
        PositionOPLNode(OPL.ObjectCount-1,True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);

        //Restoring old selected OPLs textures
        Model:=TGLFreeForm(GLDummyCube_OPLObjects.Children[Selected_OPLs[x1].Index]);
        model.Material.LibMaterialName:=Selected_OPLs[x1].Tex;
        model.Material.frontproperties.emission.color:=clrblack;

        //Selecting the just created OPL node...
        Selected_OPLs[x1].Index:=OPL.ObjectCount-1;

        //Making new selected OPL node red...
        //Model:=TGLFreeForm(GLDummyCube_OPLObjects.Children[Selected_OPLs[x1].Index]);
        //Model.Material.LibMaterialName:='';
        //Model.material.frontproperties.emission.color:=clrred;
        //Overiding a red color, which indicates its selection.
        for j:=0 to Length(Selected_OPLs)-1 do
            begin
              shader1:=TOutLineShader.Create(Self);
              with shader1 do begin
                BackgroundColor:=ConvertWinColor(GLSceneViewer.Buffer.BackgroundColor);
                Outlinesmooth:=false;
                OutLineWidth:=4;
                Lighting:=true;
                LineColor:=clrRed;
              end;
              model:=TGLFreeForm(GLDummyCube_OPLObjects.Children[Selected_OPLs[j].Index]);
              //model.Material.LibMaterialName:=Selected_OPLs[j].Tex;
              GLMaterialLibrary2.Materials[0].Shader:=shader1;
              //model.Material.LibMaterialName:='';
              //model.Material.frontproperties.emission.color:=clrBlue;
              model.Material.MaterialLibrary:=GLMaterialLibrary2;
              model.Material.LibMaterialName:='Outline';
              //model.Material.LibMaterialName:=Selected_OPLs[j].Tex;
        end;

      end;

      //Displaying the info
      DisplayOPLNodeInfo(Selected_OPLs);

      OPL.ObjectCount;
    end;
  end;
end;

procedure TForm_Main.Edit_OPL_ModelKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
  begin
    PositionOPLNode(selected_OPLs[0].Index,True,CheckBox_ShowOPLModels.Checked);
  end;
end;

procedure TForm_Main.Timer_AutoSaveTimer(Sender: TObject);
var
  s:String;
begin
  ForceDirectories(ExtractFilePath(Application.Exename)+'AutoSaves');
  If OPL<>nil then
  begin
    try
    s:=OPL.FileLocation;
    OPL.SaveToFile(ExtractFilePath(Application.Exename)+'AutoSaves\AutoSave_OPL.OPL');
    OPL.FileLocation:=s;
    except
    end;
  end;

  If KCM<>nil then
  begin
    try
    s:=KCM.FileLocation;
    KCM.SaveToFile(ExtractFilePath(Application.Exename)+'AutoSaves\AutoSave_KCM.KCM');
    KCM.FileLocation:=s;
    except
    end;
  end;

  If KSM<>nil then
  begin
    try
    s:=KSM.FileLocation;
    KSM.SaveToFile(ExtractFilePath(Application.Exename)+'AutoSaves\AutoSave_KSM.KSM');
    KSM.FileLocation:=s;
    except
    end;
  end;
end;

procedure TForm_Main.CheckBox_ShowOPLTexturesClick(Sender: TObject);
var
  x1:Integer;
begin
  If OPL<>nil then
  begin
    for x1:=0 to OPL.ObjectCount-1 do
    begin
      PositionOPLNode(x1,False,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
    end;
  end;
end;

procedure TForm_Main.SpdBtn_OPL_XClick(Sender: TObject);
begin
   SpdBtn_OPL_X.Down := SpdBtn_OPL_X.Down;
   If (SpdBtn_OPL_X.Down=True) then begin
    TOOL:=tOPL_X;
   end;
end;

procedure TForm_Main.SpdBtn_OPL_YClick(Sender: TObject);
begin
   SpdBtn_OPL_Y.Down := SpdBtn_OPL_Y.Down;
   If (SpdBtn_OPL_Y.Down=True) then begin
    TOOL:=tOPL_Y;
   end;
end;

procedure TForm_Main.SpdBtn_OPL_ZClick(Sender: TObject);
begin
   SpdBtn_OPL_Z.Down := SpdBtn_OPL_Z.Down;
   If (SpdBtn_OPL_Z.Down=True) then begin
    TOOL:=tOPL_Z;
   end;
end;

procedure TForm_Main.SpdBtn_OPL_XYZClick(Sender: TObject);
begin
   SpdBtn_OPL_XYZ.Down := SpdBtn_OPL_XYZ.Down;
   If (SpdBtn_OPL_XYZ.Down=True) then begin
    TOOL:=tOPL_XYZ;
   end;
end;

procedure TForm_Main.Export_HeightmapClick(Sender: TObject);
var
  x,y:Integer;
  heightmap: TImagingPNG;
  BMP:TBitmap;
  map:TKCMHeightMap;
begin
  BMP:=TBitmap.Create;
  BMP.Width:=257;
  BMP.Height:=257;
  BMP.PixelFormat:=pf24bit;
  For x:=0 to 256 do
  begin
    For y:=0 to 256 do
      begin
        BMP.Canvas.Pixels[x,y]:=rgb(round(KCM.HeightMap[x][y]/16),round(KCM.HeightMap[x][y]/16),round(KCM.HeightMap[x][y]/16));
      end;
  end;
  heightmap := TImagingPNG.Create;
  heightmap.Assign(BMP);
  heightmap.CompressLevel:=0;
  ForceDirectories(ExtractFilePath(Application.Exename)+'images\n_0'+IntToStr(KCM.Header.MapX)+'_0'+IntToStr(KCM.Header.MapY));
  heightmap.SaveToFile(ExtractFilePath(Application.ExeName)+'images\n_0'+IntToStr(KCM.Header.MapX)+'_0'+IntToStr(KCM.Header.MapY)+'\KCM - Heightmap.png');
  heightmap.Free;
  ShowMessage('Exported');
end;

procedure TForm_Main.Import_HeightmapClick(Sender: TObject);
var
  x,y:Integer;
  BMP:TBitmap;
  heightmap:TImagingPNG;
  KCMHeightMap:TKCMHeightMap;
  OpenFileDialog:TOpenDialog;
begin
  KCMHeightMap:=KCM.HeightMap;
  OpenFileDialog:=TOpenDialog.Create(nil);
  OpenFileDialog.Filter:='Images *.png;|*.png;';
  OpenFileDialog.Title:='Open file...';
  OpenFileDialog.Options:=[ofHideReadOnly,ofEnableSizing];
  If OpenFileDialog.Execute Then
  begin
    BMP:=TBitmap.Create;
    heightmap := TImagingPNG.Create;
    heightmap.Width:=257;
    heightmap.Height:=257;
    BMP.Width:=257;
    BMP.Height:=257;
    BMP.PixelFormat:=pf24bit;
    heightmap.LoadFromFile(OpenFileDialog.FileName);
    BMP.Assign(heightmap);
    for x:= 256 downto 0 do begin for y:= 0 to 256 do begin KCMHeightMap[x][y]:=round(BMP.Canvas.Pixels[x,y]*16); end; end;
    heightmap.Free;
  end;
  KCM.HeightMap:=KCMHeightMap;
  GLHeightField.StructureChanged;
  GLHeightFieldTwo.StructureChanged;
end;

procedure TForm_Main.Trackbar_KCMGrassPaint_TypeChange(Sender: TObject);
var
  trackbar:TTrackBar;
begin
  If sender = Trackbar_KCMGrassPaint_Type then
  begin
    TrackBar:=Trackbar_KCMGrassPaint_Type;
    Edit_KCMHEIGHT_Hardness.Text:=IntToStr(Trackbar_KCMGrassPaint_Type.Position*2);
  end;

  Trackbar_KCMGrassPaint_Type.Position:=TrackBar.Position;
end;

procedure TForm_Main.Trackbar_KCMGrassPaint_IntensityChange(Sender: TObject);
var
  trackbar:TTrackBar;
begin
  If sender = Trackbar_KCMGrassPaint_Intensity then
  begin
    TrackBar:=Trackbar_KCMGrassPaint_Intensity;
    Edit_KCMHEIGHT_Intensity.Text:=IntToStr(Trackbar_KCMGrassPaint_Intensity.Position*2);
  end;

  Trackbar_KCMGrassPaint_Intensity.Position:=TrackBar.Position;
end;

procedure TForm_Main.ColorPickerClick(Sender: TObject);
var
  x,y:Integer;
begin
  if ColorDialog1.Execute then
    rgbColor := ColorDialog1.Color;
    For x:=0 to 64 do
    begin
    For y:=0 to 64 do
    begin
      BrushPreview.Canvas.Pixels[(x*2),(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)]:=FPBrush.Canvas.Pixels[x,y];
      BrushPreview.Canvas.Pixels[(x*2),(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
      BrushPreview.Canvas.Pixels[(x*2)+1,(y*2)+1]:=FPBrush.Canvas.Pixels[x,y];
    end;
  end;
end;

procedure TForm_Main.BrushPreviewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  beginX := X;
  beginY := Y;
  PaintActive := True;
end;

procedure TForm_Main.BrushPreviewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if PaintActive then begin
    xGlobal := X;
    yGlobal := Y;
    BrushPreview.Invalidate;
  end;
end;

procedure TForm_Main.BrushPreviewMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PaintActive := False;
  BrushPreview.Invalidate;
end;

procedure TForm_Main.BrushPreviewPaint(Sender: TObject);
begin
  if PaintActive then begin
    BrushPreview.Canvas.Brush.Color := PaintColor;
    BrushPreview.Canvas.Rectangle(beginX, beginY, xGlobal, yGlobal);
  end;
end;

procedure TForm_Main.About1Click(Sender: TObject);
begin
  ShowMessage('Created by Reb3lzrr, improved by Skipy');
end;

// MODEL VIEW
procedure TForm_Main.TreeView1Click(Sender: TObject);
var
  x1:integer;
  map:string;
  maps:tstrings;
  node,childnode:TTreeNode;
begin
  try
    Node:=TreeView1.Selected;
    maps:=TStringList.create;

    //Looping every Child of the expanding node;
    for x1:=0 to Node.Count-1 do
    begin
      //Equaling childnode to the child
      ChildNode:=Node.Item[x1];

      //Getting path
      map:=GetMap(ChildNode);

      //Getting sub dirs of that path
      maps.Clear;
      maps:=GetSubDirs(map);

      //Addint the sub dirs to the child node;
      AddSubDirs(ChildNode,map);
    end;
  except
  end;

  FileBox.Directory:=GetMap(Node);
end;

procedure TForm_Main.TreeView1Collapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
  Node.ImageIndex:=IMAGE_MAPCLOSED;
end;

procedure TForm_Main.FileBoxChange(Sender: TObject);
var
  Str,Path:String;
begin
  If (FileExists(FileBox.FileName)=True) and (LowerCase(ExtractFileExt(FileBox.FileName))='.gb') then
  begin
    Str:=ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(FileBox.FileName,Length(Client_Path)+Length('\Data\'),Length(FileBox.FileName));
    Str:=Copy(Str,1,Length(str)-3)+'.3ds';
      If FileExists(Str) then
      begin
        Path:=Copy(FileBox.FileName,Length(Client_Path)+1,Length(FileBox.FileName));

        OPL.Node[selected_OPLs[0].Index].Path:=Copy(Path,1,Length(Path)-3);
        DisplayOPLNodeInfo(Selected_OPLs);
        PositionOPLNode(Selected_OPLs[0].Index,True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
      end;
  end;
end;

procedure TForm_Main.TreeView1Expanding(Sender: TObject; Node: TTreeNode;var AllowExpansion: Boolean);
var
  x1:integer;
  map:string;
  maps:tstrings;
  childnode:TTreeNode;
begin
  try
    Node.ImageIndex:=IMAGE_MAPOPENED;
    maps:=TStringList.create;

    //Looping every Child of the expanding node;
    for x1:=0 to Node.Count-1 do
    begin
      //Equaling childnode to the child
      ChildNode:=Node.Item[x1];

      //Getting path
      map:=GetMap(ChildNode);

      //Getting sub dirs of that path
      maps.Clear;
      maps:=GetSubDirs(map);

      //Addint the sub dirs to the child node;
      AddSubDirs(ChildNode,map);
    end;
  except
  end;
end;
function TForm_Main.GetMap(TreeNode:TTreeNode):String;
var
  parent:TTreeNode;
  map:String;
begin
    //Getting path
    parent:=TreeNode;
    map:='';
    while parent.Parent<>nil do
    begin
      map:=parent.Text+map;
      parent:=parent.parent;
      map:='\'+map;
    end;
    result:=parent.Text+map;
end;
function TForm_Main.GetSubDirs(const directory : string): TStrings ;
var
  sr : TSearchRec;
begin
  Result:=TStringList.Create;
  try
    if FindFirst(IncludeTrailingPathDelimiter(directory) + '*.*', faDirectory, sr) < 0 then
      Exit
    else
    repeat
      if ((sr.Attr and faDirectory <> 0) AND (sr.Name <> '.') AND (sr.Name <> '..')) then
        Result.Add(IncludeTrailingPathDelimiter(directory) + sr.Name) ;
    until FindNext(sr) <> 0;
  finally
    SysUtils.FindClose(sr) ;
  end;
end;
function TForm_Main.GetFiles(const Path, Mask: string; IncludeSubDir: boolean): TStrings;
var
 FindResult: integer;
 SearchRec : TSearchRec;
begin
 result := TStringList.Create;;

 FindResult := FindFirst(Path + Mask, faAnyFile - faDirectory, SearchRec);
 while FindResult = 0 do
 begin
   { do whatever you'd like to do with the files found }
   Result.Add(Path + SearchRec.Name);
   //result := result + 1;

   FindResult := FindNext(SearchRec);
 end;
 { free memory }
 FindClose(SearchRec);

 if not IncludeSubDir then
   Exit;

 FindResult := FindFirst(Path + '*.*', faDirectory, SearchRec);
 while FindResult = 0 do
 begin
   if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
     result.text := result.text + GetFiles(Path + SearchRec.Name + '\', Mask, TRUE).text;

   FindResult := FindNext(SearchRec);
 end;
 { free memory }
 FindClose(SearchRec);
end;

procedure TForm_Main.AddSubDirs(TreeNode:TTreeNode;Map:String);
var
  maps:TStrings;
  x2:Integer;
  AddedNode:TTreeNode;
begin
    //Getting sub dirs of that path
    maps:=TStringList.create;
    maps.Clear;
    maps:=GetSubDirs(map);

    //Checking if ther are any childs;
    If TreeNode.Count<>0 then
    begin
      //Childs detected; overwriting the old ones.
      For x2:=0 to TreeNode.Count-1 do
      begin
        maps[x2]:=Copy(maps[x2],length(map)+2,length(maps[x2]));
        TreeNode.Item[x2].Text:=maps[x2];
      end;
      //Need to add more childs to the TreeNode;;
      If TreeNode.Count<Maps.Count then
      begin
        For x2:=TreeNode.Count-1 to Maps.Count-1 do
        begin
          maps[x2]:=Copy(maps[x2],length(map)+2,length(maps[x2]));
          AddedNode:=TreeView1.Items.AddChild(TreeNode,maps[x2]);
          AddedNode.ImageIndex:=IMAGE_MAPCLOSED;
        end;
      end;
    end
    else
      //No Childs detected; adding all sub dirs;
      For x2:=0 to maps.count-1 do
      begin
        maps[x2]:=Copy(maps[x2],length(map)+2,length(maps[x2]));
        AddedNode:=TreeView1.Items.AddChild(TreeNode,maps[x2]);
        AddedNode.ImageIndex:=IMAGE_MAPCLOSED;
      end;
end;

procedure TForm_Main.DirectoryBoxChange(Sender: TObject);
begin
  {If (Pos(Form_Main.Client_Path,DirectoryBox.Directory)=0) {and (DirectoryExists(Form_Main.Client_Path)=True) then
  begin
    DirectoryBox.Directory:=Form_Main.Client_Path;
  end;}
end;

procedure TForm_Main.BuildNodes(FileLocation:String);
var
  x1:Integer;
  parent:TTreeNode;
  maps:TStrings;
begin
  TreeView1.Items.Clear;

  parent:=TreeView1.Items.AddChild(nil,FileLocation);
  maps:=TStringList.create;
  maps:=GetSubDirs(FileLocation);
  For x1:=0 to maps.count-1 do
  begin
    maps[x1]:=Copy(maps[x1],Length(FileLocation)+2,length(maps[x1]));
    TreeView1.Items.AddChild(parent,maps[x1])
  end;
  //ListBox1.Items:=maps;
end;

procedure TForm_Main.SelectFile(Model:Integer);
var
  x,x2:Integer;
  Str,Str2,Path,Path2:String;
  FileLocation,FileLocation2:String;
  Maps:TStrings;
  Map:String;
  Node:TTreeNode;
  match:Integer;
begin
  OPL_Node:=Model;
  maps:=TStringList.create;
  maps.Clear;
  FileLocation:=OPL.Node[OPL_Node].Path;
  FileLocation2:=OPL.Node[OPL_Node].Path;

  If FileExists(Client_Path+'\'+FileLocation+'.gb') = true then
  begin
    x:=1;
    While x<Length(FileLocation2) do
    begin
      If FileLocation2[x]='\' then
      begin
        Maps.Add(Copy(FileLocation2,1,x-1));
        Delete(FileLocation2,1,x);
        x:=1;
      end;
      x:=x+1;
    end;

    TreeView1.Items.Clear;
    Node:=TreeView1.Items.AddChild(nil,Copy(Client_path,1,Length(Client_path)-1));
    map:=GetMap(Node);
    AddSubDirs(Node,map);
    //Try
      For x:=0 to maps.Count-1 do
      begin
        match:=-1;
        For x2:=0 to Node.Count-1 do
        begin
          If LowerCase(Node.Item[x2].Text)=LowerCase(maps[x]) then
          begin
            match:=x2;
          end;
        end;
        If Match<>-1 then
        begin
          Node.Expanded:=True;
          Node.Selected:=True;
          Node:=Node.Item[Match];
          map:=GetMap(Node);
          AddSubDirs(Node,map);
          FileBox.Directory:=map;
        end
        else
        begin
          BuildNodes(Copy(Client_Path,1,Length(Client_Path)-1));
        end;
      end;
 {
      Str2:=ExtractFileName(Client_Path+'\'+FileLocation+'.gb');
      For x:=0 to FileBox.Count-1 do
      begin
        If FileBox.Items[x]=Str2 then
        begin
          FileBox.Selected[x]:=True;
          If (FileExists(FileBox.FileName)=True) and (LowerCase(ExtractFileExt(FileBox.FileName))='.gb') then
          begin
            Str:=ExtractFileDir(Application.ExeName)+'\Recources\'+Copy(FileBox.FileName,Length(Client_Path)+Length('\Data\'),Length(FileBox.FileName));
            Str:=Copy(Str,1,Length(str)-3)+'.3ds';
            If FileExists(Str) then
            begin

            end
            else
            begin

            end;
          end;
        end;
      end;
 }
  end
  else
  begin
    //MessageBox(0,PChar('Can''t the specified model, this error can occur if the model wasn''t converted well, or you Models are out-dated.'),PChar('File doesn''t exists'),mb_ok);
    BuildNodes(Copy(Client_Path,1,Length(Client_Path)-1));
  end;
end;

procedure TForm_Main.Chk_ResetClick(Sender: TObject);
var
  x1,y1:Integer;
begin
  If MessageBox(Handle, pchar('Are you sure you want to reset the scene?'),'Reset?',MB_YESNO) = IDYES then
  begin
  If (KCM<>nil) or (OPL<>nil) then
  begin
    KCM.Free;
    //clearing all the models
    for x1:=0 to 3999 do
    begin
      try
        GLDummyCube.Children[x1].Destroy;
      except
      end;
    end;

    //Faster than 0 to 3999
    for x1:=3999 downto 0 do
    begin
      try
        OPL.RemoveObject(x1);
      except
      end;
    end;

    PositionOPL(True,CheckBox_ShowOPLModels.Checked,CheckBox_ShowOPLTextures.Checked);
    OPL.Free;
     {
    KSM:=TKalServerMap.Create;

    For x1:=0 to 255 do
    begin
    for y1:=0 to 255 do
    begin
      Map[x1][y1][0]:=0;
      Map[x1][y1][1]:=0;
    end;
    end;
    KSM.Map:=Map;
    }
    KSM.Free;
    end;
  end;
end;

procedure TForm_Main.Delay(Milliseconds: Integer);
var
  Tick: DWord;
  Event: THandle;
begin
  Event := CreateEvent(nil, False, False, nil);
  try
    Tick := GetTickCount + DWord(Milliseconds);
    while (Milliseconds > 0) and
          (MsgWaitForMultipleObjects(1, Event, False, Milliseconds, QS_ALLINPUT) <> WAIT_TIMEOUT) do
    begin
      Application.ProcessMessages;
      if Application.Terminated then Exit;
      Milliseconds := Tick - GetTickcount;
    end;
  finally
    CloseHandle(Event);
  end;
end;
{
procedure Delay(msec: integer);
var start, stop: LongInt;
begin
  start := GetTickCount;
  repeat
    stop := GetTickCount;
    Application.ProcessMessages;
  until (stop-start)>=msec;
end;
}
procedure TForm_Main.DuplicateMapClick(Sender: TObject);
var
Openfiledialog:TOpenDialog;
filepath,x,y:String;
KCMHeader:TKCMHeader;
OPLHeader:TOPLHeader;
begin
  If (KCM<>nil) or (OPL<>nil) then
  begin
    If MessageBox(Handle, pchar('Duplicate Current Map?'),'Duplicate?',MB_YESNO) = IDYES then
    begin
      //Duplicate Current map
      Form_MapXY.SetKCMMapXY;
      //Form_MapXY.SetOPLMapXY;
      filepath := ExtractFilePath(KCM.FileLocation);

        KCMHeader:=TKCMHeader.Create;
        KCMHeader:=KCM.Header;
        OPLHeader:=TOPLHeader.Create;
        OPLHeader:=OPL.Header;
        x:=IntToStr(KCMHeader.MapX);
        y:=IntToStr(KCMHeader.MapY);
        KCM.SaveToFile(filepath+'n_0'+x+'_0'+y+'.kcm');
        OPL.SaveToFile(filepath+'n_0'+x+'_0'+y+'.opl');
    end
    else
    begin
      //Browse to map and duplicate
    end;
  end
  else
  begin
    //Browse to map and duplicate
  end;
end;

end. // End of File
