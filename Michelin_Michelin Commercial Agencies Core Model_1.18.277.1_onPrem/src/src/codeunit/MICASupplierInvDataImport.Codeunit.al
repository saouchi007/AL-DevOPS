codeunit 82026 "MICA Supplier Inv. Data Import"
{
    var
        MICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.";
        MICAFlowEntry: Record "MICA Flow Entry";
        MICAFlowInformation: Record "MICA Flow Information";
        ParamMICAFlowSetup: Record "MICA Flow Setup";
        xmlDoc: XmlDocument;
        InStream: InStream;
        ImportedRecordCount: Integer;
        XPath_Verb: Text;
        XPath_Noun: Text;
        XPath_Revision: Text;
        XPath_LogicalId: Text;
        XPath_Component: Text;
        XPath_Task: Text;
        XPath_ReferenceId: Text;
        XPath_Confirmation: Text;
        XPath_Language: Text;
        XPath_Codepage: Text;
        XPath_AuthId: Text;
        XPath_Year: Text;
        XPath_Month: Text;
        XPath_Day: Text;
        XPath_MICHRelfactcode: Text;
        XPath_MICHShipnumber: Text;
        XPath_Currency: Text;
        XPath_DocumentType: Text;
        XPath_TermId: Text;
        XPath_YearHdr: Text;
        XPath_MonthHdr: Text;
        XPath_DayHdr: Text;
        XPath_DocumentId: Text;
        XPath_MICHOrigInvNum: Text;
        XPath_MICHOrigInvDate: Text;
        XPath_DocumentIdRebill: Text;
        XPath_Attribute1: Text;
        XPath_Descriptn: Text;
        XPath_MICHAttribute1: Text;
        XPath_Attribute1DCN: Text;
        XPath_Value: Text;
        XPath_Items: Text;
        XPath_Charges: Text;
        XPath_ChargeType: Text;
        XPath_LineNum: Text;
        XPath_LineNumFreightLine: Text;
        XPath_QualifierTax: Text;
        XPath_LineNumTax: Text;
        XPath_ValueTaxQty: Text;
        XPath_TaxCode: Text;
        XPath_ValueTaxAmount: Text;
        XPath_ValueQty: Text;
        XPath_ValueOperAmount: Text;
        XPath_Item: Text;
        XPath_DescriptnLine: Text;
        XPath_ValueAmount: Text;
        XPath_ValueChargeAmount: Text;
        XPath_Unit: Text;
        XPath_MICHDestCountryCode: Text;
        XPath_MICHCountryOrig: Text;
        XPath_MICHDestRegion: Text;
        XPath_MICHDeliverTerms: Text;
        XPath_MICHTrxCodeNature: Text;
        XPath_MICHCommodityCode: Text;
        XPath_MICHNetMass: Text;
        XPath_MICHSupplementUnits: Text;
        XPath_MICHTransportMode: Text;
        XPath_MICHLoadingPort: Text;
        XPath_MICHStatisticProced: Text;
        XPath_MICHStatisticValue: Text;
        XPath_MICHLineAttribute3: Text;
        XPath_MICHContainerNum: Text;
        XPath_SchlineNum: Text;
        XPath_ShipToCountry: Text;
        XPath_ShipToDescription: Text;
        XPath_ShipToPartnerID: Text;
        XPath_ShipToName: Text;
        XPath_BillToCountry: Text;
        XPath_BillToDescription: Text;
        XPath_BillToPartnerID: Text;
        XPath_BillToName: Text;
        XPath_SupplierCountry: Text;
        XPath_SupplierDescription: Text;
        XPath_SupplierPartnerID: Text;
        XPath_SupplierName: Text;
        XPath_LineDocType1: Text;
        XPath_LineDocType2: Text;
        XPath_LineDocType3: Text;
        XPath_DocumentId1: Text;
        XPath_DocumentId2: Text;
        XPath_DocumentId3: Text;
        XPath_LineNum1: Text;
        XPath_LineNum2: Text;
        XPath_LineNum3: Text;
        XPath_NUMOFDEC_TotalAmount: Text;
        XPath_SIGN_TotalAmount: Text;
        XPath_DRCR_TotalAmount: Text;
        XPath_NUMOFDEC_Qty: Text;
        XPath_SIGN_Qty: Text;
        XPath_NUMOFDEC_OperAmt: Text;
        XPath_SIGN_OperAmt: Text;
        XPath_NUMOFDEC_LineAmount: Text;
        XPath_SIGN_LineAmount: Text;
        XPath_DRCR_LineAmount: Text;
        XPath_NUMOFDEC_LineChargeAmount: Text;
        XPath_SIGN_LineChargeAmount: Text;
        XPath_DRCR_LineChargeAmount: Text;
        Param_VerbLbl: Label 'VERB', Locked = true;
        Param_NounLbl: Label 'NOUN', Locked = true;
        Param_RevisionLbl: Label 'REVISION', Locked = true;
        Param_LogicalIdLbl: Label 'LOGICALID', Locked = true;
        Param_ComponentLbl: Label 'COMPONENT', Locked = true;
        Param_TaskLbl: Label 'TASK', Locked = true;
        Param_ReferenceIdLbl: Label 'REFERENCEID', Locked = true;
        Param_ConfirmationLbl: Label 'CONFIRMATION', Locked = true;
        Param_LanguageLbl: Label 'LANGUAGE', Locked = true;
        Param_CodepageLbl: Label 'CODEPAGE', Locked = true;
        Param_AuthIdLbl: Label 'AUTHID', Locked = true;
        Param_YearLbl: Label 'YEAR', Locked = true;
        Param_MonthLbl: Label 'MONTH', Locked = true;
        Param_DayLbl: Label 'DAY', Locked = true;
        Param_MICHRelfactcodeLbl: Label 'MICHRELFACTCODE', Locked = true;
        Param_MICHShipnumberLbl: Label 'MICHSHIPNUMBER', Locked = true;
        Param_CurrencyLbl: Label 'CURRENCY', Locked = true;
        Param_DocumentTypeLbl: Label 'DOCTYPE', Locked = true;
        Param_TermIdLbl: Label 'TERMID', Locked = true;
        Param_YearHdrLbl: Label 'YEARHDR', Locked = true;
        Param_MonthHdrLbl: Label 'MONTHHDR', Locked = true;
        Param_DayHdrLbl: Label 'DAYHDR', Locked = true;
        Param_DocumentIdLbl: Label 'DOCUMENTID', Locked = true;
        Param_MICHOrigInvNumLbl: Label 'MICHORIGINVNUM', Locked = true;
        Param_MICHOrigInvDateLbl: Label 'MICHORIGINVDATE', Locked = true;
        Param_DocumentIdRebillLbl: Label 'DOCUMENTIDREBILL', Locked = true;
        Param_Attribute1Lbl: Label 'ATTRIBUTE1', Locked = true;
        Param_DescriptnLbl: Label 'DESCRIPTN', Locked = true;
        Param_MICHAttribute1Lbl: Label 'MICHATTRIBUTE1', Locked = true;
        Param_Attribute1DCNLbl: Label 'ATTRIBUTE1DCN', Locked = true;
        Param_ValueLbl: Label 'VALUE', Locked = true;
        Param_ItemsLbl: Label 'ITEMS', Locked = true;
        Param_ChargesLbl: Label 'CHARGES', Locked = true;
        Param_ChargeTypeLbl: Label 'CHARGETYPE', Locked = true;
        Param_LineNumLbl: Label 'LINENUM', Locked = true;
        Param_LineNumFreightLineLbl: Label 'LINENUMFREIGHTLINE', Locked = true;
        Param_QualifierTaxLbl: Label 'QUALIFIERTAX', Locked = true;
        Param_LineNumTaxLbl: Label 'LINENUMTAX', Locked = true;
        Param_ValueTaxQtyLbl: Label 'VALUETAXQTY', Locked = true;
        Param_TaxCodeLbl: Label 'TAXCODE', Locked = true;
        Param_ValueTaxAmountLbl: Label 'VALUETAXAMOUNT', Locked = true;
        Param_ValueQtyLbl: Label 'VALUEQTY', Locked = true;
        Param_ValueOperAmountLbl: Label 'VALUEOPERAMOUNT', Locked = true;
        Param_ItemLbl: Label 'ITEM', Locked = true;
        Param_DescriptnLineLbl: Label 'DESCRIPTNLINE', Locked = true;
        Param_ValueAmountLbl: Label 'VALUEAMOUNT', Locked = true;
        Param_ValueChargeAmountLbl: Label 'VALUECHARGEAMOUNT', Locked = true;
        Param_UnitLbl: Label 'UNIT', Locked = true;
        Param_MICHDestCountryCodeLbl: Label 'MICHDESTCOUNTRYCODE', Locked = true;
        Param_MICHCountryOrigLbl: Label 'MICHCOUNTRYORIG', Locked = true;
        Param_MICHDestRegionLbl: Label 'MICHDESTREGION', Locked = true;
        Param_MICHDeliverTermsLbl: Label 'MICHDELIVERTERMS', Locked = true;
        Param_MICHTrxCodeNatureLbl: Label 'MICHTRXCODENATURE', Locked = true;
        Param_MICHCommodityCodeLbl: Label 'MICHCOMMODITYCODE', Locked = true;
        Param_MICHNetMassLbl: Label 'MICHNETMASS', Locked = true;
        Param_MICHSupplementUnitsLbl: Label 'MICHSUPPLEMENTUNITS', Locked = true;
        Param_MICHTransportModeLbl: Label 'MICHTRANSPORTMODE', Locked = true;
        Param_MICHLoadingPortLbl: Label 'MICHLOADINGPORT', Locked = true;
        Param_MICHStatisticProcedLbl: Label 'MICHSTATISTICPROCED', Locked = true;
        Param_MICHStatisticValueLbl: Label 'MICHSTATISTICVALUE', Locked = true;
        Param_MICHLineAttribute3Lbl: Label 'MICHLINEATTRIBUTE3', Locked = true;
        Param_MICHContainerNumLbl: Label 'MICHCONTAINERNUM', Locked = true;
        Param_SchlineNumLbl: Label 'SCHLINENUM', Locked = true;
        Param_ShipToPartnerIDLbl: Label 'SHIPTOPARTNERID', Locked = true;
        Param_ShipToCountryLbl: Label 'SHIPTOCOUNTRY', Locked = true;
        Param_ShipToDescriptionLbl: Label 'SHIPTODESC', Locked = true;
        Param_ShipToNameLbl: Label 'SHIPTONAME', Locked = true;
        Param_BillToPartnerIDLbl: Label 'BILLTOPARTNERID', Locked = true;
        Param_BillToCountryLbl: Label 'BILLTOCOUNTRY', Locked = true;
        Param_BillToDescriptionLbl: Label 'BILLTODESC', Locked = true;
        Param_BillToNameLbl: Label 'BILLTONAME', Locked = true;
        Param_SupplierPartnerIDLbl: Label 'SUPPLIERPARTNERID', Locked = true;
        Param_SupplierCountryLbl: Label 'SUPPLIERCOUNTRY', Locked = true;
        Param_SupplierDescriptionLbl: Label 'SUPPLIERDESC', Locked = true;
        Param_SupplierNameLbl: Label 'SUPPLIERNAME', Locked = true;
        Param_LineDocType1Lbl: Label 'LINETYPE', Locked = true;
        Param_LineDocType2Lbl: Label 'ALTYPE', Locked = true;
        Param_LineDocType3Lbl: Label 'PURCHASEORDERTYPE', Locked = true;
        Param_DocumentId1Lbl: Label 'DOCIDLINE', Locked = true;
        Param_DocumentId2Lbl: Label 'DOCIDAL', Locked = true;
        Param_DocumentId3Lbl: Label 'DOCIDPURCHASEORDER', Locked = true;
        Param_LineNum1Lbl: Label 'LINENUMLINE', Locked = true;
        Param_LineNum2Lbl: Label 'LINENUMAL', Locked = true;
        Param_LineNum3Lbl: Label 'LINENUMPURCHASEORDER', Locked = true;
        Param_NUMOFDEC_TotalAmountLbl: Label 'NUMOFDECTOTALAMOUNT', Locked = true;
        Param_SIGN_TotalAmountLbl: Label 'SIGNTOTALAMOUNT', Locked = true;
        Param_DRCR_TotalAmountLbl: Label 'DRCRTOTALAMOUNT', Locked = true;
        Param_NUMOFDEC_QtyLbl: Label 'NUMOFDECQTY', Locked = true;
        Param_SIGN_QtyLbl: Label 'SIGNQTY', Locked = true;
        Param_NUMOFDEC_OperAmtLbl: Label 'NUMOFDECOPERAMT', Locked = true;
        Param_SIGN_OperAmtLbl: Label 'SIGNOPERAMT', Locked = true;
        Param_NUMOFDEC_LineAmountLbl: Label 'NUMOFDECLINEAMOUNT', Locked = true;
        Param_SIGN_LineAmountLbl: Label 'SIGNLINEAMOUNT', Locked = true;
        Param_DRCR_LineAmountLbl: Label 'DRCRLINEAMOUNT', Locked = true;
        Param_NUMOFDEC_LineChargeAmountLbl: Label 'NUMOFDECLINECHARGEAM', Locked = true;
        Param_SIGN_LineChargeAmountLbl: Label 'SIGNLINECHARGEAMOUNT', Locked = true;
        Param_DRCR_LineChargeAmountLbl: Label 'DRCRLINECHARGEAMOUNT', Locked = true;
        MissingParamMsg: Label 'Missing parameter %1 in Flow Parameters';
        MissingXPathMsg: Label 'Missing XPath for parameter %1';
        MissingNodeMsg: Label 'Node not found (Flow parameter: %1, XPath: %2)';
        MissingNodeValueMsg: Label 'Node has no value (Flow parameter: %1, XPath: %2)';

    trigger OnRun()
    begin
        LoadData();

    end;

    local procedure LoadData()
    begin
        XmlDocument.ReadFrom(InStream, xmlDoc);

        CheckAndRetrieveParameters();

        PopulateTechniqueFields();
        PopulateHeaderFields();
        PopulateLineFieldsAndInsertSupplierBuffer();

    end;

    local procedure CheckAndRetrieveParameters()
    begin
        // technical nodes
        CheckPrerequisitesAndRetrieveParameters(Param_VerbLbl, XPath_Verb);
        CheckPrerequisitesAndRetrieveParameters(Param_NounLbl, XPath_Noun);
        CheckPrerequisitesAndRetrieveParameters(Param_RevisionLbl, XPath_Revision);
        CheckPrerequisitesAndRetrieveParameters(Param_LogicalIdLbl, XPath_LogicalId);
        CheckPrerequisitesAndRetrieveParameters(Param_ComponentLbl, XPath_Component);
        CheckPrerequisitesAndRetrieveParameters(Param_TaskLbl, XPath_Task);
        CheckPrerequisitesAndRetrieveParameters(Param_ReferenceIdLbl, XPath_ReferenceId);
        CheckPrerequisitesAndRetrieveParameters(Param_ConfirmationLbl, XPath_Confirmation);
        CheckPrerequisitesAndRetrieveParameters(Param_LanguageLbl, XPath_Language);
        CheckPrerequisitesAndRetrieveParameters(Param_CodepageLbl, XPath_Codepage);
        CheckPrerequisitesAndRetrieveParameters(Param_AuthIdLbl, XPath_AuthId);
        CheckPrerequisitesAndRetrieveParameters(Param_YearLbl, XPath_Year);
        CheckPrerequisitesAndRetrieveParameters(Param_MonthLbl, XPath_Month);
        CheckPrerequisitesAndRetrieveParameters(Param_DayLbl, XPath_Day);

        // header's nodes        
        CheckPrerequisitesAndRetrieveParameters(Param_MICHRelfactcodeLbl, XPath_MICHRelfactcode);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHShipnumberLbl, XPath_MICHShipnumber);
        CheckPrerequisitesAndRetrieveParameters(Param_ShipToCountryLbl, XPath_ShipToCountry);
        CheckPrerequisitesAndRetrieveParameters(Param_ShipToDescriptionLbl, XPath_ShipToDescription);
        CheckPrerequisitesAndRetrieveParameters(Param_ShipToNameLbl, XPath_ShipToName);
        CheckPrerequisitesAndRetrieveParameters(Param_ShipToPartnerIDLbl, XPath_ShipToPartnerID);
        CheckPrerequisitesAndRetrieveParameters(Param_BillToCountryLbl, XPath_BillToCountry);
        CheckPrerequisitesAndRetrieveParameters(Param_BillToDescriptionLbl, XPath_BillToDescription);
        CheckPrerequisitesAndRetrieveParameters(Param_BillToNameLbl, XPath_BillToName);
        CheckPrerequisitesAndRetrieveParameters(Param_BillToPartnerIDLbl, XPath_BillToPartnerID);
        CheckPrerequisitesAndRetrieveParameters(Param_SupplierCountryLbl, XPath_SupplierCountry);
        CheckPrerequisitesAndRetrieveParameters(Param_SupplierDescriptionLbl, XPath_SupplierDescription);
        CheckPrerequisitesAndRetrieveParameters(Param_SupplierNameLbl, XPath_SupplierName);
        CheckPrerequisitesAndRetrieveParameters(Param_SupplierPartnerIDLbl, XPath_SupplierPartnerID);
        CheckPrerequisitesAndRetrieveParameters(Param_CurrencyLbl, XPath_Currency);
        CheckPrerequisitesAndRetrieveParameters(Param_DocumentTypeLbl, XPath_DocumentType); // invoice, rebill, credit memo        
        CheckPrerequisitesAndRetrieveParameters(Param_TermIdLbl, XPath_TermId);
        CheckPrerequisitesAndRetrieveParameters(Param_YearHdrLbl, XPath_YearHdr);
        CheckPrerequisitesAndRetrieveParameters(Param_MonthHdrLbl, XPath_MonthHdr);
        CheckPrerequisitesAndRetrieveParameters(Param_DayHdrLbl, XPath_DayHdr);
        CheckPrerequisitesAndRetrieveParameters(Param_DocumentIdLbl, XPath_DocumentId); // vendor invoice no.        
        CheckPrerequisitesAndRetrieveParameters(Param_MICHOrigInvNumLbl, XPath_MICHOrigInvNum);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHOrigInvDateLbl, XPath_MICHOrigInvDate);
        CheckPrerequisitesAndRetrieveParameters(Param_DocumentIdRebillLbl, XPath_DocumentIdRebill); // reason rebill code        
        CheckPrerequisitesAndRetrieveParameters(Param_Attribute1Lbl, XPath_Attribute1);
        CheckPrerequisitesAndRetrieveParameters(Param_DescriptnLbl, XPath_Descriptn);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHAttribute1Lbl, XPath_MICHAttribute1);
        CheckPrerequisitesAndRetrieveParameters(Param_Attribute1DCNLbl, XPath_Attribute1DCN);
        CheckPrerequisitesAndRetrieveParameters(Param_ValueLbl, XPath_Value);
        CheckPrerequisitesAndRetrieveParameters(Param_NUMOFDEC_TotalAmountLbl, XPath_NUMOFDEC_TotalAmount);
        CheckPrerequisitesAndRetrieveParameters(Param_SIGN_TotalAmountLbl, XPath_SIGN_TotalAmount);
        CheckPrerequisitesAndRetrieveParameters(Param_DRCR_TotalAmountLbl, XPath_DRCR_TotalAmount);

        // line's nodes
        CheckPrerequisitesAndRetrieveParameters(Param_ItemsLbl, XPath_Items);
        CheckPrerequisitesAndRetrieveParameters(Param_ChargesLbl, XPath_Charges);
        CheckPrerequisitesAndRetrieveParameters(Param_LineDocType1Lbl, XPath_LineDocType1);
        CheckPrerequisitesAndRetrieveParameters(Param_DocumentId1Lbl, XPath_DocumentId1); // al no
        CheckPrerequisitesAndRetrieveParameters(Param_LineNum1Lbl, XPath_LineNum1); // al line no
        CheckPrerequisitesAndRetrieveParameters(Param_LineDocType2Lbl, XPath_LineDocType2);
        CheckPrerequisitesAndRetrieveParameters(Param_DocumentId2Lbl, XPath_DocumentId2);
        CheckPrerequisitesAndRetrieveParameters(Param_LineNum2Lbl, XPath_LineNum2);
        CheckPrerequisitesAndRetrieveParameters(Param_LineDocType3Lbl, XPath_LineDocType3);
        CheckPrerequisitesAndRetrieveParameters(Param_DocumentId3Lbl, XPath_DocumentId3);
        CheckPrerequisitesAndRetrieveParameters(Param_LineNum3Lbl, XPath_LineNum3);
        CheckPrerequisitesAndRetrieveParameters(Param_LineNumLbl, XPath_LineNum);
        CheckPrerequisitesAndRetrieveParameters(Param_ChargeTypeLbl, XPath_ChargeType);
        CheckPrerequisitesAndRetrieveParameters(Param_LineNumFreightLineLbl, XPath_LineNumFreightLine);
        CheckPrerequisitesAndRetrieveParameters(Param_QualifierTaxLbl, XPath_QualifierTax);
        CheckPrerequisitesAndRetrieveParameters(Param_LineNumTaxLbl, XPath_LineNumTax);
        CheckPrerequisitesAndRetrieveParameters(Param_ValueTaxQtyLbl, XPath_ValueTaxQty);
        CheckPrerequisitesAndRetrieveParameters(Param_TaxCodeLbl, XPath_TaxCode);
        CheckPrerequisitesAndRetrieveParameters(Param_ValueTaxAmountLbl, XPath_ValueTaxAmount);
        CheckPrerequisitesAndRetrieveParameters(Param_ValueQtyLbl, XPath_ValueQty);
        CheckPrerequisitesAndRetrieveParameters(Param_ValueOperAmountLbl, XPath_ValueOperAmount);
        CheckPrerequisitesAndRetrieveParameters(Param_ItemLbl, XPath_Item);
        CheckPrerequisitesAndRetrieveParameters(Param_DescriptnLineLbl, XPath_DescriptnLine);
        CheckPrerequisitesAndRetrieveParameters(Param_ValueAmountLbl, XPath_ValueAmount);
        CheckPrerequisitesAndRetrieveParameters(Param_ValueChargeAmountLbl, XPath_ValueChargeAmount);
        CheckPrerequisitesAndRetrieveParameters(Param_UnitLbl, XPath_Unit);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHDestCountryCodeLbl, XPath_MICHDestCountryCode);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHCountryOrigLbl, XPath_MICHCountryOrig);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHDestRegionLbl, XPath_MICHDestRegion);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHDeliverTermsLbl, XPath_MICHDeliverTerms);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHTrxCodeNatureLbl, XPath_MICHTrxCodeNature);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHCommodityCodeLbl, XPath_MICHCommodityCode);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHNetMassLbl, XPath_MICHNetMass);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHSupplementUnitsLbl, XPath_MICHSupplementUnits);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHTransportModeLbl, XPath_MICHTransportMode);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHLoadingPortLbl, XPath_MICHLoadingPort);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHStatisticProcedLbl, XPath_MICHStatisticProced);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHStatisticValueLbl, XPath_MICHStatisticValue);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHLineAttribute3Lbl, XPath_MICHLineAttribute3);
        CheckPrerequisitesAndRetrieveParameters(Param_MICHContainerNumLbl, XPath_MICHContainerNum);
        CheckPrerequisitesAndRetrieveParameters(Param_SchlineNumLbl, XPath_SchlineNum);
        CheckPrerequisitesAndRetrieveParameters(Param_NUMOFDEC_QtyLbl, XPath_NUMOFDEC_Qty);
        CheckPrerequisitesAndRetrieveParameters(Param_SIGN_QtyLbl, XPath_SIGN_Qty);
        CheckPrerequisitesAndRetrieveParameters(Param_NUMOFDEC_OperAmtLbl, XPath_NUMOFDEC_OperAmt);
        CheckPrerequisitesAndRetrieveParameters(Param_SIGN_OperAmtLbl, XPath_SIGN_OperAmt);
        CheckPrerequisitesAndRetrieveParameters(Param_NUMOFDEC_LineAmountLbl, XPath_NUMOFDEC_LineAmount);
        CheckPrerequisitesAndRetrieveParameters(Param_SIGN_LineAmountLbl, XPath_SIGN_LineAmount);
        CheckPrerequisitesAndRetrieveParameters(Param_DRCR_LineAmountLbl, XPath_DRCR_LineAmount);
        CheckPrerequisitesAndRetrieveParameters(Param_NUMOFDEC_LineChargeAmountLbl, XPath_NUMOFDEC_LineChargeAmount);
        CheckPrerequisitesAndRetrieveParameters(Param_SIGN_LineChargeAmountLbl, XPath_SIGN_LineChargeAmount);
        CheckPrerequisitesAndRetrieveParameters(Param_DRCR_LineChargeAmountLbl, XPath_DRCR_LineChargeAmount);

    end;

    local procedure PopulateHeaderFields()
    var
        numberDef: array[3] of Text[1];
    begin
        // mandatory
        MICAFlowBufferSupplierInv.RELFACTCODE := CopyStr(GetNodeValue(Param_MICHRelfactcodeLbl, XPath_MICHRelfactcode, true), 1, MaxStrLen(MICAFlowBufferSupplierInv.RELFACTCODE));
        MICAFlowBufferSupplierInv.SHIPNUMBER := CopyStr(GetNodeValue(Param_MICHShipnumberLbl, XPath_MICHShipnumber, true), 1, MaxStrLen(MICAFlowBufferSupplierInv.SHIPNUMBER));
        MICAFlowBufferSupplierInv."ShipTo PARTNERID" := CopyStr(GetNodeValue(Param_ShipToPartnerIDLbl, XPath_ShipToPartnerID, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."ShipTo PARTNERID"));
        MICAFlowBufferSupplierInv."ShipTo COUNTRY" := CopyStr(GetNodeValue(Param_ShipToCountryLbl, XPath_ShipToCountry, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."ShipTo COUNTRY"));
        MICAFlowBufferSupplierInv."ShipTo Descriptn" := CopyStr(GetNodeValue(Param_ShipToDescriptionLbl, XPath_ShipToDescription, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."ShipTo Descriptn"));
        MICAFlowBufferSupplierInv."ShipTo NAME" := CopyStr(GetNodeValue(Param_ShipToNameLbl, XPath_ShipToName, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."ShipTo NAME"));
        MICAFlowBufferSupplierInv."BillTo PARTNERID" := CopyStr(GetNodeValue(Param_BillToPartnerIDLbl, XPath_BillToPartnerID, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."BillTo PARTNERID"));
        MICAFlowBufferSupplierInv."BillTo COUNTRY" := CopyStr(GetNodeValue(Param_BillToCountryLbl, XPath_BillToCountry, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."BillTo COUNTRY"));
        MICAFlowBufferSupplierInv."BillTo Descriptn" := CopyStr(GetNodeValue(Param_BillToDescriptionLbl, XPath_BillToDescription, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."BillTo Descriptn"));
        MICAFlowBufferSupplierInv."BillTo NAME" := CopyStr(GetNodeValue(Param_BillToNameLbl, XPath_BillToName, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."BillTo NAME"));
        MICAFlowBufferSupplierInv."Supplier PARTNERID" := CopyStr(GetNodeValue(Param_SupplierPartnerIDLbl, XPath_SupplierPartnerID, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Supplier PARTNERID"));
        MICAFlowBufferSupplierInv."Supplier COUNTRY" := CopyStr(GetNodeValue(Param_SupplierCountryLbl, XPath_SupplierCountry, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Supplier COUNTRY"));
        MICAFlowBufferSupplierInv."Supplier Descriptn" := CopyStr(GetNodeValue(Param_SupplierDescriptionLbl, XPath_SupplierDescription, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Supplier Descriptn"));
        MICAFlowBufferSupplierInv."Supplier NAME" := CopyStr(GetNodeValue(Param_SupplierNameLbl, XPath_SupplierName, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Supplier NAME"));
        MICAFlowBufferSupplierInv.CURRENCY := CopyStr(GetNodeValue(Param_CurrencyLbl, XPath_Currency, true), 1, MaxStrLen(MICAFlowBufferSupplierInv.CURRENCY));
        MICAFlowBufferSupplierInv.DOCTYPE := CopyStr(GetNodeValue(Param_DocumentTypeLbl, XPath_DocumentType, true), 1, MaxStrLen(MICAFlowBufferSupplierInv.DOCTYPE)); // invoice, rebill, credit memoDOCTYPE);
        MICAFlowBufferSupplierInv.TERMID := CopyStr(GetNodeValue(Param_TermIdLbl, XPath_TermId, true), 1, MaxStrLen(MICAFlowBufferSupplierInv.TERMID));
        MICAFlowBufferSupplierInv.YEAR := CopyStr(GetNodeValue(Param_YearHdrLbl, XPath_YearHdr, true), 1, MaxStrLen(MICAFlowBufferSupplierInv.YEAR));
        MICAFlowBufferSupplierInv.MONTH := CopyStr(GetNodeValue(Param_MonthHdrLbl, XPath_MonthHdr, true), 1, MaxStrLen(MICAFlowBufferSupplierInv.MONTH));
        MICAFlowBufferSupplierInv.DAY := CopyStr(GetNodeValue(Param_DayHdrLbl, XPath_DayHdr, true), 1, MaxStrLen(MICAFlowBufferSupplierInv.DAY));
        MICAFlowBufferSupplierInv.DOCUMENTID := CopyStr(GetNodeValue(Param_DocumentIdLbl, XPath_DocumentId, true), 1, MaxStrLen(MICAFlowBufferSupplierInv.DOCUMENTID)); // vendor invoice no.DOCUMENTID);        
        MICAFlowBufferSupplierInv."Vendor Invoice No." := MICAFlowBufferSupplierInv.DOCUMENTID;
        MICAFlowBufferSupplierInv."ShipTo Descriptn" := CopyStr(GetNodeValue(Param_DescriptnLbl, XPath_Descriptn, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."ShipTo Descriptn"));
        MICAFlowBufferSupplierInv."MICH.ATTRIBUTE1" := CopyStr(GetNodeValue(Param_MICHAttribute1Lbl, XPath_MICHAttribute1, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."MICH.ATTRIBUTE1"));
        MICAFlowBufferSupplierInv."Total Amount RAW" := CopyStr(GetNodeValue(Param_ValueLbl, XPath_Value, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Total Amount RAW"));
        numberDef[1] := CopyStr(GetNodeValue(Param_NUMOFDEC_TotalAmountLbl, XPath_NUMOFDEC_TotalAmount, true), 1, 1);
        numberDef[2] := CopyStr(GetNodeValue(Param_SIGN_TotalAmountLbl, XPath_SIGN_TotalAmount, true), 1, 1);
        numberDef[3] := CopyStr(GetNodeValue(Param_DRCR_TotalAmountLbl, XPath_DRCR_TotalAmount, true), 1, 1);
        BuildDecimal(MICAFlowBufferSupplierInv."Total Amount RAW", numberDef[1], numberDef[2], numberDef[3]);

        // optional
        MICAFlowBufferSupplierInv."MICH.ORIGINVNUM" := CopyStr(GetNodeValue(Param_MICHOrigInvNumLbl, XPath_MICHOrigInvNum, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."MICH.ORIGINVNUM"));
        MICAFlowBufferSupplierInv."MICH.ORIGINVDATE" := CopyStr(GetNodeValue(Param_MICHOrigInvDateLbl, XPath_MICHOrigInvDate, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."MICH.ORIGINVDATE"));
        MICAFlowBufferSupplierInv."DocRef Document Type" := CopyStr(GetNodeValue(Param_DocumentIdRebillLbl, XPath_DocumentIdRebill, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."DocRef Document Type")); // reason rebill code
        MICAFlowBufferSupplierInv.ATTRIBUTE1 := CopyStr(GetNodeValue(Param_Attribute1Lbl, XPath_Attribute1, false), 1, MaxStrLen(MICAFlowBufferSupplierInv.ATTRIBUTE1));

    end;

    local procedure PopulateLineFieldsAndInsertSupplierBuffer()
    var
        xmlNodeItemList: XmlNodeList;
        xmlNodeChargeList: XmlNodeList;
        xmlNodeItem: XmlNode;
        xmlNodeCharge: XmlNode;
        numberDef: array[3] of Text[1];
    begin
        if xmlDoc.SelectNodes(XPath_Items, xmlNodeItemList) then
            foreach xmlNodeItem in xmlNodeItemList do begin
                MICAFlowBufferSupplierInv."Line No." := CopyStr(GetNodeValue(xmlNodeItem, Param_LineNumLbl, XPath_LineNum, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line No."));
                MICAFlowBufferSupplierInv."Line DOCTYPE1" := CopyStr(GetNodeValue(xmlNodeItem, Param_LineDocType1Lbl, XPath_LineDocType1, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line DOCTYPE1"));
                MICAFlowBufferSupplierInv."Line DocumentID1" := CopyStr(GetNodeValue(xmlNodeItem, Param_DocumentId1Lbl, XPath_DocumentId1, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line DocumentID1"));
                MICAFlowBufferSupplierInv."Line Linenum1" := CopyStr(GetNodeValue(xmlNodeItem, Param_LineNum1Lbl, XPath_LineNum1, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line Linenum1"));
                MICAFlowBufferSupplierInv."Line DOCTYPE2" := CopyStr(GetNodeValue(xmlNodeItem, Param_LineDocType2Lbl, XPath_LineDocType2, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line DOCTYPE2"));
                MICAFlowBufferSupplierInv."Line DocumentID2" := CopyStr(GetNodeValue(xmlNodeItem, Param_DocumentId2Lbl, XPath_DocumentId2, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line DocumentID2"));
                MICAFlowBufferSupplierInv."Line Linenum2" := CopyStr(GetNodeValue(xmlNodeItem, Param_LineNum2Lbl, XPath_LineNum2, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line Linenum2"));
                MICAFlowBufferSupplierInv."Line DOCTYPE3" := CopyStr(GetNodeValue(xmlNodeItem, Param_LineDocType3Lbl, XPath_LineDocType3, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line DOCTYPE3"));
                MICAFlowBufferSupplierInv."Line DocumentID3" := CopyStr(GetNodeValue(xmlNodeItem, Param_DocumentId3Lbl, XPath_DocumentId3, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line DocumentID3"));
                MICAFlowBufferSupplierInv."Line Linenum3" := CopyStr(GetNodeValue(xmlNodeItem, Param_LineNum3Lbl, XPath_LineNum3, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line Linenum3"));
                MICAFlowBufferSupplierInv."Line Quantity Raw" := CopyStr(GetNodeValue(xmlNodeItem, Param_ValueQtyLbl, XPath_ValueQty, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line Quantity Raw"));
                numberDef[1] := CopyStr(GetNodeValue(xmlNodeItem, Param_NUMOFDEC_QtyLbl, XPath_NUMOFDEC_Qty, true), 1, 1);
                numberDef[2] := CopyStr(GetNodeValue(xmlNodeItem, Param_SIGN_QtyLbl, XPath_SIGN_Qty, true), 1, 1);
                BuildDecimal(MICAFlowBufferSupplierInv."Line Quantity RAW", numberDef[1], numberDef[2], '');
                Clear(numberDef);
                MICAFlowBufferSupplierInv."Line OPERAMT Raw" := CopyStr(GetNodeValue(xmlNodeItem, Param_ValueOperAmountLbl, XPath_ValueOperAmount, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line OPERAMT Raw"));
                numberDef[1] := CopyStr(GetNodeValue(xmlNodeItem, Param_NUMOFDEC_OperAmtLbl, XPath_NUMOFDEC_OperAmt, true), 1, 1);
                numberDef[2] := CopyStr(GetNodeValue(xmlNodeItem, Param_SIGN_OperAmtLbl, XPath_SIGN_OperAmt, true), 1, 1);
                BuildDecimal(MICAFlowBufferSupplierInv."Line OPERAMT RAW", numberDef[1], numberDef[2], '');
                Clear(numberDef);
                MICAFlowBufferSupplierInv."Line Item No." := CopyStr(GetNodeValue(xmlNodeItem, Param_ItemLbl, XPath_Item, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line Item No."));
                MICAFlowBufferSupplierInv."Line DESCRIPTN" := CopyStr(GetNodeValue(xmlNodeItem, Param_DescriptnLineLbl, XPath_DescriptnLine, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line DESCRIPTN"));
                MICAFlowBufferSupplierInv."Line Amount Raw" := CopyStr(GetNodeValue(xmlNodeItem, Param_ValueAmountLbl, XPath_ValueAmount, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line Amount Raw"));
                numberDef[1] := CopyStr(GetNodeValue(xmlNodeItem, Param_NUMOFDEC_LineAmountLbl, XPath_NUMOFDEC_LineAmount, true), 1, 1);
                numberDef[2] := CopyStr(GetNodeValue(xmlNodeItem, Param_SIGN_LineAmountLbl, XPath_SIGN_LineAmount, true), 1, 1);
                numberDef[3] := CopyStr(GetNodeValue(xmlNodeItem, Param_DRCR_LineAmountLbl, XPath_DRCR_LineAmount, true), 1, 1);
                BuildDecimal(MICAFlowBufferSupplierInv."Line Amount RAW", numberDef[1], numberDef[2], numberDef[3]);
                Clear(numberDef);
                MICAFlowBufferSupplierInv."Line Unit of Measure" := CopyStr(GetNodeValue(xmlNodeItem, Param_UnitLbl, XPath_Unit, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line Unit of Measure"));
                MICAFlowBufferSupplierInv."Line MICH.DESTCOUNTRYCODE" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHDestCountryCodeLbl, XPath_MICHDestCountryCode, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.DESTCOUNTRYCODE"));
                MICAFlowBufferSupplierInv."Line MICH.COUNTRYORIG" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHCountryOrigLbl, XPath_MICHCountryOrig, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.COUNTRYORIG"));
                MICAFlowBufferSupplierInv."Line MICH.DELIVERTERMS" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHDeliverTermsLbl, XPath_MICHDeliverTerms, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.DELIVERTERMS"));
                MICAFlowBufferSupplierInv."Line MICH.TRXCODENATURE" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHTrxCodeNatureLbl, XPath_MICHTrxCodeNature, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.TRXCODENATURE"));
                MICAFlowBufferSupplierInv."Line MICH.NETMASS Raw" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHNetMassLbl, XPath_MICHNetMass, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.NETMASS Raw"));
                MICAFlowBufferSupplierInv."Line MICH.LOADINGPORT" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHLoadingPortLbl, XPath_MICHLoadingPort, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.LOADINGPORT"));
                MICAFlowBufferSupplierInv."Line MICH.LINEATTRIBUTE3" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHLineAttribute3Lbl, XPath_MICHLineAttribute3, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.LINEATTRIBUTE3"));

                /// optional
                MICAFlowBufferSupplierInv."Line MICH.DESTREGION" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHDestRegionLbl, XPath_MICHDestRegion, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.DESTREGION"));
                MICAFlowBufferSupplierInv."Line MICH.COMMODITYCODE" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHCommodityCodeLbl, XPath_MICHCommodityCode, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.COMMODITYCODE"));
                MICAFlowBufferSupplierInv."Line MICH.TRANSPORTMODE" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHTransportModeLbl, XPath_MICHTransportMode, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.TRANSPORTMODE"));
                MICAFlowBufferSupplierInv."Line MICH.SUPPLEMENTUNITS" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHSupplementUnitsLbl, XPath_MICHSupplementUnits, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.SUPPLEMENTUNITS"));
                MICAFlowBufferSupplierInv."Line MICH.STATISTICPROCED" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHStatisticProcedLbl, XPath_MICHStatisticProced, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.STATISTICPROCED"));
                MICAFlowBufferSupplierInv."Line MICH.STATISTICVALUE" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHStatisticValueLbl, XPath_MICHStatisticValue, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.STATISTICVALUE"));
                MICAFlowBufferSupplierInv."Line MICH.CONTAINERNUM" := CopyStr(GetNodeValue(xmlNodeItem, Param_MICHContainerNumLbl, XPath_MICHContainerNum, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line MICH.CONTAINERNUM"));
                MICAFlowBufferSupplierInv."Line SCHLINENUM" := CopyStr(GetNodeValue(xmlNodeItem, Param_SchlineNumLbl, XPath_SchlineNum, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line SCHLINENUM"));
                MICAFlowBufferSupplierInv."Qualifier Tax" := CopyStr(GetAttributeValue(xmlNodeItem, Param_QualifierTaxLbl, XPath_QualifierTax, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."Qualifier Tax"));
                MICAFlowBufferSupplierInv."Line Number Tax" := CopyStr(GetNodeValue(xmlNodeItem, Param_LineNumTaxLbl, XPath_LineNumTax, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line Number Tax"));
                MICAFlowBufferSupplierInv."Quantity Tax Raw" := CopyStr(GetNodeValue(xmlNodeItem, Param_ValueTaxQtyLbl, XPath_ValueTaxQty, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."Quantity Tax Raw"));
                MICAFlowBufferSupplierInv."Tax Code" := CopyStr(GetNodeValue(xmlNodeItem, Param_TaxCodeLbl, XPath_TaxCode, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."Tax Code"));
                MICAFlowBufferSupplierInv."Tax Amount Raw" := CopyStr(GetNodeValue(xmlNodeItem, Param_ValueTaxAmountLbl, XPath_ValueTaxAmount, false), 1, MaxStrLen(MICAFlowBufferSupplierInv."Tax Amount Raw"));

                InsertBuffer();
            end;

        if xmlDoc.SelectNodes(XPath_Charges, xmlNodeChargeList) then
            foreach xmlNodeCharge in xmlNodeChargeList do begin
                MICAFlowBufferSupplierInv."Line CHARGETYPE" := CopyStr(GetNodeValue(xmlNodeCharge, Param_ChargeTypeLbl, XPath_ChargeType, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line CHARGETYPE"));
                MICAFlowBufferSupplierInv."Freight Line No." := CopyStr(GetNodeValue(xmlNodeCharge, Param_LineNumFreightLineLbl, XPath_LineNumFreightLine, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Freight Line No."));
                MICAFlowBufferSupplierInv."Line Charge Amount Raw" := CopyStr(GetNodeValue(xmlNodeCharge, Param_ValueChargeAmountLbl, XPath_ValueChargeAmount, true), 1, MaxStrLen(MICAFlowBufferSupplierInv."Line Charge Amount Raw"));
                numberDef[1] := CopyStr(GetNodeValue(xmlNodeCharge, Param_NUMOFDEC_LineChargeAmountLbl, XPath_NUMOFDEC_LineChargeAmount, true), 1, 1);
                numberDef[2] := CopyStr(GetNodeValue(xmlNodeCharge, Param_SIGN_LineChargeAmountLbl, XPath_SIGN_LineChargeAmount, true), 1, 1);
                numberDef[3] := CopyStr(GetNodeValue(xmlNodeCharge, Param_DRCR_LineChargeAmountLbl, XPath_DRCR_LineChargeAmount, true), 1, 1);
                BuildDecimal(MICAFlowBufferSupplierInv."Line Charge Amount RAW", numberDef[1], numberDef[2], numberDef[3]);
                Clear(numberDef);

                InsertBuffer();
            end;

    end;

    procedure PopulateTechniqueFields()
    var
        TypeHelper: Codeunit "Type Helper";
        DTVariant: Variant;
        CreationDT: DateTime;
        DocDateTime: Text;
    begin
        CreationDT := 0DT;
        DocDateTime :=
        GetNodeValue(Param_YearLbl, XPath_Year, false) +
        GetNodeValue(Param_MonthLbl, XPath_Month, false) +
        GetNodeValue(Param_DayLbl, XPath_Day, false);
        DTVariant := CreationDT;
        TypeHelper.Evaluate(DTVariant, DocDateTime, '', '');
        Evaluate(CreationDT, format(DTVariant));

        MICAFlowEntry.UpdateTechnicalData(
          GetNodeValue(Param_LogicalIDLbl, XPath_LogicalID, false),
          GetNodeValue(Param_ComponentLbl, XPath_Component, false),
          GetNodeValue(Param_TaskLbl, XPath_Task, false),
          GetNodeValue(Param_ReferenceIDLbl, XPath_ReferenceID, false),
          CreationDT,
          '', '', '', '', '', '');

    end;


    local procedure CheckPrerequisitesAndRetrieveParameters(Param: Text[20]; var XPath: Text)
    begin
        if not ParamMICAFlowSetup.CheckIfParamExist(MICAFlowEntry."Flow Code", Param) then begin
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingParamMsg, Param), '');
            exit;
        end;

        XPath := ParamMICAFlowSetup.GetFlowTextParam(MICAFlowEntry."Flow Code", Param);
        if XPath = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(MissingXPathMsg, Param), '');

    end;

    local procedure GetNodeValue(Param: Text[20]; XPath: Text; Mandatory: Boolean): Text
    var
        xmlNodeInfo: XmlNode;
        NodeValue: Text;
    begin
        if XPath = '' then
            exit('');

        if not xmlDoc.SelectSingleNode(XPath, xmlNodeInfo) then begin
            GenerateInformation(Param, XPath, Mandatory, MissingNodeMsg);
            exit('');
        end;

        NodeValue := xmlNodeInfo.AsXmlElement().InnerText();
        if NodeValue = '' then
            GenerateInformation(Param, XPath, Mandatory, MissingNodeValueMsg);

        exit(NodeValue);

    end;

    local procedure GetNodeValue(xmlNodeItem: XmlNode; Param: Text[20]; XPath: Text; Mandatory: Boolean): Text
    var
        NodeValue: Text;
    begin
        if XPath = '' then
            exit('');

        if not xmlNodeItem.SelectSingleNode(XPath, xmlNodeItem) then begin
            GenerateInformation(Param, XPath, Mandatory, MissingNodeMsg);
            exit('');
        end;

        NodeValue := xmlNodeItem.AsXmlElement().InnerText();
        if NodeValue = '' then
            GenerateInformation(Param, XPath, Mandatory, MissingNodeValueMsg);

        exit(NodeValue);

    end;

    local procedure GetAttributeValue(xmlNodeItem: XmlNode; Param: Text[20]; XPath: Text; Mandatory: Boolean): Text
    var
        AttributeValue: Text;
    begin
        if XPath = '' then
            exit('');

        if not xmlNodeItem.SelectSingleNode(XPath, xmlNodeItem) then begin
            GenerateInformation(Param, XPath, Mandatory, MissingNodeMsg);
            exit('');
        end;

        AttributeValue := xmlNodeItem.AsXmlAttribute().Value();
        if AttributeValue = '' then
            GenerateInformation(Param, XPath, Mandatory, MissingNodeValueMsg);

        exit(AttributeValue);

    end;

    local procedure GenerateInformation(Param: Text[20]; XPath: Text; Mandatory: Boolean; Info: Text)
    begin
        if Mandatory then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(Info, Param, XPath), '')
        else
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Warning, StrSubstNo(Info, Param, XPath), '');

    End;

    local procedure InsertBuffer()
    begin
        ImportedRecordCount += 1;
        MICAFlowBufferSupplierInv.Validate("Flow Entry No.", MICAFlowEntry."Entry No.");
        MICAFlowBufferSupplierInv."Entry No." := ImportedRecordCount;
        MICAFlowBufferSupplierInv.Insert();
        ClearLineData(MICAFlowBufferSupplierInv);

    End;

    local procedure ClearLineData(var LocMICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.")
    begin
        Clear(LocMICAFlowBufferSupplierInv."Line No.");
        Clear(LocMICAFlowBufferSupplierInv."Line DOCTYPE1");
        Clear(LocMICAFlowBufferSupplierInv."Line DocumentID1");
        Clear(LocMICAFlowBufferSupplierInv."Line Linenum1");
        Clear(LocMICAFlowBufferSupplierInv."Line DOCTYPE2");
        Clear(LocMICAFlowBufferSupplierInv."Line DocumentID2");
        Clear(LocMICAFlowBufferSupplierInv."Line Linenum2");
        Clear(LocMICAFlowBufferSupplierInv."Line DOCTYPE3");
        Clear(LocMICAFlowBufferSupplierInv."Line DocumentID3");
        Clear(LocMICAFlowBufferSupplierInv."Line Linenum3");
        Clear(LocMICAFlowBufferSupplierInv."Line Quantity Raw");
        Clear(LocMICAFlowBufferSupplierInv."Line OPERAMT Raw");
        Clear(LocMICAFlowBufferSupplierInv."Line Item No.");
        Clear(LocMICAFlowBufferSupplierInv."Line DESCRIPTN");
        Clear(LocMICAFlowBufferSupplierInv."Line Amount Raw");
        Clear(LocMICAFlowBufferSupplierInv."Line Unit of Measure");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.DESTCOUNTRYCODE");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.COUNTRYORIG");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.DESTREGION");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.DELIVERTERMS");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.TRXCODENATURE");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.COMMODITYCODE");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.NETMASS Raw");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.SUPPLEMENTUNITS");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.TRANSPORTMODE");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.LOADINGPORT");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.STATISTICPROCED");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.STATISTICVALUE");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.LINEATTRIBUTE3");
        Clear(LocMICAFlowBufferSupplierInv."Line MICH.CONTAINERNUM");
        Clear(LocMICAFlowBufferSupplierInv."Line SCHLINENUM");
        Clear(LocMICAFlowBufferSupplierInv."Qualifier Tax");
        Clear(LocMICAFlowBufferSupplierInv."Line Number Tax");
        Clear(LocMICAFlowBufferSupplierInv."Quantity Tax Raw");
        Clear(LocMICAFlowBufferSupplierInv."Tax Code");
        Clear(LocMICAFlowBufferSupplierInv."Tax Amount Raw");

    end;

    procedure SetFlowEntry(var PMICAFlowEntry: Record "MICA Flow Entry")
    begin
        MICAFlowEntry := PMICAFlowEntry;

    end;

    procedure SetSource(PInStream: InStream)
    begin
        InStream := PInStream;

    end;

    procedure GetBuffer(var OutMICAFlowBufferSupplierInv: Record "MICA Flow Buffer Supplier Inv.")
    begin
        OutMICAFlowBufferSupplierInv := MICAFlowBufferSupplierInv;

    end;

    procedure GetRecordCount(): Integer
    begin
        exit(ImportedRecordCount);

    end;

    local procedure BuildDecimal(var RAWAmount: Text[30]; NumOfDec: Text[1]; Sign: Text[1]; DebitCredit: Text[1])
    var
        Decimals: Integer;
    begin
        RAWAmount := DelChr(RAWAmount, '<>');
        if NumOfDec <> '' then begin
            Evaluate(Decimals, NumOfDec);
            RAWAmount := CopyStr(RAWAmount, 1, StrLen(RAWAmount) - Decimals) + '.' +
                                            CopyStr(RAWAmount, StrLen(RAWAmount) - Decimals + 1);
        end;
        if Sign = '-' then
            RAWAmount := Sign + CopyStr(RAWAmount, 1, 29);
        if DebitCredit = '' then
            DebitCredit := ' ';
        RAWAmount := DebitCredit + CopyStr(RAWAmount, 1, 29);
        //[D|C| ][Sign]decimals.decimals
    end;
}