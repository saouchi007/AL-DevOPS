/// <summary>
/// PageExtension ISA_ItemList_Ext (ID 50202) extends Record Item List.
/// </summary>
pageextension 50202 ISA_ItemList_Ext extends "Item List"
{
    trigger OnOpenPage()
    var
        i: Integer;
        v: Record Vendor;
    begin
        i := 10;
        Alpha(i);
        Message('I is : %1', i); // i = 10 if no 'var' is used with Alpha, if var is used then no constant can be used 
                                 //with Alpha when called, because no adress is available when using a constant 

        v.FindFirst();
        Beta(v); // if no var is used on the procedure callstack then an error message would be generated
        v."Address 2" += 'Booya !';
        v.Modify();


        // 1. Integer , decim, date , record => need to have Var used
        //2. .net objects do not need var , ie : jsonobject
    end;

    local procedure Alpha(var i: integer)
    begin
        i += 1;
    end;

    local procedure Beta(var v: Record Vendor)
    begin
        V."Address 2" += 'Hazaaa !';
        v.Modify();
    end;


}