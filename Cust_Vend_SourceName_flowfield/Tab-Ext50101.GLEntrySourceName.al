tableextension 50101 GL_Entry_SourceName extends "G/L Entry"
{
    fields
    {
        field(50100; CustomerName; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(GLSourceName.SourceName
            where(SourceType = field("Source Type"),
            "SourceNo." = field("Source No.")));
            //CalcFormula = lookup(Customer.Name where("No." = field("Source No.")));
        }
        field(50101; VendorName; Text[100])
        {
            Caption = 'Vendor''s Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Source No.")));
        }
        field(50102; FixedAssetDescription; Text[100])
        {
            Caption = 'Fixed Asset Description';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Fixed Asset".Description where("No." = field("Source No.")));
        }
    }
}
