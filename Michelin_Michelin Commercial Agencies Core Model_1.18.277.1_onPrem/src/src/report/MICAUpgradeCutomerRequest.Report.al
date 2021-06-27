report 80101 "MICA Upgrade Cutomer Request"
{
    Caption = 'Upgrade Cutomer Request';
    ProcessingOnly = true;
    UseRequestPage = false;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Interaction Log Entry"; "Interaction Log Entry")
        {
            trigger OnAfterGetRecord()
            var
                User: Record User;
            begin
                User.SetRange("User Name", "Interaction Log Entry"."MICA Responsible User ID");
                if User.FindFirst() then
                    "Interaction Log Entry"."MICA Responsible User" := User."User Security ID";

                User.SetRange("User Name", "Interaction Log Entry"."MICA Assigned User ID");
                if User.FindFirst() then
                    "Interaction Log Entry"."MICA Assigned User" := User."User Security ID";

                User.SetRange("User Name", "Interaction Log Entry"."MICA Close the Loop User");
                if User.FindFirst() then
                    "Interaction Log Entry"."MICA Close the Loop User Guid" := User."User Security ID";

                User.SetRange("User Name", "Interaction Log Entry"."MICA Close the Case User");
                if User.FindFirst() then
                    "Interaction Log Entry"."MICA Close the Case User Guid" := User."User Security ID";

                "Interaction Log Entry".Modify();
            end;
        }
        dataitem("MICA Interaction Activities"; "MICA Interaction Activities")
        {
            trigger OnAfterGetRecord()
            var
                User: Record User;
            begin
                User.SetRange("User Name", "MICA Interaction Activities"."Creation User ID");
                if User.FindFirst() then
                    "MICA Interaction Activities"."Creation User" := User."User Security ID";

                User.SetRange("User Name", "MICA Interaction Activities"."Assigned User ID");
                if User.FindFirst() then
                    "MICA Interaction Activities"."Assigned User" := User."User Security ID";

                User.SetRange("User Name", "MICA Interaction Activities"."Activity Closer ID");
                if User.FindFirst() then
                    "MICA Interaction Activities"."Activity Closer" := User."User Security ID";

                "MICA Interaction Activities".Modify();
            end;
        }
    }
}