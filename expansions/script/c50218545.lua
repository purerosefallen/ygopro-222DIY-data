--伏龙王-轰鸣
function c50218545.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,6,2)
    c:EnableReviveLimit()
    --disable
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50218545,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1)
    e1:SetCondition(c50218545.discon)
    e1:SetCost(c50218545.discost)
    e1:SetTarget(c50218545.distg)
    e1:SetOperation(c50218545.disop)
    c:RegisterEffect(e1)
    --get effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50218545,1))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_XMATERIAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetCountLimit(1)
    e2:SetCondition(c50218545.discon)
    e2:SetCost(c50218545.discost)
    e2:SetTarget(c50218545.distg)
    e2:SetOperation(c50218545.disop)
    c:RegisterEffect(e2)
end
function c50218545.discon(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c50218545.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c50218545.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c50218545.disop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
        Duel.SendtoGrave(eg,REASON_EFFECT)
    end
end