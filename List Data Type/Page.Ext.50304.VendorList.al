pageextension 50304 ISA_VendorListExt extends "Vendor List"
{
    trigger OnOpenPage()
    var
        ISA_ToolBox: Codeunit ISA_ToolBox;
    begin
        ISA_ToolBox.ISA_SplitIntoList();
    end;
}