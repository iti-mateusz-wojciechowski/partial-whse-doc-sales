permissionset 50000 "BCW Permissions"
{
    Assignable = true;
    Caption = 'Permissions', MaxLength = 30;

    Permissions =
        codeunit "BCW Ev Sales Line" = X,
        codeunit "BCW Ev Sales Warehouse Mgt." = X;
}