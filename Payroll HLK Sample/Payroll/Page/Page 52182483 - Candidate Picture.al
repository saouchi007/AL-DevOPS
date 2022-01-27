/// <summary>
/// Page Candidate Picture (ID 52182483).
/// </summary>
page 52182483 "Candidate Picture"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidate Picture',
                FRA = 'Photo candidat';
    PageType = Card;
    SourceTable = Candidate;

    layout
    {
        area(content)
        {
            field(Picture; Picture)
            {
            }
        }
    }

    actions
    {
    }



    var
        Text001: TextConst ENU = 'Do you want to replace the existing picture of %1 %2?', FRA = 'Souhaitez-vous remplacer l''image existante de %1 %2 ?';
        Text002: TextConst ENU = 'Do you want to delete the picture of %1 %2?', FRA = 'Souhaitez-vous supprimer l''image de %1 %2 ?';
        PictureExists: Boolean;

}

