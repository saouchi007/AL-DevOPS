pageextension 80260 "MICA Workflows" extends Workflows
{
    actions
    {
        addlast(Process)
        {
            action("MICA DeleteOrphanWrkData")
            {
                caption = 'Delete Orphan Workflow Data';
                ToolTip = 'Delete Orphan Workflow Data based on existing approval entries.';
                RunObject = report "MICA Delete Orphan Wkflow Data";
                image = Delete;
                ApplicationArea = all;
            }
            action("MICA DeleteOrphanWrkStInst")
            {
                caption = 'Delete Orphan Workflow Step Instances';
                ToolTip = 'Delete Orphan Workflow Step instances based on current active workflow step instances.';
                RunObject = report "MICA Del. Orph. Wrk. St. Inst.";
                image = Delete;
                ApplicationArea = all;
            }
        }
    }
}
