codeunit 82025 "MICA Flow Send SuppInv FuncACK"
{
    //INTGIS001 – Supplier Invoice Integration
    TableNo = "MICA Flow";

    var
        PurchaseHeader: Record "Purchase Header";
        MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowRecord: Record "MICA Flow Record";
        MICAFlow: Record "MICA Flow";
        TempBlob: Codeunit "Temp Blob";

    trigger OnRun()
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        FlowNotFoundErr: Label '%1.%2 missing';
    begin
        PurchasesPayablesSetup.Get();
        PurchasesPayablesSetup.TestField("MICA GIS Sup. Inv. Flow Code");
        if not MICAFlow.Get(PurchasesPayablesSetup."MICA GIS Sup. Inv. Flow Code") then begin
            MICAFlow.AddInformation(MICAFlowInformation."Info Type"::Error,
                                StrSubstNo(FlowNotFoundErr, CopyStr(PurchasesPayablesSetup.TableCaption(), 1, 30),
                                                             CopyStr(PurchasesPayablesSetup.FieldCaption("MICA GIS Sup. Inv. Flow Code"), 1, 30)), '');
            exit;
        end else
            if not ParamMICAFlowSetup.Get(PurchasesPayablesSetup."MICA GIS Sup. Inv. Flow Code", 'FUNCTIONALACKFLOW') then begin
                MICAFlow.AddInformation(MICAFlowInformation."Info Type"::Error,
                     StrSubstNo(FlowNotFoundErr, CopyStr(ParamMICAFlowSetup.TableCaption(), 1, 30), 'FUNCTIONALACKFLOW for ' + PurchasesPayablesSetup."MICA GIS Sup. Inv. Flow Code"), '');
                exit;
            end else
                if not MICAFlow.Get(ParamMICAFlowSetup.GetFlowTextParam(PurchasesPayablesSetup."MICA GIS Sup. Inv. Flow Code", 'FUNCTIONALACKFLOW')) then begin
                    MICAFlow.AddInformation(MICAFlowInformation."Info Type"::Error,
                         StrSubstNo(FlowNotFoundErr, CopyStr(MICAFlow.TableCaption(), 1, 30), ParamMICAFlowSetup.GetFlowTextParam(PurchasesPayablesSetup."MICA GIS Sup. Inv. Flow Code", 'FUNCTIONALACKFLOW')), '');
                    exit;
                end;

        SendACK();
    end;

    procedure SetParameters(inPurchaseHeader: Record "Purchase Header"; var inMICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.")
    begin
        PurchaseHeader := inPurchaseHeader;
        MICAFlowBufferSupplierInv := inMICAFlowBufferSupplierInv;
    end;

    local procedure SendACK()
    var
        MICASupplierInvFunctionlACK: XmlPort "MICA Supplier Inv.FunctionlACK";
        DataPrepLbl: Label 'Data Prepapration has been Completed';
        ExportedRecordCountLbl: Label '%1 Records Exported';
        ExportFailErr: Label 'Export Failed (%1)';
        UnableCreateFlowEntryErr: Label 'Unable to create Flow Entry';
        StartMsg: Label 'Start preparing data';
        ExportedRecordCount: Integer;
        OutStream: OutStream;
    //f: Codeunit "File Management";

    begin
        if not MICAFlowEntry.Get(MICAFlow.CreateFlowEntry()) then begin
            MICAFlow.AddInformation(MICAFlowInformation."Info Type"::Error, UnableCreateFlowEntryErr, GetLastErrorText());
            exit;
        end;
        MICAFlowEntry.Description += '.xml';
        MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StartMsg, '');

        Clear(TempBlob);
        TempBlob.CreateOutStream(OutStream);
        Clear(MICASupplierInvFunctionlACK);
        MICASupplierInvFunctionlACK.SetParameters(MICAFlowEntry, PurchaseHeader, MICAFlowBufferSupplierInv);
        MICASupplierInvFunctionlACK.SetDestination(OutStream);
        if MICASupplierInvFunctionlACK.Export() then begin
            ExportedRecordCount := MICASupplierInvFunctionlACK.GetRecordCount();
            if ExportedRecordCount > 0 then begin
                MICAFlowRecord.UpdateSendRecord(MICAFlowEntry."Entry No.", PurchaseHeader.RecordId(), MICAFlowEntry."Send Status"::Prepared);
                MICAFlowEntry.PrepareToSend(TempBlob);

                //test>>
                //f.BLOBExport(TempBlob, 'ack.xml', true);
                //test<<
            end;
            MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount)));
            MICAFlowInformation.Update('', '');
        end else begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(ExportFailErr, GetLastErrorText()), GetLastErrorCode());
            MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount)));
            MICAFlowInformation.Update('', '');
        end;
    end;
}