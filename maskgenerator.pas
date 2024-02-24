unit maskgenerator;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, ComCtrls, Buttons, ExtCtrls, CoolForm, ExtDlgs;

type
	TFormMaskGenerator = class(TForm)
		SpeedButton1: TSpeedButton;
		SpeedButton2: TSpeedButton;
		SpeedButton3: TSpeedButton;
		Panel1: TPanel;
		CoolForm1: TCoolForm;
		Image1: TImage;
    OpenDialog1: TOpenPictureDialog;
    SpeedButton4: TSpeedButton;
    SaveDialog1: TSaveDialog;
		procedure SpeedButton1Click(Sender: TObject);
		procedure SpeedButton2Click(Sender: TObject);
		procedure SpeedButton3Click(Sender: TObject);
		procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
		procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
		procedure BitMapChange(Sender:TObject);
		procedure FormCreate(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
	private
			oldleft,oldtop:integer;
     	generating:boolean;
	public
     	OriginalRegionSize:integer;
		OriginalRegiondata:pRGNData;
     	rgn1:hrgn;
		procedure SaveOriginalRegionData;
     	destructor destroy; override;
	end;

var
	FormMaskGenerator: TFormMaskGenerator;


implementation

{$R *.DFM}

procedure TFormMaskGenerator.SpeedButton1Click(Sender: TObject);
begin
	if Opendialog1.Execute then image1.Picture.bitmap.LoadFromFile(opendialog1.filename);
end;


// This method is necessary to react to changes in the size of the bitmap
procedure TFormMaskGenerator.BitMapChange(Sender:TObject);
var
	tr2,temprgn:hrgn;
	x:pxform;
begin
	if not generating then
	begin
		// This is the transformation matrix to be used in the region generating process
		// will be used in future releases
		x:=new(pxform);
		x.eM11:=1;
		x.eM12:=0;
		x.eM21:=0;
		x.eM22:=1;
		x.eDx:=-oldleft;
		x.eDy:=-oldtop;

		// the original region is created (the generator form only)
		temprgn:=ExtCreateRegion(x,originalRegionSize,OriginalRegionData^);
		image1.width:=image1.picture.bitmap.width;
		image1.height:=image1.picture.bitmap.height;
		clientwidth:=image1.Left+image1.Width;
		clientHeight:=image1.Top+image1.Height;
     if clientwidth<=150 then ClientWidth:=150;
     if clientHeight<=150 then ClientHeight:=150;

		// a region for the bitmap is created
		tr2:=CreateRectRgn(image1.left,image1.top,image1.left+image1.width,image1.top+image1.height);
		// the two regions are combined
		CombineRgn(temprgn,temprgn,tr2,RGN_OR);
		// set the new region
		DeleteObject(CoolForm1.Mask.fregion);
		CoolForm1.Mask.Fregion:=tempRgn;
		SetWindowRgn(handle,temprgn,true);
		// clean up
		DeleteObject(tr2);
		image1.repaint;
		dispose(x);
	end;
end;


// this method is called by the Propertyeditor to backup the maskgenerator`s mask generated at design-time
procedure TFormMaskGenerator.SaveOriginalRegionData;
begin
	// clean up
	if OriginalRegionData<>nil then
	begin
		freemem(OriginalRegionData);
		OriginalRegionData:=nil;
	end;
	// save original mask information
	oldleft:=left;
	oldtop:=top;
	OriginalRegionsize:=GetRegionData(CoolForm1.Mask.Fregion,0,nil);
	getmem(OriginalRegionData,OriginalRegionsize);
	getregiondata(CoolForm1.Mask.FRegion,OriginalRegionsize,OriginalRegiondata);
end;

destructor TFormMaskGenerator.destroy;
begin
		// clean up
	if OriginalRegionData<>nil then
	begin
		freemem(originalregiondata);
	end;
	OriginalRegionData:=nil;
	inherited;
end;


procedure TFormMaskGenerator.SpeedButton2Click(Sender: TObject);
begin
	close;
end;

// This is called when the User clicks the OK Button
procedure TFormMaskGenerator.SpeedButton3Click(Sender: TObject);
var
//	stream						: TFileStream;
	size							: integer;
//	rgndata						: pRGNData;
	x,y							: integer;
	transparentcolor			: tcolor;
	rgn2							: hrgn;
	startx,endx					: integer;
	R								: TRect;

begin
  if Panel1.Color =  clNone then
     Begin
       ShowMessage('You must select the colour to be masked out.'#13+
                   'Click on the mask colour in the bitmap. '#13 +
                   '(It will appear in the square to the right of the load button).');
       Exit;
     End;
	generating:=true;
	// clean up
	if rgn1<>0 then deleteObject(rgn1);
	rgn1 := 0;
	// set the transparent color
	transparentcolor:=Panel1.color;
	// if necessary, load another mask (don`t know why again... should be redundant)
	if opendialog1.filename<>'' then image1.picture.bitmap.loadfromfile(opendialog1.filename);
	
	// for every line do...
	for y := 0 to image1.Picture.Height-1 do
	begin
		// don`t look as if we were locked up
		Application.ProcessMessages;
		x:=0;
		endx:=x;
		// no flicker
		lockWindowUpdate(FormMaskGenerator.handle);
		repeat
			// look for the beginning of a stretch of non-transparent pixels
			while (image1.picture.bitmap.canvas.pixels[x,y]=transparentcolor) and (x<=image1.picture.width) do
			inc(x);
			startx:=x;
			// paint the pixels up to here black
			for size:=endx to startx do image1.picture.bitmap.canvas.pixels[size,y]:=image1.picture.bitmap.canvas.pixels[size,y] xor $FFFFFF;
			// look for the end of a stretch of non-transparent pixels
        inc(x);
			while (image1.picture.bitmap.canvas.pixels[x,y]<>transparentcolor) and (x<=image1.picture.width) do
			inc(x);
			endx:=x;
			// do we have some pixels?
			if startx<>image1.Picture.Width then
			begin
				if endx= image1.Picture.Width then dec(endx);
				// do we have a region already?
				if rgn1 = 0 then
				begin
					// Create a region to start with
					rgn1:=createrectrgn(startx+1,y,endx,y+1);
				end else
				begin
					// Add to the existing region
					rgn2:=createrectrgn(startx+1,y,endx,y+1);
					if rgn2<>0 then combinergn(rgn1,rgn1,rgn2,RGN_OR);
					deleteobject(rgn2);
				end;
				// Paint the pixels white
				for size:=startx to endx do image1.picture.bitmap.canvas.pixels[size,y]:=image1.picture.bitmap.canvas.pixels[size,y] xor $FFFFFF;
			end;
		until x>=image1.picture.width-1;
		// flicker on
		lockwindowUpdate(0);
		// tell windows to repaint only the line of the bitmap we just processed
		R.top:=image1.top+y;
		r.Bottom:=image1.top+y+1;
		r.left:=image1.left;
		r.right:=image1.left+image1.Width;
		invalidaterect(formmaskgenerator.handle,@R,false);
		formmaskgenerator.Update;
	end;
	generating:=false;
	close;
end;


procedure TFormMaskGenerator.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
	if ssLeft in Shift then
	begin
		panel1.color:=image1.picture.bitmap.canvas.pixels[x,y];
	end;
end;


procedure TFormMaskGenerator.Image1MouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
	panel1.color:=image1.picture.bitmap.canvas.pixels[x,y];
end;


procedure TFormMaskGenerator.FormCreate(Sender: TObject);
begin
	image1.picture.OnChange:=BitMapChange;
end;

procedure TFormMaskGenerator.SpeedButton4Click(Sender: TObject);
var
	size			: integer;
	rgndata		: pRGNData;
	writer		: TFileStream;

begin
	If SaveDialog1.Execute then
	begin
		if (rgn1<>0) then
		begin
			writer :=TFileStream.Create (SaveDialog1.Filename, fmCreate);
			// get the region data`s size
			size:=getregiondata (rgn1, 0, nil);
			getmem (rgndata, size);
			// get the data itself
			getregiondata(rgn1, size, rgndata);
			// write it
			writer.write (size, sizeof(size));
			writer.write (rgndata^, size);
			freemem(rgndata, size);
			writer.Free;			
		end;
	end;
end;

end.
