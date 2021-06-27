page 82460 "MICA Warehouse Shipment Lines"
{
    Caption = 'Warehouse Shipment Lines';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Warehouse Shipment Line";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the No. of Warehouse document';
                }
                field("MICA Truck Driver Info"; Rec."MICA Truck Driver Info")
                {
                    ApplicationArea = All;
                }
                field("MICA Truck License Plate"; Rec."MICA Truck License Plate")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Line No.';
                }
                field("Source Document"; Rec."Source Document")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Source Document';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Source No.';
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Source Line No.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Item No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Description';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Location Code';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Quantity';
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Qty. to Ship';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Unit of Measure Code';
                }
                field("MICA Shipping Agent Code"; Rec."MICA Shipping Agent Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shipping Agent Code';
                }
                field("MICA Shipp. Agent Service Code"; Rec."MICA Shipp. Agent Service Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shipping Agent Service Code';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Due Date';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shipment Date';
                }
                field("MICA Ship-to Code"; Rec."MICA Ship-to Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Ship-to Code';
                }
                field("MICA Ship-to Name"; Rec."MICA Ship-to Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Ship-to Name';
                }
                field("MICA Ship-to Address"; Rec."MICA Ship-to Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Ship-to Address';
                }
                field("MICA Ship-to City"; Rec."MICA Ship-to City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Ship-to City';
                }
                field("MICA 3PL Product Weight"; Rec."MICA 3PL Product Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the 3PL Product Weight';
                }
                field("MICA 3PL Line Weight"; Rec."MICA 3PL Line Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the 3PL Line Weight';
                }
                field("MICA 3PL Weight UoM"; Rec."MICA 3PL Weight UoM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the 3PL Weight UoM';
                }
                field("MICA 3PL Product Volume"; Rec."MICA 3PL Product Volume")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the 3PL Product Volume';
                }
                field("MICA 3PL Line Volume"; Rec."MICA 3PL Line Volume")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the 3PL Line Volume';
                }
                field("MICA 3PL Volume UoM"; Rec."MICA 3PL Volume UoM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the 3PL Volume UoM';
                }
                field("MICA 3PL Whse Shpt. Comment"; Rec."MICA 3PL Whse Shpt. Comment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the 3PL Whse Shpt. Comment';
                }
                field("MICA Customer Transport"; Rec."MICA Customer Transport")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Customer Transport';
                }
                field("Shipping Advice"; Rec."Shipping Advice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Shipping Advice';
                }

                field("MICA 3PL Country Of Origin"; Rec."MICA 3PL Country Of Origin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Country Of Origin';
                }
                field("MICA 3PL DOT Value"; Rec."MICA 3PL DOT Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the DOT Value';
                }
                field("Qty. Picked"; Rec."Qty. Picked")
                {
                    ApplicationArea = All;
                }

                field("Completely Picked"; Rec."Completely Picked")
                {
                    ApplicationArea = All;
                }

                field("Pick Qty."; Rec."Pick Qty.")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Autofill Qty. to Ship")
            {
                Caption = 'Autofill Qty. to Ship';
                ToolTip = 'Have the system enter the outstanding quantity in the Qty. to Ship field.';
                Image = AutofillQtyToHandle;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    WhseShptLn: Record "Warehouse Shipment Line";
                begin
                    WhseShptLn.SetRange("No.", Rec."No.");
                    Rec.AutofillQtyToHandle(WhseShptLn);
                end;
            }
            action(Post)
            {
                Caption = 'Post Shipment';
                ToolTip = 'Post the items as shipped. Related pick documents are registered automatically.';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = PostOrder;

                trigger OnAction()
                var
                    WhseShptLn: Record "Warehouse Shipment Line";
                begin
                    WhseShptLn.Copy(Rec);
                    Codeunit.Run(Codeunit::"Whse.-Post Shipment (Yes/No)", WhseShptLn);
                    CurrPage.Update(false);
                end;
            }
            action(Release)
            {
                Caption = 'Release';
                ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
                ApplicationArea = All;
                Image = ReleaseDoc;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    WhseShptHdr: Record "Warehouse Shipment Header";
                    WhseShptRlse: Codeunit "Whse.-Shipment Release";
                begin
                    WhseShptHdr.Get(Rec."No.");
                    if WhseShptHdr.Status = WhseShptHdr.Status::Open then
                        WhseShptRlse.Release(WhseShptHdr);
                end;
            }
            action(Reopen)
            {
                Caption = 'Reopen';
                ToolTip = 'Reopen the document for additional warehouse activity.';
                ApplicationArea = All;
                image = ReOpen;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    WhseShptHdr: Record "Warehouse Shipment Header";
                    WhseShptRlse: Codeunit "Whse.-Shipment Release";
                begin
                    WhseShptHdr.Get(Rec."No.");
                    WhseShptRlse.Reopen(WhseShptHdr);
                end;
            }
            action("Create Pick")
            {
                ApplicationArea = Warehouse;
                Caption = 'Create Pick';
                Ellipsis = true;
                Image = CreateInventoryPickup;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Create a warehouse pick for the items to be shipped.';

                trigger OnAction()
                var
                    WhseShipLines: Record "Warehouse Shipment Line";
                    PLPickRequestout: Codeunit "MICA Pick Worskheet Mgt";
                begin
                    CurrPage.SetSelectionFilter(WhseShipLines);
                    PLPickRequestout.PickCreate(WhseShipLines);
                end;
            }

        }
        area(Navigation)
        {
            action(ShowWhseDoc)
            {
                Caption = 'Show Whse. Document';
                ToolTip = 'Show Warehouse document card';
                ApplicationArea = All;
                image = Document;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                RunObject = page "Warehouse Shipment";
                RunPageLink = "No." = field("No.");

                trigger OnAction()
                begin
                end;
            }
            action(ShowSourceDoc)
            {
                Caption = 'Show Source Document';
                ToolTip = 'Show source document card';
                ApplicationArea = All;
                Image = Document;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    WMSMgt: Codeunit "WMS Management";
                begin
                    WMSMgt.ShowSourceDocCard(Rec."Source Type", Rec."Source Subtype", Rec."Source No.");
                end;
            }
            action(ReservationEntries)
            {
                Caption = 'Reservation Entries';
                ToolTip = 'Show reservation entries for the selected source line';
                ApplicationArea = All;
                Image = ItemReservation;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ShowSourceReservationEntries();
                end;
            }

        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("Location Code", GetLocationFilter());
        Rec.FilterGroup(0);
    end;

    var
        UserIsNotWarehouseEmpErr: Label 'You must first set up user %1 as a warehouse employee.';

    local procedure ShowSourceReservationEntries()
    var
        ReservationEntry: Record "Reservation Entry";
        SetReservationEntries: Page "Reservation Entries";
    begin
        Clear(ReservationEntry);
        Clear(SetReservationEntries);
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        ReservationEntry.SetRange("Source ID", Rec."Source No.");
        ReservationEntry.SetRange("Source Ref. No.", Rec."Source Line No.");
        ReservationEntry.SetRange("Source Subtype", Rec."Source Subtype");
        ReservationEntry.SetRange("Source Type", Rec."Source Type");
        SetReservationEntries.SetTableView(ReservationEntry);
        SetReservationEntries.Editable(false);
        SetReservationEntries.RunModal();
    end;

    local procedure GetLocationFilter(): Text
    var
        WarehouseEmployee: Record "Warehouse Employee";
        LocationFilter: Text;
        ErrorText: Text;
    begin
        if UserId() = '' then
            exit;
        WarehouseEmployee.SetRange("User ID", UserId());
        if WarehouseEmployee.IsEmpty() then begin
            ErrorText := StrSubstNo(UserIsNotWarehouseEmpErr, UserId());
            Error(ErrorText);
        end;
        if WarehouseEmployee.FindSet() then
            repeat
                if LocationFilter = '' then
                    LocationFilter := WarehouseEmployee."Location Code"
                else
                    LocationFilter += '|' + WarehouseEmployee."Location Code";
            until WarehouseEmployee.Next() = 0;
        exit(LocationFilter);
    end;



}