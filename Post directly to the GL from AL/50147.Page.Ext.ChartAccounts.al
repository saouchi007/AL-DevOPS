/// <summary>
/// PageExtension ChartAcounts_Ext (ID 50147) extends Record Chart of Accounts.
/// </summary>
pageextension 50147 ChartAcounts_Ext extends "Chart of Accounts"
{


    actions
    {
        addfirst(processing)
        {
            action(PostEntries)
            {
                Caption = 'Post Entries';
                Image = PostedPayment;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Line: Record "Gen. Journal Line";
                    GLPost: Codeunit "Gen. Jnl.-Post Line";
                begin
                    Line.Init();
                    Line."Posting Date" := Today();
                    Line."Document Type" := Line."Document Type"::Payment;
                    Line."Document No." := 'Doc0002';
                    Line."Account Type" := Line."Account Type"::"G/L Account";
                    Line."Account No." := '1110';
                    Line.Description := 'The spaniards !';
                    Line.Amount := -50000;
                    Line."Bal. Account Type" := Line."Bal. Account Type"::"G/L Account";
                    Line."Bal. Account No." := '1220';
                    GLPost.RunWithCheck(Line);
                end;
            }
        }
    }


}