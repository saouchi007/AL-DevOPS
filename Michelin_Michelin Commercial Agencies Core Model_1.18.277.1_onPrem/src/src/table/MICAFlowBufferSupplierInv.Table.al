table 82020 "MICA Flow Buffer Supplier Inv."
{
    //INTGIS001 – Supplier Invoice Integration
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Flow Buffer Supplier Inv.";

    fields
    {
        field(1; "Flow Code"; Code[20])
        {
            Caption = 'Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
        }
        field(2; "Flow Entry No."; Integer)
        {
            Caption = 'Flow Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Entry"."Entry No.";

            trigger OnValidate()
            var
                FlowEntry: Record "MICA Flow Entry";
            begin
                if FlowEntry.Get("Flow Entry No.") then
                    Validate("Flow Code", FlowEntry."Flow Code");
            end;

        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(10; "Date Time Creation"; DateTime)
        {
            Caption = 'Date Time Creation';
            DataClassification = CustomerContent;
        }
        field(12; "Date Time Last Modified"; DateTime)
        {
            Caption = 'Date time Last Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Info Count"; Integer)
        {
            Caption = 'Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(21; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(22; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Flow Entry No." = field("Flow Entry No."), "Flow Buffer Entry No." = field("Entry No."), "Info Type" = const(Error)));
        }
        field(30; "Skip Line"; Boolean)
        {
            Caption = 'Skip Line';
            DataClassification = CustomerContent;
        }
        field(40; "Linked Record ID"; RecordID)
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Linked Record", CopyStr(Format(RecordID()), 1, 250));
            end;
        }

        field(41; "Linked Record"; Text[250])
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;
        }


        // MESSAGE FIELDS
        //raw fields>>
        field(1001; RELFACTCODE; Code[10])
        {
            Caption = 'Rel. Fact. Code';
            DataClassification = CustomerContent;
        }
        field(1002; SHIPNUMBER; Code[35])
        {
            Caption = 'Shipment No.';
            DataClassification = CustomerContent;
        }

        field(1070; "Supplier PARTNERID"; Code[20])
        {
            Caption = 'Supplier Partner ID';
            DataClassification = CustomerContent;
        }
        field(1071; "Supplier COUNTRY"; Code[10])
        {
            Caption = 'Supplier Country';
            DataClassification = CustomerContent;
        }
        field(1072; "Supplier NAME"; Text[150])
        {
            Caption = 'Supplier Name';
            DataClassification = CustomerContent;
        }
        field(1073; "Supplier Descriptn"; Text[150])
        {
            Caption = 'Supplier Description';
            DataClassification = CustomerContent;
        }
        field(1080; "BillTo PARTNERID"; Code[20])
        {
            Caption = 'Bill-to Partner ID';
            DataClassification = CustomerContent;
        }
        field(1081; "BillTo COUNTRY"; Code[10])
        {
            Caption = 'Bill-to Country';
            DataClassification = CustomerContent;
        }
        field(1082; "BillTo NAME"; Text[150])
        {
            Caption = 'Bill-to Name';
            DataClassification = CustomerContent;
        }
        field(1083; "BillTo Descriptn"; Text[150])
        {
            Caption = 'Bill-to Description';
            DataClassification = CustomerContent;
        }

        field(1090; "ShipTo PARTNERID"; Code[20])
        {
            Caption = 'Ship-to Partner ID';
            DataClassification = CustomerContent;
        }
        field(1091; "ShipTo COUNTRY"; Code[10])
        {
            Caption = 'Ship-to Country';
            DataClassification = CustomerContent;
        }
        field(1092; "ShipTo NAME"; Text[150])
        {
            Caption = 'Ship-to Name';
            DataClassification = CustomerContent;
        }
        field(1093; "ShipTo Descriptn"; Text[150])
        {
            Caption = 'Ship-to Description';
            DataClassification = CustomerContent;
        }

        field(1005; CURRENCY; Code[10])
        {
            Caption = 'Currency';
            DataClassification = CustomerContent;
        }
        field(1007; DOCTYPE; Text[20])
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }

        field(1008; TERMID; Code[15])
        {
            Caption = 'Term ID';
            DataClassification = CustomerContent;
        }
        field(1009; YEAR; Text[5])
        {
            Caption = 'Year';
            DataClassification = CustomerContent;
        }

        field(1010; MONTH; Text[2])
        {
            Caption = 'Month';
            DataClassification = CustomerContent;
        }
        field(1011; DAY; Text[2])
        {
            Caption = 'Day';
            DataClassification = CustomerContent;
        }
        field(1013; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
            DataClassification = CustomerContent;
        }
        field(1014; "MICH.ORIGINVNUM"; Code[35])
        {
            Caption = 'MICH. Orig. Invoice No.';
            DataClassification = CustomerContent;
        }
        field(1015; "MICH.ORIGINVDATE"; Text[35])
        {
            Caption = 'MICH. Orig. Invoice Date';
            DataClassification = CustomerContent;
        }
        field(1016; DOCUMENTID; Code[35])
        {
            Caption = 'Document ID';
            DataClassification = CustomerContent;
        }
        field(1020; "MICH.ATTRIBUTE1"; Text[30])
        {
            Caption = 'MICH. Attribute 1';
            DataClassification = CustomerContent;
        }
        field(1021; ATTRIBUTE1; Text[30])
        {
            Caption = 'Attribute 1';
            DataClassification = CustomerContent;
        }
        field(1022; "Total Amount RAW"; Text[30])
        {
            Caption = 'Total Amount RAW';
            DataClassification = CustomerContent;
        }
        field(1023; "DocRef Document Type"; Text[30])
        {
            Caption = 'DocRef Document Type';
            DataClassification = CustomerContent;
        }

        field(1040; "Line DOCTYPE1"; Text[15])
        {
            Caption = 'Line Doc. Type 1';
            DataClassification = CustomerContent;
        }
        field(1059; "Line DocumentID1"; Text[35])
        {
            Caption = 'Line Doc. ID 1';
            DataClassification = CustomerContent;
        }
        field(1060; "Line Linenum1"; Text[20])
        {
            Caption = 'Line Number 1';
            DataClassification = CustomerContent;
        }
        field(1061; "Line DOCTYPE2"; Text[15])
        {
            Caption = 'Line Doc. Type 2';
            DataClassification = CustomerContent;
        }
        field(1062; "Line DocumentID2"; Text[35])
        {
            Caption = 'Line Doc. ID 2';
            DataClassification = CustomerContent;
        }
        field(1063; "Line Linenum2"; Text[20])
        {
            Caption = 'Line Number 2';
            DataClassification = CustomerContent;
        }
        field(1064; "Line DOCTYPE3"; Text[15])
        {
            Caption = 'Line Doc. Type 3';
            DataClassification = CustomerContent;
        }
        field(1065; "Line DocumentID3"; Text[35])
        {
            Caption = 'Line Doc. ID 3';
            DataClassification = CustomerContent;
        }
        field(1066; "Line Linenum3"; Text[20])
        {
            Caption = 'Line Number 3';
            DataClassification = CustomerContent;
        }
        field(1041; "Line CHARGETYPE"; Text[10])
        {
            Caption = 'Line Charge Type';
            DataClassification = CustomerContent;
        }
        field(1042; "Line No."; Text[10])
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(1043; "Freight Line No."; Text[10])
        {
            Caption = 'Freight Line No.';
            DataClassification = CustomerContent;
        }
        field(1044; "Line Quantity Raw"; Text[30])
        {
            Caption = 'Line Quantity Raw';
            DataClassification = CustomerContent;
        }
        field(1045; "Line OPERAMT Raw"; Text[30])
        {
            Caption = 'Line Oper. Amount Raw';
            DataClassification = CustomerContent;
        }
        field(1046; "Line Item No."; Text[20])
        {
            Caption = 'Line Item No.';
            DataClassification = CustomerContent;
        }
        field(1047; "Line DESCRIPTN"; Text[100])
        {
            Caption = 'Line Description';
            DataClassification = CustomerContent;
        }
        field(1048; "Line Amount Raw"; Text[30])
        {
            Caption = 'Line Amount Raw';
            DataClassification = CustomerContent;
        }
        field(1049; "Line Charge Amount Raw"; Text[30])
        {
            Caption = 'Line Charge Amount Raw';
            DataClassification = CustomerContent;
        }
        field(1050; "Line Unit of Measure"; Text[10])
        {
            Caption = 'Line Unit of Measure';
            DataClassification = CustomerContent;
        }
        field(1051; "Line MICH.DESTCOUNTRYCODE"; Text[10])
        {
            Caption = 'Line MICH.DESTCOUNTRYCODE';
            DataClassification = CustomerContent;
        }
        field(1052; "Line MICH.COUNTRYORIG"; Text[10])
        {
            Caption = 'Line MICH.COUNTRYORIG';
            DataClassification = CustomerContent;
        }
        field(1053; "Line MICH.DESTREGION"; Text[10])
        {
            Caption = 'Line MICH.DESTREGION';
            DataClassification = CustomerContent;
        }
        field(1054; "Line MICH.DELIVERTERMS"; Text[10])
        {
            Caption = 'Line MICH.DELIVERTERMS';
            DataClassification = CustomerContent;
        }
        field(1055; "Line MICH.TRXCODENATURE"; Text[10])
        {
            Caption = 'Line MICH.TRXCODENATURE';
            DataClassification = CustomerContent;
        }
        field(1056; "Line MICH.NETMASS Raw"; Text[30])
        {
            Caption = 'Line MICH.NETMASS Raw';
            DataClassification = CustomerContent;
        }
        field(1057; "Line MICH.LOADINGPORT"; Text[20])
        {
            Caption = 'Line MICH.LOADINGPORT';

            DataClassification = CustomerContent;
        }
        field(1058; "Line MICH.LINEATTRIBUTE3"; Text[10])
        {
            Caption = 'Line MICH.LINEATTRIBUTE';
            DataClassification = CustomerContent;
        }
        field(1067; "Line MICH.SUPPLEMENTUNITS"; Text[30])
        {
            Caption = 'Line MICH.SUPPLEMENTUNITS';
            DataClassification = CustomerContent;
        }
        field(1068; "Line MICH.TRANSPORTMODE"; Text[30])
        {
            Caption = 'Line MICH.TRANSPORTMODE';
            DataClassification = CustomerContent;
        }
        field(1069; "Line MICH.STATISTICPROCED"; Text[30])
        {
            Caption = 'MICH.STATISTICPROCED';
            DataClassification = CustomerContent;
        }
        field(1074; "Line MICH.STATISTICVALUE"; Text[30])
        {
            Caption = 'MICH.STATISTICVALUE';
            DataClassification = CustomerContent;
        }

        field(1075; "Line MICH.COMMODITYCODE"; Text[30])
        {
            Caption = 'MICH.COMMODITYCODE';
            DataClassification = CustomerContent;
        }
        field(1076; "Line MICH.CONTAINERNUM"; Code[50])
        {
            Caption = 'MICH.CONTAINERNUM';
            DataClassification = CustomerContent;
        }

        field(1077; "Line SCHLINENUM"; Code[30])
        {
            Caption = 'SCHLINENUM';
            DataClassification = CustomerContent;
        }

        //raw fields<<

        field(1200; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(1201; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
        }
        field(1202; "Line Quantity"; Decimal)
        {
            Caption = 'Line Quantity';
            DataClassification = CustomerContent;
        }
        field(1203; "Line Direct Unit Cost"; Decimal)
        {
            Caption = 'Line Direct Unit Cost';
            DataClassification = CustomerContent;
        }
        field(1204; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            DataClassification = CustomerContent;
        }
        field(1205; "Line Charge Amount"; Decimal)
        {
            Caption = 'Line Charge Amount';
            DataClassification = CustomerContent;
        }
        field(1206; "Line Neto Weight"; Decimal)
        {
            Caption = 'Line Neto Weight';
            DataClassification = CustomerContent;
        }
        field(1207; "Line OPERAMT"; Decimal)
        {
            Caption = 'Line Oper. Amount';
            DataClassification = CustomerContent;
        }
        field(1208; "Qualifier Tax"; Text[30])
        {
            Caption = 'Qualifier Tax';
            DataClassification = CustomerContent;
        }
        field(1209; "Line Number Tax"; Text[30])
        {
            Caption = 'Line Number Tax';
            DataClassification = CustomerContent;
        }
        field(1210; "Quantity Tax"; Decimal)
        {
            Caption = 'Quantity Tax';
            DataClassification = CustomerContent;
        }
        field(1211; "Tax Code"; Text[20])
        {
            Caption = 'Tax Code';
            DataClassification = CustomerContent;
        }
        field(1212; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
            DataClassification = CustomerContent;
        }

        field(1213; "Quantity Tax Raw"; Text[30])
        {
            Caption = 'Quantity Tax Raw';
            DataClassification = CustomerContent;
        }
        field(1214; "Tax Amount Raw"; Text[30])
        {
            Caption = 'Tax Amount Raw';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Flow Code", "Flow Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Validate("Date Time Creation", CurrentDateTime());
    end;

    procedure AddInformation(MICAFlowEntry: Record "MICA Flow Entry"; BufferEntryNo: Integer; Type: Option; Description1: Text; Description2: Text): Integer
    var
        ErrorLbl: Label ';%1', Comment = '%1', Locked = true;
    begin
        ErrorCode += StrSubstNo(ErrorLbl, Description2);
        ErrorDescription += StrSubstNo(ErrorLbl, Description1);

        exit(MICAFlowEntry.AddInformation(Type, BufferEntryNo, Description1, Description2));
    end;

    procedure GetErrorText(var inErrCode: Text; var inErrDesc: Text)
    begin
        if ErrorCode[1] = ';' then
            inErrCode := CopyStr(ErrorCode, 2);
        ErrorCode := '';
        if ErrorDescription[1] = ';' then
            inErrDesc := CopyStr(ErrorDescription, 2);
        ErrorDescription := '';
    end;

    var
        ErrorDescription: Text;
        ErrorCode: Text;
}