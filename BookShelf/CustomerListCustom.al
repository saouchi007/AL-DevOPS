profile MyProfile
{
    Description = 'My Profile';
    RoleCenter = "Order Processor Role Center";
    Customizations = MyCustom;
}

pagecustomization MyCustom customizes "Customer List"
{
    layout
    {
        modify("Responsibility Center")
        {
            Visible = false;
        }
    }



}