--小早川纱枝
function c81010027.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,6,2)
    c:EnableReviveLimit()
    --damage
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TO_HAND)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c81010027.damcon1)
    e1:SetOperation(c81010027.damop1)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_TO_HAND)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c81010027.regcon)
    e2:SetOperation(c81010027.regop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_CHAIN_SOLVED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c81010027.damcon2)
    e3:SetOperation(c81010027.damop2)
    c:RegisterEffect(e3)
    --change effect
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(81010027,0))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,81010027)
    e4:SetCondition(c81010027.chcon)
    e4:SetCost(c81010027.chcost)
    e4:SetOperation(c81010027.chop)
    c:RegisterEffect(e4)
end
function c81010027.damcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsControler,1,nil,1-tp)
        and (not re or not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c81010027.damop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,81010027)
    local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
    Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end
function c81010027.regcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsControler,1,nil,1-tp)
        and re and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c81010027.regop(e,tp,eg,ep,ev,re,r,rp)
    local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
    e:GetHandler():RegisterFlagEffect(35199657,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,ct)
end
function c81010027.damcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(35199657)>0
end
function c81010027.damop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,81010027)
    local labels={e:GetHandler():GetFlagEffectLabel(35199657)}
    local ct=0
    for i=1,#labels do ct=ct+labels[i] end
    e:GetHandler():ResetFlagEffect(35199657)
    Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end
function c81010027.chcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_MONSTER) and rp==1-tp
end
function c81010027.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81010027.chop(e,tp,eg,ep,ev,re,r,rp)
    local g=Group.CreateGroup()
    Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev,c81010027.repop)
end
function c81010027.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
    Duel.Draw(1-tp,1,REASON_EFFECT)
end
