codeunit 82220 "MICA Flow Send eFDM Stock IntC"
{
    TableNo = "MICA Flow";

    var
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        MICAFlowInformation: Record "MICA Flow Information";
        MICAFlowEntry: Record "MICA Flow Entry";
        Location: Record Location;
        Item: Record Item;
        ValidItem: Record Item;
        CompanyInformation: Record "Company Information";
        CountryRegion: Record "Country/Region";
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        TempBlob: Codeunit "Temp Blob";
        FileDate: Text[14];
        ParamValue_FileNameOnHand: Text;
        ParamValue_FileNameTransit: Text;
        ParamValue_Instance: Text;
        ParamValue_HeaderFile: Text;
        ParamValue_Application: Text;
        ParamValue_FlowNameHand: Text;
        ParamValue_FlowNameTransit: Text;
        ParamValue_AppMode: Text;
        ParamValue_HeaderBlock: Text;
        ParamValue_BlockNameHand: Text;
        ParamValue_BlockNameTransit: Text;
        ParamValue_FooterBlock: Text;
        ParamValue_FooterFile: Text;
        ParamValue_RecIdentifierHand: Text;
        ParamValue_RecIdentifierTran: Text;
        ParamValue_DefSrcLocType: Text;
        ParamValue_UserItemTypeFilter: Text;
        Param_FileNameOnHandTxt: Label 'FILENAMEONHAND', Locked = true;
        Param_FileNameTransitTxt: Label 'FILENAMETRANSIT', Locked = true;
        Param_InstanceTxt: Label 'INSTANCE', Locked = true;
        Param_HeaderFileTxt: Label 'HEADERFILE', Locked = true;
        Param_ApplicationTxt: Label 'APPLICATION', Locked = true;
        Param_FlowNameHandTxt: Label 'FLOWNAMEHAND', Locked = true;
        Param_FlowNameTransitTxt: Label 'FLOWNAMETRANSIT', Locked = true;
        Param_AppModeTxt: Label 'APPMODE', Locked = true;
        Param_HeaderBlockTxt: Label 'HEADERBLOCK', Locked = true;
        Param_BlockNameHandTxt: Label 'BLOCKNAMEHAND', Locked = true;
        Param_BlockNameTransitTxt: Label 'BLOCKNAMETRANSIT', Locked = true;
        Param_FooterBlockTxt: Label 'FOOTERBLOCK', Locked = true;
        Param_FooterFileTxt: Label 'FOOTERFILE', Locked = true;
        Param_RecIdentifierHandTxt: Label 'RECIDENTIFIERHAND', Locked = true;
        Param_RecIdentifierTranTxt: Label 'RECIDENTIFIERTRAN', Locked = true;
        Param_DefSrcLocTypeTxt: Label 'DEFSRCLOCTYPE', Locked = true;
        Txt: Label 'USERITEMTYPEFILTER', Locked = true;
        DataPrepLbl: Label 'Data Preparation Executed';
        ExportedRecordCountLbl: Label '%1 Records Exported';
        ErrorFoundLbl: Label '%1 not updated to %2 (%3 errors found)';
        UnableToCreateErr: Label 'Unable to create Flow Entry';
        StartPreparingMsg: Label 'Start Preparing Data';
        FieldSeparatorLbl: label ';', Locked = true;
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        MissingParamValueMsg: Label 'Missing value for parameter %1';
        MissingFieldValueTxt: Label 'Missing Value for %1. ';
        MissingFieldValueKeyTxt: Label '%1 is empty in the record %2 where: %3';
        NoPrimaryKeyTxt: Label 'No: %1';
        TransDocumentKeyTxt: Label 'Document No: %1, Line No: %2';
        ScheduledReceptionDateTok: Label 'SCHEDULED_RECEPTION_DATE', Locked = true;

        ExportedRecordCount: Integer;
        FileDateTime: DateTime;

    trigger OnRun()
    begin
        CompanyInformation.Get();
        CountryRegion.Get(CompanyInformation."Country/Region Code");
        CheckIfFieldIsEmpty(
            CountryRegion."MICA Group Code",
            StrSubstNo(MissingFieldValueTxt, ''),
            StrSubstNo(MissingFieldValueKeyTxt, CountryRegion.FieldCaption("MICA Group Code"), CountryRegion.TableCaption(), StrSubstNo(NoPrimaryKeyTxt, CountryRegion.Code)));
        MICAFinancialReportingSetup.Get();
        CheckIfFieldIsEmpty(
            MICAFinancialReportingSetup."Company Code",
            StrSubstNo(MissingFieldValueTxt, ''),
            StrSubstNo(MissingFieldValueKeyTxt, MICAFinancialReportingSetup.FieldCaption("Company Code"), MICAFinancialReportingSetup.TableCaption(), ''));
        ValidItem.FilterGroup(10);
        ValidItem.SetFilter("MICA User Item Type", ParamValue_UserItemTypeFilter);
        ValidItem.FilterGroup(0);

        SetGlobals();
        OnHandsExport(Rec);

        SetGlobals();
        InTransitExport(Rec);
    end;

    local procedure SetGlobals()
    begin
        ExportedRecordCount := 0;
        Clear(TempBlob);
        FileDateTime := CurrentDateTime();
        FileDate := Format(FileDateTime, 14, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>');
    End;

    local procedure InTransitExport(MICAFlow: Record "MICA Flow")
    var
        TempMICAeFDMStockInterfContr: Record "MICA eFDM Stock Interf. Contr." temporary;
        TransferLine: Record "Transfer Line";
        TransferHeader: Record "Transfer Header";
        OutStream: OutStream;
        InStream: InStream;
    begin
        If not MICAFlowEntry.Get(MICAFlow.CreateFlowEntry()) then begin
            MICAFlow.AddInformation(MICAFlowInformation."Info Type"::Error, UnableToCreateErr, '');
            exit;
        end;
        CheckAndRetrieveParameters();
        MICAFlowEntry.Description += '.TXT';
        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StartPreparingMsg, ''));

        TransferHeader.SetFilter("MICA SRD", '<>%1', 0D);
        if TransferHeader.FindSet() then begin
            repeat
                TransferLine.SetRange("Document No.", TransferHeader."No.");
                TransferLine.SetRange("Derived From Line No.", 0);
                //TransferLine.SetRange("Receipt Date", 0D, WorkDate());
                TransferLine.SetFilter("Qty. in Transit (Base)", '<>0');
                if TransferLine.FindSet(false) then
                    repeat
                        GetLocation(TransferLine."Transfer-to Code");
                        if Location."MICA 3PL Location Code" <> '' then begin
                            ValidItem.SetRange("No.", TransferLine."Item No.");
                            if ValidItem.FindFirst() then
                                if TempMICAeFDMStockInterfContr.Get(TransferLine."Item No.", Location."MICA eFDM On Hand Quantity") then begin
                                    TempMICAeFDMStockInterfContr."Qty_InTransit/Qty_OH" += TransferLine."Qty. in Transit (Base)";
                                    TempMICAeFDMStockInterfContr.Modify();
                                end else begin
                                    TempMICAeFDMStockInterfContr.Init();
                                    TempMICAeFDMStockInterfContr."Transfer_To/Inv_Org" := Location."MICA eFDM On Hand Quantity";
                                    TempMICAeFDMStockInterfContr.CAD_Code := TransferLine."Item No.";
                                    TempMICAeFDMStockInterfContr."Qty_InTransit/Qty_OH" := TransferLine."Qty. in Transit (Base)";
                                    TempMICAeFDMStockInterfContr."Receipt Date" := TransferLine."Receipt Date";
                                    TempMICAeFDMStockInterfContr."Inventory Organization" := Location."MICA Inventory Organization";
                                    CheckIfFieldIsEmpty(
                                        Format(TempMICAeFDMStockInterfContr."Receipt Date"),
                                        StrSubstNo(MissingFieldValueTxt, ScheduledReceptionDateTok),
                                        StrSubstNo(
                                            MissingFieldValueKeyTxt,
                                            TransferLine.FieldCaption("Receipt Date"),
                                            TransferLine.TableCaption(), StrSubstNo(TransDocumentKeyTxt, TransferLine."Document No.", TransferLine."Line No.")));
                                    TempMICAeFDMStockInterfContr.Insert();
                                end;
                        end;
                    until TransferLine.Next() = 0;
            until TransferHeader.Next() = 0;

            if TempMICAeFDMStockInterfContr.Findset(false) then begin
                ParamMICAFlowSetup.GetFlowTextParam(MICAFlow.Code, 'LOGICALID');
                TempBlob.CreateOutStream(OutStream);
                OutStream.WriteText(InTransitHeader() + MICAFlow.GetCRLF());
                OutStream.WriteText(InTransitHeaderDataBlock() + MICAFlow.GetCRLF());
                // TempBlob.WriteTextLine(InTransitHeader() + Flow.GetCRLF());
                // TempBlob.WriteTextLine(InTransitHeaderDataBlock() + Flow.GetCRLF());
                repeat
                    OutStream.WriteText(InTransitLineBlock(TempMICAeFDMStockInterfContr) + MICAFlow.GetCRLF());
                    //TempBlob.WriteTextLine(InTransitLineBlock(TempeFDM) + Flow.GetCRLF());
                    ExportedRecordCount += 1;
                until TempMICAeFDMStockInterfContr.Next() = 0;
                OutStream.WriteText(InTransitFooterDataBlock() + MICAFlow.GetCRLF());
                OutStream.WriteText(InTransitFooter());
                // TempBlob.WriteTextLine(InTransitFooterDataBlock() + Flow.GetCRLF());
                // TempBlob.WriteTextLine(InTransitFooter());
            end;
        end;
        // Update Blob with exported data

        clear(OutStream);
        clear(InStream);
        MICAFlowEntry.Blob.CreateOutStream(OutStream);
        TempBlob.CreateInStream(InStream);
        CopyStream(OutStream, InStream);
        MICAFlowEntry.Validate(Blob);
        MICAFlowEntry.Description := StrSubstNo(ParamValue_FileNameTransit, ParamValue_Instance, CountryRegion."ISO Code", MICAFinancialReportingSetup."Company Code", FileDate);
        MICAFlowEntry.Modify(true);

        MICAFlowEntry.CalcFields("Error Count");
        If ExportedRecordCount > 0 then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount));
            MICAFlowEntry.PrepareToSend(); // update last send status on flow entries
        end else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ErrorFoundLbl, MICAFlowEntry.FieldCaption("Send Status"), MICAFlowEntry."Send Status"::Prepared, MICAFlowEntry."Error Count"), '');

        MICAFlowInformation.Update('', '');
    end;

    local procedure InTransitHeader() FormattedText: Text
    var
        FormattedText1Lbl: Label '%1_%2_%3', Comment = '%1%2%3', Locked = true;
    begin
        FormattedText := ParamValue_HeaderFile + FieldSeparatorLbl;
        FormattedText += ParamValue_Application + FieldSeparatorLbl;
        FormattedText += CountryRegion."ISO Code" + FieldSeparatorLbl;
        FormattedText += ParamValue_FlowNameTransit + FieldSeparatorLbl;
        FormattedText += ParamValue_AppMode + FieldSeparatorLbl;
        FormattedText += FileDate + FieldSeparatorLbl;
        FormattedText += StrSubstNo(FormattedText1Lbl, ParamValue_Application, CountryRegion."ISO Code", FileDate) + FieldSeparatorLbl;
        FormattedText += StrSubstNo(FormattedText1Lbl, ParamValue_Application, CountryRegion."ISO Code", MICAFinancialReportingSetup."Company Code") + FieldSeparatorLbl;
        FormattedText += FileDate + FieldSeparatorLbl;
        FormattedText += StrSubstNo(ParamValue_FileNameTransit, ParamValue_Instance, CountryRegion."ISO Code", MICAFinancialReportingSetup."Company Code", FileDate);
    end;

    local procedure InTransitHeaderDataBlock() FormattedText: Text
    begin
        FormattedText := ParamValue_HeaderBlock + FieldSeparatorLbl;
        FormattedText += ParamValue_BlockNameTransit;
    end;

    local procedure InTransitLineBlock(TempMICAeFDMStockInterfContr: Record "MICA eFDM Stock Interf. Contr.") FormattedText: Text
    begin
        FormattedText := ParamValue_RecIdentifierTran + FieldSeparatorLbl;
        FormattedText += Format(FileDateTime, 20, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z') + FieldSeparatorLbl;
        FormattedText += TempMICAeFDMStockInterfContr."Transfer_To/Inv_Org" + FieldSeparatorLbl;
        FormattedText += ParamValue_Application + FieldSeparatorLbl;
        GetItem(TempMICAeFDMStockInterfContr.CAD_Code);
        FormattedText += Item."No." + FieldSeparatorLbl;
        FormattedText += FieldSeparatorLbl; //DC_CODE
        FormattedText += Item."MICA Market Code" + FieldSeparatorLbl;
        FormattedText += CountryRegion."MICA Group Code" + FieldSeparatorLbl;
        FormattedText += ParamValue_DefSrcLocType + FieldSeparatorLbl;
        FormattedText += DelChr(Format(TempMICAeFDMStockInterfContr."Qty_InTransit/Qty_OH", 15, 1), '<') + FieldSeparatorLbl;
        FormattedText += MICAFinancialReportingSetup."Company Code" + FieldSeparatorLbl;
        FormattedText += TempMICAeFDMStockInterfContr."Inventory Organization" + FieldSeparatorLbl;
        FormattedText += Format(CREATEDATETIME(TempMICAeFDMStockInterfContr."Receipt Date", 0T), 20, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z');
    end;

    local procedure InTransitFooterDataBlock() FormattedText: Text
    begin
        FormattedText := ParamValue_FooterBlock + FieldSeparatorLbl;
        FormattedText += ParamValue_BlockNameTransit + FieldSeparatorLbl;
        FormattedText += DelChr(Format(ExportedRecordCount, 15, 1), '<');
    end;

    local procedure InTransitFooter() FormattedText: Text
    begin
        FormattedText := ParamValue_FooterFile + FieldSeparatorLbl;
        FormattedText += DelChr(Format(ExportedRecordCount + 2, 15, 1), '<');
    end;

    //-------------------------------
    local procedure OnHandsExport(MICAFlow: Record "MICA Flow")
    var
        TempMICAeFDMStockInterfContr: Record "MICA eFDM Stock Interf. Contr." temporary;
        ItemLedgerEntry: Record "Item Ledger Entry";
        OutStream: OutStream;
        InStream: InStream;
    begin
        If not MICAFlowEntry.Get(MICAFlow.CreateFlowEntry()) then begin
            MICAFlow.AddInformation(MICAFlowInformation."Info Type"::Error, UnableToCreateErr, '');
            exit;
        end;
        CheckAndRetrieveParameters();
        MICAFlowEntry.Description += '.TXT';
        MICAFlowInformation.Get(MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StartPreparingMsg, ''));

        ItemLedgerEntry.SetRange(Open, true);
        ItemLedgerEntry.SetRange(Positive, true);
        //ILE.SetRange("Posting Date", 0D, WorkDate());
        if ItemLedgerEntry.FindSet(false) then begin
            repeat
                GetLocation(ItemLedgerEntry."Location Code");
                if Location."MICA eFDM On Hand Quantity" <> '' then begin
                    ValidItem.SetRange("No.", ItemLedgerEntry."Item No.");
                    if ValidItem.FindFirst() then
                        if Location."MICA eFDM Blocked Quantity" <> '' then
                            if TempMICAeFDMStockInterfContr.Get(ItemLedgerEntry."Item No.", Location."MICA eFDM Blocked Quantity") then begin
                                TempMICAeFDMStockInterfContr.Qty_Blocked += ItemLedgerEntry."Remaining Quantity";
                                TempMICAeFDMStockInterfContr."Qty_InTransit/Qty_OH" += ItemLedgerEntry."Remaining Quantity";
                                TempMICAeFDMStockInterfContr.Modify();
                            end else begin
                                TempMICAeFDMStockInterfContr.Init();
                                TempMICAeFDMStockInterfContr."Transfer_To/Inv_Org" := Location."MICA eFDM Blocked Quantity";
                                TempMICAeFDMStockInterfContr.Stock_Status := 'ON HAND';
                                TempMICAeFDMStockInterfContr.CAD_Code := ItemLedgerEntry."Item No.";
                                TempMICAeFDMStockInterfContr.Qty_Blocked := ItemLedgerEntry."Remaining Quantity";
                                TempMICAeFDMStockInterfContr."Qty_InTransit/Qty_OH" := ItemLedgerEntry."Remaining Quantity";
                                TempMICAeFDMStockInterfContr."Inventory Organization" := Location."MICA Inventory Organization";
                                TempMICAeFDMStockInterfContr.Insert();
                            end
                        else
                            if TempMICAeFDMStockInterfContr.Get(ItemLedgerEntry."Item No.", Location."MICA eFDM On Hand Quantity") then begin
                                TempMICAeFDMStockInterfContr."Qty_InTransit/Qty_OH" += ItemLedgerEntry."Remaining Quantity";
                                TempMICAeFDMStockInterfContr.Modify();
                            end else begin
                                TempMICAeFDMStockInterfContr.Init();
                                TempMICAeFDMStockInterfContr."Transfer_To/Inv_Org" := Location."MICA eFDM On Hand Quantity";
                                TempMICAeFDMStockInterfContr.Stock_Status := 'ON HAND';
                                TempMICAeFDMStockInterfContr.CAD_Code := ItemLedgerEntry."Item No.";
                                TempMICAeFDMStockInterfContr."Qty_InTransit/Qty_OH" := ItemLedgerEntry."Remaining Quantity";
                                TempMICAeFDMStockInterfContr."Inventory Organization" := Location."MICA Inventory Organization";
                                TempMICAeFDMStockInterfContr.Insert();
                            end;
                end;
            until ItemLedgerEntry.Next() = 0;

            if TempMICAeFDMStockInterfContr.Findset(false) then begin
                TempBlob.CreateOutStream(OutStream);
                OutStream.WriteText(OnHandHeader() + MICAFlow.GetCRLF());
                OutStream.WriteText(OnHandHeaderDataBlock() + MICAFlow.GetCRLF());
                // TempBlob.WriteTextLine(OnHandHeader() + Flow.GetCRLF());
                // TempBlob.WriteTextLine(OnHandHeaderDataBlock() + Flow.GetCRLF());
                repeat
                    OutStream.WriteText(OnHandLineBlock(TempMICAeFDMStockInterfContr) + MICAFlow.GetCRLF());
                    //TempBlob.WriteTextLine(OnHandLineBlock(TempeFDM) + Flow.GetCRLF());
                    ExportedRecordCount += 1;
                until TempMICAeFDMStockInterfContr.Next() = 0;
                OutStream.WriteText(OnHandFooterDataBlock() + MICAFlow.GetCRLF());
                OutStream.WriteText(OnHandFooter());
                // TempBlob.WriteTextLine(OnHandFooterDataBlock() + Flow.GetCRLF());
                // TempBlob.WriteTextLine(OnHandFooter());
            end;
        end;
        // Update Blob with exported data
        clear(OutStream);
        clear(InStream);
        MICAFlowEntry.Blob.CreateOutStream(OutStream);
        TempBlob.CreateInStream(InStream);
        CopyStream(OutStream, InStream);
        MICAFlowEntry.Validate(Blob);
        MICAFlowEntry.Description := StrSubstNo(ParamValue_FileNameOnHand, ParamValue_Instance, CountryRegion."ISO Code", MICAFinancialReportingSetup."Company Code", FileDate);
        MICAFlowEntry.Modify(true);

        MICAFlowEntry.CalcFields("Error Count");
        If ExportedRecordCount > 0 then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, DataPrepLbl, StrSubstNo(ExportedRecordCountLbl, ExportedRecordCount));
            MICAFlowEntry.PrepareToSend(); // update last send status on flow entries
        end else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Information, StrSubstNo(ErrorFoundLbl, MICAFlowEntry.FieldCaption("Send Status"), MICAFlowEntry."Send Status"::Prepared, MICAFlowEntry."Error Count"), '');

        MICAFlowInformation.Update('', '');
    end;

    local procedure OnHandHeaderDataBlock() FormattedText: Text
    begin
        FormattedText := ParamValue_HeaderBlock + FieldSeparatorLbl;
        FormattedText += ParamValue_BlockNameHand;
    end;

    local procedure OnHandHeader() FormattedText: Text
    var
        FormattedText2Lbl: Label '%1_%2_%3', Comment = '%1%2%3', Locked = true;
    begin
        FormattedText := ParamValue_HeaderFile + FieldSeparatorLbl;
        FormattedText += ParamValue_Application + FieldSeparatorLbl;
        FormattedText += CountryRegion."ISO Code" + FieldSeparatorLbl;
        FormattedText += ParamValue_FlowNameHand + FieldSeparatorLbl;
        FormattedText += ParamValue_AppMode + FieldSeparatorLbl;
        FormattedText += FileDate + FieldSeparatorLbl;
        FormattedText += StrSubstNo(FormattedText2Lbl, ParamValue_Application, CountryRegion."ISO Code", FileDate) + FieldSeparatorLbl;
        FormattedText += StrSubstNo(FormattedText2Lbl, ParamValue_Application, CountryRegion."ISO Code", MICAFinancialReportingSetup."Company Code") + FieldSeparatorLbl;
        FormattedText += FileDate + FieldSeparatorLbl;
        FormattedText += StrSubstNo(ParamValue_FileNameOnHand, ParamValue_Instance, CountryRegion."ISO Code", MICAFinancialReportingSetup."Company Code", FileDate);
    end;

    local procedure OnHandLineBlock(TempMICAeFDMStockInterfContr: Record "MICA eFDM Stock Interf. Contr.") FormattedText: Text
    begin
        FormattedText := ParamValue_RecIdentifierHand + FieldSeparatorLbl;
        FormattedText += Format(FileDateTime, 20, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z') + FieldSeparatorLbl;
        FormattedText += ParamValue_Application + FieldSeparatorLbl;
        GetItem(TempMICAeFDMStockInterfContr.CAD_Code);
        FormattedText += Item."No." + FieldSeparatorLbl;
        FormattedText += FieldSeparatorLbl; //DC_CODE
        FormattedText += Item."MICA Market Code" + FieldSeparatorLbl;
        FormattedText += CountryRegion."MICA Group Code" + FieldSeparatorLbl;
        FormattedText += ParamValue_DefSrcLocType + FieldSeparatorLbl;
        FormattedText += DelChr(Format(TempMICAeFDMStockInterfContr."Qty_InTransit/Qty_OH", 15, 1), '<') + FieldSeparatorLbl;
        FormattedText += DelChr(Format(TempMICAeFDMStockInterfContr.Qty_Blocked, 15, 1), '<') + FieldSeparatorLbl;
        FormattedText += TempMICAeFDMStockInterfContr.Stock_Status + FieldSeparatorLbl;
        FormattedText += MICAFinancialReportingSetup."Company Code" + FieldSeparatorLbl;
        FormattedText += TempMICAeFDMStockInterfContr."Inventory Organization";
    end;

    local procedure OnHandFooterDataBlock() FormattedText: Text
    begin
        FormattedText := ParamValue_FooterBlock + FieldSeparatorLbl;
        FormattedText += ParamValue_BlockNameHand + FieldSeparatorLbl;
        FormattedText += DelChr(Format(ExportedRecordCount, 15, 1), '<');
    end;

    local procedure OnHandFooter() FormattedText: Text
    begin
        FormattedText := ParamValue_FooterFile + FieldSeparatorLbl;
        FormattedText += DelChr(Format(ExportedRecordCount + 2, 15, 1), '<');
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if Location.Code <> LocationCode then
            if not Location.Get(LocationCode) then
                Clear(Location);
    end;

    local procedure GetItem(ItemNo: Code[20])
    begin
        if Item."No." <> ItemNo then
            if not Item.Get(ItemNo) then
                Clear(Item);
    end;

    procedure CheckAndRetrieveParameters()
    begin
        CheckPrerequisitesAndRetrieveParameters(Param_FileNameOnHandTxt, ParamValue_FileNameOnHand);
        CheckPrerequisitesAndRetrieveParameters(Param_FileNameTransitTxt, ParamValue_FileNameTransit);
        CheckPrerequisitesAndRetrieveParameters(Param_InstanceTxt, ParamValue_Instance);
        CheckPrerequisitesAndRetrieveParameters(Param_HeaderFileTxt, ParamValue_HeaderFile);
        CheckPrerequisitesAndRetrieveParameters(Param_ApplicationTxt, ParamValue_Application);
        CheckPrerequisitesAndRetrieveParameters(Param_FlowNameHandTxt, ParamValue_FlowNameHand);
        CheckPrerequisitesAndRetrieveParameters(Param_FlowNameTransitTxt, ParamValue_FlowNameTransit);
        CheckPrerequisitesAndRetrieveParameters(Param_AppModeTxt, ParamValue_AppMode);
        CheckPrerequisitesAndRetrieveParameters(Param_HeaderBlockTxt, ParamValue_HeaderBlock);
        CheckPrerequisitesAndRetrieveParameters(Param_BlockNameHandTxt, ParamValue_BlockNameHand);
        CheckPrerequisitesAndRetrieveParameters(Param_BlockNameTransitTxt, ParamValue_BlockNameTransit);
        CheckPrerequisitesAndRetrieveParameters(Param_FooterBlockTxt, ParamValue_FooterBlock);
        CheckPrerequisitesAndRetrieveParameters(Param_FooterFileTxt, ParamValue_FooterFile);
        CheckPrerequisitesAndRetrieveParameters(Param_RecIdentifierHandTxt, ParamValue_RecIdentifierHand);
        CheckPrerequisitesAndRetrieveParameters(Param_RecIdentifierTranTxt, ParamValue_RecIdentifierTran);
        CheckPrerequisitesAndRetrieveParameters(Param_DefSrcLocTypeTxt, ParamValue_DefSrcLocType);
        CheckPrerequisitesAndRetrieveParameters(Txt, ParamValue_UserItemTypeFilter);
    end;

    procedure CheckPrerequisitesAndRetrieveParameters(Param: Text[20]; var ParamValue: Text)
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist(MICAFlowEntry."Flow Code", Param) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '');
            exit;
        end;

        ParamValue := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param);
        if ParamValue = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamValueMsg, Param), '');
    end;

    local procedure CheckIfFieldIsEmpty(FieldValue: Text; Description: Text; Description2: Text)
    begin
        if FieldValue = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, Description, Description2);
    end;
}