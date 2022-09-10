/// <summary>
/// PageExtension ISA_CustomerList_Ext (ID 50331) extends Record Customer List.
/// </summary>
pageextension 50331 ISA_CustomerList_Ext extends "Customer List"
{
    actions
    {
        addfirst(processing)
        {
            action(ChangeCompany)
            {
                ApplicationArea = All;
                Caption = 'Change Company';
                Image = Change;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ISA_Session: SessionSettings;
                begin
                    ISA_Session.Init();
                    ISA_Session.Company('Acme LLC');
                    ISA_Session.TimeZone();
                    ISA_Session.RequestSessionUpdate(true); // if the button is pressed the first time, the company
                    // would be saved when published a second time
                end;
            }

            action(GetTimeZone)
            {
                ApplicationArea = All;
                Caption = 'Get Timezone';
                Image = Timeline;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ISA_TypeHelper: Codeunit "Type Helper";
                begin
                    Message('%1', ISA_TypeHelper.FormatUtcDateTime(CurrentDateTime, '', ''));
                end;
            }

            action(SetTimeZone)
            {
                ApplicationArea = All;
                Caption = 'Set UTC Timezone';
                Image = Timeline;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ISA_Session: SessionSettings;
                begin
                    ISA_Session.Init();
                    ISA_Session.TimeZone('UTC');
                    ISA_Session.RequestSessionUpdate(true);
                end;
            }

            action(ChangeLocalID)
            {
                ApplicationArea = All;
                Caption = 'Change UI language to Fr';
                Image = Language;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ISA_Session: SessionSettings;
                begin
                    ISA_Session.Init();
                    ISA_Session.LanguageId(1036);
                    ISA_Session.RequestSessionUpdate(true);
                end;
            }
        }
    }
}