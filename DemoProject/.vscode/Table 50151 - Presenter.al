table 50151 PresenterShow
{
    DataClassification = ToBeClassified;
    Caption = 'Presenter Identification';


    fields
    {
        field(1; "P_Code"; Code[10])
        {
            CaptionML = ENU = 'Presenter code';

        }
        field(2; "P_Name"; Text[50])
        {
            CaptionML = ENU = 'Presenter Name';
        }
    }

    keys
    {
        key(PK; P_Code)
        {
            Clustered = true;
        }
        key(SK; P_Name)
        {

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