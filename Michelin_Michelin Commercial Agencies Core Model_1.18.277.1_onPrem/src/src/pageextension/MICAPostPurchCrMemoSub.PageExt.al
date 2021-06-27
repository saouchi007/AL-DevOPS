pageextension 82031 "MICA Post.Purch. Cr.Memo Sub." extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {
        addafter("ShortcutDimCode[8]")
        {

            field("MICA GIS Document Line No."; Rec."MICA GIS Document Line No.")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Freight Doc. Line No."; Rec."MICA GIS Freight Doc. Line No.")
            { ApplicationArea = All; }
            field("MICA GIS Dest. Country Code"; Rec."MICA GIS Dest. Country Code")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Country of Origin"; Rec."MICA GIS Country of Origin")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Region of Origin"; Rec."MICA GIS Region of Origin")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Delivery Terms"; Rec."MICA GIS Delivery Terms")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Commodity Code"; Rec."MICA GIS Commodity Code")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Net Mass"; Rec."MICA GIS Net Mass")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Supplementary Units"; Rec."MICA GIS Supplementary Units")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Mode of Transport"; Rec."MICA GIS Mode of Transport")
            {
                ApplicationArea = All;
            }
            field("MICA Freight Line No."; Rec."MICA Freight Line No.")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Loading Port"; Rec."MICA GIS Loading Port")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Statistic Procedure"; Rec."MICA GIS Statistic Procedure")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Statistical Value"; Rec."MICA GIS Statistical Value")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Country of Manuf."; Rec."MICA GIS Country of Manuf.")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Container No."; Rec."MICA GIS Container No.")
            {
                ApplicationArea = All;
            }
            field("MICA GIS Contrib. PO Shpt No."; Rec."MICA GIS Contrib. PO Shpt No.")
            {
                ApplicationArea = All;
            }
        }
    }
}