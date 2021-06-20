// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50110 CustomerListExt extends "Customer List"
{
    trigger OnOpenPage();
    var
        info: Codeunit MyCodeunit;
    begin
        // Message('%1', info.MyProcedure());
        Message('%1', info.Get_App_Version('437dbf0e-84ff-417a-965d-ed2bb9650972'));
    end;
}