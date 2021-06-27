page 81720 "MICA Flow Buffer ASN List"
{
    PageType = List;
    SourceTable = "MICA Flow Buffer ASN";
    Caption = 'Flow Buffer ASN';
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

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
                    Visible = false;
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
                    Editable = True;
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
                field("Tech. Logical ID"; Rec."Tech. Logical ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tech. Component ID"; Rec."Tech. Component ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Tech. Task ID"; Rec."Tech. Task ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tech.Reference ID"; Rec."Tech. Reference ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tech. Creation DateTime Raw"; Rec."Tech. Creation DateTime Raw")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tech. Creation DateTime"; Rec."Tech. Creation DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tech. Native ID"; Rec."Tech. Native ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Doc. Type"; Rec."Doc. Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Doc. ID"; Rec."Doc. ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Alt. Doc. ID"; Rec."Alt. Doc. ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("ETA Raw"; Rec."ETA Raw")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ETA; Rec.ETA)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("SRD Raw"; Rec."SRD Raw")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(SRD; Rec.SRD)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Ship. From"; Rec."Ship. From")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Arrival Port"; Rec."Arrival Port")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Container ID Raw"; Rec."Container ID Raw")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Container ID"; Rec."Container ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("AL No. Raw"; Rec."AL No. Raw")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Purch. Order. No."; Rec."AL No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Purch. Order. Line No."; Rec."AL Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CAI; Rec.CAI)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CCI; Rec.CCI)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CST; Rec.CST)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CCID; Rec.CCID)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Market Code"; Rec."Market Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Serial Number"; Rec."Seal Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Quantity Raw"; Rec."Quantity Raw")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Actual Ship DateTime Raw"; Rec."Actual Ship DateTime Raw")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Actual Ship DateTime"; Rec."Actual Ship DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Carrier Doc. No."; Rec."Carrier Doc. No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("ASN Line Number Raw"; Rec."ASN Line Number Raw")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("ASN Line Number"; Rec."ASN Line Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Maritime Air Company Name"; Rec."Maritime Air Company Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Maritime Air Number"; Rec."Maritime Air Number")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Ctry. ISO Code Of Orig. Manuf."; Rec."Ctry. ISO Code Of Orig. Manuf.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}