codeunit 81800 "MICA Product Type Posting"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignFieldsForNo', '', false, false)]
    local procedure t37OnAfterAssignFieldsForNo(VAR SalesLine: Record "Sales Line"; VAR xSalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        GenProductPostingGroup: Record "Gen. Product Posting Group";
    begin
        if SalesLine."Gen. Prod. Posting Group" <> '' then begin
            GenProductPostingGroup.get(SalesLine."Gen. Prod. Posting Group");
            SalesLine.Validate("MICA Product Type Code", GenProductPostingGroup."MICA Product Type");
        end else
            SalesLine.Validate("MICA Product Type Code", '');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvLineInsert', '', false, false)]
    local procedure c80OnBeforeSalesInvLineInsert(VAR SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean)
    begin
        SalesInvLine."MICA Product Type Code" := SalesLine."MICA Product Type Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesCrMemoLineInsert', '', false, false)]
    local procedure c80OnBeforeSalesCrMemoLineInsert(VAR SalesCrMemoLine: Record "Sales Cr.Memo Line"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean)
    begin
        SalesCrMemoLine."MICA Product Type Code" := SalesLine."MICA Product Type Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ArchiveManagement, 'OnAfterStoreSalesLineArchive', '', false, false)]
    local procedure c5063OnAfterStoreSalesLineArchive(VAR SalesHeader: Record "Sales Header"; VAR SalesLine: Record "Sales Line"; VAR SalesHeaderArchive: Record "Sales Header Archive"; VAR SalesLineArchive: Record "Sales Line Archive")
    begin
        SalesLineArchive."MICA Product Type Code" := SalesLine."MICA Product Type Code";
        SalesLineArchive.Modify(true);
    end;
}
