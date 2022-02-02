/// <summary>
/// Table NewVideoProdLink (ID 50136).
/// </summary>
table 50137 NewVideoProdLink
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; EntriesNo; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entries No.';

        }
        field(2; Title; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Title';
        }
        field(3; VideoURL; Text[2048])
        {
            DataClassification = ToBeClassified;
            Caption = 'Video URL';
        }
        field(4; Category; Enum "Video Category")
        {
            DataClassification = ToBeClassified;
            Caption = 'Category';
        }
        field(5; AppID; Guid)
        {
            DataClassification = ToBeClassified;
            Caption = 'App ID';
            Editable = false;
        }
        field(6; ExtensionName; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Extension Name';
            Editable = false;
        }
    }

    keys
    {
        key(PK; EntriesNo)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    var

        NewProdVideoLink: Record NewVideoProdLink;
        LastEntriesNo: Integer;
        Info: ModuleInfo;

    begin
        LastEntriesNo := 0;
        NewProdVideoLink.Reset();
        if NewProdVideoLink.FindLast() then
            LastEntriesNo := NewProdVideoLink.EntriesNo + 1
        else
            LastEntriesNo := 1;
        NavApp.GetCurrentModuleInfo(Info);
        EntriesNo := LastEntriesNo;
        AppID := Info.Id;
        ExtensionName := Info.Name;
    end;
}