/// <summary>
/// Table Post Required Qualification (ID 52182447).
/// </summary>
table 52182447 "Post Required Qualification"
//table 39108418 "Post Required Qualification"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Post Required Qualification',
                FRA = 'Qualification requise du poste';
    // DrillDownPageID = 39108434;
    // LookupPageID = 39108434;

    fields
    {
        field(1; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code',
                        FRA = 'Code poste';
            NotBlank = true;
            TableRelation = Post;

            trigger OnValidate();
            begin
                IF "Post Code" = '' THEN
                    "Post Description" := ''
                ELSE BEGIN
                    Post.GET("Post Code");
                    "Post Description" := Post.Description;
                END;
            end;
        }
        field(2; "Qualification Code"; Code[10])
        {
            CaptionML = ENU = 'Qualification Code',
                        FRA = 'Code qualification';
            NotBlank = true;
            TableRelation = Qualification;

            trigger OnValidate();
            begin
                IF "Qualification Code" = '' THEN
                    "Qualification Description" := ''
                ELSE BEGIN
                    Qualification.GET("Qualification Code");
                    "Qualification Description" := Qualification.Description;
                END;
            end;
        }
        field(3; "Qualification Description"; Text[30])
        {
            CaptionML = ENU = 'Qualification Description',
                        FRA = 'Désignation qualification';
            Editable = false;
        }
        field(4; "Post Description"; Text[50])
        {
            CaptionML = ENU = 'Post Description',
                        FRA = 'Désignation du poste';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Post Code", "Qualification Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Qualification: Record 5202;
        Post: Record 52182431;
}

