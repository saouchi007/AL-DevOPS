table 50300 CustomerTable
{

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(2; "Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup (Customer.Name where("No." = field("Customer No.")));
        }
        field(3; "Has Invoice"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist ("Sales Invoice Header" where("Sell-to Customer No." = field("Customer No.")));
        }

        field(4; "Invoices Total"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum ("Cust. Ledger Entry"."Sales (LCY)" where("Document Type" = const(Invoice), "Customer No." = field("Customer No.")));
        }
        field(5; "Invoices Average"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = average ("Cust. Ledger Entry"."Sales (LCY)" where("Document Type" = const(Invoice), "Customer No." = field("Customer No.")));
        }
        field(6; "Invoice Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Cust. Ledger Entry" where("Document Type" = const(Invoice), "Customer No." = field("Customer No.")));
        }

    }

    keys
    {
        key(PK; "Customer No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}