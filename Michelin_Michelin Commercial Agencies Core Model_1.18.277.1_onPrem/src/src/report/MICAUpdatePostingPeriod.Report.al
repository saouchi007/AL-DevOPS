report 81180 "MICA Update Posting Period"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Update Posting Period';


    dataset
    {
        dataitem("User Setup"; "User Setup")
        {
            RequestFilterFields = "MICA User Category";
            trigger OnPreDataItem()
            var
                notEmptySetLbl: Label 'Set Posting From and Set Posting to must not be empty';
                notEmptuUserCategoryFilterErr: Label 'User Category must be filled.';
            begin
                if (SetPostingFromValue = 0D) oR (SetpostingToValue = 0D) then
                    Error(notEmptySetLbl);
                if "User Setup".GetFilter("MICA User Category") = '' then
                    Error(notEmptuUserCategoryFilterErr);
            end;

            trigger OnAfterGetRecord()
            var
            //notEmptyAllowLbl: Label 'Allow Posting From and Allow Posting to must not be empty';
            begin
                //IF ("Allow Posting From" = 0D) OR ("Allow Posting To" = 0D) then
                //    Error(notEmptyAllowLbl);

                "Allow Posting From" := SetPostingFromValue;
                "Allow Posting To" := SetpostingToValue;
                Modify();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(SetPostingFrom; SetPostingFromValue)
                    {
                        Caption = 'Set Posting From';
                        ApplicationArea = All;

                    }

                    field(SetpostingTo; SetpostingToValue)
                    {
                        Caption = 'Set Posting To';
                        ApplicationArea = All;

                    }
                }
            }
        }
    }
    var
        SetPostingFromValue: Date;
        SetpostingToValue: Date;

}