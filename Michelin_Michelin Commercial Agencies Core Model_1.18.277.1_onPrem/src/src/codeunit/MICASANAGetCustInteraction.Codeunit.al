codeunit 80620 "MICA SANA Get Cust Interaction"
{
    var
        CurrentPageIndex: Integer;
        CurrentInteractIndex: Integer;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SC - Customer Functions", 'OnRunCustomerFunctions', '', false, false)]
    local procedure MyProcedure(var Rec: Record "SC - Operation"; var RequestBuff: Record "SC - XML Buffer (dotNET)"; var ResponseBuff: Record "SC - XML Buffer (dotNET)")
    begin
        if rec.Code = UPPERCASE('GetCustomerInteractions') then
            GetCustomerInteractions(RequestBuff, ResponseBuff);
    end;

    local procedure GetCustomerInteractions(var InSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; var OutSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)")
    var
        Customer: Record Customer;
        Contact: Record Contact;
        TempSCParametersCollection: Record "SC - Parameters Collection" temporary;
        TempInteractionLogEntry: Record "Interaction Log Entry" temporary;
        InteractionType: Text;
        InteractionNumber: Text;
        MaxLinesToLoadTxt: Text;
        Status: Text;
        MaxLinesToLoad: Integer;

    begin
        TempSCParametersCollection.InitParams(InSCXMLBufferdotNET, 0);
        InteractionType := InSCXMLBufferdotNET.SelectSingleNodeText('//InteractionType');
        InteractionNumber := InSCXMLBufferdotNET.SelectSingleNodeText('//InteractionNumber');
        MaxLinesToLoadTxt := InSCXMLBufferdotNET.SelectSingleNodeText('//MaxLinesToLoad');
        if MaxLinesToLoadTxt <> '' then
            Evaluate(MaxLinesToLoad, MaxLinesToLoadTxt);
        Status := InSCXMLBufferdotNET.SelectSingleNodeText('//Status');
        Status := ConvertStr(Status, '&lt;', '   <');
        Status := ConvertStr(Status, '&gt;', '   >');
        Status := DelChr(Status, '=', ' ');

        if (TempSCParametersCollection.AccountType = 'Customer') then begin
            Customer.get(TempSCParametersCollection.AccountId);
            GetCustomerInteractions(Customer, TempSCParametersCollection, InteractionType, InteractionNumber, Status, TempInteractionLogEntry);
        end;

        if (TempSCParametersCollection.AccountType = 'Contact') then begin
            Contact.Get(TempSCParametersCollection.AccountId);
            AddContactInteractions(Contact, TempSCParametersCollection, InteractionType, InteractionNumber, Status, TempInteractionLogEntry);
        end;

        FillXmlResponse(OutSCXMLBufferdotNET, TempSCParametersCollection, MaxLinesToLoad, TempInteractionLogEntry);
    end;

    local procedure GetCustomerInteractions(var Customer: record Customer; var SCParametersCollection: Record "SC - Parameters Collection"; InteractionType: Text; InteractionNumber: Text; Status: Text; var TmpInteractionLogEntry: Record "Interaction Log Entry" temporary)
    var
        Contact: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        ContactBusinessRelation.SetCurrentKey("Link to Table", "No.");
        ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
        ContactBusinessRelation.SetRange("No.", Customer."No.");
        if ContactBusinessRelation.FindFirst() then begin
            Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.");
            if Contact.FindSet() then
                repeat
                    AddContactInteractions(Contact, SCParametersCollection, InteractionType, InteractionNumber, Status, TmpInteractionLogEntry);
                until Contact.Next() = 0;
        end;
    end;

    local procedure AddContactInteractions(var Contact: record Contact; var SCParametersCollection: Record "SC - Parameters Collection"; InteractionType: Text; InteractionNumberTxt: Text; Status: Text; var TmpInteractionLogEntry: Record "Interaction Log Entry" temporary)
    var
        InteractionLogEntry: Record "Interaction Log Entry";
        MICAInteractionActivities: Record "MICA Interaction Activities";
        StartDateFilter: Text;
        EndDateFilter: Text;
        NbActivites: Integer;
        InteractionNumber: Integer;

    begin
        InteractionLogEntry.SETASCENDING("Entry No.", false);
        if InteractionNumberTxt <> '' then
            Evaluate(InteractionNumber, InteractionNumberTxt);

        if (SCParametersCollection.StartDate <> 0D) then
            StartDateFilter := Format(SCParametersCollection.StartDate);
        if (SCParametersCollection.EndDate <> 0D) then
            EndDateFilter := Format(SCParametersCollection.EndDate);

        InteractionLogEntry.SetRange("Contact No.", Contact."No.");
        if InteractionType <> '' then
            InteractionLogEntry.SetRange("Interaction Template Code", InteractionType);
        if InteractionNumber <> 0 then
            InteractionLogEntry.SetRange("Entry No.", InteractionNumber);
        if (SCParametersCollection.StartDate <> 0D) or (SCParametersCollection.EndDate <> 0D) then
            InteractionLogEntry.setfilter("MICA Interaction Creation Date", StartDateFilter + '..' + EndDateFilter);
        if (Status <> '') then
            InteractionLogEntry.SetFilter("MICA Request Status", Status);

        if InteractionLogEntry.FindSet() then
            repeat
                MICAInteractionActivities.SetRange("Interaction No.", InteractionLogEntry."Entry No.");
                NbActivites := MICAInteractionActivities.Count();
                if (NbActivites <> 0) then
                    if not TmpInteractionLogEntry.get(InteractionLogEntry."Entry No.") then begin
                        TmpInteractionLogEntry.Init();
                        TmpInteractionLogEntry.TransferFields(InteractionLogEntry);
                        TmpInteractionLogEntry.Insert(false);
                    end;
            until InteractionLogEntry.Next() = 0;
    end;

    local procedure FillXmlResponse(var OutSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)"; var SCParametersCollection: Record "SC - Parameters Collection"; MaxLinesToLoad: Integer; var TmpInteractionLogEntry: Record "Interaction Log Entry" temporary)
    var
        MICAInteractionActivities: Record "MICA Interaction Activities";
        TempOrderSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        TempLinesSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        TempLineSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
        LastDatemodified: DateTime;
        EmptyDate: DateTime;
        Nblines: Integer;
        StatusInt: Integer;

    begin
        EmptyDate := 0DT;
        TmpInteractionLogEntry.SETASCENDING("Entry No.", false);
        if TmpInteractionLogEntry.FindSet() then
            repeat
                Nblines := 0;
                MICAInteractionActivities.SetRange("Interaction No.", TmpInteractionLogEntry."Entry No.");
                NewIntercationInPage(SCParametersCollection);
                if CheckInteractToShowInPage(SCParametersCollection) then begin
                    if MICAInteractionActivities.FindLast() then
                        if MICAInteractionActivities."Ending Date" = 0DT then
                            LastDatemodified := MICAInteractionActivities."Creation Date"
                        else
                            LastDatemodified := MICAInteractionActivities."Ending Date";
                    OutSCXMLBufferdotNET.AddElement(TempOrderSCXMLBufferdotNET, 'Order', '');
                    TempOrderSCXMLBufferdotNET.AddFieldElement('InteractionNumber', copystr(Format(TmpInteractionLogEntry."Entry No."), 1, 1024));
                    TempOrderSCXMLBufferdotNET.AddFieldElement('Title', copystr(TmpInteractionLogEntry.Description, 1, 1024));
                    TempOrderSCXMLBufferdotNET.AddFieldElement('CreationDate', copystr(Format(DT2Date(TmpInteractionLogEntry."MICA Interaction Creation Date")), 1, 1024));
                    TempOrderSCXMLBufferdotNET.AddFieldElement('Creator', copystr(GetUserFullName(TmpInteractionLogEntry."User ID"), 1, 1024));
                    TempOrderSCXMLBufferdotNET.AddFieldElement('InteractionType', copystr(TmpInteractionLogEntry."Interaction Template Code", 1, 1024));
                    StatusInt := TmpInteractionLogEntry."MICA Request Status";
                    TempOrderSCXMLBufferdotNET.AddFieldElement('Status', copystr(Format(StatusInt), 1, 1024));
                    TempOrderSCXMLBufferdotNET.AddFieldElement('LastModifiedDate', copystr(Format(DT2Date(LastDatemodified)), 1, 1024));
                    if TmpInteractionLogEntry."MICA Request Status" <> TmpInteractionLogEntry."MICA Request Status"::"Close the Case - CES" then
                        TempOrderSCXMLBufferdotNET.AddFieldElement('CESScore', '')
                    else
                        TempOrderSCXMLBufferdotNET.AddFieldElement('CESScore', format(TmpInteractionLogEntry."MICA CES Evaluation"));
                    TempOrderSCXMLBufferdotNET.AddFieldElement('LinesCount', copystr(Format(MICAInteractionActivities.Count()), 1, 1024));
                    if (MaxLinesToLoad > 0) then begin
                        MICAInteractionActivities.Reset();
                        MICAInteractionActivities.SetRange("Interaction No.", TmpInteractionLogEntry."Entry No.");
                        if MICAInteractionActivities.FindSet() then
                            TempOrderSCXMLBufferdotNET.AddElement(TempLinesSCXMLBufferdotNET, 'SalesLines', '');
                        if Nblines < MaxLinesToLoad then
                            AddRequesteDescription(TempLinesSCXMLBufferdotNET, TmpInteractionLogEntry, Nblines);
                        repeat
                            Nblines += 1;
                            TempLinesSCXMLBufferdotNET.AddElement(TempLineSCXMLBufferdotNET, 'SalesLine', '');
                            TempLineSCXMLBufferdotNET.AddFieldElement('LineNo', copystr(Format(Nblines), 1, 1024));
                            if MICAInteractionActivities."Ending Date" <> EmptyDate then
                                TempLineSCXMLBufferdotNET.AddFieldElement('Date', copystr(Format(DT2Date(MICAInteractionActivities."Ending Date")), 1, 1024))
                            else
                                TempLineSCXMLBufferdotNET.AddFieldElement('Date', copystr(Format(DT2Date(MICAInteractionActivities."Creation Date")), 1, 1024));
                            TempLineSCXMLBufferdotNET.AddFieldElement('CommentType', '2');
                            TempLineSCXMLBufferdotNET.AddFieldElement('Comment', copystr(MICAInteractionActivities.GetPublicComment(), 1, 1024));
                        until (MICAInteractionActivities.Next() = 0) or (Nblines >= MaxLinesToLoad);

                        if Nblines < MaxLinesToLoad then
                            AddPublicConclusion(TempLinesSCXMLBufferdotNET, TmpInteractionLogEntry, Nblines);

                        if Nblines < MaxLinesToLoad then
                            AddCESComment(TempLinesSCXMLBufferdotNET, TmpInteractionLogEntry, Nblines);
                    end;
                end;
            until TmpInteractionLogEntry.Next() = 0;
    end;

    local procedure AddRequesteDescription(var LinesSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary; var TmpInteractionLogEntry: Record "Interaction Log Entry" temporary; var Nblines: Integer)
    var
        InteractionLogEntry: Record "Interaction Log Entry";
        TempLineSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
    begin
        if not InteractionLogEntry.get(TmpInteractionLogEntry."Entry No.") then exit;
        if InteractionLogEntry.GetRequestDescription() = '' then exit;

        Nblines += 1;
        LinesSCXMLBufferdotNET.AddElement(TempLineSCXMLBufferdotNET, 'SalesLine', '');
        TempLineSCXMLBufferdotNET.AddFieldElement('LineNo', copystr(Format(Nblines), 1, 1024));
        TempLineSCXMLBufferdotNET.AddFieldElement('Date', copystr(Format(DT2Date(TmpInteractionLogEntry."MICA Interaction Creation Date")), 1, 1024));
        TempLineSCXMLBufferdotNET.AddFieldElement('CommentType', '1');
        TempLineSCXMLBufferdotNET.AddFieldElement('Comment', copystr(InteractionLogEntry.GetRequestDescription(), 1, 1024));
    end;

    local procedure AddPublicConclusion(var LinesSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary; var TmpInteractionLogEntry: Record "Interaction Log Entry" temporary; var Nblines: Integer)
    var
        InteractionLogEntry: Record "Interaction Log Entry";
        MICAInteractionActivities: Record "MICA Interaction Activities";
        TempLineSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
    begin
        if not InteractionLogEntry.get(TmpInteractionLogEntry."Entry No.") then exit;
        if InteractionLogEntry.GetPublicClosingDesc() = '' then exit;

        Nblines += 1;
        MICAInteractionActivities.SetRange("Interaction No.", TmpInteractionLogEntry."Entry No.");
        LinesSCXMLBufferdotNET.AddElement(TempLineSCXMLBufferdotNET, 'SalesLine', '');
        TempLineSCXMLBufferdotNET.AddFieldElement('LineNo', copystr(Format(Nblines), 1, 1024));
        TempLineSCXMLBufferdotNET.AddFieldElement('Date', copystr(Format(DT2Date(TmpInteractionLogEntry."MICA Close the Case Date")), 1, 1024));
        TempLineSCXMLBufferdotNET.AddFieldElement('CommentType', '3');
        TempLineSCXMLBufferdotNET.AddFieldElement('Comment', copystr(InteractionLogEntry.GetPublicClosingDesc(), 1, 1024));
    end;

    local procedure AddCESComment(var LinesSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary; var TmpInteractionLogEntry: Record "Interaction Log Entry" temporary; var Nblines: Integer)
    var
        InteractionLogEntry: Record "Interaction Log Entry";
        MICAInteractionActivities: Record "MICA Interaction Activities";
        TempLineSCXMLBufferdotNET: Record "SC - XML Buffer (dotNET)" temporary;
    begin
        if not InteractionLogEntry.get(TmpInteractionLogEntry."Entry No.") then exit;
        if InteractionLogEntry.GetCESComment() = '' then exit;

        Nblines += 1;
        MICAInteractionActivities.SetRange("Interaction No.", TmpInteractionLogEntry."Entry No.");
        LinesSCXMLBufferdotNET.AddElement(TempLineSCXMLBufferdotNET, 'SalesLine', '');
        TempLineSCXMLBufferdotNET.AddFieldElement('LineNo', copystr(Format(Nblines), 1, 1024));
        TempLineSCXMLBufferdotNET.AddFieldElement('Date', copystr(Format(DT2Date(TmpInteractionLogEntry."MICA Close the Case - CES Date")), 1, 1024));
        TempLineSCXMLBufferdotNET.AddFieldElement('CommentType', '4');
        TempLineSCXMLBufferdotNET.AddFieldElement('Comment', copystr(InteractionLogEntry.GetCESComment(), 1, 1024));
    end;

    local procedure NewIntercationInPage(var SCParametersCollection: Record "SC - Parameters Collection")
    begin
        if CurrentInteractIndex = SCParametersCollection.PageSize then begin
            CurrentInteractIndex := 1;
            CurrentPageIndex += 1;
        end else
            CurrentInteractIndex += 1
    end;

    local procedure CheckInteractToShowInPage(var SCParametersCollection: Record "SC - Parameters Collection"): Boolean
    begin
        if SCParametersCollection.PageSize <> 0 then
            exit(CurrentPageIndex = SCParametersCollection.PageIndex)
        else
            exit(true);
    end;

    local procedure GetUserFullName(UserId: Code[50]): Text
    var
        User: Record User;
    begin
        User.SetCurrentKey("User Name");
        User.SetRange("User Name", UserId);
        if User.FindFirst() then
            exit(User."Full Name");
    end;
}