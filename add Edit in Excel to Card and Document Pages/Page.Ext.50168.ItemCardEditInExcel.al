/// <summary>
/// PageExtension ISA_ItemCardEditInExcel (ID 50168) extends Record Item Card.
/// </summary>
pageextension 50168 ISA_ItemCardEditInExcel extends "Item Card"
{
    actions
    {
        addbefore(Attributes)
        {
            action(EditInExcel)
            {
                Caption = 'Edit In Excel';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Image = Excel;
                ToolTip = 'Send the data to Excel for analysis or editing';

                trigger OnAction()
                var
                    EditInExcel: Codeunit "Edit in Excel";
                    ODataFilter: Text;
                    Filters: Label 'No eq ''%1''';
                begin
                    ODataFilter := StrSubstNo(Filters, Rec."No.");
                    EditInExcel.EditPageInExcel(CurrPage.ObjectId(false), CurrPage.ObjectId(false), ODataFilter);
                end;
            }
        }
    }

}