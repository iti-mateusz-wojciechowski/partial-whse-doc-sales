permissionset 50000 "BCW Permissions"
{
    Assignable = true;
    Caption = 'Permissions', MaxLength = 30;

    Permissions =
        codeunit "BCW Ev Get Src. Doc. Inbound" = X,
        codeunit "BCW Ev Get Src. Doc. Outbound" = X,
        codeunit "BCW Ev Sales Line" = X,
        codeunit "BCW Ev Sales Warehouse Mgt." = X,
        codeunit "BCW Ev Warehouse Receipt Line" = X,
        codeunit "BCW Ev Warehouse Shipment Line" = X;
}