pageextension 50100 GeoLocation extends "Customer List"
{
    trigger OnOpenPage()
    var
        geoLocation: Codeunit Geolocation;
        Latitude: Decimal;
        Longitude: Decimal;
        msg: Label 'Latitude is %1.\ Longitude is %2';
    begin
        geoLocation.SetHighAccuracy(true);
        if geoLocation.RequestGeolocation() then begin
            geoLocation.GetGeolocation(Latitude, Longitude);
            Message(msg, Latitude, Longitude);
        end;
    end;
}