--伏龙王-闪乱
function c50218560.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,7,2)
    c:EnableReviveLimit()
    --multi attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c50218560.atkcon)
    e1:SetCost(c50218560.atkcost)
    e1:SetTarget(c50218560.atktg)
    e1:SetOperation(c50218560.atkop)
    c:RegisterEffect(e1)
    --get effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_XMATERIAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c50218560.atkcon)
    e2:SetCost(c50218560.atkcost)
    e2:SetTarget(c50218560.atktg)
    e2:SetOperation(c50218560.atkop)
    c:RegisterEffect(e2)
end
function c50218560.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP()
end
function c50218560.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c50218560.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0
        and e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK_MONSTER)==0 end
end
function c50218560.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end