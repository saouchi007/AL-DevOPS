/// <summary>
/// Table ISA_Customer (ID 50323).
/// </summary>
table 50323 ISA_Customer
{
    DataClassification = CustomerContent;
    Caption = 'ISA Flowfields';

    fields
    {
        field(1; CustomerNo; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
            Caption = 'Customer No.';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field(CustomerNo)));
        }
        field(3; HasInvoices; Boolean)
        {
            FieldClass = FlowField;
            Caption = 'Has Invoice';
            CalcFormula = exist("Sales Invoice Header" where("Sell-to Customer No." = field(CustomerNo)));
        }
        field(4; InvoicesTotal; Decimal)
        {
            Caption = 'Invoices Total';
            FieldClass = FlowField;
            CalcFormula = sum("Cust. Ledger Entry"."Sales (LCY)" where("Document Type" = const(Invoice), "Customer No." = field(CustomerNo)));
        }
        field(5; InvoiceCount; Integer)
        {
            Caption = 'Invoice Count';
            FieldClass = FlowField;
            CalcFormula = count("Cust. Ledger Entry" where("Document Type" = const(Invoice), "Customer No." = field(CustomerNo)));
        }
        field(6; AverageInvoice; Decimal)
        {
            Caption = 'Average Invoice';
            FieldClass = FlowField;
            CalcFormula = average("Cust. Ledger Entry"."Sales (LCY)" where("Document Type" = const(Invoice), "Customer No." = field(CustomerNo)));
        }
        field(7; MaxInvoiceAmount; Decimal)
        {
            Caption = 'Max Invoice Amount';
            FieldClass = FlowField;
            CalcFormula = max("Cust. Ledger Entry"."Sales (LCY)" where("Document Type" = const(Invoice), "Customer No." = field(CustomerNo)));
        }
        field(8; MinInvoiceAmount; Decimal)
        {
            Caption = 'Min Invoice Amount';
            FieldClass = FlowField;
            CalcFormula = min("Cust. Ledger Entry"."Sales (LCY)" where("Document Type" = const(Invoice), "Sell-to Customer No." = field(CustomerNo)));
        }



    }

    keys
    {
        key(PK; CustomerNo)
        {
            Clustered = true;
        }
    }


}