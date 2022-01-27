/// <summary>
/// Codeunit Training-Requ.to Regist. (Y/N) (ID 52182424).
/// </summary>
codeunit 52182424 "Training-Requ.to Regist. (Y/N)"
//codeunit 39108396 "Training-Requ.to Regist. (Y/N)"
{
    // version HALRHPAIE.6.1.01

    TableNo = 52182441;

    trigger OnRun();
    begin
        TESTFIELD("Document Type", "Document Type"::Request);
        IF NOT CONFIRM(Text000, FALSE) THEN
            EXIT;
        GET("Document Type"::Request, "No.");
        TrainingReqToReg.RUN(Rec);
        TrainingReqToReg.GetTrainingRegistrationHeader(TrainingHeader2);
        COMMIT;
        MESSAGE(Text001, "No.", TrainingHeader2."No.");
    end;

    var
        Text000: TextConst ENU = 'Do you want to convert the quote to an order?', FRA = 'Souhaitez-vous transformer la demande en inscription ?';
        Text001: TextConst ENU = 'Quote %1 has been changed to order %2.', FRA = 'La demande %1 a été transformée en inscription %2.';
        TrainingHeader2: Record 52182441;
        TrainingReqToReg: Codeunit 52182425;
}

