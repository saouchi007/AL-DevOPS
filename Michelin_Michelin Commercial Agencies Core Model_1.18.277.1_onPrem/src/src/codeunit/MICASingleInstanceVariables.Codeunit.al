codeunit 81821 "MICA SingleInstanceVariables"
{
    //3PL-010: Whse. Shipment. 3PL Confirmation
    SingleInstance = true;

    var
        C81820PostPrint: Boolean;
        C81820LastShipingNo: Code[20];
        C81820LastPostingNo: Code[20];
        Skip3PLExportStatus: Boolean;


    procedure Set_Skip3PLExportStatus(newSkip3PLExportStatus: Boolean)
    begin
        Skip3PLExportStatus := newSkip3PLExportStatus;
    end;

    procedure Get_Skip3PLExportStatus(ClearVal: Boolean): Boolean
    var
        ValVariant: Variant;
    begin
        ValVariant := Skip3PLExportStatus;
        if ClearVal then
            Clear(Skip3PLExportStatus);
        exit(ValVariant);
    end;

    procedure Set_C81820PostPrint(newC81820PostPrint: Boolean)
    begin
        C81820PostPrint := newC81820PostPrint;
    end;

    procedure Get_C81820PostPrint(ClearVal: Boolean): Boolean
    var
        ValVariant: Variant;
    begin
        ValVariant := C81820PostPrint;
        if ClearVal then
            Clear(C81820PostPrint);
        exit(ValVariant);
    end;

    procedure Set_C81820LastShipingNo(newC81820LastShipingNo: Code[20])
    begin
        C81820LastShipingNo := newC81820LastShipingNo;
    end;

    procedure Get_C81820LastShipingNo(ClearVal: Boolean): Code[20]
    var
        ValVariant: Variant;
    begin
        ValVariant := C81820LastShipingNo;
        if ClearVal then
            Clear(C81820LastShipingNo);
        exit(ValVariant);
    end;

    procedure Set_C81820LastPostingNo(newC81820LastPostingNo: Code[20])
    begin
        C81820LastPostingNo := newC81820LastPostingNo;
    end;

    procedure Get_C81820LastPostingNo(ClearVal: Boolean): Code[20]
    var
        ValVariant: Variant;
    begin
        ValVariant := C81820LastPostingNo;
        if ClearVal then
            Clear(C81820LastPostingNo);
        exit(ValVariant);
    end;

}