pageextension 80340 "MICA Transfer Order" extends "Transfer Order"
{
    layout
    {
        modify("Receipt Date")
        {
            Caption = 'Availability date';
        }

        addlast(General)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';
                field("MICA ASN No."; Rec."MICA ASN No.")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Open);
                }
                field("MICA Container ID"; Rec."MICA Container ID")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Open);
                }
                field("MICA Maritime Air Company Name"; Rec."MICA Maritime Air Company Name")
                {
                    ApplicationArea = all;
                    Editable = (Rec.Status = Rec.Status::Open);
                }
                field("MICA Maritime Air Number"; Rec."MICA Maritime Air Number")
                {
                    ApplicationArea = all;
                    Editable = (Rec.Status = Rec.Status::Open);
                }
                field("MICA ASN Date"; Rec."MICA ASN Date")
                {
                    ApplicationArea = All;
                }
                field("MICA ETA"; Rec."MICA ETA")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Open);
                }
                field("MICA SRD"; Rec."MICA SRD")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Open);
                }
                field("MICA Initial ETA"; Rec."MICA Initial ETA")
                {
                    ApplicationArea = All;
                }
                field("MICA Initial SRD"; Rec."MICA Initial SRD")
                {
                    ApplicationArea = All;
                }
                field("MICA Seal No."; Rec."MICA Seal No.")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Open);
                }
                field("MICA Port of Arrival"; Rec."MICA Port of Arrival")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Open);
                }
                field("MICA Carrier Doc. No."; Rec."MICA Carrier Doc. No.")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Open);
                }
            }

            field("MICA Vendor Order No."; Rec."MICA Vendor Order No.")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
        }

    }

    actions
    {
        addlast("F&unctions")
        {
            action("MICA Auto Reserve")
            {
                Caption = 'Allocate Sales Orders';
                Promoted = true;
                PromotedCategory = Category6;
                ApplicationArea = All;
                Image = AutoReserve;
                trigger OnAction()
                var
                    MICAReallocBackOrdMgt: Codeunit "MICA Realloc. BackOrder Mgt";
                begin
                    MICAReallocBackOrdMgt.CommitmentOnTransferOrderHeader(Rec);
                end;
            }
        }

        modify("Create Whse. S&hipment")
        {
            Visible = false;
        }
        addbefore("Create &Whse. Receipt")
        {
            action("MICA Create Whse. Shipment")
            {
                Caption = 'Create Whse. S&hipment';
                ToolTip = 'Create a warehouse shipment to start a pick a ship process according to an advanced warehouse configuration.';
                AccessByPermission = TableData "Warehouse Shipment Header" = R;
                ApplicationArea = All;
                Image = NewShipment;
                trigger OnAction()
                var
                    GetSourceDocOutbound: Codeunit "MICA Get Source Doc. Outbound";
                begin
                    GetSourceDocOutbound.CreateFromOutbndTransferOrder(Rec);
                end;
            }
        }


    }
}