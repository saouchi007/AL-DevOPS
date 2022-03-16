/// <summary>
/// PageExtension ISA_CustomerCard (ID 50169) extends Record Customer Card.
/// </summary>
pageextension 50169 ISA_CustomerCard extends "Customer Card"
{
    actions
    {
        addbefore("&Customer")
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