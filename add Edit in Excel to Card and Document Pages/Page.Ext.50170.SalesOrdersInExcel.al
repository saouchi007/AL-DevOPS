/// <summary>
/// PageExtension ISA_SalesOrdersInExcel (ID 50170) extends Record MyTargetPage.
/// </summary>
pageextension 50170 ISA_SalesOrdersInExcel extends "Sales Order"
{

    actions
    {
        addbefore(AttachAsPDF)
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

    var
        myInt: Integer;
}