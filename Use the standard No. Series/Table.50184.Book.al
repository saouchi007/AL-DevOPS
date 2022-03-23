table 50184 ISA_Book
{
    DataClassification = CustomerContent;
    Caption = 'Book';

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesSetup.Get();
                    NoSeriesMgmt.TestManual(SalesSetup."Book Nos.");
                    "No.Series" := '';
                end;
            end;
        }
        field(2; Title; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Title';
        }
        field(3; Author; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Author';
        }
        field(4; PageCount; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Page Count';
        }
        field(5; "No.Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "No." = '' then begin
            SalesSetup.Get();
            SalesSetup.TestField("Book Nos.");
            NoSeriesMgmt.InitSeries(SalesSetup."Book Nos.", xRec."No.Series", 0D, "No.", "No.Series");
        end;
    end;

    var

        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgmt: Codeunit NoSeriesManagement;



}