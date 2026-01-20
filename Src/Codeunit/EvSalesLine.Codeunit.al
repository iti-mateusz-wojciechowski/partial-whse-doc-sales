codeunit 50001 "Ev Sales Line"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterInitQtyToShip, '', false, false)]
    local procedure OnAfterInitQtyToShip(var SalesLine: Record "Sales Line")
    begin
        SalesLine.InitQtyToShipReceiveWhse();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterInitQtyToShip2, '', false, false)]
    local procedure OnAfterInitQtyToShip2(var SalesLine: Record "Sales Line")
    begin
        SalesLine.InitQtyToShipReceiveWhse();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, "Location Code", false, false)]
    local procedure OnAfterValidateLocationCode(var Rec: Record "Sales Line")
    begin
        Rec.InitQtyToShipReceiveWhse();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, Quantity, false, false)]
    local procedure OnAfterValidateQuantity(var Rec: Record "Sales Line")
    begin
        Rec.InitQtyToShipReceiveWhse();
    end;
}