codeunit 80440 "MICA SANA EvalCustInteraction"
{
    var
        CustNotExistingErr: label 'The customer %1 doesn''t exist. Please contact the customer care service.';
        CustWithoutContactErr: label 'The customer %1 doesn''t have a contact. For information the interaction is liked to a contact, not to a customer. Please contact the customer care service.';
        CustWhitoutInteractionErr: Label 'There is no interaction for the customer %1 with the id %2. Please contact the customer care service.';
        ContNotExistingErr: Label 'The contact %1 doesn''t exist. Please contact the customer care service.';
        ContWhitoutInteractionErr: Label 'There is no interaction for the contact %1 with the id %2. Please contact the customer care service.';
        InteractionWhitWrongStatusErr: Label 'The interaction %1 has not the right status to be closed by the customer. Please contact the customer care service.';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Customer Functions", 'OnRunCustomerFunctions', '', false, false)]
    local procedure MyProcedure(var Rec: Record "SC - Operation"; var RequestBuff: Record "SC - XML Buffer (dotNET)"; var ResponseBuff: Record "SC - XML Buffer (dotNET)")
    begin
        if rec.Code = UPPERCASE('EvaluateCustomerInteraction') then
            EvaluateCustomerInteraction(RequestBuff, ResponseBuff);
    end;

    local procedure EvaluateCustomerInteraction(var SCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; var OutSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)")
    var
        Customer: Record Customer;
        Contact: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        InteractionLogEntry: Record "Interaction Log Entry";
        TempSCParametersCollection: Record "SC - Parameters Collection" temporary;
        InteractionIdtxt: Text;
        RatingTxt: Text;
        Comment: Text;
        ErrorTxt: text;
        InteractionId: Integer;
        Rating: Integer;

    begin
        TempSCParametersCollection.InitParams(SCXMLBufferdotNET, 0);
        InteractionIdtxt := SCXMLBufferdotNET.SelectSingleNodeText('//InteractionId');
        if InteractionIdtxt <> '' then
            Evaluate(InteractionId, InteractionIdtxt);
        RatingTxt := SCXMLBufferdotNET.SelectSingleNodeText('//Rating');
        if RatingTxt <> '' then
            Evaluate(Rating, RatingTxt);
        Comment := SCXMLBufferdotNET.SelectSingleNodeText('//Comment');

        if (TempSCParametersCollection.AccountType = 'Customer') then begin
            if not Customer.get(TempSCParametersCollection.AccountId) then begin
                ErrorTxt := StrSubstNo(CustNotExistingErr, TempSCParametersCollection.AccountId);
                FillResponseXMLBuffer(OutSCXMLBufferdotNET, ErrorTxt);
                exit;
            end;

            ContactBusinessRelation.SetCurrentKey("Link to Table", "No.");
            ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
            ContactBusinessRelation.SetRange("No.", Customer."No.");
            if not ContactBusinessRelation.FindFirst() then begin
                ErrorTxt := StrSubstNo(CustWithoutContactErr, TempSCParametersCollection.AccountId);
                FillResponseXMLBuffer(OutSCXMLBufferdotNET, ErrorTxt);
                exit;
            end;

            InteractionLogEntry.SetRange("Entry No.", InteractionId);
            InteractionLogEntry.SetRange("Contact Company No.", ContactBusinessRelation."Contact No.");
            if not InteractionLogEntry.FindSet() then begin
                ErrorTxt := StrSubstNo(CustWhitoutInteractionErr, TempSCParametersCollection.AccountId, format(InteractionId));
                FillResponseXMLBuffer(OutSCXMLBufferdotNET, ErrorTxt);
                exit;
            end;
        end;

        if (TempSCParametersCollection.AccountType = 'Contact') then begin
            if not Contact.Get(TempSCParametersCollection.AccountId) then begin
                ErrorTxt := StrSubstNo(ContNotExistingErr, TempSCParametersCollection.AccountId);
                FillResponseXMLBuffer(OutSCXMLBufferdotNET, ErrorTxt);
                exit;
            end;

            InteractionLogEntry.SetRange("Entry No.", InteractionId);
            InteractionLogEntry.SetRange("Contact No.", Contact."No.");
            if not InteractionLogEntry.FindSet() then begin
                ErrorTxt := StrSubstNo(ContWhitoutInteractionErr, TempSCParametersCollection.AccountId, format(InteractionId));
                FillResponseXMLBuffer(OutSCXMLBufferdotNET, ErrorTxt);
                exit;
            end;

        end;

        if InteractionLogEntry."MICA Request Status" <> InteractionLogEntry."MICA Request Status"::"Close the Case" then begin
            ErrorTxt := StrSubstNo(InteractionWhitWrongStatusErr, format(InteractionId));
            FillResponseXMLBuffer(OutSCXMLBufferdotNET, ErrorTxt);
            exit;
        end;

        InteractionLogEntry.SetCESComment(Comment);
        InteractionLogEntry.Validate("MICA CES Evaluation", Rating);
        InteractionLogEntry.Modify();

        FillResponseXMLBuffer(OutSCXMLBufferdotNET, ErrorTxt);
    end;

    local procedure FillResponseXMLBuffer(var OutSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; ErrorTxt: Text)
    var
        TempIsSavedSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        TempReasonSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;

    begin
        if ErrorTxt <> '' then begin
            OutSCXMLBufferdotNET.AddElement(TempIsSavedSCXMLBufferdotNET, 'IsSaved', copystr(Format(0), 1, 1024));
            OutSCXMLBufferdotNET.AddElement(TempReasonSCXMLBufferdotNET, 'Reason', copystr(ErrorTxt, 1, 1024));
        end else
            OutSCXMLBufferdotNET.AddElement(TempIsSavedSCXMLBufferdotNET, 'IsSaved', copystr(Format(1), 1, 1024));
    end;
}