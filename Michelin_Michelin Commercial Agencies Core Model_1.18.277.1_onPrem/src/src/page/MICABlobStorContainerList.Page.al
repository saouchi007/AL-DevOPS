page 80871 "MICA BlobStor. Container List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MICA MME BlobStorage Container";
    SourceTableTemporary = true;
    Caption = 'Blob Storage Container List';
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Containers)
            {
                field(Name; Rec."Name")
                {
                    ApplicationArea = All;
                }
                field("Last Modified"; Rec."Last Modified")
                {
                    ApplicationArea = All;
                }
                field("Lease State"; Rec."Lease State")
                {
                    ApplicationArea = All;
                }
                field("Lease Status"; Rec."Lease Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure InsertTemp(var TmpMICAMMEBlobStorageContainer: Record "MICA MME BlobStorage Container" temporary)
    begin
        if TmpMICAMMEBlobStorageContainer.FindSet() then
            repeat
                Rec.TransferFields(TmpMICAMMEBlobStorageContainer);
                Rec.Insert(true);
            until TmpMICAMMEBlobStorageContainer.Next() = 0;
    end;
}