codeunit 80920 "MICA Flow Extract MT940"
{
    TableNo = "MICA Flow Entry";

    var
        MICAFlow: Record "MICA Flow";
        MICAFlowEntry: Record "MICA Flow Entry";
        FlowEntryEntryNo: Integer;
        DebitAmountParamTxt: Text;
        WrongFileErr: label 'File not MT940 bank message.';
        UnknowContentErr: label 'Wrong file content.';

    trigger OnRun()
    var
        MICAFlowBufferMT9402: Record "MICA Flow Buffer MT940-2";
        InStream: InStream;
        txt: Text;
    begin
        MICAFlow.Get(rec."Flow Code");
        MICAFlowEntry.Get(Rec."Entry No.");

        Rec.CalcFields(Blob);
        if not Rec.Blob.HasValue then
            exit;

        CheckFlowParam();

        Rec.Blob.CreateInStream(InStream);
        InStream.Read(txt);

        FlowEntryEntryNo := Rec."Entry No.";
        if FillFlowBuffer(txt) then begin
            Rec."Receive Status" := Rec."Receive Status"::Loaded;
            MICAFlowBufferMT9402.Reset();
            MICAFlowBufferMT9402.SetRange("Flow Entry No.", Rec."Entry No.");
            Rec."Buffer Count" := MICAFlowBufferMT9402.Count();
            Rec.Modify(true);
        end;
    end;

    local procedure FillFlowBuffer(MT940: Text): Boolean
    var
        MICAFlowBufferMT9402: Record "MICA Flow Buffer MT940-2";
    begin
        ParseMT940(MICAFlowBufferMT9402, MT940);
        exit(true);
    end;

    local procedure ParseMT940(var MICAFlowBufferMT9402: Record "MICA Flow Buffer MT940-2"; MT940: text)
    var
        Block: text;
    begin
        while MT940 <> '' do begin
            Block := ReadBlock(MT940);
            case CopyStr(Block, 2, 2) of
                '1:':
                    Block := Block;
                '2:':
                    if CopyStr(Block, 4, 4) <> 'O940' then
                        Error(WrongFileErr);
                '4:':
                    ReadBlock4(Block, MICAFlowBufferMT9402);
                else
                    Error(UnknowContentErr);
            end;
        end;
    end;

    local procedure ReadBlock(var MT940: Text): Text
    var
        txt: Text;
        i: Integer;
    begin
        if CopyStr(MT940, 1, 1) = '{' then begin
            i := StrPos(MT940, '}');
            txt := CopyStr(MT940, 1, i);
            MT940 := CopyStr(MT940, i + 1);

            while (MT940 <> '') and (MT940[1] <> '{') do
                MT940 := CopyStr(MT940, 2);

            txt := CopyStr(txt, 1, i);
            exit(txt);
        end else
            Error(UnknowContentErr);
    end;

    local procedure ReadBlock4(Block: text; var MICAFlowBufferMT9402: Record "MICA Flow Buffer MT940-2")
    var
        txt: Text;
        txt2: Text;
        AdditionalTransactionInfo100: Text[100];
        BankAccNoTxt: text[30];
        RawClosingBalanceDateTxt: Text[6];
        CurrencyCode: Code[3];
        StatementNoCode: Code[20];
        HeaderEntryNo: Integer;
        ClosingBalanceDate: Date;
    begin
        Clear(MICAFlowBufferMT9402);
        MICAFlowBufferMT9402.Validate("Flow Entry No.", FlowEntryEntryNo);
        MICAFlowBufferMT9402."Bank Account No." := CopyStr(GetNodeValue('25', Block), 1, 20);
        MICAFlowBufferMT9402."Statement No." := CopyStr(GetNodeValue('28C', Block), 1, 20); //Statement No.
        Set60F(GetNodeValue('60F', Block), MICAFlowBufferMT9402."Raw Open Balance Amount", MICAFlowBufferMT9402."Open Balance D/C");
        Set62F(GetNodeValue('62F', Block), MICAFlowBufferMT9402."Raw Closing Balance Amount", MICAFlowBufferMT9402."Raw Closing Balance Date", MICAFlowBufferMT9402."Currency Code", MICAFlowBufferMT9402."Closing Balance D/C");
        MICAFlowBufferMT9402.Insert(true); //Header
        HeaderEntryNo := MICAFlowBufferMT9402."Entry No.";
        BankAccNoTxt := MICAFlowBufferMT9402."Bank Account No.";
        CurrencyCode := MICAFlowBufferMT9402."Currency Code";
        StatementNoCode := MICAFlowBufferMT9402."Statement No.";
        RawClosingBalanceDateTxt := MICAFlowBufferMT9402."Raw Closing Balance Date";
        ClosingBalanceDate := MICAFlowBufferMT9402."Closing Balance Date";
        txt := GetNodeValue('61', Block);
        while txt <> '' do begin
            Clear(MICAFlowBufferMT9402);
            MICAFlowBufferMT9402.Validate("Flow Entry No.", FlowEntryEntryNo);
            MICAFlowBufferMT9402."Header Entry No." := HeaderEntryNo;
            Set61(txt, MICAFlowBufferMT9402."Raw Line Date", MICAFlowBufferMT9402."Raw Line Entry Date", MICAFlowBufferMT9402."Raw Line Amount", MICAFlowBufferMT9402."Transaction Text", MICAFlowBufferMT9402."Line Amount D/C");
            txt2 := GetNodeValue('86', Block);
            AdditionalTransactionInfo100 := CopyStr(MICAFlowBufferMT9402."Additional Transaction Info", 1, MaxStrLen(AdditionalTransactionInfo100));
            Set86(txt2, AdditionalTransactionInfo100);
            MICAFlowBufferMT9402."Additional Transaction Info" := AdditionalTransactionInfo100;
            MICAFlowBufferMT9402."Bank Account No." := BankAccNoTxt;
            MICAFlowBufferMT9402."Currency Code" := CurrencyCode;
            MICAFlowBufferMT9402."Statement No." := StatementNoCode;
            MICAFlowBufferMT9402."Raw Closing Balance Date" := RawClosingBalanceDateTxt;
            MICAFlowBufferMT9402."Closing Balance Date" := ClosingBalanceDate;
            MICAFlowBufferMT9402.Insert(true);
            txt := GetNodeValue('61', Block);
        end;
    end;

    local procedure GetNodeValue(Node: Text; var Block: Text): Text
    var
        Val: Text;
        txt: Text;
        NodeStart: Integer;
        NodeLength: Integer;
        LF: text;
        CRLF: array[2] of Char;
        NodeLbl: Label ':%1:', Comment = '%1', Locked = true;
    begin
        CRLF[1] := 13;
        CRLF[2] := 10;
        LF := Format(CRLF[1]) + Format(CRLF[2]);
        Node := StrSubstNo(NodeLbl, Node);
        NodeStart := StrPos(Block, Node);
        if NodeStart > 0 then begin
            txt := CopyStr(Block, NodeStart);
            if StrPos(txt, LF + ':') <> 0 then
                NodeLength := StrPos(txt, LF + ':') - 1
            else
                NodeLength := StrPos(txt, LF + '-}') - 1;

            Val := CopyStr(Block, NodeStart, NodeLength);
            Val := CopyStr(Val, StrLen(Node) + 1);
            Block := CopyStr(Block, 1, NodeStart) + CopyStr(Block, NodeStart + NodeLength + 1);
        end;
        exit(Val);
    end;

    local procedure Set60F(txt: Text; var OpenBalance: Text[15]; var DC: Text[1])
    begin
        // Tag						ex:60F:
        // D/C Mark 			(1 digit)		ex: C
        // Booking Date (yymmdd)	(6 digits) 	ex: 180906
        // Currency (ISO code)		(3 digits) 	ex: COP
        // Amount: 			(15 digits) 	ex: 26382,85 = credit balance of 26382,85 Cop
        DC := txt[1];
        OpenBalance := CopyStr(txt, 11, 15);
    end;

    local procedure Set62F(txt: Text; var EndingBalance: Text[15]; var StatementDate: Text[6]; var Currency: Code[3]; var DC: Text[1])
    begin
        // Tag						ex:62F
        // D/C mark	 		(1 digit)		ex: C
        // Date (yymmdd)	 		(6 digit)		ex: 190212
        // Currency			(3 digit)		ex: COP
        // Amount			(15 digit)	ex: 251128,58 = credit balance of 251281,58 Cop
        DC := txt[1];
        StatementDate := CopyStr(txt, 2, 6);
        Currency := CopyStr(txt, 8, 3);
        EndingBalance := CopyStr(txt, 11, 15);
    end;

    local procedure Set61(txt: Text; var ValueDate: Text[6]; var EntryDate: Text[6]; var StatementAmount: Text[15]; var TransactionText: Text[140]; var LineAmountDC: Text[2])
    var
        i: Integer;
        EntryReason: Text[3];
        LF: Text[1];
    begin
        // Tag							ex:61:
        // Date (yymmdd)	 			(6 digits)	ex: 190212
        // Entry Date (mmdd)			(4 digits)	ex: 0212
        // D/C mark	 			(2 digits)	ex: CP 		(Ref 1)
        // Amount				(15 digits)	ex: 363592,78
        // Entry Method				(1 digit)		ex: N (always)
        // Entry Reason				(3 digits)	ex: TRF		(Ref 2)
        // Reference for the Account Owner	(16 digits)	ex: NTRF3938 	(Ref 3)
        // Supplementary details			(16 digits)	ex: /CTC/690/TRA	(Ref 4)
        //:1901110111CP810107403,28NTRFTRASLADO
        //:/CTC/548/CR ZBA-SMART ACCOUNT
        LF[1] := 10;
        ValueDate := CopyStr(txt, 1, 6);
        if Evaluate(i, CopyStr(txt, 1, 2) + CopyStr(txt, 7, 4)) then begin //does Entry Date exist ?
            EntryDate := CopyStr(txt, 1, 2) + CopyStr(txt, 7, 4);
            txt := CopyStr(txt, 11);
        end else
            txt := CopyStr(txt, 7);

        LineAmountDC := CopyStr(txt, 1, 2);
        txt := CopyStr(txt, 3);
        StatementAmount := CopyStr(CopyStr(txt, 1, StrPos(txt, 'N') - 1), 1, 15);
        txt := CopyStr(txt, StrPos(txt, 'N') + 1);
        EntryReason := CopyStr(txt, 1, 3); //related table 
        TransactionText := EntryReason;
        txt := CopyStr(txt, 4);
        TransactionText += ' ' + CopyStr(txt, 1, StrPos(txt, LF) - 1);
        txt := CopyStr(txt, StrPos(txt, LF) + 1);
        TransactionText += ' ' + CopyStr(txt, 1);
    end;

    local procedure Set86(txt: Text; var AddInfo: Text[100])
    var
        LF: Text[1];
    begin
        LF[1] := 10;
        txt := CopyStr(txt, 5);
        txt := ConvertStr(txt, LF, ' ');
        while StrPos(txt, '  ') <> 0 do
            txt := CopyStr(txt, 1, StrPos(txt, '  ') - 1) + CopyStr(txt, StrPos(txt, '  ') + 1);
        AddInfo := CopyStr(txt, 1, 100);
    end;

    local procedure CheckFlowParam()
    var
        MICAFlowSetup: record "MICA Flow Setup";
        MICAFlowInformation: record "MICA Flow Information";
        FlowParamMissingErr: Label 'For %1 %2, %3 ''%4'' is missing.', comment = '%1 = Flow table caption ; %2 = Flow code ; %3 = Flow setup table caption ; %4 = Flow setup param code';
    begin
        DebitAmountParamTxt := CopyStr(MICAFlowSetup.GetFlowTextParam(MICAFlow.Code, 'DEBITAMTPARAMCODE'), 1, 20);
        if DebitAmountParamTxt = '' then
            MICAFlowEntry.AddInformation(MICAFlowInformation."Info Type"::Error, StrSubstNo(FlowParamMissingErr, MICAFlow.TableCaption(), MICAFlow.Code, MICAFlowSetup.TableCaption(), 'DEBITAMTPARAMCODE'), '');
    end;
}