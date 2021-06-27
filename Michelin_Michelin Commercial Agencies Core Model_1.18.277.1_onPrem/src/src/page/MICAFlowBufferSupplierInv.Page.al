page 82020 "MICA Flow Buffer Supplier Inv."
{

    PageType = List;
    SourceTable = "MICA Flow Buffer Supplier Inv.";
    Caption = 'Flow Buffer Supplier Inv. Data List';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Flow Code"; Rec."Flow Code")
                {
                    ApplicationArea = All;
                }
                field("Flow Entry No."; Rec."Flow Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Date Time Creation"; Rec."Date Time Creation")
                {
                    ApplicationArea = All;
                }
                field("Date Time Last Modified"; Rec."Date Time Last Modified")
                {
                    ApplicationArea = All;
                }
                field("Info Count"; Rec."Info Count")
                {
                    ApplicationArea = All;
                }
                field("Warning Count"; Rec."Warning Count")
                {
                    ApplicationArea = All;
                }
                field("Error Count"; Rec."Error Count")
                {
                    ApplicationArea = All;
                }
                field("Skip Line"; Rec."Skip Line")
                {
                    ApplicationArea = All;
                }
                field("Linked Record ID"; Rec."Linked Record ID")
                {
                    ApplicationArea = All;
                }
                field("Linked Record"; Rec."Linked Record")
                {
                    ApplicationArea = All;
                }

                field(RELFACTCODE; Rec.RELFACTCODE)
                {
                    ApplicationArea = All;
                }
                field(SHIPNUMBER; Rec.SHIPNUMBER)
                {
                    ApplicationArea = All;
                }
                field("Supplier PARTNERID"; Rec."Supplier PARTNERID")
                {
                    ApplicationArea = All;
                }
                field("Supplier COUNTRY"; Rec."Supplier COUNTRY")
                {
                    ApplicationArea = All;
                }
                field("Supplier Descriptn"; Rec."Supplier Descriptn")
                {
                    ApplicationArea = All;
                }
                field("BillTo PARTNERID"; Rec."BillTo PARTNERID")
                {
                    ApplicationArea = All;
                }
                field("BillTo COUNTRY"; Rec."BillTo COUNTRY")
                {
                    ApplicationArea = All;
                }
                field("BillTo NAME"; Rec."BillTo NAME")
                {
                    ApplicationArea = All;
                }
                field("BillTo Descriptn"; Rec."BillTo Descriptn")
                {
                    ApplicationArea = All;
                }
                field("ShipTo PARTNERID"; Rec."ShipTo PARTNERID")
                {
                    ApplicationArea = All;
                }
                field("ShipTo COUNTRY"; Rec."ShipTo COUNTRY")
                {
                    ApplicationArea = All;
                }
                field("ShipTo NAME"; Rec."ShipTo NAME")
                {
                    ApplicationArea = All;
                }
                field("ShipTo Descriptn"; Rec."ShipTo Descriptn")
                {
                    ApplicationArea = All;
                }
                field(CURRENCY; Rec.CURRENCY)
                {
                    ApplicationArea = All;
                }
                field(DOCTYPE; Rec.DOCTYPE)
                {
                    ApplicationArea = All;
                }
                field(TERMID; Rec.TERMID)
                {
                    ApplicationArea = All;
                }
                field(YEAR; Rec.YEAR)
                {
                    ApplicationArea = All;
                }
                field(MONTH; Rec.MONTH)
                {
                    ApplicationArea = All;
                }
                field(DAY; Rec.DAY)
                {
                    ApplicationArea = All;
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("MICH.ORIGINVNUM"; Rec."MICH.ORIGINVNUM")
                {
                    ApplicationArea = All;
                }
                field("MICH.ORIGINVDATE"; Rec."MICH.ORIGINVDATE")
                {
                    ApplicationArea = All;
                }
                field(DOCUMENTID; Rec."DOCUMENTID")
                {
                    ApplicationArea = All;
                }
                field("MICH.ATTRIBUTE1"; Rec."MICH.ATTRIBUTE1")
                {
                    ApplicationArea = All;
                }
                field(ATTRIBUTE1; Rec.ATTRIBUTE1)
                {
                    ApplicationArea = All;
                }
                field("Total Amount RAW"; Rec."Total Amount RAW")
                {
                    ApplicationArea = All;
                }
                field("Line DOCTYPE1"; Rec."Line DOCTYPE1")
                {
                    ApplicationArea = All;
                }
                field("Line DocumentID1"; Rec."Line DocumentID1")
                {
                    ApplicationArea = All;
                }
                field("Line Linenum1"; Rec."Line Linenum1")
                {
                    ApplicationArea = All;
                }
                field("Line DOCTYPE2"; Rec."Line DOCTYPE2")
                {
                    ApplicationArea = All;
                }
                field("Line DocumentID2"; Rec."Line DocumentID2")
                {
                    ApplicationArea = All;
                }
                field("Line Linenum2"; Rec."Line Linenum2")
                {
                    ApplicationArea = All;
                }
                field("Line DOCTYPE3"; Rec."Line DOCTYPE3")
                {
                    ApplicationArea = All;
                }
                field("Line DocumentID3"; Rec."Line DocumentID3")
                {
                    ApplicationArea = All;
                }
                field("Line Linenum3"; Rec."Line Linenum3")
                {
                    ApplicationArea = All;
                }
                field("Line CHARGETYPE"; Rec."Line CHARGETYPE")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Freight Line No."; Rec."Freight Line No.")
                {
                    ApplicationArea = All;
                }
                field("Line Quantity RAW"; Rec."Line Quantity RAW")
                {
                    ApplicationArea = All;
                }
                field("Line OPERAMT Raw"; Rec."Line OPERAMT Raw")
                {
                    ApplicationArea = All;
                }
                field("Line Item No."; Rec."Line Item No.")
                {
                    ApplicationArea = All;
                }
                field("Line DESCRIPTN"; Rec."Line DESCRIPTN")
                {
                    ApplicationArea = All;
                }
                field("Line Amount Raw"; Rec."Line Amount Raw")
                {
                    ApplicationArea = All;
                }
                field("Line Charge Amount Raw"; Rec."Line Charge Amount Raw")
                {
                    ApplicationArea = All;
                }
                field("Line Unit of Measure"; Rec."Line Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Line MICH.DESTCOUNTRYCODE"; Rec."Line MICH.DESTCOUNTRYCODE")
                {
                    ApplicationArea = All;
                }
                field("Line MICH.COUNTRYORIG"; Rec."Line MICH.COUNTRYORIG")
                {
                    ApplicationArea = All;
                }
                field("Line MICH.DESTREGION"; Rec."Line MICH.DESTREGION")
                {
                    ApplicationArea = All;
                }
                field("Line MICH.DELIVERTERMS"; Rec."Line MICH.DELIVERTERMS")
                {
                    ApplicationArea = All;
                }
                field("Line MICH.TRXCODENATURE"; Rec."Line MICH.TRXCODENATURE")
                {
                    ApplicationArea = All;
                }
                field("Line MICH.NETMASS Raw"; Rec."Line MICH.NETMASS Raw")
                {
                    ApplicationArea = All;
                }
                field("Line MICH.LOADINGPORT"; Rec."Line MICH.LOADINGPORT")
                {
                    ApplicationArea = All;
                }
                field("Line MICH.LINEATTRIBUTE3"; Rec."Line MICH.LINEATTRIBUTE3")
                {
                    ApplicationArea = All;
                }

                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Line Quantity"; Rec."Line Quantity")
                {
                    ApplicationArea = All;
                }
                field("Line Direct Unit Cost"; Rec."Line Direct Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Line Charge Amount"; Rec."Line Charge Amount")
                {
                    ApplicationArea = All;
                }
                field("Line Neto Weight"; Rec."Line Neto Weight")
                {
                    ApplicationArea = All;
                }

                field("Line MICH.SUPPLEMENTUNITS"; Rec."Line MICH.SUPPLEMENTUNITS")
                {
                    ApplicationArea = All;
                }
                field("Line MICH.TRANSPORTMODE"; Rec."Line MICH.TRANSPORTMODE")
                {
                    ApplicationArea = All;
                }
                field("Line MICH.STATISTICPROCED"; Rec."Line MICH.STATISTICPROCED")
                {
                    ApplicationArea = All;
                }
                field("Line MICH.STATISTICVALUE"; Rec."Line MICH.STATISTICVALUE")
                {
                    ApplicationArea = All;
                }
                field("Qualifier Tax"; Rec."Qualifier Tax")
                {
                    ApplicationArea = All;
                }
                field("Line Number Tax"; Rec."Line Number Tax")
                {
                    ApplicationArea = All;
                }
                field("Tax Code"; Rec."Tax Code")
                {
                    ApplicationArea = All;
                }
                field("Tax Amount Raw"; Rec."Tax Amount Raw")
                {
                    ApplicationArea = All;
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("Quantity Tax Raw"; Rec."Quantity Tax Raw")
                {
                    ApplicationArea = All;
                }
                field("Quantity Tax"; Rec."Quantity Tax")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
