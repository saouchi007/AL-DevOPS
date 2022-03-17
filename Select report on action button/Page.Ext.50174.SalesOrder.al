/// <summary>
/// PageExtension ISA_SalesOrderSelectReport (ID 50174) extends Record Sales Order.
/// </summary>
pageextension 50174 ISA_SalesOrderSelectReport extends "Sales Order"
{
    actions
    {
        modify("Print Confirmation")
        {
            Visible = false;
        }
        addafter("Work Order")
        {
            action(SelectPrint)
            {
                Caption = 'Select Print';
                ApplicationArea = All;
                Image = PrintInstallment;
                ToolTip = 'Please select the report to be printed';

                trigger OnAction()
                var
                    StrMenuMembers: Label 'Sales - Quote,Order - Confirmation, Sales - Invoice';
                    StrMenuDescription: Label 'Please select the report to be printed :';
                    ReportID: Integer;

                begin
                    Clear(ReportID);
                    ReportID := Dialog.StrMenu(StrMenuMembers, 1, StrMenuDescription);
                    case ReportID of
                        0:
                            exit;
                        1:
                            Report.Run(1304, true);
                        2:
                            Report.Run(10571, true);
                        3:
                            Report.Run(10572, true);
                    end;
                end;
            }
        }
    }

}