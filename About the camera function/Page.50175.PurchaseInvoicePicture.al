/// <summary>
/// Page PurchaseInvoicePicture (ID 50175).
/// </summary>
page 50175 PurchaseInvoicePicture
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Purchase Header";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    Caption = 'Purchase Invoice Picture';

    layout
    {
        area(Content)
        {
            field(PurchaseInvoiceImage; Rec.PurchaseInvoiceImage)
            {
                ApplicationArea = All;
                ShowCaption = false;
                ToolTip = 'Specifies the picture for the PI';

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TakePicture)
            {
                ApplicationArea = All;
                Caption = 'Take';
                Image = Camera;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Activate the camera on the device';

                trigger OnAction()
                var
                CameraInteraction: Page "Camera Interaction";
                Picstraeam: InStream;
                begin

                    CameraInteraction.AllowEdit(true);
                    CameraInteraction.Quality(100);
                    CameraInteraction.EncodingType('PNG');
                    CameraInteraction.RunModal();
                    CameraInteraction.GetPicture(Picstraeam);
                    PurchInvoiceImage.ImportStream(Picstraeam, CameraInteraction.GetPictureName());
                    if not Insert(true) then
                        Modify(true);
                    Rec.TestField("No.");
                    Camera.AddPicture(Rec, Rec.FieldNo(PurchaseInvoiceImage));
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    Rec.TestField("No.");

                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(PurchaseInvoiceImage);
                    Rec.Modify(true);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := PurchaseInvoiceImage.HasValue;
    end;

    var
        Camera: Codeunit Camera;
        [InDataSet]
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DeleteExportEnabled: Boolean;
}