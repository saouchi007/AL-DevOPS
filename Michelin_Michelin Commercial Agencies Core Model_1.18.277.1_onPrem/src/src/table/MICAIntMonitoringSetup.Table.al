table 80879 "MICA Int. Monitoring Setup"
{

    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }

        field(100; "EndPoint Substitute Value 1"; Text[100])
        {
            caption = 'EndPoint Substitute Value 1';
            DataClassification = CustomerContent;

        }
        field(101; "EndPoint Substitute Value 2"; Text[100])
        {
            caption = 'EndPoint Substitute Value 2';
            DataClassification = CustomerContent;

        }

        field(102; "EndPoint Substitute Value 3"; Text[100])
        {
            caption = 'EndPoint Substitute Value 3';
            DataClassification = CustomerContent;

        }
        field(103; "EndPoint Substitute Value 4"; Text[100])
        {
            caption = 'EndPoint Substitute Value 4';
            DataClassification = CustomerContent;

        }

        field(104; "EndPoint Substitute Value 5"; Text[100])
        {
            caption = 'EndPoint Substitute Value 5';
            DataClassification = CustomerContent;

        }

        field(200; "Use Def. Windows Network Auth."; Boolean)
        {
            Caption = 'Use Def. Windows Network Auth.';
            DataClassification = CustomerContent;
        }
        field(300; "Discard Blob Name Containing"; Text[100])
        {
            Caption = 'Discard Blob Name Containing';
            DataClassification = CustomerContent;
        }
        field(310; "Disable Blob Prefix Control"; Boolean)
        {
            Caption = 'Disable Blob Prefix Control';
            DataClassification = CustomerContent;
        }
        field(400; "Force Add. Text On Close Error"; Boolean)
        {
            Caption = 'Force Add. Text On Close Error';
            DataClassification = CustomerContent;
        }
        field(500; "Enable API Detailed Log"; Boolean)
        {
            Caption = 'Enable API Detailed Log';
            DataClassification = CustomerContent;
        }
        field(600; "Confirm Buffer Record Deletion"; Boolean)
        {
            Caption = 'Confirm Buffer Record Deletion';
            DataClassification = CustomerContent;
        }
        field(700; "PGP Azure Function URI"; Text[250])
        {
            Caption = 'PGP Azure Function URI';
            DataClassification = CustomerContent;
        }
        field(710; "PGP Azure Function Key"; Text[250])
        {
            Caption = 'PGP Azure Function Key';
            DataClassification = CustomerContent;
        }
        field(720; "PGP File Extension"; Text[20])
        {
            Caption = 'PGP File Extension';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure InsertIfNotExists()
    var
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;

    procedure SetupHttpClient(var HttpClient: HttpClient)
    begin

        if not Get() then
            exit;
#if OnPremise            
        if "Use Def. Windows Network Auth." then
            HttpClient.UseDefaultNetworkWindowsAuthentication();
#endif
    end;


}