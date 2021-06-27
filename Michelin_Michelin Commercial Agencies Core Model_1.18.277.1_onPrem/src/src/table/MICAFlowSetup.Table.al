table 80869 "MICA Flow Setup"
{
    DataClassification = CustomerContent;
    LookupPageId = "MICA Flow Parameters";
    DrillDownPageId = "MICA Flow Parameters";
    fields
    {
        field(10; Flow; Code[20])
        {
            Caption = 'Flow';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
        }
        field(20; "Parameter Code"; Code[20])
        {
            Caption = 'Parameter Code';
            DataClassification = CustomerContent;
        }
        field(30; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(40; Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionMembers = Decimal,Integer,Text,Date,Dateformula;
            OptionCaption = 'Decimal,Integer,Text,Date,Dateformula';
        }
        field(50; "Decimal Value"; Decimal)
        {
            Caption = 'Decimal Value';
            DataClassification = CustomerContent;
        }
        field(60; "Integer Value"; Integer)
        {
            Caption = 'Integer Value';
            DataClassification = CustomerContent;
        }
        field(70; "Text Value"; Text[250])
        {
            Caption = 'Text Value';
            DataClassification = CustomerContent;
        }
        field(80; "Date Value"; Date)
        {
            Caption = 'Date Value';
            DataClassification = CustomerContent;
        }
        field(90; "Date Formula Value"; DateFormula)
        {
            Caption = 'Date Formula Value';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Flow", "Parameter Code")
        {
            Clustered = true;
        }
    }

    procedure GetFlowDecParam(FlowCode: Code[20]; ParameterCode: Code[20]): Decimal
    var
        MICAFlowSetup: Record "MICA Flow Setup";
    begin
        if MICAFlowSetup.Get(FlowCode, ParameterCode) then
            if MICAFlowSetup.Type = Type::Decimal then
                exit(MICAFlowSetup."Decimal Value");
        exit(0);
    end;

    procedure GetFlowIntParam(FlowCode: Code[20]; ParameterCode: Code[20]): Integer
    var
        MICAFlowSetup: Record "MICA Flow Setup";
    begin
        if MICAFlowSetup.Get(FlowCode, ParameterCode) then
            if MICAFlowSetup.Type = Type::Integer then
                exit(MICAFlowSetup."Integer Value");
        exit(0);
    end;

    procedure GetFlowTextParam(FlowCode: Code[20]; ParameterCode: Code[20]): Text
    var
        MICAFlowSetup: Record "MICA Flow Setup";
    begin
        if MICAFlowSetup.Get(FlowCode, ParameterCode) then
            if MICAFlowSetup.Type = Type::Text then
                exit(MICAFlowSetup."Text Value");
        exit('');
    end;

    procedure GetFlowDateParam(FlowCode: Code[20]; ParameterCode: Code[20]): Date
    var
        MICAFlowSetup: Record "MICA Flow Setup";
    begin
        if MICAFlowSetup.Get(FlowCode, ParameterCode) then
            if MICAFlowSetup.Type = Type::Date then
                exit(MICAFlowSetup."Date Value");
        exit(0D);
    end;

    procedure GetFlowDateFormulaParam(FlowCode: Code[20]; ParameterCode: Code[20]): Text
    var
        MICAFlowSetup: Record "MICA Flow Setup";
    begin
        if MICAFlowSetup.Get(FlowCode, ParameterCode) then
            if MICAFlowSetup.Type = Type::Text then
                exit(Format(MICAFlowSetup."Date Formula Value"));
        exit('');
    end;

    procedure CheckIfParamExist(FlowCode: Code[20]; ParameterCode: Code[20]): Boolean
    var
        MICAFlowSetup: Record "MICA Flow Setup";
    begin
        exit(MICAFlowSetup.Get(FlowCode, ParameterCode));
    end;

}