report 50001 "BalanceSheet-Assets"
{
    // version TaxReturn V06.04.20

    DefaultLayout = RDLC;
    RDLCLayout = './BalanceSheet-Assets.rdlc';
    PreviewMode = PrintLayout;
    UseRequestPage = true;

    dataset
    {
        dataitem(DataItem1;Table17)
        {
            DataItemTableView = SORTING(G/L Account No.,Posting Date)
                                ORDER(Ascending);
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Posting Date";
            column(GLAccountNo_GLEntry;"G/L Entry"."G/L Account No.")
            {
            }
            column(PostingDate_GLEntry;"G/L Entry"."Posting Date")
            {
            }
            column(Description_GLEntry;"G/L Entry".Description)
            {
            }
            column(Amount_GLEntry;"G/L Entry".Amount)
            {
            }
            column(DebitAmount_GLEntry;"G/L Entry"."Debit Amount")
            {
            }
            column(CreditAmount_GLEntry;"G/L Entry"."Credit Amount")
            {
            }
            dataitem(DataItem2;Table79)
            {
                DataItemTableView = SORTING(Primary Key)
                                    ORDER(Ascending);
                column(Name_CompanyInformation;"Company Information".Name)
                {
                }
                column(Address_CompanyInformation;"Company Information".Address)
                {
                }
                column(CISD_CompanyInformation;"Company Information".CISD)
                {
                }
                column(RegistrationNo_CompanyInformation;"Company Information"."Registration No.")
                {
                }
                column(BDate;BDate)
                {
                }
                column(GWMtBrut;GWMtBrut)
                {
                }
                column(GWAmort;GWAmort)
                {
                }
                column(GWNet;GWNet)
                {
                }
                column(GWNet_1;GWNet_1)
                {
                }
                column(IAMtBrut_20_207;IAMtBrut_20_207)
                {
                }
                column(IAAmort;IAAmort)
                {
                }
                column(IANet;IANet)
                {
                }
                column(IANet_1;IANet_1)
                {
                }
                column(TATerMtBrut;TATerMtBrut)
                {
                }
                column(TABuildMtBrut;TABuildMtBrut)
                {
                }
                column(TABuildMtAmort;TABuildMtAmort)
                {
                }
                column(TAMiscMtBrut;TAMiscMtBrut)
                {
                }
                column(TAMiscMtAmort;TAMiscMtAmort)
                {
                }
                column(TAConceBrut;TAConceBrut)
                {
                }
                column(TAConceAmort;TAConceAmort)
                {
                }
                column(AUCMtBrut_23;AUCMtBrut_23)
                {
                }
                column(AUCAmort_293;AUCAmort_293)
                {
                }
                column(AUCNet;AUCNet)
                {
                }
                column(AUCNet_1;AUCNet_1)
                {
                }
                column(TABuildNet;TABuildNet)
                {
                }
                column(TABuildNet_1;TABuildNet_1)
                {
                }
                column(TAMiscNet;TAMiscNet)
                {
                }
                column(TAMiscNet_1;TAMiscNet_1)
                {
                }
                column(TAConceNet;TAConceNet)
                {
                }
                column(TAConceNet_1;TAConceNet_1)
                {
                }
                column(IEMtBrut;IEMtBrut)
                {
                }
                column(IEAmort;IEAmort)
                {
                }
                column(IEMt_Net;IEMt_Net)
                {
                }
                column(IEMt_Net_1;IEMt_Net_1)
                {
                }
                column(PIRRMtBrut;PIRRMtBrut)
                {
                }
                column(PIRRNet;PIRRNet)
                {
                }
                column(PIRRNet_1;PIRRNet_1)
                {
                }
                column(IEMiscMtBrut_271_272_273;IEMiscMtBrut_271_272_273)
                {
                }
                column(IEMiscNet_271_272_273;IEMiscNet_271_272_273)
                {
                }
                column(IEMiscNet_1_271_272_273;IEMiscNet_1_271_272_273)
                {
                }
                column(LTFAMtBrut_274_275_276;LTFAMtBrut_274_275_276)
                {
                }
                column(LTFAAmort_274_275_276;LTFAAmort_274_275_276)
                {
                }
                column(LTFNet_274_275_276;LTFNet_274_275_276)
                {
                }
                column(LTFNet_1_274_275_276;LTFNet_1_274_275_276)
                {
                }
                column(GTCurrentAssets;GTCurrentAssets)
                {
                }
                column(TotalAmort;TotalAmort)
                {
                }
                column(TotalNet;TotalNet)
                {
                }
                column(TotalNet_1;TotalNet_1)
                {
                }
                column(InWIPMtBrut_30_38;InWIPMtBrut_30_38)
                {
                }
                column(InWIPAmort_39;InWIPAmort_39)
                {
                }
                column(InWIP_Net;InWIP_Net)
                {
                }
                column(InWIP_Net_1;InWIP_Net_1)
                {
                }
                column(TATerNet;TATerNet)
                {
                }
                column(TATerNet_1;TATerNet_1)
                {
                }
                column(ClientsMtBrut_41_419;ClientsMtBrut_41_419)
                {
                }
                column(ClientsAmort_491;ClientsAmort_491)
                {
                }
                column(Clients_Net;Clients_Net)
                {
                }
                column(Clients_Net_1;Clients_Net_1)
                {
                }
                column(MiscDrMtBrut_Net;MiscDrMtBrut_Net)
                {
                }
                column(MiscDrAmort_495_496_Net;MiscDrAmort_495_496_Net)
                {
                }
                column(MiscDr_Net;MiscDr_Net)
                {
                }
                column(MiscDr_Net_1;MiscDr_Net_1)
                {
                }
                column(TaxImpMtBrut_444_445_447_Net;TaxImpMtBrut_444_445_447_Net)
                {
                }
                column(TaxImpAmort_Net;TaxImpAmort_Net)
                {
                }
                column(TaxImp_Net;TaxImp_Net)
                {
                }
                column(TaxImp_Net_1;TaxImp_Net_1)
                {
                }
                column(MiscCurAsMtBrut_Dr_48_Net;MiscCurAsMtBrut_Dr_48_Net)
                {
                }
                column(MiscCurAsAmort_Net;MiscCurAsAmort_Net)
                {
                }
                column(MiscCurAs_Net;MiscCurAs_Net)
                {
                }
                column(MiscCurAs_Net_1;MiscCurAs_Net_1)
                {
                }
                column(InvFinAsMtBrut_Net;InvFinAsMtBrut_Net)
                {
                }
                column(InvFinAsAmort_Net;InvFinAsAmort_Net)
                {
                }
                column(InvFinAs_Net;InvFinAs_Net)
                {
                }
                column(InvFinAs_Net_1;InvFinAs_Net_1)
                {
                }
                column(CasFlowMtBrut_Net;CasFlowMtBrut_Net)
                {
                }
                column(CasFlowAmort_59_Net;CasFlowAmort_59_Net)
                {
                }
                column(CasFlow_Net;CasFlow_Net)
                {
                }
                column(CasFlow_Net_1;CasFlow_Net_1)
                {
                }
                column(CurAssGrandTotal;CurAssGrandTotal)
                {
                }
                column(CurAssAmortTotal;CurAssAmortTotal)
                {
                }
                column(CurAssNetTotal;CurAssNetTotal)
                {
                }
                column(CurAssNet_1_Total;CurAssNet_1_Total)
                {
                }
                column(AssetsGrandTotal;AssetsGrandTotal)
                {
                }
                column(AssetsAmort;AssetsAmort)
                {
                }
                column(AssetsNet;AssetsNet)
                {
                }
                column(AssetsNet_1;AssetsNet_1)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                //*******************Goodwill******************************
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'207*');
                GL.CALCSUMS(Amount);
                GWMtBrut := GL.Amount;
                //--------------------------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'2807*|2907*');
                GL.CALCSUMS(Amount);
                GWAmort := GL.Amount;
                //--------------------------------------
                GWNet := GWMtBrut - GWAmort;
                //--------------------------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'207*');
                GL.CALCSUMS(Amount);
                GWMtBrut_1 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'2807*|2907*');
                GL.CALCSUMS(Amount);
                GWAmort_1 := GL.Amount;
                GWNet_1 := GWMtBrut_1 - GWAmort_1;
                //*******************Intangible Assets******************************
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'20*');
                GL.CALCSUMS(Amount);
                IAMtBrut_20 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'207*');
                GL.CALCSUMS(Amount);
                IAMtBrut_207 := GL.Amount;
                IAMtBrut_20_207 := IAMtBrut_20 - IAMtBrut_207;
                //--------------------------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'280*');
                GL.CALCSUMS(Amount);
                IAAmort_280 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'2807*');
                GL.CALCSUMS(Amount);
                IAAmort_2807 := GL.Amount;
                IAAmort_280_2807 := IAAmort_280 - IAAmort_2807;

                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'290*');
                GL.CALCSUMS(Amount);
                IAAmort_290 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'2907*');
                GL.CALCSUMS(Amount);
                IAAmort_2907 := GL.Amount;
                IAAmort_290_2907 := IAAmort_290 - IAAmort_2907;
                IAAmort := IAAmort_280_2807 + IAAmort_290_2907;
                //--------------------------------------
                IANet := IAMtBrut_20_207 - IAAmort;
                //--------------------------------------
                //Take your time and catch your breath, this is the N-1 part filtered by DDate initialised up there.

                //We set MontantBrut column to N-1 here which is 20* - 207*
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'20*');
                GL.CALCSUMS(Amount);
                IAMtBrut_20_1 := GL.Amount;
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'207*');
                GL.CALCSUMS(Amount);
                IAMtBrut_207_1 := GL.Amount;
                IAMtBrut_20_207_1 := IAMtBrut_20_1 - IAMtBrut_207_1;
                //????????????????????????????????????????
                //Comes then the Amortisation part to be set on N-1, that would be 280*-2807* and 290*-2907*, again with DDate
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'280*');
                GL.CALCSUMS(Amount);
                IAAmort_280_1 := GL.Amount;
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'2807*');
                GL.CALCSUMS(Amount);
                IAAmort_2807_1 := GL.Amount;
                IAAmort_280_2807_1 := IAAmort_280_1 - IAAmort_2807_1;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'290*');
                GL.CALCSUMS(Amount);
                IAAmort_290_1 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'2907*');
                GL.CALCSUMS(Amount);
                IAAmort_2907_1 := GL.Amount;
                IAAmort_290_2907_1 := IAAmort_290_1 - IAAmort_2907_1;
                //????????????????????????????????????????
                //This final part is the coup de gras which sums up (280*-2807*) and (290*-2907*)
                IANet_1 := IAAmort_280_2807_1 + IAAmort_290_2907_1;
                //*******************Tangible Assets******************************
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'211*');
                GL.CALCSUMS(Amount);
                TATerMtBrut := GL.Amount;
                //????????????????????????????????????????
                TATerNet := TATerMtBrut; // no amortisation for terrain so Gross total is assigned to Net
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'211*');
                GL.CALCSUMS(Amount);
                TATerNet_1 := GL.Amount;
                //No amortisation for terrains
                //--------------------------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'213*');
                GL.CALCSUMS(Amount);
                TABuildMtBrut := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'2813*');
                GL.CALCSUMS(Amount);
                TABuildMtAmort := GL.Amount;
                //????????????????????????????????????????
                TABuildNet := TABuildMtBrut - TABuildMtAmort;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'213*');
                GL.CALCSUMS(Amount);
                TABuildMtBrut_1 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'2813*');
                GL.CALCSUMS(Amount);
                TABuildMtAmort_1 := GL.Amount;
                //????????????????????????????????????????
                TABuildNet_1 := TABuildMtBrut_1 - TABuildMtAmort_1;
                //--------------------------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'218*');
                GL.CALCSUMS(Amount);
                TAMiscMtBrut := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'2818*');
                GL.CALCSUMS(Amount);
                TAMiscMtAmort := GL.Amount;
                //--------------------------------------
                TAMiscNet := TAMiscMtBrut - TAMiscMtAmort;
                //--------------------------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'218*');
                GL.CALCSUMS(Amount);
                TAMiscMtBrut_1 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'2818*');
                GL.CALCSUMS(Amount);
                TAMiscMtAmort_1 := GL.Amount;
                //--------------------------------------
                TAMiscNet_1 := TAMiscMtBrut_1 - TAMiscMtAmort_1;
                //--------------------------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'22*');
                GL.CALCSUMS(Amount);
                TAConceMtBrut_22 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'229*');
                GL.CALCSUMS(Amount);
                TAConceMtBrut_229 := GL.Amount;

                TAConceBrut := TAConceMtBrut_22 - TAConceMtBrut_229;
                //--------------------------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'282*');
                GL.CALCSUMS(Amount);
                TAConceAmort := GL.Amount;
                //--------------------------------------
                TAConceNet := TAConceBrut - TAConceAmort;
                //--------------------------------------

                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'22*');
                GL.CALCSUMS(Amount);
                TAConceMtBrut_22_1 := GL.Amount;
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'229*');
                GL.CALCSUMS(Amount);
                TAConceMtBrut_229_1 := GL.Amount;

                TAConceBrut_1 := TAConceMtBrut_22_1 - TAConceMtBrut_229_1;

                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'282*');
                GL.CALCSUMS(Amount);
                TAConceAmort_1 := GL.Amount;

                TAConceNet_1 := TAConceBrut_1 - TAConceAmort_1;
                //--------------------------------------

                //*******************Assets under construction********************
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',BDate);
                GL.SETFILTER("G/L Account No.",'23*');
                GL.CALCSUMS(Amount);
                AUCMtBrut_23 := GL.Amount;
                //--------------------------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',BDate);
                GL.SETFILTER("G/L Account No.",'293*');
                GL.CALCSUMS(Amount);
                AUCAmort_293 := GL.Amount;
                //--------------------------------------
                AUCNet := AUCMtBrut_23 - AUCAmort_293;
                //--------------------------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',DDate);
                GL.SETFILTER("G/L Account No.",'23*');
                GL.CALCSUMS(Amount);
                AUCMtBrut_23_1 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',DDate);
                GL.SETFILTER("G/L Account No.",'293*');
                GL.CALCSUMS(Amount);
                AUCAmort_293_1 := GL.Amount;
                //--------------------------------------
                AUCNet_1 := AUCMtBrut_23_1 - AUCAmort_293_1;
                //---------------Investments in equity-----------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',BDate);
                GL.SETFILTER("G/L Account No.",'265*');
                GL.CALCSUMS(Amount);
                IEMtBrut := GL.Amount;
                //????????????????????????????????????????
                IEAmort := 0; // No amortisation
                //????????????????????????????????????????
                IEMt_Net := IEMtBrut - IEAmort;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',DDate);
                GL.SETFILTER("G/L Account No.",'265*');
                GL.CALCSUMS(Amount);
                IEMtBrutNet_1 := GL.Amount;
                //????????????????????????????????????????
                IEAmortNet_1 := 0;
                //????????????????????????????????????????
                IEMt_Net_1 := IEMtBrutNet_1 - IEAmortNet_1;
                //---------Other participating interests and related receivables-------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',BDate);
                GL.SETFILTER("G/L Account No.",'26*');
                GL.CALCSUMS(Amount);
                PIRRMtBrut_26 := GL.Amount;

                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',BDate);
                GL.SETFILTER("G/L Account No.",'265*');
                GL.CALCSUMS(Amount);
                PIRRMtBrut_265 := GL.Amount;

                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',BDate);
                GL.SETFILTER("G/L Account No.",'269*');
                GL.CALCSUMS(Amount);
                PIRRMtBrut_269 := GL.Amount;

                PIRRMtBrut := PIRRMtBrut_26 - ( PIRRMtBrut_265 + PIRRMtBrut_269);
                //????????????????????????????????????????
                PIRRNet := PIRRMtBrut; //No amortisation to be processed.
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',DDate);
                GL.SETFILTER("G/L Account No.",'26*');
                GL.CALCSUMS(Amount);
                PIRRMtBrut_26_1 := GL.Amount;

                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',DDate);
                GL.SETFILTER("G/L Account No.",'265*');
                GL.CALCSUMS(Amount);
                PIRRMtBrut_265_1 := GL.Amount;

                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',DDate);
                GL.SETFILTER("G/L Account No.",'269*');
                GL.CALCSUMS(Amount);
                PIRRMtBrut_269_1 := GL.Amount;

                PIRRMtBrut_Net_1 := PIRRMtBrut_26_1 - (PIRRMtBrut_265_1+PIRRMtBrut_269_1);

                PIRRNet_1 := PIRRMtBrut_Net_1;
                //------------------Misc Investments in equity --------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',BDate);
                GL.SETFILTER("G/L Account No.",'271*|272*|273*');
                GL.CALCSUMS(Amount);
                IEMiscMtBrut_271_272_273 := GL.Amount;
                //????????????????????????????????????????
                IEMiscAmort_271_272_273 := 0;
                //????????????????????????????????????????
                IEMiscNet_271_272_273 := IEMiscMtBrut_271_272_273 - IEMiscAmort_271_272_273;
                //--------------------------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',DDate);
                GL.SETFILTER("G/L Account No.",'271*|272*|273*');
                GL.CALCSUMS(Amount);
                IEMiscMtBrut_271_272_273_1 := GL.Amount;
                IEMiscAmort_271_272_273_1 := 0; //No amortisation to be processed.

                IEMiscNet_1_271_272_273 := IEMiscMtBrut_271_272_273_1 -IEMiscAmort_271_272_273_1;
                //-------------------Long-term financial assets-------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',BDate);
                GL.SETFILTER("G/L Account No.",'274*|275*|276*');
                GL.CALCSUMS(Amount);
                LTFAMtBrut_274_275_276 := GL.Amount;
                //????????????????????????????????????????
                LTFAAmort_274_275_276 := 0; //No amortisation to be processed.
                //????????????????????????????????????????
                LTFNet_274_275_276 := LTFAMtBrut_274_275_276 - LTFAAmort_274_275_276;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'%1',DDate);
                GL.SETFILTER("G/L Account No.",'274*|275*|276*');
                GL.CALCSUMS(Amount);
                LTFAMtBrut_274_275_276_1 := GL.Amount;
                LTFAAmort_274_275_276_1 := 0;

                LTFNet_1_274_275_276 := LTFAMtBrut_274_275_276_1 - LTFAAmort_274_275_276_1;
                //--------------------------------------
                GTCurrentAssets := GWMtBrut + IAMtBrut_20_207 + TATerMtBrut + TABuildMtBrut + TAMiscMtBrut + TAConceBrut + LTFAMtBrut_274_275_276 + IEMiscMtBrut_271_272_273 + PIRRMtBrut + AUCMtBrut_23 + IEMtBrut;
                //--------------------------------------
                TotalAmort := GWAmort + IAAmort + TABuildMtAmort + TAMiscMtAmort + TAConceAmort + LTFAAmort_274_275_276 + IEMiscAmort_271_272_273 + AUCAmort_293 + IEAmort;
                //--------------------------------------
                TotalNet := GWNet + IANet + TATerNet + TABuildNet + TAMiscNet + TAConceNet  + LTFNet_274_275_276 + IEMiscNet_271_272_273  + PIRRNet + AUCNet + IEMt_Net ;
                //--------------------------------------
                TotalNet_1 := GWNet_1 + IANet_1 + TATerNet_1 + TABuildNet_1 + TAMiscNet_1 + TAConceNet_1 + AUCNet_1 + IEMt_Net_1 + PIRRNet_1 + IEMiscNet_1_271_272_273 + LTFNet_1_274_275_276;
                //-------------------Inventory & Work In Progress-------------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'30*|31*|32*|33*|34*|35*|36*|37*|38*');
                GL.CALCSUMS(Amount);
                InWIPMtBrut_30_38 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'39*');
                GL.CALCSUMS(Amount);
                InWIPAmort_39 := GL.Amount;
                //????????????????????????????????????????
                InWIP_Net  := InWIPMtBrut_30_38 - InWIPAmort_39;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'30*|31*|32*|33*|34*|35*|36*|37*|38*');
                GL.CALCSUMS(Amount);
                InWIPMtBrut_30_38_Net_1 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'39*');
                GL.CALCSUMS(Amount);
                InWIPAmort_39_Net_1 := GL.Amount;
                //????????????????????????????????????????
                InWIP_Net_1 := InWIPMtBrut_30_38_Net_1 - InWIPAmort_39_Net_1;
                //---------------------Accounts Receivable-----------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'41*');
                GL.CALCSUMS(Amount);
                ClientsMtBrut_41 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'419*');
                GL.CALCSUMS(Amount);
                ClientsMtBrut_419 := GL.Amount;
                //????????????????????????????????????????
                ClientsMtBrut_41_419 := ClientsMtBrut_41-ClientsMtBrut_419;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'491*');
                GL.CALCSUMS(Amount);
                ClientsAmort_491 := GL.Amount;
                //????????????????????????????????????????
                Clients_Net := ClientsMtBrut_41_419 - ClientsAmort_491;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'41*');
                GL.CALCSUMS(Amount);
                ClientsMtBrut_41_Net_1 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'419*');
                GL.CALCSUMS(Amount);
                ClientsMtBrut_419_Net_1 := GL.Amount;
                //????????????????????????????????????????
                ClientsMtBrut_41_419_Net_1 := ClientsMtBrut_419_Net_1 - ClientsMtBrut_419_Net_1;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'491*');
                GL.CALCSUMS(Amount);
                ClientsAmort_491_Net_1 := GL.Amount;
                //????????????????????????????????????????
                Clients_Net_1 := ClientsMtBrut_41_419_Net_1 - ClientsAmort_491_Net_1;
                //---------------------Misc Debitors-----------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'409*');
                GL.CALCSUMS(Amount);
                MiscDrMtBrut_409 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'42*|43*|44*|45*|46*|486*|489*');
                GL.CALCSUMS("Debit Amount");
                MiscDrMtBrut_42_43_44_45_46_486_489 := GL."Debit Amount";
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'444*|448*');
                GL.CALCSUMS("Debit Amount");
                MiscDrMtBrut_444_448 := GL."Debit Amount";
                //????????????????????????????????????????
                MiscDrMtBrut_Net :=  MiscDrMtBrut_409 + (MiscDrMtBrut_42_43_44_45_46_486_489 - MiscDrMtBrut_444_448);
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'495*|496*');
                GL.CALCSUMS(Amount);
                MiscDrAmort_495_496_Net := GL.Amount;
                //????????????????????????????????????????
                MiscDr_Net := MiscDrMtBrut_Net - MiscDrAmort_495_496_Net;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'409*');
                GL.CALCSUMS(Amount);
                MiscDrMtBrut_409_Net_1 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'42*|43*|44*|45*|46*|486*|489*');
                GL.CALCSUMS("Debit Amount");
                MiscDrMtBrut_42_43_44_45_46_486_489_Net_1 := GL."Debit Amount";
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'444*|448*');
                GL.CALCSUMS("Debit Amount");
                MiscDrMtBrut_444_448_Net_1 := GL."Debit Amount";
                //????????????????????????????????????????
                MiscDrMtBrut_Net_1 :=  MiscDrMtBrut_409_Net_1 + (MiscDrMtBrut_42_43_44_45_46_486_489_Net_1 - MiscDrMtBrut_444_448_Net_1);
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'495*|496*');
                GL.CALCSUMS(Amount);
                MiscDrAmort_495_496_Net_1 := GL.Amount;
                //????????????????????????????????????????
                MiscDr_Net_1 := MiscDrMtBrut_Net_1 - MiscDrAmort_495_496_Net_1;
                //---------------------Taxes and Imposition-----------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'444*|445*|447*');
                GL.CALCSUMS(Amount);
                TaxImpMtBrut_444_445_447_Net := GL.Amount;
                //????????????????????????????????????????
                TaxImpAmort_Net := 0; //No Amortisation
                //????????????????????????????????????????
                TaxImp_Net := TaxImpMtBrut_444_445_447_Net - TaxImpAmort_Net;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'444*|445*|447*');
                GL.CALCSUMS(Amount);
                TaxImpMtBrut_444_445_447_Net_1 := GL.Amount;
                //????????????????????????????????????????
                TaxImpAmort_Net_1 := 0; //No Amortisation
                //????????????????????????????????????????
                TaxImp_Net_1 := TaxImpMtBrut_444_445_447_Net_1 - TaxImpAmort_Net_1;
                //---------------------Misc Current Assets-----------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'48*');
                GL.CALCSUMS("Debit Amount");
                MiscCurAsMtBrut_Dr_48_Net := GL."Debit Amount";
                //????????????????????????????????????????
                MiscCurAsAmort_Net := 0; //No Amortisation
                //????????????????????????????????????????
                MiscCurAs_Net := MiscCurAsMtBrut_Dr_48_Net - MiscCurAsAmort_Net;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'48*');
                GL.CALCSUMS("Debit Amount");
                MiscCurAsMtBrut_Dr_48_Net_1 := GL."Debit Amount";
                //????????????????????????????????????????
                MiscCurAsAmort_Net_1 := 0; //No Amortisation
                //????????????????????????????????????????
                MiscCurAs_Net_1 := MiscCurAsMtBrut_Dr_48_Net_1 - MiscCurAsAmort_Net_1;
                //---------------------Investments and Financial Assets -----------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'50*');
                GL.CALCSUMS(Amount);
                InvFinAsMtBrut_50_Net := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'509*');
                GL.CALCSUMS(Amount);
                InvFinAsMtBrut_509_Net := GL.Amount;
                //????????????????????????????????????????
                InvFinAsMtBrut_Net := InvFinAsMtBrut_50_Net - InvFinAsMtBrut_509_Net;
                //????????????????????????????????????????
                InvFinAsAmort_Net := 0; //No Amortisation
                //????????????????????????????????????????
                InvFinAs_Net := InvFinAsMtBrut_Net - InvFinAsAmort_Net;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'50*');
                GL.CALCSUMS(Amount);
                InvFinAsMtBrut_50_Net_1 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'509*');
                GL.CALCSUMS(Amount);
                InvFinAsMtBrut_509_Net_1 := GL.Amount;
                //????????????????????????????????????????
                InvFinAsMtBrut_Net_1 := InvFinAsMtBrut_50_Net_1 - InvFinAsMtBrut_509_Net_1;
                //????????????????????????????????????????
                InvFinAsAmort_Net_1 := 0; //No Amortisation
                //????????????????????????????????????????
                InvFinAs_Net_1 := InvFinAsMtBrut_Net_1 - InvFinAsAmort_Net_1;
                //---------------------CashFlow-----------------
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'519*');
                GL.CALCSUMS(Amount);
                CasFlowMtBrut_519_Net := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'51*|52*|53*|54*');
                GL.CALCSUMS("Debit Amount");
                CasFlowMtBrut_Dr_51_52_53_54_Net := GL."Debit Amount";
                //????????????????????????????????????????
                CasFlowMtBrut_Net := CasFlowMtBrut_519_Net + CasFlowMtBrut_Dr_51_52_53_54_Net;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',BDate);
                GL.SETFILTER("G/L Account No.",'59*');
                GL.CALCSUMS(Amount);
                CasFlowAmort_59_Net := GL.Amount;
                //????????????????????????????????????????
                CasFlow_Net := CasFlowMtBrut_Net - CasFlowAmort_59_Net;
                //????????????????????????????????????????

                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'519*');
                GL.CALCSUMS(Amount);
                CasFlowMtBrut_519_Net_1 := GL.Amount;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'51*|52*|53*|54*');
                GL.CALCSUMS("Debit Amount");
                CasFlowMtBrut_Dr_51_52_53_54_Net_1 := GL."Debit Amount";
                //????????????????????????????????????????
                CasFlowMtBrut_Net_1 := CasFlowMtBrut_519_Net_1 + CasFlowMtBrut_Dr_51_52_53_54_Net_1;
                //????????????????????????????????????????
                GL.RESET;
                GL.SETCURRENTKEY("Posting Date","G/L Account No.");
                GL.SETFILTER("Posting Date",'..%1',DDate);
                GL.SETFILTER("G/L Account No.",'59*');
                GL.CALCSUMS(Amount);
                CasFlowAmort_59_Net_1 := GL.Amount;
                //????????????????????????????????????????
                CasFlow_Net_1 := CasFlowMtBrut_Net_1 - CasFlowAmort_59_Net_1;
                //--------------------------------------
                CurAssGrandTotal := InWIPMtBrut_30_38 + ClientsMtBrut_41_419 + MiscDrMtBrut_Net + TaxImpMtBrut_444_445_447_Net + MiscCurAsMtBrut_Dr_48_Net + InvFinAsMtBrut_Net + CasFlowMtBrut_Net;
                //????????????????????????????????????????
                CurAssAmortTotal := InWIPAmort_39 + ClientsAmort_491 + MiscDrAmort_495_496_Net + TaxImpAmort_Net + MiscCurAsAmort_Net + InvFinAsAmort_Net + CasFlowAmort_59_Net;
                //????????????????????????????????????????
                CurAssNetTotal := InWIP_Net + Clients_Net + MiscDr_Net + TaxImp_Net + MiscCurAs_Net + InvFinAs_Net + CasFlow_Net;
                //????????????????????????????????????????
                CurAssNet_1_Total := InWIP_Net_1 + Clients_Net_1 + MiscDr_Net_1 + TaxImp_Net_1 + MiscCurAs_Net_1 + InvFinAs_Net_1 + CasFlow_Net_1;
                //--------------------------------------
                AssetsGrandTotal := CurAssGrandTotal + GTCurrentAssets;
                //????????????????????????????????????????
                AssetsAmort := CurAssAmortTotal + TotalAmort;
                //????????????????????????????????????????
                AssetsNet := CurAssNetTotal + TotalNet;
                //????????????????????????????????????????
                AssetsNet_1 := CurAssNet_1_Total + TotalNet_1;
                //--------------------------------------
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        DateFilter := "G/L Entry".GETFILTER("Posting Date");
        EVALUATE(BDate,DateFilter);
        EVALUATE(DDate,DateFilter);
        BDate := CALCDATE('<CY>',BDate);
        DDate := CALCDATE('<CY-1Y>',DDate);
    end;

    var
        DateFilter: Text;
        GL: Record "17";
        BDate: Date;
        GWMtBrut: Decimal;
        GWAmort: Decimal;
        GWNet: Decimal;
        GWNet_1: Decimal;
        DDate: Date;
        GWMtBrut_1: Decimal;
        GWAmort_1: Decimal;
        IAAmort_280_2807: Decimal;
        IAMtBrut_20_207: Decimal;
        IAMtBrut_20: Decimal;
        IAMtBrut_207: Decimal;
        IAAmort_280: Decimal;
        IAAmort_2807: Decimal;
        IANet: Decimal;
        IANet_1: Decimal;
        IAMtBrut_1: Decimal;
        IAAmort_1: Decimal;
        IAAmort_290: Decimal;
        IAAmort_2907: Decimal;
        IAAmort_290_2907: Decimal;
        IAAmort: Decimal;
        IAMtBrut_20_1: Decimal;
        IAMtBrut_207_1: Decimal;
        IAMtBrut_20_207_1: Decimal;
        IAAmort_280_1: Decimal;
        IAAmort_2807_1: Decimal;
        IAAmort_280_2807_1: Decimal;
        IAAmort_290_1: Decimal;
        IAAmort_2907_1: Decimal;
        IAAmort_290_2907_1: Decimal;
        TATerMtBrut: Decimal;
        TATerNet: Decimal;
        TATerNet_1: Decimal;
        TABuildMtBrut: Decimal;
        TABuildMtBrut_1: Decimal;
        TABuildNet: Decimal;
        TABuildNet_1: Decimal;
        TAMiscMtBrut: Decimal;
        TAMiscMtBrut_1: Decimal;
        TAMiscNet: Decimal;
        TAMiscNet_1: Decimal;
        TAConceMtBrut_22: Decimal;
        TAConceMtBrut_22_1: Decimal;
        TAConceMtBrut_229: Decimal;
        TAConceMtBrut_229_1: Decimal;
        TAConceAmort: Decimal;
        TAConceAmort_1: Decimal;
        TAConceNet_1: Decimal;
        TABuildMtAmort: Decimal;
        TABuildMtAmort_1: Decimal;
        TAMiscMtAmort: Decimal;
        TAMiscMtAmort_1: Decimal;
        TAConceBrut: Decimal;
        TAConceBrut_1: Decimal;
        TAConceNet: Decimal;
        AUCMtBrut_23: Decimal;
        AUCAmort_293: Decimal;
        AUCNet: Decimal;
        AUCNet_1: Decimal;
        AUCMtBrut_23_1: Decimal;
        AUCAmort_293_1: Decimal;
        IEMtBrut: Decimal;
        IEMtBrutNet_1: Decimal;
        IEAmort: Decimal;
        IEAmortNet_1: Decimal;
        IEMt_Net: Decimal;
        IEMt_Net_1: Decimal;
        PIRRMtBrut_26: Decimal;
        PIRRMtBrut_26_1: Decimal;
        PIRRMtBrut_265: Decimal;
        PIRRMtBrut_265_1: Decimal;
        PIRRMtBrut_269: Decimal;
        PIRRMtBrut_269_1: Decimal;
        PIRRMtBrut: Decimal;
        PIRRMtBrut_Net_1: Decimal;
        PIRRNet: Decimal;
        PIRRNet_1: Decimal;
        IEMiscMtBrut_271_272_273: Decimal;
        IEMiscMtBrut_271_272_273_1: Decimal;
        IEMiscAmort_271_272_273: Decimal;
        IEMiscAmort_271_272_273_1: Decimal;
        IEMiscNet_271_272_273: Decimal;
        IEMiscNet_1_271_272_273: Decimal;
        LTFAMtBrut_274_275_276: Decimal;
        LTFAAmort_274_275_276: Decimal;
        LTFNet_274_275_276: Decimal;
        LTFAMtBrut_274_275_276_1: Decimal;
        LTFNet_1_274_275_276: Decimal;
        LTFAAmort_274_275_276_1: Decimal;
        GTCurrentAssets: Decimal;
        TotalAmort: Decimal;
        TotalNet: Decimal;
        TotalNet_1: Decimal;
        InWIPMtBrut_30_38: Decimal;
        InWIPMtBrut_30_38_Net_1: Decimal;
        InWIPAmort_39: Decimal;
        InWIPAmort_39_Net_1: Decimal;
        InWIP_Net: Decimal;
        InWIP_Net_1: Decimal;
        ClientsMtBrut_41: Decimal;
        ClientsMtBrut_419: Decimal;
        ClientsMtBrut_41_419: Decimal;
        ClientsAmort_491: Decimal;
        Clients_Net: Decimal;
        ClientsMtBrut_41_Net_1: Decimal;
        ClientsMtBrut_419_Net_1: Decimal;
        ClientsMtBrut_41_419_Net_1: Decimal;
        ClientsAmort_491_Net_1: Decimal;
        Clients_Net_1: Decimal;
        MiscDrMtBrut_409: Decimal;
        MiscDrMtBrut_42_43_44_45_46_486_489: Decimal;
        MiscDrMtBrut_444_448: Decimal;
        MiscDrMtBrut_Net: Decimal;
        MiscDrAmort_495_496_Net: Decimal;
        MiscDr_Net: Decimal;
        MiscDrMtBrut_409_Net_1: Decimal;
        MiscDrMtBrut_42_43_44_45_46_486_489_Net_1: Decimal;
        MiscDrMtBrut_444_448_Net_1: Decimal;
        MiscDrMtBrut_Net_1: Decimal;
        MiscDrAmort_495_496_Net_1: Decimal;
        MiscDr_Net_1: Decimal;
        TaxImpMtBrut_444_445_447_Net: Decimal;
        TaxImpAmort_Net: Decimal;
        TaxImp_Net: Decimal;
        TaxImpMtBrut_444_445_447_Net_1: Decimal;
        TaxImpAmort_Net_1: Decimal;
        TaxImp_Net_1: Decimal;
        MiscCurAsMtBrut_Dr_48_Net: Decimal;
        MiscCurAsAmort_Net: Decimal;
        MiscCurAs_Net: Decimal;
        MiscCurAsMtBrut_Dr_48_Net_1: Decimal;
        MiscCurAsAmort_Net_1: Decimal;
        MiscCurAs_Net_1: Decimal;
        InvFinAsMtBrut_50_Net: Decimal;
        InvFinAsMtBrut_509_Net: Decimal;
        InvFinAsMtBrut_Net: Decimal;
        InvFinAsAmort_Net: Decimal;
        InvFinAs_Net: Decimal;
        InvFinAsMtBrut_50_Net_1: Decimal;
        InvFinAsMtBrut_509_Net_1: Decimal;
        InvFinAsMtBrut_Net_1: Decimal;
        InvFinAsAmort_Net_1: Decimal;
        InvFinAs_Net_1: Decimal;
        CasFlowMtBrut_519_Net: Decimal;
        CasFlowMtBrut_Dr_51_52_53_54_Net: Decimal;
        CasFlowMtBrut_Net: Decimal;
        CasFlowAmort_59_Net: Decimal;
        CasFlow_Net: Decimal;
        CasFlowMtBrut_519_Net_1: Decimal;
        CasFlowMtBrut_Dr_51_52_53_54_Net_1: Decimal;
        CasFlowMtBrut_Net_1: Decimal;
        CasFlowAmort_59_Net_1: Decimal;
        CasFlow_Net_1: Decimal;
        CurAssGrandTotal: Decimal;
        CurAssAmortTotal: Decimal;
        CurAssNetTotal: Decimal;
        CurAssNet_1_Total: Decimal;
        AssetsGrandTotal: Decimal;
        AssetsAmort: Decimal;
        AssetsNet: Decimal;
        AssetsNet_1: Decimal;
}

