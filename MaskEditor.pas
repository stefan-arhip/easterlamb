unit MaskEditor;

interface
uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ExtCtrls, maskgenerator, dsgnintf;


type
	TCoolMaskEditor = class(TPropertyEditor)
		private
			FValue:string;
		public
			destructor destroy;override;
			procedure Edit;override;
			function GetAttributes: TPropertyAttributes;override;
			function getname:string; override;
			function getValue:string; override;
		published
			property Value:string read FValue write FValue;
	end;

var
	FormCreated:boolean=false;

implementation

uses
	CoolForm;

function TCoolMaskEditor.getname:string;
begin
	result:='Mask';
end;


function TCoolMaskEditor.getValue:string;
begin
	result:='Mask';
end;



destructor TCoolMaskEditor.Destroy;
begin
	if Formmaskgenerator<>nil then
  begin
  	FormMaskGenerator.Free;
     FormMaskGenerator:=nil;
     FormCreated:=false;
	end;
	inherited;
end;

function TCoolMaskEditor.GetAttributes: TPropertyAttributes;
begin
	// Make Delphi display the (...) button in the objectinspector
	Result := [paDialog];
end;


procedure TCoolMaskEditor.Edit;
//******************* Unknown *************************
begin
	// Create the maskeditorform if it doesn`t exist yet
	if not assigned(FormMaskGenerator) then
	begin
		formMaskGenerator:=TFormMaskGenerator.Create(nil);
		formMaskGenerator.OriginalRegionData:=nil;
		formMaskGenerator.SaveOriginalRegionData;
		FormCreated:=true;
	end;
	with formMaskGenerator do
	begin
		// Set the existing mask in the editor
		formMaskGenerator.Rgn1:=hrgn(TRegionType(GetOrdValue).Fregion);
		// copy the bitmap into the editor
		Image1.picture.bitmap.Assign(TRegionType(GetOrdValue).owner.picture.bitmap);
		opendialog1.filename:='';
		Showmodal;
		// get the new region from the editor
		hrgn(TRegionType(GetOrdValue).Fregion):=formMaskGenerator.Rgn1;
		// note: the editorform must not be freed here
		// if done, delphi eats lines of the sourcecode of the form in which coolform is used
		// (every line where a visible component is defined) ... rather strange
	end;
end;


end.
