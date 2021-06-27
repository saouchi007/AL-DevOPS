pageextension 80040 "MICA Item Card" extends "Item Card"
{
    layout
    {
        modify("Item Disc. Group")
        {
            Visible = false;
        }

        addafter("No.")
        {
            field("MICA No. 2"; Rec."No. 2")
            {
                ApplicationArea = all;
            }
        }
        addafter("Net Weight")
        {
            field("MICA Net Weight UoM"; Rec."MICA Net Weight UoM")
            {
                ApplicationArea = All;
            }
        }
        addafter("Gross Weight")
        {
            field("MICA Gross Weight UoM"; Rec."MICA Gross Weight UoM")
            {
                ApplicationArea = All;
            }
        }
        addlast(Content)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';
                field("MICA Exclude from Reporting Group"; Rec."MICA Exclude from Report. Grp.")
                {
                    ApplicationArea = All;
                }

                field("MICA Item Location Code"; Rec."MICA Item Location Code")
                {
                    ApplicationArea = All;
                }

                field("MICA Express Order"; Rec."MICA Express Order")
                {
                    ApplicationArea = All;
                }

                field("MICA Market Code"; Rec."MICA Market Code")
                {
                    ApplicationArea = All;
                }

                field("MICA Sensitive Product"; Rec."MICA Sensitive Product")
                {
                    ApplicationArea = All;
                }

                field("MICA Item Status"; Rec."MICA Item Status")
                {
                    ApplicationArea = All;
                }

                field("MICA Accr. Item  Grp."; Rec."MICA Accr. Item Grp.")
                {
                    ApplicationArea = All;
                }
                field("MICA LB-OE"; Rec."MICA LB-OE")
                {
                    ApplicationArea = All;
                }
                field("MICA LB-RT"; Rec."MICA LB-RT")
                {
                    ApplicationArea = All;
                }
                field("MICA EAN Item ID"; Rec."MICA EAN Item ID")
                {
                    ApplicationArea = All;
                }
                field("MICA Auto Off-Invoice Setup"; Rec."MICA Auto Off-Invoice Setup")
                {
                    ApplicationArea = All;
                }
            }
            group("MICA Attributes")
            {
                Caption = 'Attributes';

                field("MICA Item Master Type Code"; Rec."MICA Item Master Type Code")
                {
                    ApplicationArea = All;
                }

                field("MICA Brand"; Rec."MICA Brand")
                {
                    ApplicationArea = All;
                }
                field("MICA Brand Grouping"; Rec."MICA Brand Grouping")
                {
                    ApplicationArea = All;
                }

                field("MICA Product Segment"; Rec."MICA Product Segment")
                {
                    ApplicationArea = All;
                }

                field("MICA Item Class"; Rec."MICA Item Class")
                {
                    ApplicationArea = All;
                }

                field("MICA Long Description"; Rec."MICA Long Description")
                {
                    ApplicationArea = All;
                }

                field("MICA Short Description"; Rec."MICA Short Description")
                {
                    ApplicationArea = All;
                }

                field("MICA Primary Unit Of Measure"; Rec."MICA Primary Unit Of Measure")
                {
                    ApplicationArea = All;
                }

                field("MICA LP Family Code"; Rec."MICA LP Family Code")
                {
                    ApplicationArea = All;
                }

                field("MICA LPR Category"; Rec."MICA LPR Category")
                {
                    ApplicationArea = All;
                }

                field("MICA LPR Sub Family"; Rec."MICA LPR Sub Family")
                {
                    ApplicationArea = All;
                }

                field("MICA Product Nature"; Rec."MICA Product Nature")
                {
                    ApplicationArea = All;
                }

                field("MICA Usage Category"; Rec."MICA Usage Category")
                {
                    ApplicationArea = All;
                }

                field("MICA Prevision Indicator"; Rec."MICA Prevision Indicator")
                {
                    ApplicationArea = All;
                }

                field("MICA Manufacturer Part Number"; Rec."MICA Manufacturer Part Number")
                {
                    ApplicationArea = All;
                }

                field("MICA Commercial Label"; Rec."MICA Commercial Label")
                {
                    ApplicationArea = All;
                }

                field("MICA Product Weight"; Rec."MICA Product Weight")
                {
                    ApplicationArea = All;
                }

                field("MICA Product Weight UOM"; Rec."MICA Product Weight UOM")
                {
                    ApplicationArea = All;
                }

                field("MICA Product Volume"; Rec."MICA Product Volume")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Product Volume';
                }

                field("MICA Product Volume UoM"; Rec."MICA Product Volume UoM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Product Volume UoM';
                }
                field("MICA Section Width"; Rec."MICA Section Width")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Section Width';
                }
                field("MICA Aspect Ratio"; Rec."MICA Aspect Ratio")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Aspect Ratio';
                }

                field("MICA Rim Diameter"; Rec."MICA Rim Diameter")
                {
                    ApplicationArea = All;
                }

                field("MICA Rim Diameter UOM"; Rec."MICA Rim Diameter UOM")
                {
                    ApplicationArea = All;
                }

                field("MICA Load Index 1"; Rec."MICA Load Index 1")
                {
                    ApplicationArea = All;
                }

                field("MICA Speed Index 1"; Rec."MICA Speed Index 1")
                {
                    ApplicationArea = All;
                }

                field("MICA Tire Type"; Rec."MICA Tire Type")
                {
                    ApplicationArea = All;
                }

                field("MICA Star Rating"; Rec."MICA Star Rating")
                {
                    ApplicationArea = All;
                }

                field("MICA Grading Type"; Rec."MICA Grading Type")
                {
                    ApplicationArea = All;
                }

                field("MICA Rolling Resistance2"; Rec."MICA Rolling Resistance2")
                {
                    ApplicationArea = All;
                }

                field("MICA Wet Grip2"; Rec."MICA Wet Grip2")
                {
                    ApplicationArea = All;
                }

                field("MICA Noise Performance"; Rec."MICA Noise Performance2")
                {
                    ApplicationArea = All;
                }

                field("MICA Noise Wave2"; Rec."MICA Noise Wave2")
                {
                    ApplicationArea = All;
                }

                field("MICA Noise Class2"; Rec."MICA Noise Class2")
                {
                    ApplicationArea = All;
                }

                field("MICA Aspect Quality"; Rec."MICA Aspect Quality2")
                {
                    ApplicationArea = All;
                }

                field("MICA Marketing Manager Name"; Rec."MICA Marketing Manager Name2")
                {
                    ApplicationArea = All;
                }

                field("MICA Commercialization Start Date"; Rec."MICA Commercial. Start Date")
                {
                    ApplicationArea = All;
                }

                field("MICA Commercialization End Date"; Rec."MICA Commercial. End Date")
                {
                    ApplicationArea = All;
                }

                field("MICA None Update from PS9"; Rec."MICA None Update from PS9")
                {
                    ApplicationArea = All;
                }
                field("MICA CCID Code"; Rec."MICA CCID Code")
                {
                    ApplicationArea = All;
                }
                field("MICA User Item Type"; Rec."MICA User Item Type")
                {
                    ApplicationArea = All;
                }
                field("MICA Vignette"; Rec."MICA Vignette")
                {
                    ApplicationArea = All;
                }
                field("MICA Business Line"; Rec."MICA Business Line")
                {
                    ApplicationArea = All;
                }
                field("MICA Business Line OE"; Rec."MICA Business Line OE")
                {
                    ApplicationArea = All;
                }
                field("MICA Business Line RT"; Rec."MICA Business Line RT")
                {
                    ApplicationArea = All;
                }
                field("MICA Administrative Status"; Rec."MICA Administrative Status")
                {
                    ApplicationArea = All;
                }
                field("MICA Load Range"; Rec."MICA Load Range")
                {
                    ApplicationArea = All;
                }
                field("MICA Airtightness"; Rec."MICA Airtightness")
                {
                    ApplicationArea = All;
                }
                field("MICA Tire Size"; Rec."MICA Tire Size")
                {
                    ApplicationArea = All;
                }
                field("MICA Pattern Code"; Rec."MICA Pattern Code")
                {
                    ApplicationArea = All;
                }

            }
            group("MICA Homologation")
            {
                Caption = 'Homologation';
                field("MICA Homologator Code"; Rec."MICA Homologator Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Homologator Label"; Rec."MICA Homologator Label")
                {
                    ApplicationArea = All;
                }
                field("MICA Homologation Market Code"; Rec."MICA Homologation Market Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Homologation Vehicle Code"; Rec."MICA Homologation Vehicle Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Homologation Type2"; Rec."MICA Homologation Type2")
                {
                    ApplicationArea = All;
                }
                field("MICA Homologation Start Date"; Rec."MICA Homologation Start Date")
                {
                    ApplicationArea = All;
                }
                field("MICA Homologation End Date"; Rec."MICA Homologation End Date")
                {
                    ApplicationArea = All;
                }
                field("MICA Homologa. Deliver Profil"; Rec."MICA Homologa. Deliver Profil")
                {
                    ApplicationArea = All;
                }
                field("MICA Homologation Country"; Rec."MICA Homologation Country")
                {
                    ApplicationArea = All;
                }
                field("MICA Derogation Number"; Rec."MICA Derogation Number")
                {
                    ApplicationArea = All;
                }
                field("MICA Derogation Quantity"; Rec."MICA Derogation Quantity")
                {
                    ApplicationArea = All;
                }

            }
            group("MICA Certification")
            {
                Caption = 'Certification';
                field("MICA Certificate Country"; Rec."MICA Certificate Country")
                {
                    ApplicationArea = All;
                }
                field("MICA Certif. Effective Date"; Rec."MICA Certif. Effective Date")
                {
                    ApplicationArea = All;
                }
                field("MICA Certif. Expiration Date"; Rec."MICA Certif. Expiration Date")
                {
                    ApplicationArea = All;
                }
                field("MICA Certificate Number"; Rec."MICA Certificate Number")
                {
                    ApplicationArea = All;
                }

            }
            group("MICA Regionalisation Attributes")
            {
                Caption = 'Regionalisation Attributes';
                field("MICA Regional. Active Country"; Rec."MICA Regional. Active Country")
                {
                    ApplicationArea = All;
                }
                field("MICA Regional. Act. Str. Date"; Rec."MICA Regional. Act. Str. Date")
                {
                    ApplicationArea = All;
                }
                field("MICA Regional. Act. End Date"; Rec."MICA Regional. Act. End Date")
                {
                    ApplicationArea = All;
                }

            }
            group("MICA Custom Code")
            {
                Caption = 'Custom Code';
                field("MICA Custom Export Country"; Rec."MICA Custom Export Country")
                {
                    ApplicationArea = All;
                }
                field("MICA Custom Start Date"; Rec."MICA Custom Start Date2")
                {
                    ApplicationArea = All;
                }
                field("MICA Custom End Date"; Rec."MICA Custom End Date2")
                {
                    ApplicationArea = All;
                }

            }
            group("MICA Military Code")
            {
                Caption = 'Military Code';
                field("MICA Military ECCN Code"; Rec."MICA Military ECCN Code2")
                {
                    ApplicationArea = All;
                }
                field("MICA Military ECCN Label"; Rec."MICA Military ECCN Label")
                {
                    ApplicationArea = All;
                }
                field("MICA Military Export Country"; Rec."MICA Military Export Country")
                {
                    ApplicationArea = All;
                }
                field("MICA Military Start Date"; Rec."MICA Military Start Date")
                {
                    ApplicationArea = All;
                }
                field("MICA Military End Date"; Rec."MICA Military End Date")
                {
                    ApplicationArea = All;
                }

            }
            group("MICA Flow Integration")
            {
                Caption = 'Flow Integration';
                field("MICA Send Last Flow Entry No."; Rec."MICA Send Last Flow Entry No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("MICA Send Last Flow Status"; Rec."MICA Send Last Flow Status")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("MICA Record ID"; Rec."MICA Record ID")
                {
                    ApplicationArea = All;

                }
            }
        }
        addfirst(FactBoxes)
        {
            part(FlowResult; "MICA Flow Result")
            {
                ApplicationArea = All;
                SubPageLink = "MICA Send Last Flow Entry No." = FIELD("MICA Send Last Flow Entry No."), "MICA Rcv. Last Flow Entry No." = FIELD("MICA Rcv. Last Flow Entry No.");
            }
        }
    }

    actions
    {
        addlast(PricesandDiscounts)
        {
            action("MICA Add. Item Discount Group")
            {
                Caption = 'Additional Item Discount Group';
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                image = LineDiscount;
                ApplicationArea = All;
                RunObject = page "MICA Add. Item Disc. Groups";
                RunPageView = sorting("Item No.", "Item Discount Group Code");
                RunPageLink = "Item No." = field("No.");
            }
            action("MICA Add. Item Discounts Detail")
            {
                Caption = 'Additional Item Discounts Detail';
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                image = LineDiscount;
                ApplicationArea = All;

                trigger OnAction();
                var
                    AdditionalItemDiscountGroup: Record "MICA Add. Item Discount Group";
                    SalesLineDiscount: Record "Sales Line Discount";
                    AddItemDiscountsDetail: Page "MICA Add. Item Disc. Details";
                    ItemDiscGrpFilter: Text;
                    ItemDiscGrpFilterLbl: Label '%1|%2', Comment = '%1%2', Locked = true;
                begin
                    IF Rec."Item Disc. Group" <> '' THEN
                        ItemDiscGrpFilter := Rec."Item Disc. Group";
                    AdditionalItemDiscountGroup.SETRANGE("Item No.", Rec."No.");
                    IF AdditionalItemDiscountGroup.FINDSET() THEN
                        REPEAT
                            IF ItemDiscGrpFilter = '' THEN
                                ItemDiscGrpFilter := AdditionalItemDiscountGroup."Item Discount Group Code"
                            ELSE
                                ItemDiscGrpFilter := STRSUBSTNO(ItemDiscGrpFilterLbl, ItemDiscGrpFilter, AdditionalItemDiscountGroup."Item Discount Group Code");
                        UNTIL AdditionalItemDiscountGroup.NEXT() = 0;

                    SalesLineDiscount.SETRANGE(Type, SalesLineDiscount.Type::"Item Disc. Group");
                    IF ItemDiscGrpFilter = '' THEN
                        SalesLineDiscount.SETRANGE(Code, '')
                    ELSE
                        SalesLineDiscount.SETFILTER(Code, ItemDiscGrpFilter);

                    IF SalesLineDiscount.FINDSET() THEN;
                    AddItemDiscountsDetail.SETRECORD(SalesLineDiscount);
                    AddItemDiscountsDetail.SETTABLEVIEW(SalesLineDiscount);
                    AddItemDiscountsDetail.RUNMODAL();
                end;

            }
            action("MICA Apply Off-Invoice to New Item")
            {
                Caption = 'Apply Off-Invoice New Item';
                Promoted = true;
                PromotedCategory = Category6;
                Image = Apply;
                ApplicationArea = All;

                trigger OnAction()
                var
                    MICAApplyOffInvoice: Report "MICA Apply Off-Invoice";
                begin
                    MICAApplyOffInvoice.SetFilterItemNo((Format(Rec."No.")));
                    MICAApplyOffInvoice.Run();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;

}