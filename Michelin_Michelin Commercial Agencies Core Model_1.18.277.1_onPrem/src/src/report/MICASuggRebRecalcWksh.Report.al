report 82762 "MICA Sugg. Reb. Recalc. Wksh."
{
    Caption = 'Suggest Rebate Recaclulation Worksheet';
    ProcessingOnly = true;
    UseRequestPage = true;
    UsageCategory = None;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = sorting("Document No.") where("Document Type" = const(Order));
            trigger OnPreDataItem()
            var
                FilterSalesLineStatus: Text;
            begin
                SetRange(Type, Type::Item);
                SetFilter("No.", '<>%1', '');
                if ToSalesType = ToSalesType::Customer then
                    SetRange("Sell-to Customer No.", ToSalesCode);

                if ToSalesStatus = '' then begin
                    FilterSalesLineStatus := MICASuggImpPricRebChng.CheckAllSalesLineStatuses();
                    SetFilter("MICA Status", FilterSalesLineStatus);
                end else
                    SetFilter("MICA Status", ToSalesStatus);
            end;

            trigger OnAfterGetRecord()
            var
                SalesLineDiscount: Decimal;
            begin
                Clear(MICASuggImpPricRebChng);

                if not MICASuggImpPricRebChng.CheckLinesStatusReserveOnHandInTransit("Sales Line", SuggestionFilterDate) then
                    exit;

                MICASuggImpPricRebChng.SetSORebateRecalcExclWindow(SalesReceivablesSetup."MICA SO Reb. Rec. Excl. Wind.");
                if MICASuggImpPricRebChng.FindSalesDiscount("Sales Line", ToSalesType, SalesLineDiscount) then
                    if SalesLineDiscount <> "Line Discount %" then
                        MICASuggImpPricRebChng.FillRebateRecalcWorksheet("Sales Line", SalesLineDiscount);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Copy to Price Recalc. Worksheet")
                    {
                        Caption = 'Copy to Price Recalculation Worksheet';
                        field(SalesType; ToSalesType)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Sales Type';
                            OptionCaption = 'Customer,All Customers';
                            ToolTip = 'Specifies the sales type that the sales price agreement will be copied to. To see the existing sales types, click the field.';

                            trigger OnValidate()
                            begin
                                SalesCodeEnabled := ToSalesType <> ToSalesType::"All Customers";

                                if not SalesCodeEnabled then
                                    ToSalesCode := '';
                            end;
                        }
                        field(SalesCode; ToSalesCode)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Sales Code';
                            Enabled = SalesCodeEnabled;
                            ToolTip = 'Specifies the code for the sales type that the sales prices will be copied to. To see the existing sales codes, click the field.';

                            trigger OnValidate()
                            var
                                Customer: Record Customer;
                                TextError: Text;
                            begin
                                case ToSalesType of
                                    ToSalesType::"All Customers":
                                        exit;
                                    ToSalesType::Customer:
                                        begin
                                            if ToSalesCode = '' then begin
                                                TextError := StrSubstNo(SalesCodeIsEmptyErr, Format(ToSalesType::Customer));
                                                Error(TextError);
                                            end;

                                            Customer.Get(ToSalesCode);
                                        end;

                                end;
                            end;

                            trigger OnLookup(var Text: Text): Boolean
                            var
                                CustomerList: Page "Customer List";
                            begin
                                if ToSalesType = ToSalesType::Customer then begin
                                    if not ToCustomer.Get(ToSalesCode) then
                                        ToCustomer.Init();

                                    CustomerList.LookupMode := true;
                                    CustomerList.SetRecord(ToCustomer);
                                    if CustomerList.RunModal() = Action::LookupOK then begin
                                        CustomerList.GetRecord(ToCustomer);
                                        ToSalesCode := ToCustomer."No.";
                                    end;
                                end;
                            end;
                        }
                        field(SalesStatus; ToSalesStatus)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'MICA Status';
                            ToolTip = 'Specifies the types of status for sales lines. To see existing options, click the field.';

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                MICASuggImpPricRebChng.CheckAndProcessSalesStatus(ToSalesStatus, 1);
                            end;
                        }
                    }
                }
            }
        }

        trigger OnInit()
        begin
            SalesCodeEnabled := true;
        end;

        trigger OnOpenPage()
        begin
            ToSalesStatus := '';
            SalesCodeEnabled := true;
            if ToSalesType = ToSalesType::"All Customers" then begin
                SalesCodeEnabled := false;
                ToSalesCode := '';
            end;
        end;
    }
    trigger OnPreReport()
    begin
        SalesReceivablesSetup.Get();
        SuggestionFilterDate := CalcDate(SalesReceivablesSetup."MICA Price Recalc. Window", WorkDate());
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        ToCustomer: Record Customer;
        MICASuggImpPricRebChng: Codeunit "MICA Sugg.Imp. Pric.Reb. Chng.";
        ToSalesType: Option Customer,"All Customers";
        SuggestionFilterDate: Date;
        ToSalesStatus: Text;
        ToSalesCode: Code[20];
        [InDataSet]
        SalesCodeEnabled: Boolean;
        SalesCodeIsEmptyErr: Label 'Filter Sales Code needs to be filled when Sales Type is: %1';
}