codeunit 82660 "MICA SANA Get Business Lines"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Customer Functions", 'OnRunCustomerFunctions', '', false, false)]
    local procedure OnRunCustomerFunctionsSCCustomerFunctions(var Rec: Record "SC - Operation"; var RequestBuff: Record "SC - XML Buffer (dotNET)"; var ResponseBuff: Record "SC - XML Buffer (dotNET)")
    begin
        if Rec.Code = UPPERCASE('GetBusinessLines') then
            GetBusinessLines(RequestBuff, ResponseBuff);
    end;

    local procedure GetBusinessLines(var InSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; var OutSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)")
    begin
        TempSCParametersCollection.InitParams(InSCXMLBufferdotNET, 0);
        FillXmlResponse(OutSCXMLBufferdotNET);
    end;

    local procedure FillXmlResponse(var OutSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)")
    var
        TempLineSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        DimensionValue: Record "Dimension Value";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
    begin
        if MICAFinancialReportingSetup.Get() then begin
            DimensionValue.SetRange("Dimension Code", MICAFinancialReportingSetup."Structure Dimension");
            if DimensionValue.FindSet() then
                repeat
                    OutSCXMLBufferdotNET.AddElement(TempLineSCXMLBufferdotNET, 'BusinessLine', '');
                    TempLineSCXMLBufferdotNET.AddFieldElement('Id', DimensionValue.Code);
                    TempLineSCXMLBufferdotNET.AddFieldElement('Name', DimensionValue.Name);
                until (DimensionValue.Next() = 0);
        end;
    end;

    var
        TempSCParametersCollection: Record "SC - Parameters Collection" temporary;
}