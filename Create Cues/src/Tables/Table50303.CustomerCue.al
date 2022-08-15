/// <summary>
/// Table ISA_CustomerCue (ID 50303).
/// </summary>
table 50303 ISA_CustomerCue
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; PrimaryKey; Code[20])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; BlockedCustomers; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count(Customer where(Blocked = filter(All)));
        }

    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// InsertIfNotExists.
    /// </summary>
    procedure InsertIfNotExists()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

}