/// <summary>
/// Table Payroll Manager (ID 52182503).
/// </summary>
table 52182503 "Payroll Manager"
//table 39108476 "Payroll Manager"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Manager',
                FRA = 'Gestionnaire de paie';
    //LookupPageID = 119;

    fields
    {
        field(1; "User ID"; Code[40])
        {
            CaptionML = ENU = 'User ID',
                        FRA = 'Code utilisateur';
            NotBlank = true;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup();
            var
                LoginMgt: Record 52182503;
            begin
                LoginMgt.LookupUserID("User ID");
            end;

            trigger OnValidate();
            var
                LoginMgt: Record 52182503;
            begin
                LoginMgt.ValidateUserID("User ID");
            end;
        }
        field(2; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
            TableRelation = "Company Business Unit";
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
        }
        key(Key2; "Company Business Unit Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        GLSetup: Record 98;
        Text01: TextConst ENU = 'You can only have one default location per user ID.', FRA = 'Vous pouvez uniquement avoir une direction par défaut par code utilisateur.';


    procedure ValidateUserID(UserName: Code[50]);
    var
        User: Record 2000000120;
    begin
        IF UserName <> '' THEN BEGIN
            User.SETCURRENTKEY("User Name");
            User.SETRANGE("User Name", UserName);
            IF NOT User.FINDFIRST THEN BEGIN
                User.RESET;
                IF NOT User.ISEMPTY THEN
                    ERROR(Text000, UserName);
            END;
        END;
    end;


    procedure LookupUserID(var UserName: Code[50]);
    var
        SID: Guid;
    begin
        LookupUser(UserName, SID);
    end;

    procedure LookupUser(var UserName: Code[50]; var SID: Guid): Boolean;
    var
        User: Record 2000000120;
    begin
        User.RESET;
        User.SETCURRENTKEY("User Name");
        User."User Name" := UserName;
        IF User.FIND('=><') THEN;
        IF PAGE.RUNMODAL(PAGE::Users, User) = ACTION::LookupOK THEN BEGIN
            UserName := User."User Name";
            SID := User."User Security ID";
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    end;

    var
        Text000: TextConst ENU = 'The user name %1 does not exist.', FRA = 'Le nom utilisateur %1 n''existe pas.';
}

