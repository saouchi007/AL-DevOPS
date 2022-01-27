/// <summary>
/// Codeunit Reminder Reg.-Show Entries (ID 52182432).
/// </summary>
codeunit 52182432 "Reminder Reg.-Show Entries"
{
    // version HALRHPAIE.6.2.00

    TableNo = "Reminder Register";

    trigger OnRun();
    begin
        PayrollLedgEntry.SETRANGE("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        //PAGE.RUN(PAGE::"Reminder Entries",PayrollLedgEntry);
    end;

    var
        PayrollLedgEntry: Record "Payroll Entry";
}

