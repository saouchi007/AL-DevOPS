page 82082 "MICA Flow Buffer PS9 List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Flow Buffer PS9 List';
    SourceTable = "MICA Flow Buffer PS9";
    DeleteAllowed = false;
    CardPageId = 82081;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Flow Code"; Rec."Flow Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Flow Entry No."; Rec."Flow Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Date Time Creation"; Rec."Date Time Creation")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Date Time Last Modified"; Rec."Date Time Last Modified")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Info Count"; Rec."Info Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Warning Count"; Rec."Warning Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Error Count"; Rec."Error Count")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Skip Line"; Rec."Skip Line")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Linked Record ID"; Rec."Linked Record ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Linked Record"; Rec."Linked Record")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("PS9 Execution DateTime"; Rec."PS9 Execution DateTime")
                {
                    ApplicationArea = All;
                }

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("No. 2"; Rec."No. 2")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Item Category Code"; Rec."Item Category Code")
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
                    ;
                }

                field("MICA Commercial Label"; Rec."MICA Commercial Label")
                {
                    ApplicationArea = All;
                }

                field("MICA Product Weight"; Rec."MICA Product Weight Raw")
                {
                    ApplicationArea = All;
                }

                field("MICA Product Weight UOM"; Rec."MICA Product Weight UOM")
                {
                    ApplicationArea = All;
                }
                field("MICA Product Volume"; Rec."MICA Product Volume Raw")
                {
                    ApplicationArea = All;
                }

                field("MICA Product Volume UoM"; Rec."MICA Product Volume UoM")
                {
                    ApplicationArea = All;
                }

                field("MICA Section Width"; Rec."MICA Section Width Raw")
                {
                    ApplicationArea = All;
                }
                field("MICA Aspect Ratio"; Rec."MICA Aspect Ratio")
                {
                    ApplicationArea = All;
                }
                field("MICA Load Index 1"; Rec."MICA Load Index 1 Raw")
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

                field("MICA Noise Performance2"; Rec."MICA Noise Performance2")
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

                field("MICA Aspect Quality2"; Rec."MICA Aspect Quality2")
                {
                    ApplicationArea = All;
                }
                field("MICA Marketing Manager Name2"; Rec."MICA Marketing Manager Name2")
                {
                    ApplicationArea = All;
                }

                // missing field Homologation Class (Code)

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
                field("MICA LB-OE"; Rec."MICA LB-OE")
                {
                    ApplicationArea = All;
                }

                field("MICA LB-RT"; Rec."MICA LB-RT")
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
                field("MICA Homologator Code"; Rec."MICA Homologator Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Homologator Label"; Rec."MICA Homologator Label")
                {
                    ApplicationArea = All;
                }
                field("MICA Homologation Market Code"; Rec."MICA Homologation Market Code"
                    )
                {
                    ApplicationArea = All;
                }
                field("MICA Homologation Vehicle Code"; Rec."MICA Homologation Vehicle Code"
                    )
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
                field("MICA Homologa. Deliver Profil"; Rec."MICA Homologa. Deliver Profil"[1])
                {
                    ApplicationArea = All;
                    Caption = 'Homologa. Deliver Profil';
                }
                field("MICA Homologation Country"; Rec."MICA Homologation Country")
                {
                    ApplicationArea = All;
                }
                field("MICA Derogation Number"; Rec."MICA Derogation Number")
                {
                    ApplicationArea = All;
                }

                field("MICA Derogation Quantity"; Rec."MICA Derogation Quantity Raw")
                {
                    ApplicationArea = All;
                }
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
                field("MICA EAN Item ID"; Rec."MICA EAN Item ID")
                {
                    ApplicationArea = All;
                }
                field("MICA Last DateTime Modified"; Rec."MICA Last DateTime Modified")
                {
                    ApplicationArea = All;
                }
                field("MICA Blocked"; Rec."MICA Blocked")
                {
                    ApplicationArea = All;
                }
                field("MICA Rim Diameter"; Rec."MICA Rim Diameter")
                {
                    ApplicationArea = All;
                }

                field("MICA Rim Diameter UOM"; Rec."MICA Rim Diameter UOM")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}