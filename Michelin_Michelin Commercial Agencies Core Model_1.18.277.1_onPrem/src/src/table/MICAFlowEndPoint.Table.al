table 80861 "MICA Flow EndPoint"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "MICA Flow EndPoint List";
    LookupPageId = "MICA Flow EndPoint List";
    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(30; "Partner Code"; Code[20])
        {
            Caption = 'Partner Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Partner";
        }
        field(40; "EndPoint Type"; Option)
        {
            Caption = 'EndPoint Type';
            DataClassification = CustomerContent;
            OptionMembers = " ",Blob,MQ;
        }
        field(50; "Blob Storage"; Text[100])
        {
            Caption = 'Blob Storage';
            DataClassification = CustomerContent;
        }
        field(60; "Blob SSAS Signature"; Text[250])
        {
            Caption = 'Blob SSAS Signature';
            DataClassification = CustomerContent;
        }
        field(70; "MQ URL"; Text[250])
        {
            Caption = 'MQ URL';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
        field(80; "MQ Login"; Text[50])
        {
            Caption = 'MQ Login';
            DataClassification = CustomerContent;
        }
        field(90; "MQ Password"; Text[50])
        {
            Caption = 'MQ Password';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
        field(100; "Flow Count"; Integer)
        {
            Caption = 'Flow Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow" where("EndPoint Code" = field(Code)));
        }
        field(110; "Count of Entry"; Integer)
        {
            Caption = 'Count of Entry';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow ENtry" where("EndPoint Code" = field(Code)));
        }
        field(120; "Count of Archived File"; Integer)
        {
            Caption = 'Count of Archived File';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(130; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(140; "Last Modified User ID"; Code[50])
        {
            Caption = 'Last Modified User ID';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
        }

        field(240; "Use Certificate"; Boolean)
        {
            Caption = 'Use Certificate';
            DataClassification = CustomerContent;
        }
        field(250; "Certificate String (base64)"; Text[2048])
        {
            Caption = 'Certificate String (base64)';
            DataClassification = CustomerContent;
        }
        field(260; "Certificate Password"; Text[100])
        {
            Caption = 'Certificate Password';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }


    procedure SubstituteParameters(InText: Text) OutText: Text
    var
        MICAIntMonitoringSetup: Record "MICA Int. Monitoring Setup";
        MICAFlowPartner: Record "MICA Flow Partner";
    begin

        if InText = '' then
            exit;


        if not MICAIntMonitoringSetup.Get() then
            clear(MICAIntMonitoringSetup);

        if not MICAFlowPartner.get("Partner Code") then
            clear(MICAFlowPartner);

        outText := StrSubstNo(intext,
            MICAIntMonitoringSetup."EndPoint Substitute Value 1",
            MICAIntMonitoringSetup."EndPoint Substitute Value 2",
            MICAIntMonitoringSetup."EndPoint Substitute Value 3",
            MICAIntMonitoringSetup."EndPoint Substitute Value 4",
            MICAIntMonitoringSetup."EndPoint Substitute Value 5",
            MICAFlowPartner."EndPoint Substitute Value 1",
            MICAFlowPartner."EndPoint Substitute Value 2",
            MICAFlowPartner."EndPoint Substitute Value 3",
            MICAFlowPartner."EndPoint Substitute Value 4",
            MICAFlowPartner."EndPoint Substitute Value 5")
    end;

    trigger OnInsert()
    begin
        Validate("Last Modified Date Time", CurrentDateTime());
        Validate("Last Modified User ID", UserId());
    end;

    trigger OnModify()
    begin
        Validate("Last Modified Date Time", CurrentDateTime());
        Validate("Last Modified User ID", UserId());
    end;

    procedure SetupHttpClient(var HttpClient: HttpClient)
    begin

        if "Use Certificate" then
            HttpClient.AddCertificate("Certificate String (base64)", "Certificate Password");

    end;

}