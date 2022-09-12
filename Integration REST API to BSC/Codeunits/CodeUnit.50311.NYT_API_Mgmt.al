/// <summary>
/// Codeunit ISA_NYT_API_Mgmt (ID 50311).
/// </summary>
codeunit 50311 ISA_NYT_API_Mgmt
{
    /// <summary>
    /// SyncBookAPIData.
    /// </summary>
    procedure ISA_SyncBookAPIData()
    var
        NYTBestSellerTheme: Record ISA_NYT_Best_Sellers_Theme;
        NYTJsonMgt: Codeunit ISA_NYT_Json_Mgmt;
        Window: Dialog;
        AddUrl: Text;
        HttpStatusCode: Integer;
        RecCounter: Integer;
        Data: Text;
    begin
        NYTBestSellerTheme.DeleteAll(true);

        AddUrl := '/lists/names.json?';
        ISA_Get_Request(AddUrl, Data, HttpStatusCode);
        NYTJsonMgt.UpdateBestSellersTheme(Data);
        Window.OPEN('Processing: @1@@@@@@@@@@@@@@@');
        if NYTBestSellerTheme.FindSet() then
            repeat
                RecCounter += 1;
                Window.UPDATE(1, ROUND(RecCounter / NYTBestSellerTheme.Count() * 10000, 1));
                AddUrl := StrSubstNo('/lists.json?list=%1&', NYTBestSellerTheme."List Name Encoded");
                ISA_Get_Request(AddUrl, Data, HttpStatusCode);
                NYTJsonMgt.UpdateBestSeller(Data);
                Commit();
                Sleep(7000); // To avoid New York Time API request limit
            until NYTBestSellerTheme.Next() = 0;
        Window.CLOSE();
    end;

    /// <summary>
    /// ISA_Get_Request.
    /// </summary>
    /// <param name="AdditionalURL">Text.</param>
    /// <param name="Data">VAR Text.</param>
    /// <param name="HTTPStatusCode">VAR Integer.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ISA_Get_Request(AdditionalURL: Text; var Data: Text; var HTTPStatusCode: Integer): Boolean
    var
        NYTAPISetup: Record ISA_NYT_API_Setup;
        httpClient: HttpClient;
        httpResponseMessage: HttpResponseMessage;
        requestURI: Text;
    begin
        NYTAPISetup.Get();
        requestURI := NYTAPISetup.BaseURL + AdditionalURL + 'api-key=' + NYTAPISetup.ISA_GetAPIKey();
        httpClient.Get(requestURI, httpResponseMessage);
        httpResponseMessage.Content().ReadAs(Data);
        HTTPStatusCode := httpResponseMessage.HttpStatusCode;

        if not httpResponseMessage.IsSuccessStatusCode() then
            Error(RequestErr, HTTPStatusCode, Data);
        exit(true);
    end;

    var
        RequestErr: Label 'Request failed with HTTP Code:: %1 Request Body:: %2', Comment = '%1 = HttpCode, %2 = RequestBody';

}