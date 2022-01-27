/// <summary>
/// Table TIT Grid (ID 52182466).
/// </summary>
table 52182466 "TIT Grid"
//table 391084437 "TIT Grid"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Basis"; Decimal)
        {
            CaptionML = FRA = 'Base', ENU = 'Basis';

        }
        field(2; "TIT"; Decimal)
        {
            CaptionML = FRA = 'IRG', ENU = 'TIT';

        }
        field(3; "TITR"; Decimal)
        {
            CaptionML = FRA = 'IRGR', ENU = 'TITR';

        }
        field(4; "TIT20"; Decimal)
        {
            CaptionML = FRA = 'IRG20', ENU = 'TIT20';

        }
        field(5; "TITGS"; Decimal)
        {
            CaptionML = FRA = 'IRGGS', ENU = 'TITGS';

        }

    }

    keys
    {

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