table 50100 "Airplane Type"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ICAO; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'ICAO Code';
            AccessByPermission = tabledata "Item" = R;

        }
        field(2; Description; Text[200])
        {

        }
        field(3; Popularity; Decimal)
        {
            CaptionML = ENU = 'Popularity %';
        }
    }

    keys
    {
        key(PK; ICAO)
        {
            Clustered = true;
        }
        key(SK; Popularity) { }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        Message('Item %1 inserted !!', ICAO);
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