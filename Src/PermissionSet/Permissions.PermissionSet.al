permissionset 50000 Permissions
{
    Assignable = true;
    Caption = 'Permissions', MaxLength = 30;

    Permissions =
        codeunit "Ev Sales Warehouse Mgt." = X,
        codeunit "Ev Sales Line" = X;
}