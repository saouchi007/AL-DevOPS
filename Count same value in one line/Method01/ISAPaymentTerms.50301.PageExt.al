/// <summary>
/// PageExtension ISA_PaymentTerms (ID 50301) extends Record Payment Terms.
/// </summary>
pageextension 50301 ISA_PaymentTerms extends "Payment Terms"
{
    layout
    {
        addafter("Due Date Calculation")
        {

            field("Process Check 01"; Rec."Process Check 01")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Process Check 01 field.';
            }
            field("Process Check 02"; Rec."Process Check 02")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Process Check 02 field.';
            }
            field("Process Check 03"; Rec."Process Check 03")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Process Check 03 field.';
            }
            field("Process Check 04"; Rec."Process Check 04")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Process Check 04 field.';
            }
            field("Process Check 05"; Rec."Process Check 05")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Process Check 05 field.';
            }
            field("Process Check 06"; Rec."Process Check 06")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Process Check 06 field.';
            }
            field("Total No. of Processed"; Rec."Total No. of Processed")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total No. of Processed field.';
            }
            field("Total No. of Pending"; Rec."Total No. of Pending")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total No. of Pending field.';
            }
            field("Total No. of Unprocessed"; Rec."Total No. of Unprocessed")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total No. of Unprocessed field.';
            }
        }
    }


}