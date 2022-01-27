/// <summary>
/// Codeunit Payroll Reg.-Show Entries (ID 52182429).
/// </summary>
codeunit 52182429 "Payroll Reg.-Show Entries"
//codeunit 39108401 "Payroll Reg.-Show Entries"
{
    // version HALRHPAIE.6.1.01

    TableNo = "Payroll Register";

    trigger OnRun();
    begin
        PayrollLedgEntry.SETRANGE("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        IF PayrollLedgEntry.FINDFIRST THEN
            PAGE.RUN(PAGE::"Payroll Entries", PayrollLedgEntry);
    end;

    var
        PayrollLedgEntry: Record "Payroll Entry";
}

