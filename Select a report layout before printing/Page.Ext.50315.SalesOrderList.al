/// <summary>
/// PageExtension ISA_SalesOrderList (ID 50315) extends Record MyTargetPage.
/// </summary>
pageextension 50315 ISA_SalesOrderList extends "Sales Order List"
{

    actions
    {
        addafter("Print Confirmation")
        {
            action(PrintSelectedLayout)
            {
                ApplicationArea = All;
                Caption = 'Print Selected Layout';
                Ellipsis = true;
                Image = PrintInstallment;
                Promoted = true;
                PromotedCategory = Category8;

                trigger OnAction()
                var
                    RepLaySelection: Record "Report Layout Selection";
                    SalesHeader: Record "Sales Header";
                    Selection: Integer;
                    ISA_Layouts: Label '01.Alpha, 02.Beta, 03.Charlie';
                begin
                    SalesHeader.Reset();
                    CurrPage.SetSelectionFilter(SalesHeader);
                    Selection := StrMenu(ISA_Layouts);

                    case Selection of
                        1:
                            RepLaySelection.SetTempLayoutSelected('1305-000004');
                        2:
                            RepLaySelection.SetTempLayoutSelected('1305-000005');
                        3:
                            RepLaySelection.SetTempLayoutSelected('1305-000006');
                        else
                            exit;
                    end;
                    Report.Run(Report::"Standard Sales - Order Conf.", true, true, SalesHeader);
                end;
            }
        }
    }

}