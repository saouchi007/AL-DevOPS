/// <summary>
/// Codeunit ISA_AutomaticProcesses (ID 50301).
/// </summary>
codeunit 50301 ISA_AutomaticProcesses
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    var
        ISA_Functions: Codeunit ISA_AutomaticProcesses;
    begin

        case Rec."Parameter String" of
            'SayHi':
                ISA_Functions.SayHi();

            'SayDate':
                ISA_Functions.sayDate();
        // Head over then to Job Queue Entries, create an entry by specifiying Object ID to run => 50301 and Object Type to run => 
        // Codeunit and chosse between 'SayHi' and 'SayDate' as 'Parameter String'
        end;

    end;

    /// <summary>
    /// SayHi.
    /// </summary>
    procedure SayHi()
    begin
        Message('Hello there');
    end;

    /// <summary>
    /// sayDate.
    /// </summary>
    procedure sayDate()
    begin
        Message('It is :', Today);
    end;

}