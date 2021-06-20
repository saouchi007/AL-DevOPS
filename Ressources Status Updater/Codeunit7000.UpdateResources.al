codeunit 70000 "Update Resource"
{
    trigger OnRun()
    begin
        UpdateResource();
    end;

    local procedure UpdateResource()
    var
        Resource: Record Resource;
    begin
        Resource.Reset();
        Resource.SetRange(Type, Resource.Type::Person);
        if Resource.FindSet(true, false) then
            repeat
                if Resource.Blocked = false then begin
                    Resource.Blocked := true;
                    Resource.Modify();
                end;
            until (Resource.Next() = 0);
    end;
}

