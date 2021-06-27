tableextension 80922 "MICA Posted Pmt Recon. Line" extends "Posted Payment Recon. Line"
{
    fields
    {
        // Add changes to table fields here
        //Flow Receive
        field(80870; "MICA Rcv. Last Flow Entry No."; Integer)
        {
            Caption = 'Receive Last Flow Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "MICA Flow Entry";
        }
        field(80872; "MICA Receive Last Flow Status"; Option)
        {
            Caption = 'Receive Last Flow Status';
            OptionMembers = " ",Created,Received,Loaded,Processed,PostProcessed;
            OptionCaption = ' ,Created,Received,Loaded,Processed,Post Processed';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(80920; "MICA Description 2"; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Description 2';
        }
    }
}