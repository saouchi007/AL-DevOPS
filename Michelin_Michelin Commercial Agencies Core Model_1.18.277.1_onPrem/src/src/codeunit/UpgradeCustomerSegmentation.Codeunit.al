codeunit 82825 "Upgrade Customer Segmentation"
{
    Subtype = Upgrade;

    trigger OnRun()
    begin
    end;

    trigger OnUpgradePerCompany()
    begin
        UpgradeCustomerSegmentation();
    end;

    local procedure UpgradeCustomerSegmentation()
    var
        Customer: Record Customer;
    begin
        if UpgradeTag.HasUpgradeTag(CustomerSegmentationUpgradeTagLbl) then
            exit;

        InitTableValues();

        if not Customer.FindSet(true, false) then
            exit;

        repeat
            case Customer."MICA Segmentation" of
                Customer."MICA Segmentation"::AVIATION:
                    Customer.Validate("MICA Segmentation Code", AviationMICATableValue.Code);
                Customer."MICA Segmentation"::DEALER:
                    Customer.Validate("MICA Segmentation Code", DealerMICATableValue.Code);
                Customer."MICA Segmentation"::LEASER:
                    Customer.Validate("MICA Segmentation Code", LeaserMICATableValue.Code);
                Customer."MICA Segmentation"::OEM:
                    Customer.Validate("MICA Segmentation Code", OemMICATableValue.Code);
                Customer."MICA Segmentation"::PROF_END_USER:
                    Customer.Validate("MICA Segmentation Code", EndUserMICATableValue.Code);
            end;
            Customer.Modify();
        until Customer.Next() = 0;

        UpgradeTag.SetUpgradeTag(CustomerSegmentationUpgradeTagLbl);
    end;

    local procedure InitTableValues()
    var
        MICATableType: Record "MICA Table Type";
    begin
        MICATableType.Init();
        MICATableType.Type := MICATableType.Type::CustSegment;
        MICATableType."Max. Length for Code" := 20;
        MICATableType."Max. Length for Description" := 50;
        if not MICATableType.Insert() then;

        AdministrationMICATableValue.Init();
        AdministrationMICATableValue."Table Type" := AdministrationMICATableValue."Table Type"::CustSegment;
        AdministrationMICATableValue.Code := 'ADMINISTRATION';
        AdministrationMICATableValue.Description := 'Administration';
        if not AdministrationMICATableValue.Insert() then;

        DealerMICATableValue.Init();
        DealerMICATableValue."Table Type" := DealerMICATableValue."Table Type"::CustSegment;
        DealerMICATableValue.Code := 'DEALER';
        DealerMICATableValue.Description := 'Dealer';
        if not DealerMICATableValue.Insert() then;

        HcMICATableValue.Init();
        HcMICATableValue."Table Type" := HcMICATableValue."Table Type"::CustSegment;
        HcMICATableValue.Code := 'HC';
        HcMICATableValue.Description := 'Hors Canaux';
        if not HcMICATableValue.Insert() then;

        LeaserMICATableValue.Init();
        LeaserMICATableValue."Table Type" := LeaserMICATableValue."Table Type"::CustSegment;
        LeaserMICATableValue.Code := 'LEASER';
        LeaserMICATableValue.Description := 'Leaser';
        if not LeaserMICATableValue.Insert() then;

        OemMICATableValue.Init();
        OemMICATableValue."Table Type" := OemMICATableValue."Table Type"::CustSegment;
        OemMICATableValue.Code := 'OEM';
        OemMICATableValue.Description := 'Original Equipment Manufacturer';
        if not OemMICATableValue.Insert() then;

        EndUserMICATableValue.Init();
        EndUserMICATableValue."Table Type" := EndUserMICATableValue."Table Type"::CustSegment;
        EndUserMICATableValue.Code := 'PROF_END_USER';
        EndUserMICATableValue.Description := 'Professional End User';
        if not EndUserMICATableValue.Insert() then;

        AviationMICATableValue.Init();
        AviationMICATableValue."Table Type" := AviationMICATableValue."Table Type"::CustSegment;
        AviationMICATableValue.Code := 'AVIATION';
        AviationMICATableValue.Description := 'Aviation';
        if not AviationMICATableValue.Insert() then;
    end;

    var
        AdministrationMICATableValue: Record "MICA Table Value";
        DealerMICATableValue: Record "MICA Table Value";
        HcMICATableValue: Record "MICA Table Value";
        LeaserMICATableValue: Record "MICA Table Value";
        OemMICATableValue: Record "MICA Table Value";
        EndUserMICATableValue: Record "MICA Table Value";
        AviationMICATableValue: Record "MICA Table Value";
        UpgradeTag: Codeunit "Upgrade Tag";
        CustomerSegmentationUpgradeTagLbl: Label 'CC-O2C-024-CustSegmentUpgrade-13042021', Locked = true;
}