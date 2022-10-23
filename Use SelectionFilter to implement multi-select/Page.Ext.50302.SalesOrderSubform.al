/// <summary>
/// PageExtension ISA_SalesOrderSubform (ID 50302) extends Record MyTargetPage.
/// </summary>
pageextension 50303 ISA_SalesOrderSubform extends "Sales Order Subform"
{
    layout
    {
        modify("No.")
        {
            AssistEdit = true;
            trigger OnAssistEdit()
            var
                ItemList: Page "Item List";
                Item: Record Item;
                SLines: Record "Sales Line";
                LineNo: Integer;
            begin
                ItemList.LookupMode := true;
                if ItemList.RunModal() = Action::LookupOK then begin
                    SLines.SetRange("Document No.", Rec."Document No.");
                    SLines.SetRange("Document Type", Rec."Document Type");

                    if SLines.FindLast() then
                        LineNo := SLines."Line No.";

                    Item.SetFilter("No.", ItemList.GetSelectionFilter());
                    if Item.FindSet() then
                        repeat
                            LineNo += 10000;
                            SLines.Init();
                            SLines."Document Type" := Rec."Document Type";
                            SLines."Document No." := Rec."Document No.";
                            SLines."Line No." := LineNo;
                            SLines.Insert(true);
                            SLines.Validate(Type, SLines.Type::Item);
                            SLines.Validate("No.", Item."No.");
                            SLines.Validate(Quantity, 1);
                            SLines.Modify(true);
                        until Item.Next() = 0;
                end;
            end;
        }
    }



}