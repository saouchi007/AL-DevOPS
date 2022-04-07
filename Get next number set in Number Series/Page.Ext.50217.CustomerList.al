/// <summary>
/// PageExtension ISA_CustomerList (ID 50217) extends Record Customer List.
/// </summary>
pageextension 50217 ISA_CustomerList extends "Customer List"
{
    trigger OnOpenPage()
    var
        SalesReceiv: Record "Sales & Receivables Setup";
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        NextNumber: Text[50];
        NextNumberMsg: Label 'The next number is ''%1''';
    begin
        SalesReceiv.Get();
        SalesReceiv.TestField("Customer Nos."); // to check wwhehther hte field containes 0 or is empty
        NextNumber := NoSeriesMgmt.GetNextNo(SalesReceiv."Customer Nos.", WorkDate(), true);
        Message(NextNumberMsg, NextNumber);
    end;
}