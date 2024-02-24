unit CoolForm;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ExtCtrls ,dsgnintf;

type
	TCoolForm = class;

	TRegionType = class(TPersistent)
		public
			Fregion:hrgn;
			owner:TCoolForm;
	end;

	TCoolForm = class(TImage)
		private
			Fregion   : TRegionType;
			FOrgRgn   : PRgnData;
			FOrgSize  : Integer;
			// the dummy is necessary (or maybe not) as a public property for the writing of the
			// mask into a stream (btter leyve it as it is, never touch a running system)
			Dummy:TRegionType;
			FDraggable:boolean;
                        FEnteringMouse:Boolean;
			procedure PictureChanged(Sender:TObject);
			procedure ReadMask(Reader: TStream);
			procedure WriteMask(Writer: TStream);
			procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
			procedure DefineProperties(Filer: TFiler);override;
			procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
		protected
			procedure SetRegion(Value:TRegionType);
			procedure SetParent(Value:TWinControl); override;
			procedure SetTop(Value:integer); virtual;
			procedure SetLeft(Value:integer); virtual;
			procedure Setwidth(Value:integer); virtual;
			procedure SetHeight(Value:integer); virtual;
			function  GetRegion:TRegionType;
			procedure size;
		public
			constructor Create(Aowner:TComponent); override;
			destructor  Destroy; override;
			property    Mask2:TRegionType read Dummy write Dummy;
			function    LoadMaskFromFile (FileName: String): Boolean;
                        procedure   CMMouseEnter(var AMsg: TMessage); message CM_MOUSEENTER;
                        procedure   CMMouseLeave(var AMsg: TMessage); message CM_MOUSELEAVE;
        procedure RefreshRegion;
		published
			property Mask:TRegionType read GetRegion write SetRegion;
			property Draggable:boolean read FDraggable write FDraggable default true;
                        property EnteringMouse:boolean read FEnteringMouse write FEnteringMouse default False;
			property top write settop;
			property left write setleft;
			property width write setwidth;
			property height write setheight;
	end;

procedure Register;

implementation
uses
	MaskEditor;

procedure Register;
begin
	RegisterComponents ('Cool!', [TCoolForm]);
	RegisterPropertyEditor (TypeInfo(TRegionType), TCoolForm, 'Mask', TCoolMaskEditor);
end;

procedure TCoolForm.CMMouseEnter(var AMsg: TMessage);
begin
  //MessageBox(Parent.Handle,'Mouse enter','Message',MB_OK);
  EnteringMouse:=True;
end;

procedure TCoolForm.CMMouseLeave(var AMsg: TMessage);
begin
  //MessageBox(Parent.Handle,'Mouse leave','Message',MB_OK);
  EnteringMouse:=False;
end;

// The next two procedures are there to ensure hat the component always sits in the top left edge of the window
procedure TCoolForm.SetTop(Value:integer);
begin
	inherited top := 0;
end;

procedure TCoolForm.SetLeft(Value:integer);
begin
	inherited left := 0;
end;

procedure TCoolForm.RefreshRegion;
begin
	FRegion.FRegion := ExtCreateRegion (nil, FOrgSize, FOrgRgn^);
	SetWindowRgn (parent.handle, FRegion.Fregion, true);
end;

destructor TCoolForm.destroy;
begin
	If FOrgRgn <> Nil then
		FreeMem (FOrgRgn, FOrgSize);

	if fregion.fregion <> 0 then deleteobject (fregion.fregion);
	Dummy.Free;
	FRegion.free;
	inherited;
end;

constructor TCoolForm.create(Aowner:TComponent);
begin
	inherited;
	// make it occupy all of the form
	Align := alClient;
	Fregion := TRegionType.Create;
	Dummy := TRegionType.Create;
	Fregion.Fregion := 0;
	Fregion.owner := self;
	Picture.OnChange := PictureChanged;
	// if draggable is false, it will be overwritten later by delphi`s runtime component loader
	Draggable := true;
        EnteringMouse:=False;
end;

procedure TCoolForm.PictureChanged(Sender:TObject);
begin
	if (parent <> nil) and (picture.bitmap <> nil) then
	begin
		// resize the form to fit the bitmap
{		width:=picture.bitmap.Width;
		height:=picture.bitmap.height;
		parent.clientwidth:=picture.bitmap.Width;
		parent.clientheight:=picture.bitmap.height;
}	end;
	if Fregion.FRegion<>0 then
	begin
		// if somehow there`s a region already, delete it
		deleteObject (FRegion.FRegion);
		FRegion.Fregion := 0;
	end;
end;

function TCoolForm.GetRegion:TRegionType;
begin
	result := FRegion;
end;

procedure TCoolForm.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
	// if dragging is on, start the dragging process
  If Draggable Then
	If button = mbleft then
	begin
		releasecapture;
		TWincontrol (Parent).perform (WM_syscommand, $F012, 0);
	end;
end;

// This is used by delphi`s component streaming system
// it is called whenever delphi reads the componnt from the .dfm
procedure TCoolForm.ReadMask(Reader: TStream);
begin
	// read the size of the region data to come
	reader.read (FOrgSize, 4);
	if FOrgSize <> 0 then
	begin
		// if we have region data, allocate memory for it
		getmem (FOrgRgn, FOrgSize);
		// read the data
		reader.read (FOrgRgn^, FOrgSize);
		// create the region
		FRegion.FRegion := ExtCreateRegion (nil, FOrgSize, FOrgRgn^);
		if not (csDesigning in ComponentState) and (FRegion.FRegion <> 0) then
			SetWindowRgn (parent.handle, FRegion.Fregion, true);
		// dispose of the memory
	end else fregion.fregion := 0;
end;


// This is pretty much the same stuff as above. Only it`s written this time
procedure TCoolForm.WriteMask(Writer: TStream);
var
	size		: integer;
	rgndata	: pRGNData;

begin
	if (fregion.fregion<>0) then
	begin
		// get the region data`s size
		size:=getregiondata (FRegion.FRegion, 0, nil);
		getmem (rgndata,size);
		// get the data itself
		getregiondata (FRegion.FRegion, size, rgndata);
		// write it
		writer.write (size,sizeof (size));
		writer.write (rgndata^, size);
		freemem (rgndata, size);
	end else
	begin
		// if there`s no region yet (from the mask editor), then write a size of zero
		size := 0;
		writer.write (size, sizeof (size));
	end;
end;

// This tells Delphi to read the public property `Mask 2` from the stream,
// That`s what we need the dummy for.
procedure TCoolForm.DefineProperties(Filer: TFiler);
begin
	inherited DefineProperties(Filer);
	// tell Delphi which methods to call when reading the property data from the stream
	Filer.DefineBinaryProperty ('Mask2', ReadMask, WriteMask, true);
end;

procedure TCoolForm.SetRegion(Value:TRegionType);
begin
	if Value <> nil then
	begin
		FRegion := Value;
		// The owner is for the property editor to find the component
		FRegion.owner := self;
	end;
end;

procedure TCoolForm.SetParent(Value:TWinControl);
begin
	inherited;
	if Value <> nil then
		if not (Value is TWinControl) then
		begin
			raise Exception.Create ('Drop the CoolForm on a FORM!');
		end else
		with TWincontrol (Value) do
		begin
			if Value is TForm then TForm (Value).borderstyle := bsNone;
		end;
	top := 0;
	left := 0;
end;

procedure TCoolForm.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
	message.Result := 1;
end;

function TCoolForm.LoadMaskFromFile (FileName: String): Boolean;
var
	reader : TFileStream;

begin
	// read the size of the region data to come

	try
		reader := TFileStream.Create (FileName, fmOpenRead);
		reader.read (FOrgSize, 4);
		if FOrgSize <> 0 then
		begin
			If ForgRgn <> Nil then
				FreeMem (FOrgRgn, FOrgSize);
			// if we have region data, allocate memory for it
			getmem(FOrgRgn, FOrgSize);
			// read the data
			reader.read (FOrgRgn^, FOrgSize);
			// create the region
			FRegion.FRegion:=ExtCreateRegion(nil,FOrgSize,FOrgRgn^);
			// if runtime, set the region for the window... Tadaaa
			if not (csDesigning in ComponentState) and (FRegion.FRegion <> 0) then
			begin
				SetWindowRgn (parent.handle, FRegion.Fregion, true);
			end;
			// dispose of the memory
		end else fregion.fregion := 0;
		 reader.free;
		Result := True;
	except
		Result := False;
	end;

end;

procedure TCoolForm.size;
var
	size		: integer;
	rgndata	: pRGNData;
	xf			: TXform;

begin
	if (fregion.fregion<>0) then
	begin
		// get the region data`s size
		size := getregiondata (FRegion.FRegion, 0, nil);
		getmem (rgndata, size);
		// get the data itself
		getregiondata (FRegion.FRegion, size, rgndata);
		// write it

		xf.eM11 := 1;//Width / Picture.Bitmap.Width;
		xf.eM12 := 0;
		xf.eM21 := 0;
		xf.eM22 := 1;//Height / Picture.Bitmap.Height;
		xf.eDx := 0;
		xf.eDy := 0;
		FRegion.FRegion := ExtCreateRegion (nil, size, rgndata^);

		if not (csDesigning in ComponentState) and (FRegion.FRegion <> 0) then
			SetWindowRgn (parent.handle, FRegion.Fregion, true);
	end;
end;

procedure TCoolForm.Setwidth(Value:integer);
begin
	inherited Width := Value;
//	Size;
end;

procedure TCoolForm.SetHeight(Value:integer);
begin
	inherited Height := Value;
//	Size;
end;

end.
