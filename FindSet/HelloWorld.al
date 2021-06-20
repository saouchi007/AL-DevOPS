// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 50100 CustomerListExt extends "Customer List"
{
    trigger OnOpenPage();
    var
        MyRecRef: RecordRef;
        MyFieldRef: FieldRef;
    begin
        MyRecRef.Open(18);
        MyFieldRef := MyRecRef.Field(1);
        MyFieldRef.SetFilter('01121212..01905902');
        MyFieldRef := MyRecRef.Field(2);
        if MyRecRef.FindSet(false, false) then begin
            repeat
                Message('%1 - %2', MyRecRef.RecordId, MyFieldRef.Value);
            until MyRecRef.Next = 0;
        end;
    end;
}